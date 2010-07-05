--
-- edgepairs_to_adjlist.pig
--
-- This takes an edge-pairs representation of a graph
--
--    src       dest
--
-- and converts it to adjacency-list representation
--
--    src 	destA,destB,destC
--
--
-- Usage:
--
--    pig -p A_REPLIES_B_FILE=a_replies_b.tsv edgepairs_to_adjlist.pig 
--
-- Copyright 2010, Flip Kromer for Infochimps, Inc
-- Released under the Apache License
--

%default A_REPLIES_B_FILE      'a_replies_b.tsv'
%default REPLIES_ADJ_LIST_FILE 'replies_adj_list.tsv'

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
-- Group edges by their source node
--
-- -- (jerry,{(jerry,Drake),(jerry,Elaine)})
-- -- (Elaine,{(Elaine,george),(Elaine,jerry)})
-- -- (Newman,{(Newman,Elaine)})
-- -- (george,{(george,jerry),(george,kramer)})
-- -- (kramer,{(kramer,Elaine),(kramer,george),(kramer,jerry),(kramer,Newman)})
--
SrcEdges = GROUP Edges BY src;

--
-- Retain only the distinct destination nodes
--
-- -- (Elaine,{(george),(jerry)})
-- -- (Newman,{(Elaine)})
-- -- (george,{(jerry),(kramer)})
-- -- (jerry,{(Drake),(Elaine)})
-- -- (kramer,{(Elaine),(Newman),(george),(jerry)})
--
RepliesAdjList = FOREACH SrcEdges { nbrs = DISTINCT Edges.dest ; GENERATE group, nbrs ; };

-- Save the output.
rmf                        $REPLIES_ADJ_LIST_FILE
STORE RepliesAdjList INTO '$REPLIES_ADJ_LIST_FILE';
