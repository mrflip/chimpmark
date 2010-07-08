#!/usr/bin/env bash

## -- directories and file paths
local_ripd_root=/mnt/tmp
hdfs_ripd_root=/data/ripd
hdfs_rawd_root=/data/rawd
## -- wikipedia dump info
wikidump_url_base="download.wikimedia.org/enwiki"
wikidump_timestamp="20100622"
wikidump_ignores="stub-meta-current.xml.gz stub-meta-history.xml.gz pages-meta-current.xml.bz2 pages-logging.xml.gz"

## -- derived: leave these alone
local_ripd_path=${local_ripd_root}/${wikidump_url_base}/${wikidump_timestamp}
hdfs_ripd_path=${hdfs_ripd_root}/${wikidump_url_base}/${wikidump_timestamp}
hdfs_rawd_path=${hdfs_ripd_root}/wikidump
hdfs_tmp_path=/tmp/wikidump
script_dir=$(readlink -f `dirname "$0"`)

# Setup staging directories
mkdir -p $local_ripd_path
rm -f ${local_ripd_path}/index*

#
# For the big-assed files we don't want to process,
# touch an empty file to make it not download.
#
for wikidump_ignore in $wikidump_ignores ; do
  touch ${local_ripd_path}/enwiki-${wikidump_timestamp}-${wikidump_ignore}
done

#
# Fetch dump 
#
cd $local_ripd_root
wget -r -l1 -np -nc http://${wikidump_url_base}/${wikidump_timestamp}/

#
# Expand compressed files
#
for zipped in `/bin/ls -Sr1 ${local_ripd_path}/*.gz` ; do
  unzipped=${local_ripd_path}-expanded/`basename $zipped .gz`
  if  [ -e $unzipped -o \! -s $zipped ] ; then continue ; fi
  echo   "Unzipping $zipped into $unzipped"
  gunzip -c $zipped > $unzipped
done

for zipped in `/bin/ls -Sr1 ${local_ripd_path}/*.bz2` ; do
  unzipped=${local_ripd_path}-expanded/`basename $zipped .bz2`
  if  [ -e $unzipped -o \! -s $zipped ] ; then continue ; fi
  echo   "Unzipping $zipped into $unzipped"
  bunzip2 -c $zipped > $unzipped
done

#
# Copy expanded files to HDFS
#
hadoop fs -mkdir ${hdfs_ripd_path}-expanded
hadoop fs -put   ${local_ripd_path}-expanded/* ${hdfs_ripd_path}-expanded/
