#!/usr/bin/env bash

mkdir -p /data/ripd
cd /data/ripd

# ---------------------------------------------------------------------------
#
# DBPedia
#

dbpedia_baseurl="http://downloads.dbpedia.org/3.7/en"
dbpedia_filenames="geo_coordinates_en.nq labels_en.nq page_ids_en.nq redirects_en.nq page_links_en.nq article_categories_en.nq"
dbpedia_moreurls="http://downloads.dbpedia.org/3.7/links/yago_links.nt.bz2"

for filename in $dbpedia_filenames ; do
  url="${dbpedia_baseurl}/${filename}.bz2"
  echo "Downloading $url"
  wget -nc -nv -a /tmp/wget-dbpedia.log -x $url &
done

for url in $dbpedia_moreurls  ; do
  echo "Downloading $url"
  wget -nc -nv -a /tmp/wget-dbpedia.log -x $url &
done

# ---------------------------------------------------------------------------
#
# Wikipedia
#

wp_baseurl="http://dumps.wikimedia.org/enwiki/latest/enwiki-latest"
wp_filenames="pages-articles.xml.bz2 page.sql.gz all-titles-in-ns0.gz stub-articles1.xml.gz redirect.sql.gz page_props.sql.gz md5sums.txt site_stats.sql.gz pagelinks.sql.gz categorylinks.sql.gz category.sql.gz page_restrictions.sql.gz protected_titles.sql.gz flaggedpages.sql.gz"

wget   -nc -nv -a /tmp/wget-wikipedia.log -x http://dumps.wikimedia.org/enwiki/20111007/enwiki-20111007-md5sums.txt

# for filename in $wp_filenames ; do
#   url="${wp_baseurl}-${filename}"
#   echo "Downloading $url"
#   wget -nc -nv -a /tmp/wget-wikipedia.log -x $url
# done

mkdir -p /data/chimpmark/rawd/wp_corpus
ln -s /data/ripd/dumps.wikimedia.org/enwiki/latest /data/chimpmark/ripd/wp_corpus

cd /data/chimpmark/rawd/dbpedia && for foo in /data/chimpmark/ripd/dbpedia/*.bz2 ; do echo $foo ; bzcat $foo > `basename $foo .bz2` ; done 

cd /data/chimpmark/rawd/wp_corpus && for foo in /data/chimpmark/ripd/wp_corpus/enwiki-latest-*.gz  ; do echo $foo ; gzcat $foo > `basename $foo .gz` ; done
cd /data/chimpmark/rawd/wp_corpus && for foo in /data/chimpmark/ripd/wp_corpus/enwiki-latest-*.bz2 ; do echo $foo ; bzcat $foo > `basename $foo .bz2` ; done

cd /data/chimpmark/rawd/weather/gsod && ( year=2011 ; mkdir -p $year ; for foo in /data/chimpmark/ripd/weather/gsod/$year/* ; do echo $foo ; gzcat $foo > $year/`basename $foo .gz` ; done )

# Index of http://dumps.wikimedia.org/enwiki/latest/
# 
# Name                                    	Last Modified       	Size  	Type                       
# 
# enwiki-latest-pages-articles.xml.bz2    	2011-Oct-08 18:52:54	 7.2G    	application/x-bzip         
# enwiki-latest-page.sql.gz               	2011-Oct-08 04:29:58	   784.2M	application/x-gzip         
# enwiki-latest-all-titles-in-ns0.gz      	2011-Oct-08 04:36:53	    47.5M 	application/x-gzip         
# enwiki-latest-stub-articles1.xml.gz    	2011-Oct-08 12:54:47	       459.0K	application/x-gzip
# 
# enwiki-latest-redirect.sql.gz           	2011-Oct-08 04:31:15	    71.3M 	application/x-gzip         
# enwiki-latest-page_props.sql.gz         	2011-Oct-08 04:30:55	    43.1M 	application/x-gzip         
# enwiki-latest-md5sums.txt               	2011-Sep-08 01:35:38	    42.7K 	text/plain                 
# enwiki-latest-site_stats.sql.gz         	2011-Oct-07 21:14:36	     0.8K  	application/x-gzip         
#
# enwiki-latest-pagelinks.sql.gz          	2011-Oct-08 01:12:18	 3.9G    	application/x-gzip         
# enwiki-latest-categorylinks.sql.gz      	2011-Oct-08 01:36:29	   989.2M	application/x-gzip         
# enwiki-latest-category.sql.gz           	2011-Oct-08 04:27:11	    17.0M 	application/x-gzip         
# 
# enwiki-latest-page_restrictions.sql.gz  	2011-Oct-08 04:30:03	      579.7K	application/x-gzip         
# enwiki-latest-protected_titles.sql.gz   	2011-Oct-08 04:30:57	      747.0K	application/x-gzip         
# enwiki-latest-flaggedpages.sql.gz       	2011-Oct-09 05:25:51	        0.9K  	application/x-gzip         
#
# # Not used
#
# enwiki-latest-stub-meta-history.xml.gz  	2011-Oct-08 15:09:14	17.6G   	application/x-gzip         
# enwiki-latest-stub-meta-current.xml.gz  	2011-Oct-08 15:15:02	 1.5G   	application/x-gzip         
# enwiki-latest-stub-articles.xml.gz      	2011-Oct-08 15:17:47	   747.3M	application/x-gzip         
# enwiki-latest-pages-meta-current.xml.bz2	2011-Oct-09 03:05:59	13.9G   	application/x-bzip         
# enwiki-latest-abstract.xml              	2011-Oct-08 12:38:15	 3.2G    	application/xml            
# 
# enwiki-latest-image.sql.gz              	2011-Oct-07 21:17:35	   112.2M	application/x-gzip         
# enwiki-latest-imagelinks.sql.gz         	2011-Oct-08 01:55:03	   282.8M	application/x-gzip         
# enwiki-latest-oldimage.sql.gz           	2011-Oct-07 21:17:52	    19.3M 	application/x-gzip         
# enwiki-latest-externallinks.sql.gz      	2011-Oct-08 04:22:19	 1.0G   	application/x-gzip         
# enwiki-latest-templatelinks.sql.gz      	2011-Oct-08 03:49:36	 1.0G    	application/x-gzip         
# 
# enwiki-latest-pages-logging.xml.gz      	2011-Oct-09 05:25:28	 1.3G    	application/x-gzip         
# enwiki-latest-flaggedrevs.sql.gz        	2011-Oct-09 05:25:56	     3.0M  	application/x-gzip         
# enwiki-latest-user_groups.sql.gz        	2011-Oct-08 04:26:59	       68.2K 	application/x-gzip         
# 
# enwiki-latest-interwiki.sql.gz          	2011-Oct-08 04:26:57	       7.9K  	application/x-gzip         
# enwiki-latest-iwlinks.sql.gz            	2011-Oct-08 04:36:30	    58.3M 	application/x-gzip         
# enwiki-latest-langlinks.sql.gz          	2011-Oct-08 04:26:54	   132.7M	application/x-gzip         


# ---------------------------------------------------------------------------
#
# Done!
#

ls -l dumps.wikimedia.org/enwiki/latest/* downloads.dbpedia.org/3.7/*/*

#   all-titles-in-ns0.gz
#   category.sql.gz
#   categorylinks.sql.gz
# flaggedpages.sql.gz
#   md5sums.txt
#   page.sql.gz
#   page_props.sql.gz
# page_restrictions.sql.gz
#   pagelinks.sql.gz
# pages-articles.xml.bz2
# protected_titles.sql.gz
# redirect.sql.gz
#   site_stats.sql.gz
# stub-articles1.xml.gz
