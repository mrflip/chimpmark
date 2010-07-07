#!/usr/bin/env bash

local_scratch_dir=/mnt/tmp
hdfs_root_dir=/data/source
wikidump_url_base="download.wikimedia.org/enwiki"
wikidump_timestamp="20100622"
wikidump_ignores="stub-meta-current.xml.gz stub-meta-history.xml.gz pages-meta-current.xml.bz2 pages-logging.xml.gz"

## -- derived: leave these alone
wikidump_path=${local_scratch_dir}/${wikidump_url_base}/${wikidump_timestamp}
hdfs_path=${hdfs_root_dir}/${wikidump_url_base}/${wikidump_timestamp}

#
# For the big-assed files we don't want to process,
# touch an empty file to make it not download.
#
for wikidump_ignore in $wikidump_ignores ; do
  touch ${wikidump_path}/enwiki-${wikidump_timestamp}-${wikidump_ignore}
done

#
# Fetch dump 
#
mkdir -p $local_scratch_dir
cd $local_scratch_dir
rm -f ${wikidump_path}/index*
wget -r -l1 -np -nc http://${wikidump_url_base}/${wikidump_timestamp}/

for zipped in `/bin/ls -Sr1 ${wikidump_path}/*.gz` ; do
  unzipped=${wikidump_path}-expanded/`basename $zipped .gz`
  if  [ -e $unzipped -o \! -s $zipped ] ; then continue ; fi
  echo   "Unzipping $zipped into $unzipped"
  gunzip -c $zipped > $unzipped &
done

for zipped in `/bin/ls -Sr1 ${wikidump_path}/*.bz2` ; do
  unzipped=${wikidump_path}-expanded/`basename $zipped .bz2`
  if  [ -e $unzipped -o \! -s $zipped ] ; then continue ; fi
  echo   "Unzipping $zipped into $unzipped"
  bunzip2 -c $zipped > $unzipped &
done

hadoop fs -mkdir ${hdfs_path}-expanded
hadoop fs -put   ${wikidump_path}-expanded/* ${hdfs_path}-expanded/
