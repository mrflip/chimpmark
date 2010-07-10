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
--    pig -p wikidump_fix_pagelinks.pig 
--
-- get fancy:
--
--    PIG_OPTS="-Dio.sort.record.percent=0.20 -Dio.sort.mb=300" pig -p PAGELINKS_PREP_FILE=$pagelinks_prep -p PAGELINKS_FILE=$pagelinks_file wikidump_fix_pagelinks.pig 
--
-- Copyright 2010, Flip Kromer for Infochimps, Inc
-- Released under the Apache License
--

%default PAGE_INFO_FILE      '/data/rawd/wikidump/page_info'
%default PAGELINKS_PREP_FILE '/tmp/wikidump-prep/pagelinks-prep'
%default PAGELINKS_FILE      '/data/rawd/wikidump/pagelinks'

--  
-- page_id ns      title                   rest    ctr     redir?  new?    rand?                   touched         latest_rev      len
-- 10      0       AccessibleComputing             0       1       0       0.33167112649574        20100621103213  133452289       57
-- 12      0       Anarchism                       5252    0       0       0.786172332974311       20100628041732  370527139       84666
-- 13      0       AfghanistanHistory              5       1       0       0.0621502865684687      20100624091507  74466652        57
-- 14      0       AfghanistanGeography            0       1       0       0.952234464653055       20100621230030  74466619        59
--
--
PageInfo     = LOAD '$PAGE_INFO_FILE' AS (page_id:long, ns:int, title:chararray, restr:chararray, counter:long, is_redir:int, is_new:int, rand:float, touched:long, latest_rev:long, len:long);
PageInfoIds  = FOREACH PageInfo GENERATE  page_id, ns, title;

--
-- Raw pagelinks file is tab-separated: source id in first column, destination ns+title in second
--
-- 23567310	0	1819-1820
-- 15843327	0	1877_Shamokin,_Pennsylvania_Uprising
-- 17313825	0	1981
-- 10291435	0	1984
-- 10292620	0	1984
--
PagelinksPrep = LOAD '$PAGELINKS_PREP_FILE' AS (src_id:long, dest_ns:int, dest_title:chararray);

--
-- JOIN to convert titles to ids
--
Pagelinks_0 = JOIN PagelinksPrep BY (dest_ns, dest_title) LEFT OUTER, PageInfoIds BY (ns, title) PARALLEL 10 ;
Pagelinks_1 = FOREACH Pagelinks_0 GENERATE PagelinksPrep::src_id AS src_id, PageInfoIds::page_id AS dest_id;
Pagelinks   = ORDER Pagelinks_1 BY src_id ASC;

--
-- Save output
--
rmf                   $PAGELINKS_FILE
STORE Pagelinks INTO '$PAGELINKS_FILE' ;
