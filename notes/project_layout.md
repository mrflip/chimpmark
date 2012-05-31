
Proposed layout:



notes/

challenges/

  cat_wrangling/
    identity map
    partitioned sort
    uniq
    total sort
    JSON -> TSV
    
  stats

  graph/
  
  geo/
  
  text/
  
  ml/
    

timings/                                        **timings** 
  {org}/
    {challenge}/
      {run_id}/

fixtures/                                       **fixtures** holds

data/
    
  rawd/                                         **rawd** holds the raw data from which everything else comes
  
     wp_web_logs/                               -- one page-day-hour count per line, tsv
    
     wp_articles/                               -- flattened xml fragments, one per article
     wp_abstracts/                              -- Plain-text abstracts
     wp_page_links/                             -- links between wikipedia pages
     wp_external_links/                         -- links to outside wikipedia
     wp_page_properties/                        -- page metadata
    
     weather_station_metadata/
     weather_station_regions/
     weather_observations/

  ripd/                                         **ripd** data as it comes from elsewhere, not yet useful

    download.wikimedia.org/enwiki/{version}/    Wikipedia corpus

      pages-articles.xml.bz2    	7,200 M
      page.sql.gz               	  784 M  
      all-titles-in-ns0.gz      	   48 M	
      stub-articles1.xml.gz    	       <1 M  
                                           
      redirect.sql.gz           	   71 M	
      page_props.sql.gz         	   43 M	
      md5sums.txt               	   <1 M
      site_stats.sql.gz         	   <1 M
                                           
      pagelinks.sql.gz          	3,900 M   	
      categorylinks.sql.gz      	  989 M  
      category.sql.gz           	   17 M	
  
      page_restrictions.sql.gz  	   <1 M
      protected_titles.sql.gz   	   <1 M
      flaggedpages.sql.gz       	   <1 M

      externallinks.sql.gz            663 M
      image.sql.gz                    107 M
      imagelinks.sql.gz               201 M
      interwiki.sql.gz                  1 M
      langlinks.sql.gz                 94 M 
      templatelinks.sql.gz            245 M

    downloads.dbpedia.org/{version}/           Wikipedia corpus cleaned-up metadata
    
      en/geo_coordinates_en.nq
      en/labels_en.nq
      en/page_ids_en.nq
      en/redirects_en.nq
      en/page_links_en.nq
      en/article_categories_en.nq
      links/yago_links.nt.bz2
      
    dammit.lt/wikistats/                        Wikipedia pagelogs
    
      {year}
      
    ftp.ncdc.noaa.gov/pub/data/                 Weather Data
    
      {year}/{wmo_id}-{wban_id}-{year}.op.gz    -- weather observation data for that weather_station:year
      gsod/ish-history.csv                      -- weather station service history
      gsod/country-list.txt                     -- station number range / country id / country name cross reference
      inventories/ish-inventory.csv             -- weather station metadata
      gsod/readme.txt                           -- supporting docs
      inventories/{many supporting docs}
