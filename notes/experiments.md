
Stream
Stream + parse

Stream + sort 	skew(low/hi)	(large/small) keys

Join		skew(low/hi)	(large/small) keys	small+huge / med+med(sparse) / med+med(natural) / med+med(dense) / huge+huge(sparse)

			
### public data snapshot of page logs (~ 1TB)

- put on HDFS, 1 directory per month

* http://www.datawrangling.com/wikipedia-page-traffic-statistics-dataset
* http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2596
* http://dammit.lt/wikistats/
* http://aws.amazon.com/datasets/4182

        projectcode	pagename      	pageviews	bytes
        en Barack_Obama                 	997 	123091092
        en Barack_Obama%27s_first_100_days 	8 	850127
        en Barack_Obama,_Jr             	1 	144103
        en Barack_Obama,_Sr.               	37 	938821
        en Barack_Obama_%22HOPE%22_poster 	4 	81005
        en Barack_Obama_%22Hope%22_poster 	5 	102081


### DBpedia

* get from david
* **abstracts**: ~2 GB
* **page_ids**: small

* join the page ids on the titles to get

	projcode  pageid pagename pageviews bytes
        

### Raw dumps

* http://dumps.wikimedia.org/enwiki/20110620/enwiki-20110620-stub-meta-history.xml.gz (16.8 GB)
* http://download.wikimedia.org/enwiki/20110620/enwiki-20110620-pages-articles.xml.bz2 (5.8 GB)
* http://download.wikimedia.org/enwiki/20110620/enwiki-20110620-all-titles-in-ns0.gz
* http://download.wikimedia.org/enwiki/20110620/enwiki-20110620-pagelinks.sql.gz

**stub-meta-history**:

  <page>
    <title>User talk:97.127.176.129</title>
    <id>31645030</id>
    <revision>
      <id>426878040</id>
      <timestamp>2011-05-01T11:54:44Z</timestamp>
      <contributor>
        <username>SineBot</username>
        <id>4936590</id>
      </contributor>
      <comment>Added {{tilde}} note.</comment>
      <text id="428784613" bytes="803" />
    </revision>
  </page>

(define-key markdown-mode-map [tab] 'self-insert-command)
(define-key markdown-mode-map (kbd "<tab>") (insert-char ?+ 1))+
