%default A_REPLIES_B_FILE 'a_replies_b.tsv'
%default N1X_EDGES_FILE    'n1x_edges.tsv'
%default N0_SEED           'jerry'

Edges  = LOAD '$A_REPLIES_B_FILE' AS (user_a:chararray, user_b:chararray);

-- Extract all edges that originate or terminate on the seed (n0)
E1_Edges  = FILTER Edges BY (user_a == '$N0_SEED') OR (user_b == '$N0_SEED');

--
-- Find all nodes in the in or out 1-neighborhood (at radius 1 from our seed)
--
all_nbrs = FOREACH E1_Edges GENERATE ((user_a == '$N0_SEED') ? user_b : user_a) AS node;
n1x      = DISTINCT all_nbrs;

-- Find all edges that originate in n1x
edges_from_n1x_0 = JOIN Edges BY user_a, n1x BY node using 'replicated';
edges_from_n1x   = FOREACH edges_from_n1x_0 GENERATE Edges::user_a, n1x::node AS user_b;

-- Among those edges, find those that terminate in n1x as well
edges_within_n1x_0 = JOIN edges_within_n1x BY user_b, n1x BY node using 'replicated';
edges_within_n1x   = FOREACH edges_within_n1x_0 GENERATE user_a, user_b;

-- Save the result
rmf                          $N1X_EDGES_FILE;
STORE edges_within_n1x INTO '$N1X_EDGES_FILE';
