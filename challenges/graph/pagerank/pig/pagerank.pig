%default PRGRPH '../data/pagerank_graph_000'
%default OUT    '../data/pagerank_graph_001'
%default DAMP   '0.85' -- naively accepting that given in the wikipedia article on pagerank...
--
-- Demonstrates complex load function...
-- Data sits in the file as:
--
-- Vargas    1.0    4    {(Kevin),(Gene),(Feldman),(ElaineBenes)}
--

network      = LOAD '$PRGRPH' AS (user_a:chararray, rank:float, num_out_links:int, out_links:bag { link:tuple (user_b:chararray) });
give_shares  = FOREACH network GENERATE FLATTEN(out_links) AS user_a, (float)rank / (float)num_out_links AS share:float;
filtered     = FILTER give_shares BY (user_a IS NOT NULL AND share IS NOT NULL); --this should not be necessary...
list_shares  = GROUP filtered BY user_a;
sum_shares   = FOREACH list_shares
               {
                   raw_rank    = SUM(filtered.share);
                   damped_rank = (raw_rank == 0.0 ? 0.0 : raw_rank*$DAMP + 1.0 - $DAMP);
                   GENERATE
                       group       AS user_a,
                       damped_rank AS damped_rank
                   ;
               };
update_graph = JOIN sum_shares BY user_a, network BY user_a;
out = FOREACH update_graph GENERATE
          network::user_a         AS user_a,
          sum_shares::damped_rank AS damped_rank,
          network::num_out_links  AS num_out_links,
          network::out_links      AS out_links
      ;

rmf $OUT;
STORE out INTO '$OUT';
