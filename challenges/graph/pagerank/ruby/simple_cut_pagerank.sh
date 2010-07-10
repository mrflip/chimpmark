#!/usr/bin/env bash

# Run it as
#
#   simple_cut_pagerank.sh OUTPUT_PATH INPUT_PATH
#
# INPUT_PATH should contain the full output of the pagerank iteration
# script.

OUTPUT_PATH=$1
INPUT_PATH=$2

script_dir=$(readlink -f `dirname $0`)

hdp-rm -r $OUTPUT_PATH
/usr/lib/hadoop/bin/hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-*-streaming.jar       \
  -D           stream.num.map.output.key.fields="2"                                          \
  -mapper      "/usr/bin/cut -f1,2"                                                      \
  -reducer     "/usr/bin/uniq"                                                               \
  -input       "$INPUT_PATH" \
  -output      "$OUTPUT_PATH"                             \
  -cmdenv       LC_ALL=C
