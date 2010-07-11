%default CURR_ITER_FILE '../data/pagerank_graph_000'
%default NEXT_ITER_FILE '../data/pagerank_graph_001'
%default DAMP   '0.85f' -- naively accepting that given in the wikipedia article on pagerank...

--
-- Demonstrates complex load function...
-- Data sits in the file as:
--
-- Vargas    1.0    4    {(Kevin),(Gene),(Feldman),(ElaineBenes)}
--

-- filtered     = FILTER give_shares BY (user_a IS NOT NULL AND share IS NOT NULL); --this should not be necessary...

network      = LOAD '$CURR_ITER_FILE' AS (user_a:long, rank:float, num_out_links:int, out_links:bag { link:tuple (user_b:long) });

give_shares  = FOREACH network GENERATE FLATTEN(out_links) AS user_b, (float)(rank / (float)num_out_links) AS share:float;
list_shares  = COGROUP give_shares BY user_b, network BY user_a;
sum_shares   = FOREACH list_shares
               {
                   raw_rank    = (float)SUM(give_shares.share);
                   damped_rank = (raw_rank > 1.0e-12f ? raw_rank*0.85f + 0.15f : 0.0f);
                   GENERATE
                       group         AS user_a,
                       damped_rank   AS rank,
                       FLATTEN(network.num_out_links),
                       FLATTEN(network.out_links)
                   ;
               };

rmf                    $NEXT_ITER_FILE 
STORE sum_shares INTO '$NEXT_ITER_FILE';
