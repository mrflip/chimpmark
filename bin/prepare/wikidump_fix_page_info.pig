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
--    PIG_OPTS="-Dio.sort.record.percent=0.20 -Dio.sort.mb=300" pig ~/ics/hadoop/chimpmark/bin/prepare/wikidump_fix_pagelinks.pig
--
-- Copyright 2010, Flip Kromer for Infochimps, Inc
-- Released under the Apache License
--

%default PAGE_INFO_PREP '/tmp/wikidump-prep/page_info-prep'
%default PAGE_INFO_FILE '/data/rawd/wikidump/page_info'

PageInfoPrep   = LOAD '$PAGE_INFO_PREP' AS (page_id:long, ns:int, title:chararray, restr:chararray, counter:long, is_redir:int, is_new:int, rand:float, touched:long, latest_rev:long, len:long);
PageInfo       = ORDER PageInfoPrep BY page_id ASC;

--
-- Save output
--
rmf                  $PAGE_INFO_FILE
STORE PageInfo INTO '$PAGE_INFO_FILE' ;
