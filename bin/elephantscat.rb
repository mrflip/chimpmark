#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'
require 'imw'


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
    [:reduce_output_records, Bignum]
    )
end

class JobDetailsParser

  def initialize *args
    
  end
  
  def extract_run_time raw
    return if raw.blank?
    re = /^\<b\>Finished\Win\:\<\/b\>\W(.*)\</
    run_time = (raw.match(re)).captures.first rescue nil
  end

  def extract_finished raw
    return if raw.blank?
    re = /^\<b\>Status\:\<\/b\>\W(.*)\</
    finished = (raw.match(re)).captures.first rescue nil
    return 1 unless finished.downcase == 'failed'
    0
  end

  def extract_raw_table imw_obj
    ripd = imw_obj.parse ["table[2]/tr", {:row => ["td"]}]
    rawd = ripd.map do |ele|
      if ele[:row].size >= 5
        ele[:row] = ele[:row][1..-1] #cut off the crap at the beginning
      end      
    end
    rawd
  end

  #
  # Fill a hash with the information extracted with imw.
  #
  def raw_table_to_hash tbl
    fixd_hsh = tbl.reject{|arr| arr.blank?}.inject({}) do |h,arr|
      title = arr.first.downcase.gsub(' ', '_').gsub('-', '_').to_sym
      h[title] = arr.last.gsub(",","")
      h
    end
    fixd_hsh
  end

  def parse jobdetails, &blk
    data       = IMW.open(jobdetails)
    raw_string = IMW.open(jobdetails).read
    run_time   = extract_run_time raw_string
    finished   = extract_finished raw_string
    rawd       = extract_raw_table data
    fixd       = raw_table_to_hash rawd
    fixd[:job_id]   = jobdetails.gsub('.html', '')
    fixd[:run_time] = run_time
    fixd[:finished] = finished
    yield JobDetails.from_hash fixd
  end
  
end

#
# Use curl to fetch the jobdetails page
#
def get_job_pages job_id
  details_url  = NAMENODE_URL + ":50030" + "/jobdetails.jsp?jobid=" + job_id
  details_file = job_id + ".html"
  jobconf_url  = NAMENODE_URL + ":50030" + "/jobconf.jsp?jobid=" + job_id
  jobconf_file = job_id + ".xml"
  %x{curl -s #{details_url} -o #{details_file}}
  %x{curl -s #{jobconf_url} -o #{jobconf_file}}
end

job_id = ARGV[0]
get_job_pages job_id
parser = JobDetailsParser.new
parser.parse(job_id + ".html") do |details|
 puts details.to_flat.join("\t")
end
