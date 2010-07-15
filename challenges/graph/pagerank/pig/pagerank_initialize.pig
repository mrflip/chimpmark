--
-- Create initial graph on which to iterate the pagerank algorithm.
--
%default ADJLIST  'sample.tsv'
%default INITGRPH 'pagerank_graph_000'

--
-- Generate a unique list of nodes with in links to cogroup on. This allows
-- us to treat the case where nodes have in links but no out links.
--
network     = LOAD '$ADJLIST' AS (rsrc:chararray, user_a:long, user_b:long);
cut_rhs     = FOREACH network GENERATE user_b;
uniq_rhs    = DISTINCT cut_rhs;
cut_links   = FOREACH network GENERATE user_a, user_b;
list_links  = COGROUP cut_links BY user_a, uniq_rhs BY user_b;
count_links = FOREACH list_links
              {
                  -- if cut_links.user_b is empty there are no out links, set to dummy value
                  out_links = (IsEmpty(cut_links.user_b) ? {(999999999)} : cut_links.user_b);
                  GENERATE
                      group     AS user_a,
                      1.0       AS rank,
                      out_links AS out_links
                  ;
              };

rmf $INITGRPH;
STORE count_links INTO '$INITGRPH';
