--
-- Chimpmark :: Graph :: Find symmetric Edges
--
-- 
--

Edges = LOAD '/data/rawd/wp/linkgraph/a_linksto_b-100k.tsv' AS (src:long, dest:long );

-- remove edge's directionality: put the lower-numbered one first 
UndirectedEdges = FOREACH Edges GENERATE ((src <= dest) ? src : dest), ((src <= dest) ? dest : src) ;

-- Group and count each undirected edge:
UndirectedEdgesCount_0 = GROUP UndirectedEdges BY (src, dest) ;
UndirectedEdgesCount   = FOREACH UndirectedEdgesCount_0 GENERATE group.src, group.dest, COUNT(UndirectedEdges) AS edge_count;
SymmetricEdges_0       = FILTER UndirectedEdgesCount BY edge_count == 2 ;
SymmetricEdges         = FOREACH SymmetricEdges_0 GENERATE src, dest; 


rmf                        /data/rawd/wp/linkgraph/a_symm_b-100k.tsv  ;  
STORE SymmetricEdges INTO '/data/rawd/wp/linkgraph/a_symm_b-100k.tsv' ;

-- ***************************************************************************
--

--

SymmEdges_0 = JOIN Edges BY (src, dest), Edges BY (dest, src) ;
SymmEdges   = FOREACH SymmEdges GENERATE group.$0 AS edge_a, group.$1 AS edge_b;



rmf                        /data/rawd/wp/linkgraph/a_symm_b-fromjoin-100k.tsv  ;  
STORE SymmetricEdges INTO '/data/rawd/wp/linkgraph/a_symm_b-fromjoin-100k.tsv' ;

