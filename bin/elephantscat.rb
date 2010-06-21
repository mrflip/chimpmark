#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'
require 'imw'
require 'configliere'
require 'configliere/commandline'
require 'fileutils'

Settings.define :archive_dir, :default => File.expand_path("~/timings"), :description => 'Where to store the archived job output'
Settings.resolve!

#
# FIXME: add these fields: started at, num_tasks, reduce_input_groups
#
NAMENODE_URL = "http://gibbon.infinitemonkeys.info"

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
    [:job_name,              String]
    )
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

  def extract_raw_table imw_obj
    ripd = imw_obj.parse ["table[2]//tr", {:row => ["td"]}]
    rawd = ripd.map do |ele|
      ele[:row][-4..-1] #cut off the crap at the beginning
    end
    rawd
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

  def parse jobdetails_file, &blk
    data       = IMW.open(jobdetails_file)
    raw_string = IMW.open(jobdetails_file).read
    finished   = extract_finished raw_string
    rawd       = extract_raw_table data
    fixd       = raw_table_to_hash rawd
    fixd[:job_id]   = File.basename(jobdetails_file).gsub('.html', '')
    fixd[:run_time] = extract_header( raw_string, '(?:Finished|Killed) in')
    fixd[:job_name] = extract_header( raw_string, 'Job Name')
    fixd[:finished] = finished
    yield JobDetails.from_hash(fixd)
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

  # Where to find the jobdetails HTML page (the one that is parsed)
  def jobdetails_url
    NAMENODE_URL + ":50030" + "/jobdetails.jsp?jobid=" + job_id
  end
  # Where to find the jobconf xml
  def jobconf_url
    NAMENODE_URL + ":50030" + "/jobconf.jsp?jobid=" + job_id
  end

  #
  # Use curl to fetch the jobdetails page
  #
  def archive!
    FileUtils.mkdir_p(File.dirname(jobdetails_filename))
    FileUtils.mkdir_p(File.dirname(jobconf_filename))
    $stderr.print %x{curl -s #{jobdetails_url} -o #{jobdetails_filename}}
    $stderr.print %x{curl -s #{jobconf_url}    -o #{jobconf_filename}}
  end

  def parse &block
    parser = JobDetailsParser.new
    File.open(stats_filename, 'w') do |stats_file|
      parser.parse(jobdetails_filename)  do |details|
        puts details.to_flat.join("\t")
        stats_file << details.to_flat.join("\t")+"\n"
        yield details if block
      end
    end
  end
end

job_id = Settings.rest.first
job = ArchivableJob.new(job_id)
job.archive!
job.parse
