

______________________________________________________________________________

## Datasets

### Overview

* Daily Weather -- NCDC Global Summary of Daily Weather (GSOD)
  - Weather Station metadata: 
    `usno_id | wmo_id | lng | lat | elev | date_beg | date_end`
  - Weather Observations
    `usno_id | wmo_id | date | temp | pressure | ...`
  - Coverage cells: Polygons approximating weather stations' area of coverage, by year
    `usno_id | wmo_id | ctr_lng | ctr_lat | [[lng,lat],[lng,lat],...]`
* Wikipedia Corpus
  - `page title | page id | redirect | extended abstract | lng | lat | keywords | text`
* Wikipedia Pagelinks
  - `page_id | dest,dest,dest`
* Wikipedia Pageview logs
  - `page_id | date | hour | count`
  
### Size and Shape

    Dataset             Rows    GB      RecSz   +/-     Skew
    -------             ----    --      -----   ---     ----
    Daily Weather       xx      xx      xx      xx      low 
    WP Corpus           xx      xx      xx      xx      
    WP Page Graph       xx
    WP Page Views
    

### High-level

Domains:

* **Machine Learning**
* **Spatial Data**
* **Corpus Data**
* **Graph Data**
* **Log Data**
* **Traditional OLAP reporting**
* **Timeseries Data**

## Challenges

### Statistical Summary Global Weather 

Send weather observations to macro tiles, and calculate statistics (min, max, average, stdev, mode, median and percentiles).

* Join weather data and voronoi tiles; dispatch 

* calculate same but on all rows

### Anomaly Detection on a Timeseries

Pageview anomalies

Sessionize pageviews

### Logistic Regression

Which pages are correlated with the weather?

### Pagerank

### Enumerate Triangles (Clustering Coefficient)

### Document Clustering 

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


### Shingling of Documents



### K-Means Clustering


__________________________________________________________________________

## Operations

* full dataset: min, max, average, stdev, mode, count, sum, median and percentiles
* Correlation / covariance
* date difference; day of week; day of year; epoch <> time <> strftime
* bitstring flicking (and,or,xor; packed to tuple of bits)
* binning
* polar coordinates
* tuple/bag ops: min, max, average, stdev, mode, count, sum, %iles, (el) -> (el,idx)
* tuple/bag set: union, intersection, difference
* tuple/bag: sort within
* top k
* string regex: grep ; replace ; split
* string flicking: size, bytesize, chomp, replace, concat, int-to-hex, substr, downcase, sprintf
* field-by-field diff 
* random ; consistent hash
* trigonometric functions
* SHA1 / MD5 / bcrypt / base64 / un-base64 / XML-escaped of integer, short string, long text
* generate time-based UUID, string-hashed UUID, short (64-bit) UUID
* numeric: floor/ceil, log, pow; values for e, pi
* sort: numeric, string, case-insensitive, collated string (`&aacute;` and `a` sort same)
* geo: haversine distance, quadkey <> lng,lat+zl <> bbox
* sessionize visit from logs

* inline case/if/elsif statement
* inline loop
* typecast

* Handle unicode

* easy to use in mini-mode and full mode

* Transform a complex record (turn a nested hash into a different nested hash)
* Unwind a complex record (table <> ORM)
* Deals correctly with missing data
* Deals with structured records, tables, lines, documents, tensor (multi-dim tables)

* filter / sample
* foreach
* union / split / limit
* stream
* flatten
* cogroup, group, join
  - inner join
  - outer join (left, right and full)
  - null skew (one record per group)
  - massive skew cogroup
  - massive skew join
  - merge join (pre-sorted files)
  - small to large (fragment replicate)
* order
* cross
* distinct

* Load structured records: JSON, XML, fixed-width, log files
* Parse semi-structured text

* Use small (but big enough) utility table (eg stopwords list)

* Store to Database
* Store to S3
* Store to HDFS
* Store to disk

* combine to one file
* output multiple files
* route records to file by key

#### Datatypes

* int, long, md5, float, double, boolean
* ascii string, identifier string, UTF-8 string w/ ext. characters
* date, datetime
* longitude, latitude, quadkey
* enum
* hash
* array
* structured field
* polygon

* field stats: %null, numeric range, strlen, chars, cardinality (#distinct vals), freq dist

### Facilities to exercise:

* Ingesting serialized data (specifically, TSV and JSON), and ingesting semi-structured documents
* Running arbitrary (non-native) code
* Iterative jobs

Sources: 

* [Pig manual](http://pig.apache.org/docs/r0.9.1/basic.html)
* [piggybank](http://bit.ly/piggybanktrunk)
* [MySQL manual](http://dev.mysql.com/doc/refman/5.6/en/func-op-summary-ref.html)
* [Scripting language comparisons](http://hyperpolyglot.org/scripting)
* [DataFu](http://sna-projects.com/datafu/javadoc/0.0.1/)

* [Mining of Massive Datasets](http://infolab.stanford.edu/~ullman/mining/mining.html)

#### Optimizations

* jumbo quadkeys vs uniform quadkeys
* types (double vs float vs printf'd)
* small dataset on left in join
* algebraic 
* combiners

* many small files (tons of mappers)
* too many / too few reducers

* mapper: small input => big output, same size, big record => many small records (same size), record => few records (filter)


## Cluster Sizes

* 7GB, 8 cores
* 

CRam = cluster ram
CCores = cluster cores

Midstream size ~= 4 x CRam -- 1 x CRam -- 0.5 x CRam


## Spirit of the Game

* **Generic**: you must not draw on source domain knowledge. You can capitalize on the coarse structure 
