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
$script_dir/extract_page_info.rb --rm --run $page_info_dump $page_info_file

#
# Pagelinks
#
pagelinks_dump=${hdfs_path}-expanded/enwiki-${wikidump_timestamp}-pagelinks.sql
pagelinks_prep=${hdfs_tmp_path}/pagelinks_prep
pagelinks_file=${hdfs_rawd_path}/pagelinks
# Get the raw pagelinks (temp version: need to reconcile titles)
echo $script_dir/extract_page_info.rb --rm --run $pagelinks_dump $pagelinks_prep
# Normalize the titles to page ids
echo pig -p PAGELINKS_PREP_FILE=$pagelinks_prep -p PAGELINKS_FILE=$pagelinks_file $script_dir/wikidump_fix_pagelinks.pig 

#
# Articles
#
articles_dump=${hdfs_ripd_path}-expanded/enwiki-${wikidump_timestamp}-pages-articles.xml
articles_file=${hdfs_rawd_path}/articles
echo $script_dir/extract_articles.rb --rm --run $articles_dump $articles_file

#
# Pageview Stats
#
## -- not yet
