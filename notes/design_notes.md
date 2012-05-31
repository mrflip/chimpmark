
## Goals:

* Datasets at full size should be about 30-200GB raw size on HDFS (that is, ready to process, not including replication multiplier)
* Run tasks times on 5%, 20% and 100% samples
* Cluster sizes from 5 to 15 machines m1.small, c1.medium, m2.xl
* Important that all datasets be *completely* unencumbered by copyright issues or controversy
* Exercise CPU-bound, IO-bound and memory-bound operations
* Tasks should be specified so that say Solr or Cassandra can show example code.

## Corpora:

* **Graph**: "Wikipedia page links dataset,":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596 a wikipedia linkgraph dataset provided by Henry Haselgrove. These files contain all links between proper english language Wikipedia pages. This will be converted to a list of [src_id dest_id] adjacency pairs and a lookup table [id => page information].
* **Short Documents**: Want a table having an interesting ~200-char free-text field and several columns of metadata. (Basically, we wish we could use the twitter tweets corpus, but can't because of copyright.)  Enron email corpus? Web page headers? Should be 100-200 GB of 500-char records
* **Long Documents**: Want a large interesting colxn of web pages: useful for parsing, link graph generation.  Should be 100-200 GB of 10k - 1M records.
* **Log files**: "Wikipedia Traffic Statistics Dataset,":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596 contains hourly wikipedia article traffic statistics dataset covering 7 month period from October 01 2008 to April 30 2009 (collected from the wikipedia squid proxy by Domas Mituzas). Will be denormalized into [date hour namespace title pageviews_that_hour page_id page_size], where the page_id has the same mapping as in the link graph.
* **Statistical**: Want something in the traditional OLAP regime: a large table of several numeric columns and a few classification columns. Perhaps "Business and Industry Summary Data":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2342&categoryID=248 or "2003-2006 US Economic Data":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2341&categoryID=248


## Tasks


Discarded:

* Shingling of Documents
* K-Means Clustering
