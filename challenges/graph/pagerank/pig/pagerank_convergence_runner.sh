#!/usr/bin/env bash

export PIG_OPTS="-Dio.sort.record.percent=0.35 -Dio.sort.mb=100 -Dio.sort.factor=60"

n_reducers=${n_reducers-10}
inv_sample_fraction=${inv_sample_fraction-100L}

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
  pig -p PREV_ITER_FILE=$work_dir/pagerank_graph_$curr -p CURR_ITER_FILE=$work_dir/pagerank_graph_$next -p PR_STATS_FILE=$work_dir/pr_stats_${curr}_${next} -p N_REDUCERS=$n_reducers -p INV_SAMPLE_FRACTION=$inv_sample_fraction $script_dir/check_convergence.pig &
done 

echo -e "prev_iter_file\tcurr_iter_file\ttot_prev_rank\ttot_curr_rank\ttot_out_links\tmean_sq_diff\tmean_sq_pct_diff\tsum_diff\tnum_nodes\tmin_pct_diff\tmax_pct_diff\tmin_rank\tmax_rank"
