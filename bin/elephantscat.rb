#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'
require 'imw'
require 'configliere'
require 'configliere/commandline'
require 'fileutils'
require 'set'

Settings.define :archive_dir, :default => File.expand_path("~/timings"), :description => 'Where to store the archived job output'
Settings.define :note, :default => "", :description => 'Where to store the archived job output'
Settings.resolve!

#
# FIXME: add these fields: started at, num_tasks, reduce_input_groups
#

#
# Namenode URL. make sure to use the local IP (or that the port is open to you)
#
NAMENODE_URL = "http://localhost"

class JobDetails < TypedStruct.new(
    [:job_id,                String],
    [:scraped_at,            Bignum],
    [:run_time,              Bignum],
    [:finished,             Integer],
    [:s3n_bytes_read,        Bignum],
    [:hdfs_bytes_read,       Bignum],
    [:file_bytes_read,       Bignum],
    [:hdfs_bytes_written,    Bignum],
    [:file_bytes_written,    Bignum],
    [:map_input_bytes,       Bignum],
    [:map_output_bytes,      Bignum],
    [:map_input_records,     Bignum],
    [:map_output_records,    Bignum],
    [:reduce_input_records,  Bignum],
    [:reduce_output_records, Bignum],
    [:job_name,              String],
    [:started_at,            String],
    [:finished_at,           String],
    [:map_tasks,            Integer],
    [:reduce_tasks,         Integer]
    )

  def started_at= dt
    super DateTime.parse_and_flatten(dt)
  end
  def finished_at dt
    super DateTime.parse_and_flatten(dt)
  end
end

class JobDetailsParser

  def extract_header raw, intro
    return if raw.blank?
    re = /^\<b\>#{intro}\:\<\/b\>\W*(.*)\</
    (raw.match(re)).captures.first rescue nil
  end

  def extract_finished raw
    return if raw.blank?
    re = /^\<b\>Status\:\<\/b\>\W(.*)\</
    finished = (raw.match(re)).captures.first rescue nil
    (finished.to_s.downcase == 'failed') ? 0 : 1
  end

  def extract_num_table imw_obj
    ripd = imw_obj.parse ["table[1]//tr", {:row => ["td"]}]
    # we only want to keep the rows that have a bunch of elements
    rawd = ripd.select{|ele| ele[:row] && ele[:row].length > 2}.map do |ele|
      ele[:row]
    end
    rawd
  end

  def extract_raw_table imw_obj
    ripd = imw_obj.parse ["table[2]//tr", {:row => ["td"]}]
    rawd = ripd.map do |ele|
      ele[:row][-4..-1] #cut off the crap at the beginning
    end
    rawd
  end

  def extract_top_table raw
    table = {}
    raw.scan(/^<b>([^:]+):<\/b>\s*(.*)\s*<br>/){|key,value| table[key] = value}
    return table;
  end

  #
  # Fill a hash with the information extracted with imw.
  #
  def raw_table_to_hash tbl
    fixd_hsh = tbl.reject{|arr| arr.blank?}.inject({}) do |h,arr|
      title = arr.first.downcase.gsub(/[-\s]/, '_').to_sym
      val   = arr.last.gsub(",","")
      h[title] = val
      h
    end
    fixd_hsh
  end

  def parse jobdetails_file, &block
    data       = IMW.open(jobdetails_file)
    raw_string = IMW.open(jobdetails_file).read
    top_table  = extract_top_table raw_string
    num_table  = extract_num_table IMW.open(jobdetails_file)
    rawd       = extract_raw_table data
    details = JobDetails.from_hash(raw_table_to_hash(rawd))

    details.job_id       = File.basename(jobdetails_file).gsub('.html', '')
    details.run_time     = extract_header( raw_string, '(?:Finished|Killed) in')
    details.job_name     = extract_header( raw_string, 'Job Name')
    details.finished     = top_table["Status"].to_s.downcase == "failed" ? 0 : 1
    details.started_at   = top_table["Started at" ]
    details.finished_at  = top_table["Finished at"]
    details.map_tasks    = num_table[0][-6].to_i
    details.reduce_tasks = num_table[1][-6].to_i

    yield  details if block
    return details
  end

end

class JobTasks
  attr_accessor :job_slug, :num_map_tasks, :num_reduce_tasks

  def initialize job_slug, num_map_tasks, num_reduce_tasks
    self.job_slug           = job_slug
    self.num_map_tasks    = num_map_tasks
    self.num_reduce_tasks = num_reduce_tasks
  end

  def task_id_for phase, task_num
    "task_#{job_slug}_#{phase}_#{"%06d"%task_num}"
  end

  def extract_counters_table raw
    ripd = raw.parse ["table[1]//tr", { :row => ["td"] }]
    counters = { }
    ripd.each do |ele|
      counter_row = ele[:row]
      next if counter_row[2].blank?
      counters[counter_row[1]] = counter_row[2].gsub(/,/,"")
    end
    counters
  end

  def parse task_counters_file, &blk
    extract_counters_table IMW.open(task_counters_file)
  end

  def job_path
    File.join(Settings.archive_dir, 'job', job_slug.to_s.gsub(/_/, '/'))
  end
  def task_counters_path
    File.join(job_path, "tasks-#{job_slug}")
  end
  def task_counters_filename(task_id)    File.join(task_counters_path, "/counters-#{task_id}.html")  end
  def tasks_overview_filename(phase)     File.join(job_path, "tasks-#{job_slug}-#{phase}.html")   end
  def task_counter_stats_filename(phase) File.join(job_path, "counters-#{job_slug}-#{phase}.tsv") end

  # Whtere to find the task counters table
  def task_counters_url(task_id)
    NAMENODE_URL + ":50030/taskstats.jsp?jobid=job_#{job_slug}&tipid=#{task_id}"
  end
  # Tasks listing
  def tasks_overview_url phase
    phase_name = (phase == 'm') ? "map" : "reduce"
    NAMENODE_URL + ":50030/jobtasks.jsp?jobid=job_#{job_slug}&type=#{phase_name}&pagenum=1&state=completed"
  end

  def fetch_task_counters
    fetch_task_counters_for 'm', num_map_tasks
    fetch_task_counters_for 'r', num_reduce_tasks
  end

  def fetch_task_counters_for phase, num_tasks
    ArchivableJob.fetch_url( tasks_overview_url(phase), tasks_overview_filename(phase), true )
    FileUtils.mkdir_p(task_counters_path)
    task_counters     = []
    task_counter_keys = Set.new
    (0...num_tasks).each do |task_num|
      task_id = task_id_for(phase, task_num)
      tc_file = task_counters_filename(task_id)
      ArchivableJob.fetch_url(task_counters_url(task_id), tc_file)
      counters = parse(tc_file)
      task_counters << counters
      task_counter_keys += counters.keys.to_set
    end
    cols = task_counter_keys.to_a.sort
    File.open(task_counter_stats_filename(phase), 'w') do |task_counter_stats_file|
      task_counter_stats_file << ["task_counters", cols].flatten.join("\t")+"\n"
      task_counters.each do |tc|
        tc_str = (["task_counters"]+tc.values_of(*cols)).join("\t")+"\n"
        task_counter_stats_file << tc_str
        puts tc_str
      end
    end
  end

end

class ArchivableJob
  attr_reader :job_id
  def initialize job_id
    @job_id = job_id
    if job_id.blank? then warn "Please give a job_id: something like 'job_201006162228_0021'" ; exit(-2) ; end
  end

  # the jobtrackerid_jobcount part of the job_id:
  # @example ArchivableJob.new('job_201006162228_0021').slug  # => '201006162228_0021'
  def slug
    job_id.gsub(/^job_/, '')
  end

  def archive_path
    File.join(Settings.archive_dir, job_id.to_s.gsub(/_/, '/'))
  end
  # Where to put the parsed statistics.
  def stats_filename
    File.join(archive_path, "stats-#{slug}.tsv")
  end
  def jobdetails_filename
    File.join(archive_path, "jobdetails-#{slug}.html")
  end
  def jobconf_filename
    File.join(archive_path, "jobconf-#{slug}.xml")
  end
  def note_filename
    File.join(archive_path, "note-#{slug}.txt")
  end

  # Where to find the jobdetails HTML page (the one that is parsed)
  def jobdetails_url
    NAMENODE_URL + ":50030/jobdetails.jsp?jobid=#{job_id}"
  end
  # Where to find the jobconf xml
  def jobconf_url
    NAMENODE_URL + ":50030/jobconf.jsp?jobid=#{job_id}"
  end

  #Is there a note associated with this job?
  def note?
    return true unless Settings.note.blank?
    return false
  end

  def store_note
    return unless note?
    note = Settings.note
    note_file = File.open(note_filename, 'w')
    note_file << note
    note_file.close
  end

  def self.fetch_url url, filename, force=false
    unless File.exists?(filename) || force
      $stderr.print "Fetching #{File.basename(filename)}"
      $stderr.puts  %x{curl -s '#{url}' -o '#{filename}'}
    end
  end

  #
  # Use curl to fetch the jobdetails page
  #
  def archive!
    FileUtils.mkdir_p(File.dirname(jobdetails_filename))
    FileUtils.mkdir_p(File.dirname(jobconf_filename))
    store_note
    ArchivableJob.fetch_url(jobdetails_url, jobdetails_filename)
    ArchivableJob.fetch_url(jobconf_url,    jobconf_filename)
    details = parse()
    tasks = JobTasks.new(slug, [details.map_tasks].min, [details.reduce_tasks].min)
    tasks.fetch_task_counters
  end

  def parse
    parser = JobDetailsParser.new
    details = parser.parse(jobdetails_filename)
    File.open(stats_filename, 'w') do |stats_file|
      puts details.to_flat.join("\t")
      stats_file << details.to_flat.join("\t")+"\n"
    end
    details
  end
end

Settings.rest.each do |job_id|
  job = ArchivableJob.new(job_id)
  job.archive!
end
