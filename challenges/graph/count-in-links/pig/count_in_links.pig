%default GRAPH  /data/rawd/wp/linkgraph/a_linksto_b
%default TITLES /data/rawd/wp/article_info/article_titles
%default OUTPUT /data/graph/count-in-links/pig/count-in-links

graph = LOAD '$GRAPH' using PigStorage() as (from_id:int,to_id:int);
graph_group = GROUP graph by to_id;
in_count = FOREACH graph_group GENERATE group as id, COUNT(graph) as count; 
titles = LOAD '$TITLES' using PigStorage() as (id:int,title:chararray);
title_count_0 = JOIN in_count by id, titles by id ;
title_count = FOREACH title_count_0 GENERATE $0 as id, $3 as title, $1 as count;
--EXPLAIN title_count;
STORE title_count into '$OUTPUT' using PigStorage();
