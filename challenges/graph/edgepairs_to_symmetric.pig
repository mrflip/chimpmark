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

%default A_REPLIES_B_FILE 'a_replies_b.tsv'
%default SYMM_EDGES_FILE  'symm_edges.tsv'

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
-- Don't do this:
--
-- Edges_1 = LOAD '/Users/flip/ics/me/blog_posts/hadoop_book/foo.tsv' AS (src: chararray, dest:chararray);
-- Edges_2 = LOAD '/Users/flip/ics/me/blog_posts/hadoop_book/foo.tsv' AS (src: chararray, dest:chararray);
-- SymmEdges_0 = JOIN Edges_1 BY (src, dest), Edges_2 BY (dest, src) ;
-- SymmEdges_1 = FOREACH SymmEdges_0 GENERATE Edges_1::src, Edges_1::dest;
-- SymmEdges_2 = DISTINCT SymmEdges_1;
--

-- do this:

-- UndirectedEdges = FOREACH Edges GENERATE
--   ((src <= dest) ? src  : dest) AS user_a,
--   ((src <= dest) ? dest : src)  AS user_b,
--   ((src <= dest) ? 1 : 0)       AS a_replies_b:int,
--   ((src <= dest) ? 0 : 1)       AS b_replies_a:int;
-- UserEdges_0 = GROUP UndirectedEdges BY (user_a, user_b);
-- UserEdges   = FOREACH UserEdges_0 { 
--   a_replies_b_count = (int)SUM(UndirectedEdges.a_replies_b) ; 
--   b_replies_a_count = (int)SUM(UndirectedEdges.b_replies_a) ; 
--   is_symmetric = (((a_replies_b_count > 0) AND (b_replies_a_count > 0)) ? 1 : 0);
--   GENERATE group.user_a AS user_a, group.user_b AS user_b,
--     a_replies_b_count AS a_replies_b_count:int, 
--     b_replies_a_count AS b_replies_a_count:int, 
--     is_symmetric AS is_symmetric:int; 
-- };
-- SymmEdges = FILTER UserEdges BY (is_symmetric == 1);

    UndirectedEdges = FOREACH Edges GENERATE
      ((src <= dest) ? src  : dest) AS user_a,
      ((src <= dest) ? dest : src)  AS user_b,
      ((src <= dest) ? 1 : 0)       AS a_replies_b:int,
      ((src <= dest) ? 0 : 1)       AS b_replies_a:int;
    UserEdges_0 = GROUP UndirectedEdges BY (user_a, user_b);
    UserEdges   = FOREACH UserEdges_0 GENERATE 
      group.user_a AS user_a, 
      group.user_b AS user_b,
      ( ((SUM(UndirectedEdges.a_replies_b) > 0) AND (SUM(UndirectedEdges.b_replies_a) > 0)) ? 1 : 0) AS is_symmetric:int; 

    DUMP UserEdges;

    SymmEdges = FILTER UserEdges BY (is_symmetric == 1);


-- Save the output.
rmf                   $SYMM_EDGES_FILE
STORE SymmEdges INTO '$SYMM_EDGES_FILE';
