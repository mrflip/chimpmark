* http://www.cloudera.com/resource/hadoop-world-2011-presentation-slides-hadoop-and-performance
* https://github.com/SWIMProjectUCB/SWIM/wiki
* http://cloud.github.com/downloads/SWIMProjectUCB/SWIM/MapReduceWorkloadMASCOTSCameraReady.pdf

    

### High-level

Domains:

* **Machine Learning**
* **Spatial Data**
* **Corpus Data**
* **Graph Data**
* **Log Data**
* **Traditional OLAP reporting**
* **Timeseries Data**

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

## What to measure

Would like to measure:

* time to (pending_map_tasks == 0) and (running_map_tasks / cluster_map_tasks ~ 0.5)
* map tasks complete
* complete_reduce tasks / total_reduce_tasks =~ 0.8
* reduce_tasks complete
