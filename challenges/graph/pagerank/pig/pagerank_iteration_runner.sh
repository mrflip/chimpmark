#!/usr/bin/env bash

# Run this with 2 mappers and 1 reducer on m1.large
export PIG_OPTS='-Dio.sort.record.percent=0.43 -Dio.sort.mb=520 -Dio.sort.factor=52 -Dio.sort.spill.percent=0.88 -Dmapred.job.reuse.jvm.num.tasks=1'

# Directory to pagerank on.
work_dir=$1     ; shift
if [ "$work_dir" == '' ] ; then echo "Please specify the parent of the directory made by gen_initial_pagerank: $0 initial_dir [number_of_iterations] [start_iteration]" ; exit ; fi

# How many rounds to run: default 10
n_iters=${1-10} ; shift
# the iteration to start with: default 0
start_i=${1-0}  ; shift
# this directory
script_dir=$(readlink -f `dirname $0`)

for (( iter=0 ; "$iter" < "$n_iters" ; iter++ )) ; do
  curr_str=`printf "%03d" $(( $start_i + $iter     ))`
  next_str=`printf "%03d" $(( $start_i + $iter + 1 ))`
  curr_iter_file=$work_dir/pagerank_graph_${curr_str}
  next_iter_file=$work_dir/pagerank_graph_${next_str}
  echo -e "\n****************************\n"
  echo -e "Iteration $(( $iter + 1 )) / $n_iters:\t `basename $curr_iter_file` => `basename $next_iter_file`"
  echo -e "\n****************************"
  pig -param CURR_ITER_FILE=$curr_iter_file -param NEXT_ITER_FILE=$next_iter_file $script_dir/pagerank_cogroup.pig
done
