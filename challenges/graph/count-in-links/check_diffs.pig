%default PIG_FILE    /data/graph/count-in-links/pig/count-in-links
%default WUKONG_FILE /data/graph/count-in-links/wukong/count-in-links

pig    = LOAD '$PIG_FILE'    using PigStorage() as (id:int,title:chararray,count:int);
wukong = LOAD '$WUKONG_FILE' using PigStorage() as (id:int,title:chararray,count:int);
cogrp  = COGROUP pig BY id, wukong BY id;
expand = FOREACH cogrp GENERATE group as id,FLATTEN( pig.title) as ptitle, FLATTEN( pig.count ) as pcount, FLATTEN( wukong.title ) as wtitle, FLATTEN( wukong.count ) as wcount;
filt   = FILTER expand BY (ptitle != wtitle) OR (pcount != wcount);
DUMP filt;
