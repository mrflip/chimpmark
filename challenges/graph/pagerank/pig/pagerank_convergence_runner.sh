#!/usr/bin/env bash

export PIG_OPTS="-Dio.sort.record.percent=0.30 -Dio.sort.mb=250 -Dio.sort.factor=25 -Dmapred.child.java.opts=-Xmx1900m"

# Directory to pagerank on.
work_dir=$1     ; shift
if [ "$work_dir" == '' ] ; then echo "Please specify the parent of the directory made by gen_initial_pagerank: $0 initial_dir [number_of_iterations] [start_iteration]" ; exit ; fi
# this directory
script_dir=$(readlink -f `dirname $0`)

for iter in $* ; do
  # expand "5" to "005" and "006"
  curr=`printf "%03d" $iter` ;
  next=`printf "%03d" $(($iter + 1))`
  # run the script for convergence statistics 
  pig -p PREV_ITER_FILE=$work_dir/pagerank_graph_$curr -p CURR_ITER_FILE=$work_dir/pagerank_graph_$next -p PR_STATS_FILE=$work_dir/pr_stats_${curr}_${next} $script_dir/check_convergence.pig &
done 
