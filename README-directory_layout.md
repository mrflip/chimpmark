
Proposed layout:

<pre><code>

/data
  /source                                       -- source holds data from elsewhere, not yet useful to us
    /wikidata/*
  /rawd                                         -- rawd holds the raw data from which everything else comes
    /wikistats/pagestats                        -- one page-day-hour count per line, tsv
    /wikidump/articles.xml                      -- flattened xml fragments, one per article
    /linkgraph/edges                            -- adjacency pairs graph, tsv
    /linkgraph/pageinfo                         -- maps ids to page info, tsv
 
  /basic
  /graph
  /stats
  /text
     ... [each organized like the challenges dir]


</code></pre>     
