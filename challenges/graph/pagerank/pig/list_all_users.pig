%default ADJ_LIST_FILE   '/data/sn/tw/rawd/pagerank/a_follows_b/pig/pagerank_graph_010'
%default USER_IDS_FILE  '/data/sn/tw/fixd/user_ids/from_a_follows_b'

--
-- Takes a pagerank iteration file
-- and lists all uniq user ids in it
--
-- @input
--
--     Vargas         19.0    {(Kevin),(Gene),(Feldman),(ElaineBenes)}
--     BobSacamano    6.0     {(Newman),(Kramer),(Lomez)}
--
-- @output:
--
--     prev_iter_file	curr_iter_file	tot_prev_rank	tot_curr_rank	tot_out_links	mean_sq_diff	mean_sq_pct_diff	sum_diff	num_nodes	min_pct_diff	max_pct_diff	min_rank	max_rank
--

adj_list     = LOAD '$ADJ_LIST_FILE' AS (user_a:long, rank:double, out_links:bag { link:tuple (user_b:long) });

src_nodes    = FOREACH adj_list GENERATE user_a AS user_id:long;
dest_nodes   = FOREACH adj_list GENERATE FLATTEN(out_links) AS user_id:long;
all_nodes    = UNION src_nodes, dest_nodes;
uniq_nodes   = DISTINCT all_nodes;

rmf                    $USER_IDS_FILE
STORE uniq_nodes INTO '$USER_IDS_FILE';
