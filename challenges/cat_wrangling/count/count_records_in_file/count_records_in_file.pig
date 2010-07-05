--
-- Chimpmark
--
-- Counts the number of lines
--
Edges = LOAD '/data/rawd/wp/linkgraph/a_linksto_b-100k.tsv' AS (src:long, dest:long );
EdgesCount_0 = GROUP Edges ALL ;
EdgesCount   = FOREACH EdgesCount_0 GENERATE COUNT(Edges);

-- (100000L)
DUMP EdgesCount ;
