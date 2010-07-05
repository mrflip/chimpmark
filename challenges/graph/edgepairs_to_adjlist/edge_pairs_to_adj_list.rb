

EDGE_PAIRS_FILE = '/chimpmark-data/wikigraph.txt'

EdgePairs_0 = LOAD '/data/rawd/wp/linkgraph/a_linksto_b' AS ( src:long, dest:long );
EdgePairs   = LIMIT EdgePairs_0 10000;

AdjList_0 = GROUP EdgePairs BY src;
AdjList   = FOREACH AdjList_0 GENERATE group, EdgePairs.dest;


