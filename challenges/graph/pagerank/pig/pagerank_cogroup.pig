%default CURR_ITER_FILE '../data/pagerank_graph_000'
%default NEXT_ITER_FILE '../data/pagerank_graph_001'
%default DAMP   '0.85f' -- naively accepting that given in the wikipedia article on pagerank...

--
-- Demonstrates complex load function...
-- Data sits in the file as:
--
-- Vargas    1.0    4    {(Kevin),(Gene),(Feldman),(ElaineBenes)}
--

network      = LOAD '$CURR_ITER_FILE' AS (user_a:long, rank:float, out_links:bag { link:tuple (user_b:long) });
sent_shares  = FOREACH network GENERATE FLATTEN(out_links) AS user_b, (float)(rank / (float)SIZE(out_links)) AS share:float;
sent_links   = FOREACH network GENERATE user_a, out_links;

rcvd_shares  = COGROUP sent_links BY user_a, sent_shares BY user_b PARALLEL 58;
next_iter    = FOREACH rcvd_shares
               {
                   raw_rank    = (float)SUM(sent_shares.share);
                   damped_rank = (raw_rank > 1.0e-12f ? raw_rank*0.85f + 0.15f : 0.0f);
                   GENERATE
                       group         AS user_a,
                       damped_rank   AS rank,
                       FLATTEN(sent_links.out_links) -- hack, should only be one, unbag it
                   ;
               };
rmf                   $NEXT_ITER_FILE 
STORE next_iter INTO '$NEXT_ITER_FILE';


-- network_3    = FOREACH network GENERATE user_a, rank, out_links;
-- network_f    = FILTER network_3 BY NOT( (user_a IS NOT NULL) AND (user_a != 0) AND (rank > 1.0e-12f) AND (NOT IsEmpty(out_links)) );
-- rmf                   /data/sn/tw/rawd/pagerank/a_follows_b/pig/pagerank_graph_004_g
-- STORE network_f INTO '/data/sn/tw/rawd/pagerank/a_follows_b/pig/pagerank_graph_004_g';
