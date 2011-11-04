h1. ChimpMARK-2010: Big Data Benchmark on Real-World Datasets

The ChimpMARK-2010 is a collection of massive real-world datasets, interesting real-world problems, and simple example code to solve them. Learn Big Data processing, benchmark your cluster, or compete on implementation!

Why?

* Estimate run time for a job using runtimes for tasks with similar size, shape and atomic operations.
* With known data and code, you can performance-qualify cluster. How fast should a join run on a 10-machine cluster of m1.large instances?
* Understand how cluster settings should be tuned in response to job characteristics.
* Compare clusters of equivalent nominal power (CPU, cores, memory) across data centers or hardware configs: AWS vs Rackspace vs private cluster, go!
* Different core technologies (pig vs. wukong vs. raw Java) can compete on run time, efficiency, elegance, and size of code.

Each problem is meant to a) to be a real-world task, b) to nonetheless encapsulate a very small, generic number of operations. For instance, adjacency pairs => adjacency list on the wikipedia link graph is really just a GROUP, but in particular it's a group on very small records with median multiplicity of ~5, maximum in the thousands, and low skew.

**Note: this is a planning document: the repo contains no code yet**. There's a great variety of example code -- the foundations of what will appear here -- in the "wukong repo":http://github.com/infochimps/wukong/tree/master/examples/

h2. Goals:

* Datasets at full size should be about 30-200GB raw size on HDFS (that is, ready to process, not counting replication multiplier)
* Run tasks times on 5%, 20% and 100% samples
* Cluster sizes from 5 to 15 machines m1.small, c1.medium, m2.xl
* Important that all datasets be *completely* unencumbered by copyright issues or controversy
* Exercise CPU-bound, IO-bound and memory-bound operations
* Tasks should be specified so that say Solr or Cassandra can show example code.

h2. Corpora:

* **Graph**: "Wikipedia page links dataset,":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596 a wikipedia linkgraph dataset provided by Henry Haselgrove. These files contain all links between proper english language Wikipedia pages. This will be converted to a list of [src_id dest_id] adjacency pairs and a lookup table [id => page information].
* **Short Documents**: Want a table having an interesting ~200-char free-text field and several columns of metadata. (Basically, we wish we could use the twitter tweets corpus, but can't because of copyright.)  Enron email corpus? Web page headers? Should be 100-200 GB of 500-char records
* **Long Documents**: Want a large interesting colxn of web pages: useful for parsing, link graph generation.  Should be 100-200 GB of 10k - 1M records.
* **Log files**: "Wikipedia Traffic Statistics Dataset,":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596 contains hourly wikipedia article traffic statistics dataset covering 7 month period from October 01 2008 to April 30 2009 (collected from the wikipedia squid proxy by Domas Mituzas). Will be denormalized into [date hour namespace title pageviews_that_hour page_id page_size], where the page_id has the same mapping as in the link graph.
* **Spreadsheet-ish**: Want something in the traditional OLAP regime: a large table of several numeric columns and a few classification columns. Perhaps "Business and Industry Summary Data":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2342&categoryID=248 or "2003-2006 US Economic Data":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2341&categoryID=248

h2. Ideas for Tasks:

|_. Problem                                      | Dataset                 | Operations exercised                               |
|                                                |                         |                                                    |
|_. Cat wrangling                                |                         |                                                    |
|  sort on numeric field, 1k-char records        | wp traffic              | ORDER                                              |
|  sort on numeric field, 6 numeric columns      | spreadsheet             | ORDER                                              |
|  sort wp by page titles                        | long documents          | ORDER                                              |
|  create inverted index                         | long documents          | tokenize, group                                    |
|  word count (simple tokenization)              | long documents          | tokenize, group, count                             |
|  word count (advanced tokenization)            | long documents          | complex code, group                                |
|  uniform (x% random sample)                    | short documents         | FILTER                                             |
|  uniform (x% random sample)                    | long documents          | FILTER                                             |
|  make a single .gz file on non-HDFS            | human genome?           | want higher entropy                                |
|  make a single .gz file on non-HDFS            | graph                   | want very low entropy                              |
|  simple filter on 10k files, most smaller than block size | constructed for task | job startup time                           |
|  uniq -c                                       | short documents         | distinct, count                                    |
|  uniq -c                                       | long documents          | distinct, count                                    |
|                                                |                         |                                                    |
|_. Graph                                        |                         |                                                    |
|  turn adjacency pairs into adj list            | wp graph                | GROUP, no combiner                                 |
|  given adj. pairs, get counts of in-links and out-links  | wp graph      | GROUP and COUNT, no combiner                       |
|  join the counts of in-links and out-links by node | wp graph            | JOIN that is 1:1                                   |
|  pagerank                                      | wp graph                | workflow; complex code                             |
|  breadth first search                          | wp graph                | JOIN, very memory-intensive                        |
|  1-clique                                      | breadth-first search    | JOIN huge on big with low overlap                  |
|  sub-universe (get random sample, and corr. records from assoc datasets) | graph + short documents | complex code             |
|  put aggregated counts on adjacency list       | wp graph + wp traffic   | JOIN huge on big with 100% overlap                 |
|                                                |                         |                                                    |
|_. Filter                                       |                         |                                                    |
|  filter on numeric criteria                    | spreadsheet             | FILTER                                             |
|  split on simple criteria into 5 files: every record to exactly 1 file   | spreadsheet | SPLIT                                |
|  split on simple criteria into 5 files: records could go to some, none or any of the files | spreadsheet | SPLIT              |
|  regex search                                  | short documents         | FILTER, MATCHES                                    |
|  100 keywords                                  | short documents         | FILTER, MATCHES                                    |
|  100 keywords                                  | long documents          | FILTER, MATCHES                                    |
|  30,000 keywords                               | short documents         | FILTER, trie?                                      |
|  1000 keywords + huge inverted index           | inverted index          | fragment replicate JOIN (JOIN big on tiny)         |
|                                                |                         |                                                    |
|_. Parse                                        |                         |                                                    |
|  extract title, keyword, desc from HTML head   | long documents          | complex code                                       |
|  extract all a and img etc URLs from HTML      | long documents          | complex code; CPU-bound                            |
|                                                |                         |                                                    |
|_. OLAP / Stats                                 |                         |                                                    |
|  simple statistics: avg, stdev, counts         | spreadsheet             | GROUP, FOREACH                                     |
|  top-N: find top 100 pages by views per day    | wp traffic statistics   | GROUP, nested FOREACH                              |
|  something very CPU-intensive in foreach       | [some bio dataset]      | CPU-intensive in inner loop                        |
|  linear regression                             | spreadsheet             | ..                                                 |
|  assign percentiles                            | spreadsheet             | ..                                                 |
|                                                |                         |                                                    |
|_. Geo                                          |                         |                                                    |
|                                                |                         |                                                    |
|   take (x,y) pairs giving points of interest; for each point, roll up all points within radius R | weather stations + ML ballparks |   |
|                                                |                         |                                                    |
|_. Misc                                         |                         |                                                    |
|  render as JSON                                | spreadsheet?            | stream                                             |
|                                                |                         |                                                    |
|_. Infrastructure                               |                         |                                                    |
|  count the characters in a single line file    | tiny file               | process overhead                                   |

h2. Ideas for Atomic Operations to be exercised

* group all
* group by
* cogroup A by a0 left, B by b1 left
* cogroup A by a0 left, B by b1 right
* join big, huge
* join A, B, C
* join tiny, big
* join sorted, sorted

* cross A, B

* distinct A
* filter A by regex
* filter A by (a in set_of_100_items)
* filter A by (a in set_of_100_000_items)

* sort A by number
* sort A by character

* inverted index: => gutenberg
*   tokenize doc:         [word, doc, line]
*   group on word:        word => [ [doc,count], [doc,count], [doc,count], ... ] * in descending order by count
*   group on word+doc:    [word, doc] => [line, line, line, ...]

* relative frequency => gutenberg
*   group by document. => [doc  tok  doc_tok_count  doc_tok_freq doc_vocab]
*   group by token.    => [     tok  all_tok_count  all_tok_freq avg_doc_tok_freq  * stdev_doc_tok_freq  tok_dispersion  tok_range ]
*   group by

* parse XXX


h2. Detailed Dataset Descriptions

h3. Graph: wikidata/wikilinks (1.1G)

"Wikipedia page links dataset":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596 contains a wikipedia linkgraph dataset provided by Henry Haselgrove. These files contain all links between proper english language Wikipedia pages, that is pages in "namespace 0". This includes disambiguation pages and redirect pages.   [ convert this to adj. pairs -- or to be directly loadable in pig ] In links-simple-sorted.txt, there is one line for each page that has links from it. The format of the lines is:
<pre><code>
      from1: to11 to12 to13 ...
      from2: to21 to22 to23 ...
      ...
</code></pre>
  where from1 is an integer labelling a page that has links from it, and to11 to12 to13 ... are integers labelling all the pages that the page links to. To find the page title that corresponds to integer n, just look up the n-th line in the file titles-sorted.txt.

h3. Short Documents 1: ???

uniform ~150-200 char fields + metadata

h3. Long Documents: Large interesting colxn of web pages

typically 10k - 1M files

h3. Log

h4. Wikipedia Traffic Statistics Dataset

  Contains hourly wikipedia article traffic statistics dataset covering 7 month period from October 01 2008 to April 30 2009, this data is regularly logged from the wikipedia squid proxy by Domas Mituzas.
  Each log file is named with the date and time of collection: pagecounts-20090430-230000.gz
  Each line has 4 fields: projectcode, pagename, pageviews, bytes

<pre><code>
        en Barack_Obama                         997 123091092
	en Barack_Obama%27s_first_100_days        8 850127
	en Barack_Obama,_Jr                       1 144103
	en Barack_Obama,_Sr.                     37 938821
	en Barack_Obama_%22HOPE%22_poster         4 81005
	en Barack_Obama_%22Hope%22_poster         5 102081
</code></pre>

   we should denormalize into

<pre><code>
        date 	hour	en Barack_Obama                         997 123091092
	date 	hour	en Barack_Obama%27s_first_100_days        8 850127
	date 	hour	en Barack_Obama,_Jr                       1 144103
	date 	hour	en Barack_Obama,_Sr.                     37 938821
	date 	hour	en Barack_Obama_%22HOPE%22_poster         4 81005
	date 	hour	en Barack_Obama_%22Hope%22_poster         5 102081
</code></pre>

h3. Spreadsheet-ish: (Business and Industry Summary Data?)

Choices:
* "Business and Industry Summary Data":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2342&categoryID=248
* "2003-2006 US Economic Data":http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2341&categoryID=248

