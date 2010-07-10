#!/usr/bin/env bash

input=/data/rawd/wikidump/articles/part-00000
output=/tmp/chimpmark/sort-articles-java

hadoop fs -mkdir $output

hadoop jar /usr/lib/hadoop/hadoop-*-examples.jar sort         \
  -D io.sort.record.percent=0.25                              \
  -D io.sort.mb=350                                           \
  -inFormat  org.apache.hadoop.mapred.KeyValueTextInputFormat \
  -outFormat org.apache.hadoop.mapred.TextOutputFormat        \
  ${input}                                                    \
  ${output}
