
http://download.wikimedia.org/enwiki/20101011/


    3090226993	enwiki-20101011-abstract.xml                  abstract.xml                 2.9 GB 	# Extracted page abstracts for Yahoo   2010-10-14 12:46:26: enwiki 21862415 pages (86.897/sec), 21862416 revs (86.897/sec), ETA 2010-10-15 12:04:42 [max 29152778]
      44658610	enwiki-20101011-all-titles-in-ns0.gz          all-titles-in-ns0.gz        42.6 MB 	# List of page titles
      13707310	enwiki-20101011-category.sql.gz               category.sql.gz             13.1 MB 	# Category information.
     693939457	enwiki-20101011-categorylinks.sql.gz          categorylinks.sql.gz       661.8 MB 	# Wiki category membership link records.
     835501636	enwiki-20101011-externallinks.sql.gz          externallinks.sql.gz       796.8 MB 	# Wiki external URL link records.
          9718	enwiki-20101011-flaggedpages.sql.gz           flaggedpages.sql.gz          9   KB 	# This contains a row for each flagged article, containing the stable revision ID, if the lastest edit was flagged, and how long edits have been pending.
       1541560	enwiki-20101011-flaggedrevs.sql.gz            flaggedrevs.sql.gz           1.5 MB 	# This contains a row for each flagged revision, containing who flagged it, when it was flagged, reviewer comments, the flag values, and the quality tier those flags fall under.
     113905980	enwiki-20101011-image.sql.gz                  image.sql.gz               108.6 MB 	# Metadata on current versions of uploaded images.
     244646437	enwiki-20101011-imagelinks.sql.gz             imagelinks.sql.gz          233.3 MB 	# Wiki image usage records.
          7903	enwiki-20101011-interwiki.sql.gz              interwiki.sql.gz             7   KB 	# Set of defined interwiki prefixes and links for this wiki.
     115035382	enwiki-20101011-langlinks.sql.gz              langlinks.sql.gz           109.7 MB 	# Wiki interlanguage link records.
          1874	enwiki-20101011-md5sums.txt                   
      17191314	enwiki-20101011-oldimage.sql.gz               oldimage.sql.gz             16.4 MB 	# Metadata on prior versions of uploaded images.
     718889462	enwiki-20101011-page.sql.gz                   page.sql.gz                685.6 MB 	# Base per-page data (id, title, old restrictions, etc).
         26552	enwiki-20101011-page_props.sql.gz             page_props.sql.gz           25   KB 	# Name/value pairs for pages.
        577795	enwiki-20101011-page_restrictions.sql.gz      page_restrictions.sql.gz   564   KB 	# Newer per-page restrictions table.
    3576839493	enwiki-20101011-pagelinks.sql.gz              pagelinks.sql.gz             3.3 GB 	# Wiki page-to-page link records.
    4065806321	enwiki-20101011-pages-articles.xml.bz2        pages-articles.xml.bz2       6.2 GB 	# This contains current versions of article content, and is the archive most mirror sites will probably want. * Articles, templates, image descriptions, and primary meta-pages. * 2010-10-15 18:50:49: enwiki 10476611 pages (196.522/sec), 10476611 revs (196.522/sec), 87.3% prefetched, ETA 2010-10-16 21:18:44 [max 29200072]
    1234635583	enwiki-20101011-pages-logging.xml.gz          pages-logging.xml.gz         1.1 GB 	# This contains the log of actions performed on pages.
                                                                  pages-meta-current.xml.bz2  11.9 GB 	# Discussion and user pages are included in this complete archive. Most mirrors won't want this extra material. * All pages, current versions only. * 2010-10-16 14:59:09: enwiki 21894705 pages (302.615/sec), 21894705 revs (302.615/sec), 91.3% prefetched, ETA 2010-10-16 21:41:50 [max 29206388]
        679931	enwiki-20101011-protected_titles.sql.gz       protected_titles.sql.gz    663   KB 	# Nonexistent pages that have been protected.
      46557283	enwiki-20101011-redirect.sql.gz               redirect.sql.gz             44.4 MB 	# Redirect list
           795	enwiki-20101011-site_stats.sql.gz             site_stats.sql.gz          795   b  	# A few statistics such as the page count.
                                                                  stub-articles.xml.gz       637.9 MB 	# These files contain no page text, only revision metadata. * Creating split stub dumps... * 2010-10-15 03:55:50: enwiki 21894705 pages (401.769/sec), 359407803 revs (6595.150/sec), ETA 2010-10-15 05:14:53 [max 390684614]
                                                                  stub-meta-current.xml.gz     1.3 GB 	# These files contain no page text, only revision metadata. * Creating split stub dumps... * 2010-10-15 03:55:50: enwiki 21894705 pages (401.769/sec), 359407803 revs (6595.150/sec), ETA 2010-10-15 05:14:53 [max 390684614]
                                                                  stub-meta-history.xml.gz    13.8 GB 	# These files contain no page text, only revision metadata. * Creating split stub dumps... * 2010-10-15 03:55:50: enwiki 21894705 pages (401.769/sec), 359407803 revs (6595.150/sec), ETA 2010-10-15 05:14:53 [max 390684614]
     895520929	enwiki-20101011-templatelinks.sql.gz          templatelinks.sql.gz       854.0 MB 	# Wiki template inclusion link records.
         61687	enwiki-20101011-user_groups.sql.gz            user_groups.sql.gz          60   KB 	# User group assignments.

        -- Table structure for table `page`
        CREATE TABLE `page` (
          `page_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
          `page_namespace` int(11) NOT NULL DEFAULT '0',
          `page_title` varbinary(255) NOT NULL DEFAULT '',
          `page_restrictions` tinyblob NOT NULL,
          `page_counter` bigint(20) unsigned NOT NULL DEFAULT '0',
          `page_is_redirect` tinyint(1) unsigned NOT NULL DEFAULT '0',
          `page_is_new` tinyint(1) unsigned NOT NULL DEFAULT '0',
          `page_random` double unsigned NOT NULL DEFAULT '0',
          `page_touched` varbinary(14) NOT NULL DEFAULT '',
          `page_latest` int(8) unsigned NOT NULL DEFAULT '0',
          `page_len` int(8) unsigned NOT NULL DEFAULT '0',
          PRIMARY KEY (`page_id`),
          UNIQUE KEY `name_title` (`page_namespace`,`page_title`),
          KEY `page_random` (`page_random`),
          KEY `page_len` (`page_len`)
        ) ENGINE=InnoDB AUTO_INCREMENT=33341208 DEFAULT CHARSET=binary;
        INSERT INTO `page` VALUES (10,0,'AccessibleComputing','',0,1,0,0.33167112649574,'20110930213429',381202555,57),(12,0,'Anarchism','',5252,0,0,0.786172332974311,'20111007225731',454332051,127328)
        INSERT INTO `page` VALUES (15836,1,'Jazz','',72,0,0,0.87733831152072,'20111007225820',446037123,98729),(15837,0,'Jean_Cocteau','',359,0,0,0.637959953060336,'20111007225820',451984695,29236)
        INSERT INTO `page` VALUES (75844,1,'About_a_Boy_(novel)','',28,0,0,0.703174525595433,'20111003043629',440748277,4574),(75845,0,'Capua','',164,0,0,0.742207926457941,'20111007212344',437671969,19817),(7

        CREATE TABLE `category` (
          `cat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
          `cat_title` varbinary(255) NOT NULL DEFAULT '',
          `cat_pages` int(11) NOT NULL DEFAULT '0',
          `cat_subcats` int(11) NOT NULL DEFAULT '0',
          `cat_files` int(11) NOT NULL DEFAULT '0',
          `cat_hidden` tinyint(1) unsigned NOT NULL DEFAULT '0',
          PRIMARY KEY (`cat_id`),
          UNIQUE KEY `cat_title` (`cat_title`),
          KEY `cat_pages` (`cat_pages`)
        ) ENGINE=InnoDB AUTO_INCREMENT=105381352 DEFAULT CHARSET=binary;
        INSERT INTO `category` VALUES (1,'Redirects_from_title_without_diacritics',0,0,0,0),(2,'Unprintworthy_redirects',847404,13,0,0),(3,'Computer_storage_devices',84,10,0,0),(4,'American_Animation_articles
        INSERT INTO `category` VALUES (28165,'1999_Pacific_typhoon_season',4,1,0,0),(28166,'1999_Pan_American_Games',28,4,0,0),(28167,'1999_Rugby_World_Cup_qualification',1,0,0,0),(28168,'1999_Rugby_World_Cup
        INSERT INTO `category` VALUES (53569,'Art_criticism',17,3,0,0),(53570,'Art_critics',25,1,0,0),(53571,'Art_critics_by_nationality',40,40,0,0),(53572,'Art_curators',146,2,0,0),(53573,'Art_dealers',36,22
        INSERT INTO `category` VALUES (76412,'Buildings_and_structures_in_Manchester',102,18,0,0),(76413,'Buildings_and_structures_in_Manhattan',406,23,0,0),(76414,'Buildings_and_structures_in_Manitoba',23,18
        INSERT INTO `category` VALUES (98971,'Congo-Kinshasa_immigrants_to_Belgium',0,0,0,0),(98972,'Congo-Kinshasa_immigrants_to_Canada',0,0,0,0),(98973,'Congo_River',16,3,0,0),(98974,'Congo_basin',0,0,0,0),
        INSERT INTO `category` VALUES (122087,'English_patrons_of_music',5,0,0,0),(122088,'English_peace_treaties',0,0,0,0),(122089,'English_peaks_by_listing',4,4,0,0),(122090,'English_people',74,32,0,0),(122
        INSERT INTO `category` VALUES (144616,'George_Martin_articles_by_quality',17,15,0,0),(144617,'George_Martin_articles_with_comments',0,0,0,0),(144618,'George_Mason_Patriots_basketball     

        CREATE TABLE `categorylinks` (
          `cl_from` int(8) unsigned NOT NULL DEFAULT '0',
          `cl_to` varbinary(255) NOT NULL DEFAULT '',
          `cl_sortkey` varbinary(230) NOT NULL DEFAULT '',
          `cl_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          `cl_sortkey_prefix` varbinary(255) NOT NULL DEFAULT '',
          `cl_collation` varbinary(32) NOT NULL DEFAULT '',
          `cl_type` enum('page','subcat','file') NOT NULL DEFAULT 'page',
          UNIQUE KEY `cl_from` (`cl_from`,`cl_to`),
          KEY `cl_timestamp` (`cl_to`,`cl_timestamp`),
          KEY `cl_collation` (`cl_collation`),
          KEY `cl_sortkey` (`cl_to`,`cl_type`,`cl_sortkey`,`cl_from`)
        ) ENGINE=InnoDB DEFAULT CHARSET=binary;
        INSERT INTO `categorylinks` VALUES (4644610,'English_patrons_of_music','JENNENS, CHARLES\nCHARLES JENNENS','2008-08-16 23:46:21','Jennens, Charles','uppercase','page'),(4644610,'George_Frideric_Handel','GEORGE FRIDERIC HANDEL\nCHARLES JENNENS','2010-01-24 18:42:25','George Frideric Handel','uppercase','page'),(4644610,'Persondata_templates_without_short_description_parameter','JENNENS, CHARLES\nCHARLES JENNENS','2011-08-01 22:56:18','Jennens, Charles','uppercase','page'),(4644615,'User_en','DREWD007','2006-11-18 21:28:55','','uppercase','page'),(4644615,'User_en-N','DREWD007','2009-05-18 17:38:42','','uppercase','page'),(4644615,'User_es','DREWD007','2006-11-18 21:28:55','','uppercase','page'),(4644615,'User_es-1','DREWD007','2006-11-18 21:28:55','','uppercase','page'),(4644615,'WikiProject_St._Louis_Cardinals_members','DREWD007','2008-05-08 17:57:30','','uppercase','page'),(4644615,'Wikipedian_Colorado_Avalanche_fans','DREWD007','2006-11-18 21:28:55','','uppercase','page'),(4644615,'Wikipedian_St._Louis_Cardinals_fans','DREWD007','2009-06-11 00:02:16','','uppercase','page'),(4644615,'Wikipedian_St._Louis_Rams_fans','DREWD007','2007-06-06 06:12:55','','uppercase','page'),(4644615,'Wikipedians_in_Illinois','DREWD007','2006-11-18 21:28:55','','uppercase','page')
        INSERT INTO `categorylinks` VALUES (10846,'Days_of_the_year','FEBRUARY 01\nFEBRUARY 1','2009-02-08 01:46:17','February 01','uppercase','page'),(10846,'February','FEBRUARY 01\nFEBRUARY 1','2009-02-08 01:46:17','February 01','uppercase','page'),(10846,'Wikipedia_indefinitely_move-protected_pages','FEBRUARY 1\nFEBRUARY 1','2011-03-09 08:57:15','February 1','uppercase','page'),(10847,'First_Ladies_of_the_United_States',' \nFIRST LADY OF THE UNITED STATES','2009-12-10 22:46:31',' ','uppercase','page'),(10852,'1920_births','HERBERT, FRANK\nFRANK HERBERT','2007-05-07 18:36:52','Herbert, Frank','uppercase','page'),(10852,'1986_deaths','HERBERT, FRANK\nFRANK HERBERT','2007-05-07 18:36:52','Herbert, Frank','uppercase','page'),(10852,'All_articles_needing_additional_references','HERBERT, FRANK\nFRANK HERBERT','2009-10-24 20:31:20','Herbert, Frank','uppercase','page'),(10852,'All_articles_with_unsourced_statements','HERBERT, FRANK\nFRANK HERBERT','2010-10-21 12:57:22','Herbert, Frank','uppercase','page'),(10852,'American_Zen_Buddhists','HERBERT, FRANK\nFRANK HERBERT','2011-05-09 05:33:00','Herbert, Frank','uppercase','page'),(10852,'American_military_personnel_of_World_War_II','HERBERT, FRANK\nFRANK HERBERT','2007-05-07 18:36:52','Herbert, Frank','uppercase','page')


        CREATE TABLE `page_props` (
          `pp_page` int(11) NOT NULL DEFAULT '0',
          `pp_propname` varbinary(60) NOT NULL DEFAULT '',
          `pp_value` blob NOT NULL,
          PRIMARY KEY (`pp_page`,`pp_propname`)
        ) ENGINE=InnoDB DEFAULT CHARSET=binary;
        INSERT INTO `page_props` VALUES (305,'defaultsort','Achilles'),(307,'defaultsort','Lincoln, Abraham'),(308,'defaultsort','Aristotle'),(309,'defaultsort','American In Paris, An'),(316,'defaultsort','Academy Award For Best Art Direction'),(316,'notoc',''),(330,'displaytitle','<i>Actrius</i>'),(332,'defaultsort','Animalia (Book)'),(339,'defaultsort','Rand, Ayn'),(340,'defaultsort','Connes, Alain'),(344,'defaultsort','Dwan, Allan'),(359,'defaultsort','Atlas Shrugged Characters'),(572,'defaultsort','Agricultural Science'),(582,'noeditsection',''),(582,'nonewsectionlink',''),(586,'defaultsort','Ascii'),(590,'defaultsort','Austin'),(593,'defaultsort','Animation'),(595,'defaultsort','Agassi, Andre'),(597,'defaultsort','Austro-Asiatic Languages'),(599,'defaultsort','Afroasiatic Languages'),(612,'defaultsort','Arithmetic Mean'),(620,'displaytitle','<i>Animal Farm</i>'),(628,'defaultsort','Huxley, Aldous'),(634,'defaultsort','Analysis Of Variance'),(643,'defaultsort','Appellate Court'),(651,'defa
        INSERT INTO `page_props` VALUES (82295,'defaultsort','Robby The Robot'),(82323,'defaultsort','Vasternorrland County'),(82327,'defaultsort','Primal Scream'),(82328,'defaultsort','Chateau De Blois'),(82329,'displaytitle','<i>Lumpenproletariat</i>'),(82340,'defaultsort','Angers, Chateau D\''),(82346,'defaultsort','Telford, Thomas'),(82349,'defaultsort','Back-Formation'),(82359,'defaultsort','Least Squares'),(82361,'defaultsort','Gram-Schmidt Process'),(82368,'displaytitle','<i>Structure and Interpretation of Computer Programs</i>'),(82371,'noeditsection',''),(82371,'nonewsectionlink',''),(82373,'defaultsort','Europa (Rocket)'),(82378,'notoc',''),(82384,'defaultsort','Boll, Heinrich'),(82385,'defaultsort','Sex Reassignment Surgery'),(82390,'displaytitle','<i>Dirty Weekend</i> (1993&#32;film)'),(82394,'defaultsort','Chavez, Julio Cesar'),(82413,'defaultsort','Vian, Boris'),(82417,'defaultsort','Murnau, F.W.'),(82423,'displaytitle','<i>Nosferatu</i>'),(82426,'defaultsort','Aragon, Louis'),(8


CREATE TABLE `pagelinks` (
  `pl_from` int(8) unsigned NOT NULL DEFAULT '0',
  `pl_namespace` int(11) NOT NULL DEFAULT '0',
  `pl_title` varbinary(255) NOT NULL DEFAULT '',
  UNIQUE KEY `pl_from` (`pl_from`,`pl_namespace`,`pl_title`),
  KEY `pl_namespace` (`pl_namespace`,`pl_title`,`pl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
INSERT INTO `pagelinks` VALUES (0,0,'Vector_map'),(3,10,'Pending_deletion'),(10,0,'Computer_accessibility'),(10,4,'Subpages'),(12,0,'1917_October_Revolution'),(12,0,'1919_United_States_anarchist_bombings'),(12,0,'19th_century_philosophy'),(12,0,'6_February_1934_crisis'),(12,0,'A._K._Press'),(12,0,'A._S._Neill'),(12,0,'AK_Press'),(12,0,'A_Greek-English_Lexicon'),(12,0,'A_Vindication_of_Natural_Society'),(12,0,'A_las_barricadas'),(12,0,'Absolute_idealism'),(12,0,'Abstentionism'),(12,0,'Action_theory_(philosophy)'),(12,0,'Adam_Smith'),(12,0,'Adi_Shankara'),(12,0,'Adolf_Brand'),(12,0,'Adolphe_Thiers'),(12,0,'Aesthetics'),(12,0,'Affinity_group'),(12,0,'Affinity_groups'),(12,0,'Africana_philosophy'),(12,0,'Age_of_Enlightenment'),(12,0,'Agorism'),(12,0,'Agrarianism'),(12,0,'Agriculturalism'),(12,0,'Alain_Badiou'),(12,0,'Albert_Camus'),(12,0,'Albert_Jay_Nock'),(12,0,'Alex_Comfort'),(12,0,'Alexander_Berkman'),(12,0,'Alexandre_Christoyannopoulos'),(12,0,'Alexandre_Skirda'),(12,0,'Alfredo_M._Bona
INSERT INTO `pagelinks` VALUES (765,0,'Houghton_Mifflin_Company'),(765,0,'Human_rights'),(765,0,'Human_sex_ratio'),(765,0,'Hysterectomy'),(765,0,'Hysterotomy_abortion'),(765,0,'ICD-10'),(765,0,'ICD-10_Chapter_O'),(765,0,'IUD_with_copper'),(765,0,'IUD_with_progestogen'),(765,0,'If_These_Walls_Could_Talk'),(765,0,'Implanon'),(765,0,'Impossible_Motherhood'),(765,0,'In_utero'),(765,0,'Inanna'),(765,0,'Incest'),(765,0,'Infertility'),(765,0,'Informed_consent'),(765,0,'Instillation_abortion'),(765,0,'Intact_dilation_and_extraction'),(765,0,'International_Journal_of_Gynecology_&_Obstetrics'),(765,0,'International_Standard_Book_Number'),(765,0,'International_Statistical_Classification_of_Diseases_and_Related_Health_Problems'),(765,0,'Intrauterine_device'),(765,0,'Islam_and_abortion'),(765,0,'JSTOR'),(765,0,'J_Am_Med_Assoc'),(765,0,'J_Obstet_Gynaecol_Can'),(765,0,'J_Psychiatr_Pract'),(765,0,'John_Britton_(doctor)'),(765,0,'John_Wiley_&_Sons,_Ltd.'),(765,0,'Jon_F._Merz'),(765,0,'Jonathan_Berek'),
INSERT INTO `pagelinks` VALUES (1012,0,'565'),(1012,0,'851'),(1012,0,'Adewale_Akinnuoye-Agbaje'),(1012,0,'African_Americans'),(1012,0,'Agustín_Pichot'),(1012,0,'Aimé_Bonpland'),(1012,0,'Airstrike'),(1012,0,'Al_Dvorin'),(1012,0,'Alabama'),(1012,0,'Alabama_Supreme_Court'),(1012,0,'Alex_Holmes'),(1012,0,'Alexander_Bogdanov'),(1012,0,'Alexander_Mostovoi'),(1012,0,'Alfred_Gough'),(1012,0,'Alfred_Neubauer'),(1012,0,'Alice_in_Chains'),(1012,0,'Althea_Gibson'),(1012,0,'America\'s_Cup'),(1012,0,'America_(yacht)'),(1012,0,'American_Revolutionary_War'),(1012,0,'Andres_Calamaro'),(1012,0,'Angus_Bethune_(politician)'),(1012,0,'Ant_(comedian)'),(1012,0,'April'),(1012,0,'April_1'),(1012,0,'April_10'),(1012,0,'April_11'),(1012,0,'April_12'),(1012,0,'April_13'),(1012,0,'April_14'),(1012,0,'April_15'),(1012,0,'April_16'),(1012,0,'April_17'),(1012,0,'April_18'),(1012,0,'April_19'),(1012,0,'April_2'),(1012,0,'April_20'),(1012,0,'April_21'),(1012,0,'April_22'),(1012,0,'April_23'),(1012,0,'April_24'),(1012,
INSERT INTO `pagelinks` VALUES (1217,0,'Gold_Coast_(British_colony)'),(1217,0,'Government'),(1217,0,'Governor_of_Anguilla'),(1217,0,'Greenland'),(1217,0,'Grenada'),(1217,0,'Gross_domestic_product'),(1217,0,'Grouper'),(1217,0,'Guadeloupe'),(1217,0,'Guam'),(1217,0,'Guatemala'),(1217,0,'Guernsey'),(1217,0,'Guernsey_English'),(1217,0,'Guyana'),(1217,0,'Haiti'),(1217,0,'Hampshire_County_Cricket_Club'),(1217,0,'Hawai\'i_English'),(1217,0,'Head_of_government'),(1217,0,'Heligoland'),(1217,0,'Hiberno-English'),(1217,0,'Highland_English'),(1217,0,'Hindu'),(1217,0,'History_of_Anguilla'),(1217,0,'History_of_Australia_(1901-1945)'),(1217,0,'History_of_New_Brunswick'),(1217,0,'History_of_Newfoundland_and_Labrador'),(1217,0,'History_of_Nova_Scotia'),(1217,0,'History_of_Prince_Edward_Island'),(1217,0,'Holy_Piby'),(1217,0,'Honduras'),(1217,0,'Hong_Kong'),(1217,0,'Hong_Kong_English'),(1217,0,'Hubert_Hughes'),(1217,0,'Hudson_Valley_English'),(1217,0,'Hurricane_Lenny'),(1217,0,'Hurricane_Luis'),(1217,0,'I

CREATE TABLE `site_stats` (
  `ss_row_id` int(8) unsigned NOT NULL DEFAULT '0',
  `ss_total_views` bigint(20) unsigned DEFAULT '0',
  `ss_total_edits` bigint(20) unsigned DEFAULT '0',
  `ss_good_articles` bigint(20) unsigned DEFAULT '0',
  `ss_total_pages` bigint(20) DEFAULT '-1',
  `ss_users` bigint(20) DEFAULT '-1',
  `ss_admins` int(10) DEFAULT '-1',
  `ss_images` int(10) DEFAULT '0',
  `ss_active_users` bigint(20) DEFAULT '-1',
  UNIQUE KEY `ss_row_id` (`ss_row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
INSERT INTO `site_stats` VALUES (1,63208806,490596838,3761500,25169486,15451917,496,832184,147958);

