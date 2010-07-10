#!/usr/bin/env bash

## -- directories and file paths
local_ripd_root=/mnt/tmp
hdfs_ripd_root=/data/ripd
hdfs_rawd_root=/data/rawd
## -- wikipedia dump info
wikidump_url_base="download.wikimedia.org/enwiki"
wikidump_timestamp="20100622"

## -- derived: leave these alone
local_ripd_path=${local_ripd_root}/${wikidump_url_base}/${wikidump_timestamp}
hdfs_ripd_path=${hdfs_ripd_root}/${wikidump_url_base}/${wikidump_timestamp}
hdfs_rawd_path=${hdfs_rawd_root}/wikidump
hdfs_tmp_path=/tmp/wikidump-prep
script_dir=$(readlink -f `dirname "$0"`)
hadoop fs -mkdir ${hdfs_tmp_path} ${hdfs_rawd_path}

#
# Page Info
#
page_info_dump=${hdfs_ripd_path}-expanded/enwiki-${wikidump_timestamp}-page.sql
page_info_file=${hdfs_rawd_path}/page_info
# $script_dir/wikidump_extract_sql.rb --rm --run $page_info_dump $page_info_file

# hdp-rm -r /data/rawd/wikidump/page_info_sorted ; hadoop jar /usr/lib/hadoop/hadoop-*-examples.jar sort  -D io.sort.record.percent=0.25 -D io.sort.mb=350 -inFormat org.apache.hadoop.mapred.KeyValueTextInputFormat -outFormat org.apache.hadoop.mapred.TextOutputFormat -outKey org.apache.hadoop.io.LongWritable  -outValue org.apache.hadoop.io.Text  /data/rawd/wikidump/page_info /data/rawd/wikidump/page_info_sorted

#
# Pagelinks
#
pagelinks_dump=${hdfs_path}-expanded/enwiki-${wikidump_timestamp}-pagelinks.sql
pagelinks_prep=${hdfs_tmp_path}/pagelinks-prep
pagelinks_file=${hdfs_rawd_path}/pagelinks
# # Get the raw pagelinks (temp version: need to reconcile titles)
# $script_dir/wikidump_extract_sql.rb --rm --run $pagelinks_dump $pagelinks_prep
# # Normalize the titles to page ids
PIG_OPTS="-Dio.sort.record.percent=0.20 -Dio.sort.mb=300" pig -p PAGELINKS_PREP_FILE=$pagelinks_prep -p PAGELINKS_FILE=$pagelinks_file $script_dir/wikidump_fix_pagelinks.pig 

#
# Articles
#
articles_dump=${hdfs_ripd_path}-expanded/enwiki-${wikidump_timestamp}-pages-articles.xml
articles_file=${hdfs_rawd_path}/articles
# $script_dir/wikidump_extract_articles.rb --rm --run $articles_dump $articles_file

#
# Pageview Stats
#
## -- not yet
