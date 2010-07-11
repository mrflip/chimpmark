%default PREV_ITER_FILE '../data/pagerank_graph_010'
%default CURR_ITER_FILE '../data/pagerank_graph_011'
%default PR_STATS_FILE  '/tmp/pagerank/pr_stats'
%default N_REDUCERS     '6'

--
-- Takes two pagerank iteration files
-- and calculates the mean squared error from one iteration to the next
-- 
-- Vargas    19.0    4    {(Kevin),(Gene),(Feldman),(ElaineBenes)}
--

-- for foo in 1 5 9 10 18 19 26 29  ; do
--   curr=`printf "%03d" $foo` ;
--   next=`printf "%03d" $(($foo + 1))`
--   pig -p PREV_ITER_FILE=/tmp/pagerank_some/pagerank_graph_$curr -p CURR_ITER_FILE=/tmp/pagerank_some/pagerank_graph_$next -p PR_STATS_FILE=/tmp/pagerank_some/pr_stats_${curr}_${next} ./check_convergence.pig &
-- done 

REGISTER /usr/local/share/pig/contrib/piggybank/java/piggybank.jar ;

prev_iter  = LOAD '$PREV_ITER_FILE' AS (user_a:long, rank:double, num_out_links:int, out_links:bag { link:tuple (user_b:long) });
curr_iter  = LOAD '$CURR_ITER_FILE' AS (user_a:long, rank:double, num_out_links:int, out_links:bag { link:tuple (user_b:long) });

prev_iter  = FOREACH prev_iter GENERATE user_a, rank AS prev_rank;
curr_iter  = FOREACH curr_iter GENERATE user_a, rank AS curr_rank;

pr_diff_j  = JOIN prev_iter BY user_a, curr_iter BY user_a  PARALLEL $N_REDUCERS;
pr_diff    = FOREACH pr_diff_j GENERATE
  prev_iter::user_a               AS user_a,
  prev_iter::prev_rank            AS prev_rank,
  curr_iter::curr_rank            AS curr_rank,
  (curr_rank - prev_rank)                                                  AS diff:double,
  ((curr_rank - prev_rank)*(curr_rank - prev_rank))                        AS diff_sq:double,
  ((curr_rank - prev_rank)/(curr_rank))                                    AS pct_diff:double,  
  ((curr_rank - prev_rank)*(curr_rank - prev_rank)/(curr_rank*curr_rank))  AS pct_diff_sq:double
  ;

pr_stats_g = GROUP pr_diff ALL PARALLEL 1;

pr_stats   = FOREACH pr_stats_g GENERATE
  '$PREV_ITER_FILE'                       AS prev_iter_file:chararray,
  '$CURR_ITER_FILE'                       AS curr_iter_file:chararray,
  SUM(pr_diff.prev_rank)                  AS tot_prev_rank,
  SUM(pr_diff.curr_rank)                  AS tot_curr_rank,
  org.apache.pig.piggybank.evaluation.math.SQRT((double)(SUM(pr_diff.diff_sq) / (double)COUNT(pr_diff)))
                                          AS mean_sq_diff,
  org.apache.pig.piggybank.evaluation.math.SQRT((double)(SUM(pr_diff.pct_diff_sq) / (double)COUNT(pr_diff)))
                                          AS mean_sq_pct_diff,
  SUM(pr_diff.diff)                       AS sum_diff,
  COUNT(pr_diff)                          AS num_nodes,
  MIN(pr_diff.pct_diff)                   AS min_pct_diff,
  MAX(pr_diff.pct_diff)                   AS max_pct_diff,
  MIN(pr_diff.curr_rank)                  AS min_rank,
  MAX(pr_diff.curr_rank)                  AS max_rank
  ;

rmf                  $PR_STATS_FILE
STORE pr_stats INTO '$PR_STATS_FILE';
pr_stats = LOAD '$PR_STATS_FILE' AS (prev_iter_file:chararray, curr_iter_file:chararray, tot_prev_rank:double, tot_curr_rank:double, mean_sq_diff:double, sum_diff:double, num_nodes:long, min_diff:double, max_diff:double, min_rank:double, max_rank:double);
DUMP pr_stats;


