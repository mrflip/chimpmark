# ChimpMARK-2010: Big Data Benchmark on Real-World Datasets

The ChimpMARK-2010 is a collection of massive real-world datasets, interesting real-world problems, and simple example code to solve them. Learn Big Data processing, benchmark your cluster, or compete on implementation!

Why?

* Estimate run time for a job using runtimes for tasks with similar size, shape and atomic operations.
* With known data and code, you can performance-qualify cluster. How fast should a join run on a 10-machine cluster of m1.large instances?
* Understand how cluster settings should be tuned in response to job characteristics.
* Compare clusters of equivalent nominal power (CPU, cores, memory) across data centers or hardware configs: AWS vs Rackspace vs private cluster, go!
* Different core technologies (pig vs. wukong vs. raw Java) can compete on run time, efficiency, elegance, and size of code.

Each problem is meant to a) to be a real-world task, b) to nonetheless encapsulate a very small, generic number of operations. For instance, adjacency pairs => adjacency list on the wikipedia link graph is really just a GROUP, but in particular it's a group on very small records with median multiplicity of ~5, maximum in the thousands, and low skew.

**Note: this is a planning document: the repo contains no code yet**. There's a great variety of example code -- the foundations of what will appear here -- in the "wukong repo":http://github.com/infochimps/wukong/tree/master/examples/


______________________________________________________________________________

## Datasets

The required datasets all bear open licenses and are available through [Infochimps](http://infochimps.com/)

* **Daily Weather** (`daily_weather`) -- NCDC Global Summary of US Daily Weather (GSOD), 1930-2011 (Public Domain). Contains about 20 numeric columns; the basis for several geospatial, timeseries and statistical questions.
  - Weather Observations: weather station id, date, and observation data (temperature, wind speed and so forth).
  - Weather Station metadata: weather station id, longitude/latitude/elevation, periods of service
  - Weather Station spatial coverage: Polygons approximating each weather station's area of coverage by year. (Within each polygon, you are closer to the contained weather station than to any other weather station operating that year.) Contains a GeoJSON polygon feature describing the spatial extent along wiht the weather station id, year, and longitude/latitude/elevation.
* **Wikipedia Corpus** (`wp_corpus`) -- The October 2011 dump of all english-language wikipedia articles in source (mediawiki) format. (This is the snapshot of each page's current state, not the larger dataset containing all edits.)
  - `page title | page id | redirect | extended abstract | lng | lat | keywords | text`
* **Wikipedia Extracted Facts** (`wp_extraction`)
* **Wikipedia Pagelinks** (`wp_linkgraph`)
  - `page_id | dest,dest,dest`
* **Wikipedia Pageview logs** (`wp_weblogs`)
  - `page_id | date | hour | count`
  
### Size and Shape

    Dataset             Rows    GB      RecSz   +/-     Skew
    -------             ----    --      -----   ---     ----
    Daily Weather       xx      xx      xx      xx      low 
    WP Corpus           xx      xx      xx      xx      
    WP Page Graph       xx
    WP Page Views



## Challenges

### Statistical Summary of Global Weather Trends

Send weather observations to macro tiles, and calculate statistics (min, max, average, stdev, mode, median and percentiles).

* Join weather data and voronoi tiles; dispatch 

* calculate same but on all rows

_demonstrates_: support for statistical analysis; high skew reduce

### Similarity

### Anomaly Detection on a Timeseries

Pageview anomalies

Sessionize pageviews

### Logistic Regression

Which pages are correlated with the weather?

### Simple Geopatial Rollup of Weather Data


### Pagerank


_Demonstrates_: iterative workflows

### Enumerate Triangles (Clustering Coefficient)

_demonstrates_: large amount of midstream data


* count in- and out-degree for each noe; filter out nodes with total degree <= 1.
* assemble the min-degree-ordered adjacency list (maps node to all its in- or out-neighbors of higher degree)
* emit cross product of neighbor+neighbor pairs
* intersect to find only triangles

### Clustering

### Document Clustering 

* Calculate top-k TF/IDF terms (based on threshold importance and max size)
* use minhashing into LSH
  - For i = 1...m
    - Generate a random order h i on words
    - m hi(u) = argmin {hi(w) | w  Bu}

* Tokenize the documents (following mildly complicated rules)
* Generate wordbag for each doc, stripping out words that occur > hi_thresh (fixed, and these stopwords are given in advance, or you can enumerate and then chop) and stripping out words that occur < lo_thresh in full corpus
* (want circa 50_000 terms? 50,000 terms . 3,000,000 documents = 150 B cells

* count of terms in document, count of usages in document
* ent:   `-sum(s*log(s))/log(length(s))` (relative entropy of all sizes of the corpus parts)

For each term:
* Rg:    range -- count of docs it occurs in
* f:     freq (fractional count in whole corpus), dispersion (), log likelihood
* stdev: standard deviation
* chisq: chi-squared
* disp:  Julliand's D -- `1 - ( (sd(v/s) / mean(v/s)) / sqrt(length(v/s) - 1) )`
* IDF:   `log_2( N / Rg )`

http://www.linguistics.ucsb.edu/faculty/stgries/research/2008_STG_Dispersion_IJCL.pdf

### Co-ocurrence Graph

See Mining of Massive Datasets p208 - a-priori algorithm...
step I calculate frequent items

Step II:
1. For each basket, look in the frequent-items table to see which of its items are frequent.
2. In a double loop, generate all frequent pairs.
3. For each frequent pair, add one to its count in the data structure used to
store counts.
4. Finally, at the end of the second pass, examine the structure of counts to determine which pairs are frequent.

Park, Chen, and Yu (PCY)

In step I, keep a count of items. Also, for each piar take hash and bump the count in that bucket.

We can define the set of candidate pairs C2 to be those pairs {i, j} such that:
1. i and j are frequent items.
2. {i, j} hashes to a frequent bucket.
For even better results, use two or more hashes (each in a separate hash table)


## Tasks:

    |_. Problem                                      | Dataset                 | Operations exercised                               |
    |                                                |                         |                                                    |
    |_. Cat wrangling                                |                         |                                                    |
    |  total sort on numeric field, small records    | wikistats               | ORDER                                              |
    |  total sort on numeric field, medium records   | weather tiles           | ORDER                                              |
    |  total sort on text field (wp page titles)     | long documents          | ORDER                                              |
    |  uniform (x% random sample)                    | short documents         | FILTER                                             |
    |  uniform (x% random sample)                    | long documents          | FILTER                                             |
    |  prepare .tsv.gz files of 1G +/- 10%           | pagerank                | STORE, compress (very low entropy)                 |
    |  .gz compress in-place those files             | pagerank.gz             | STORE, compress (very high entropy)                |
    |  simple transform on 100k distinct files       | raw weather data        | job startup time                                   |
    |  uniq -c                                       | short documents         | distinct, count                                    |
    |  uniq -c                                       | long documents          | distinct, count                                    |
    |                                                |                         |                                                    |
    |_. Text                                         |                         |                                                    |
    |  create inverted index                         | long documents          | tokenize, group                                    |
    |  word count (simple tokenization)              | long documents          | tokenize, group, count                             |
    |  word count (advanced tokenization)            | long documents          | complex code, group                                |
    |                                                |                         |                                                    |
    |_. Graph                                        |                         |                                                    |
    |  edge pairs => adj list                        | wp graph                | GROUP                                              |
    |  in-degree + out degree for each node          | wp graph                | 1:1 JOIN                                           |
    |  degree-sorted adj list (w/ degrees)           | wp graph                | FOREACH                                            |
    |  pagerank                                      | wp graph                | workflow; complex code                             |
    |  sub-universe                                  | graph + short documents | complex code                                       |
    |  put aggregated counts on adjacency list       | wp graph + wikistats    | JOIN huge on big with 100% overlap                 |
    |                                                |                         |                                                    |
    |_. Filter                                       |                         |                                                    |
    |  filter on numeric criteria                    | weather                 | FILTER                                             |
    |  split on redirect/not                         | wp corpus               | SPLIT                                              |
    |  regex search                                  | short documents         | FILTER, MATCHES                                    |
    |  100 keywords                                  | short documents         | FILTER, MATCHES                                    |
    |  100 keywords                                  | long documents          | FILTER, MATCHES                                    |
    |  100,000 keywords + huge inverted index        | inverted index          | fragment replicate JOIN (JOIN big on tiny)         |
    |                                                |                         |                                                    |
    |_. Parse                                        |                         |                                                    |
    |  extract title, keyword, desc from HTML head   | long documents          | complex code                                       |
    |  extract all a and img etc URLs from HTML      | long documents          | complex code; CPU-bound                            |
    |                                                |                         |                                                    |
    |_. OLAP / Stats                                 |                         |                                                    |
    |  simple statistics: avg, stdev, counts         | weather                 | GROUP, FOREACH                                     |
    |  top-N: find top 100 pages by views per day    | wikistats               | GROUP, nested FOREACH                              |
    |  something very CPU-intensive in foreach       | [some bio dataset]      | CPU-intensive in inner loop                        |
    |  linear regression                             | weather                 | ..                                                 |
    |  assign percentiles                            | weather                 | ..                                                 |
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

## Ideas for Atomic Operations to be exercised

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

## Detailed Dataset Descriptions

### Graph: wikidata/wikilinks (1.1G)

[Wikipedia page links dataset](http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596) contains a wikipedia linkgraph dataset provided by Henry Haselgrove. These files contain all links between proper english language Wikipedia pages, that is pages in "namespace 0". This includes disambiguation pages and redirect pages.   [ convert this to adj. pairs -- or to be directly loadable in pig ] In links-simple-sorted.txt, there is one line for each page that has links from it. The format of the lines is:
<pre><code>
      from1: to11 to12 to13 ...
      from2: to21 to22 to23 ...
      ...
</code></pre>
  where from1 is an integer labelling a page that has links from it, and to11 to12 to13 ... are integers labelling all the pages that the page links to. To find the page title that corresponds to integer n, just look up the n-th line in the file titles-sorted.txt.

### Short Documents 1: ???

uniform ~150-200 char fields + metadata

### Long Documents: Large interesting colxn of web pages

typically 10k - 1M files

### Log

#### Wikipedia Traffic Statistics Dataset

  Contains hourly wikipedia article traffic statistics dataset covering 7 month period from October 01 2008 to April 30 2009, this data is regularly logged from the wikipedia squid proxy by Domas Mituzas.
  Each log file is named with the date and time of collection: pagecounts-20090430-230000.gz
  Each line has 4 fields: projectcode, pagename, pageviews, bytes

```
    en Barack_Obama                         997 123091092
	en Barack_Obama%27s_first_100_days        8 850127
	en Barack_Obama,_Jr                       1 144103
	en Barack_Obama,_Sr.                     37 938821
	en Barack_Obama_%22HOPE%22_poster         4 81005
	en Barack_Obama_%22Hope%22_poster         5 102081
```

   we should denormalize into

```
    date 	hour	en Barack_Obama                         997 123091092
	date 	hour	en Barack_Obama%27s_first_100_days        8 850127
	date 	hour	en Barack_Obama,_Jr                       1 144103
	date 	hour	en Barack_Obama,_Sr.                     37 938821
	date 	hour	en Barack_Obama_%22HOPE%22_poster         4 81005
	date 	hour	en Barack_Obama_%22Hope%22_poster         5 102081
```

h3. Spreadsheet-ish: (Business and Industry Summary Data?)

Choices:
* [Business and Industry Summary Data](http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2342&categoryID=248)
* [2003-2006 US Economic Data](http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2341&categoryID=248)


Identity mapper         Wukong          `which cat`             pig
Identity reducer        wukong          `which cat`             pig
* no skew
* data/reducer > ram

Do a sort|uniq on 150GB
