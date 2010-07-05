--
-- edgepairs_to_indegree.pig
--
-- This takes an edge-pairs representation of a graph
--
--    src       dest
--
-- and finds the in-degree (number of incoming edges)
-- and neighbor count (number of distinct nodes)
--
--    node      in_degree       neighbor_count
--
-- Usage:
--
--    pig -p A_REPLIES_B_FILE=a_replies_b.tsv edgepairs_to_indegree.pig 
--
-- Copyright 2010, Flip Kromer for Infochimps, Inc
-- Released under the Apache License
--

%default A_REPLIES_B_FILE  'a_replies_b.tsv'
%default A_INDEGREE_FILE   'a_indegree.tsv'

--
-- Edges file is tab-separated: source label in first column, destination label in second
--
-- -- Elaine	george
-- -- Elaine	jerry
-- -- Elaine	jerry
-- -- Newman	Elaine
-- -- george	jerry
-- -- george	kramer
-- -- jerry	Elaine
-- -- jerry	george
-- -- jerry	kramer
-- -- kramer	Elaine
-- -- kramer	george
-- -- kramer	jerry
-- -- kramer	jerry
-- -- kramer	Newman
--
Edges    = LOAD '$A_REPLIES_B_FILE' AS (src: chararray, dest:chararray);

--
-- Find all edges incoming to each node by grouping on destination
--
-- -- (jerry,{(Elaine,jerry),(Elaine,jerry),(george,jerry),(kramer,jerry),(kramer,jerry)})
-- -- (Elaine,{(kramer,Elaine),(Newman,Elaine),(jerry,Elaine)})
-- -- (Newman,{(kramer,Newman)})
-- -- (george,{(Elaine,george),(kramer,george),(jerry,george)})
-- -- (kramer,{(george,kramer),(jerry,kramer)})
--
InEdges = GROUP Edges BY dest;

DUMP InEdges;

--
-- Count the distinct incoming repliers (neighbor nodes) and the total incoming replies
--
-- -- jerry	3	5
-- -- Elaine	3	3
-- -- Newman	1	1
-- -- george	3	3
-- -- kramer	2	2
--
InDegree  = FOREACH InEdges { nbrs = DISTINCT Edges.src ; GENERATE group, COUNT(nbrs), COUNT(Edges) ; };

-- Save the output.
rmf                  $A_INDEGREE_FILE
STORE InDegree INTO '$A_INDEGREE_FILE';
