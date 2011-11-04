
h2. Document Dataset: Wikipedia English Articles XML

http://meta.wikimedia.org/wiki/Data_dumps

http://dumps.wikimedia.org/enwiki/latest/
http://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2

A collection of
  NNNN
  
  each line is an XML fragment representing one 

 3 219 183 'good' articles
19 677 204  total pages

The main page data is provided in the same XML wrapper format that Special:Export produces for individual pages. It's fairly self-explanatory to look at, but there is some documentation at Help:Export.

Three sets of page data are produced for each dump, depending on what you need:

* pages-articles.xml
** Contains current version of all article pages, templates, and other pages
** Excludes discussion pages ('Talk:') and user "home" pages ('User:')
** Recommended for republishing of content.
* pages-meta-current.xml
** Contains current version of all pages, including discussion and user "home" pages.
* pages-meta-history.xml
** Contains complete text of every revision of every page (can be very large!)
** Recommended for research and archives.

The XML itself contains complete, raw text of every revision, so in particular the full history files can be extremely large; en.wikipedia.org's January 2010 dump is about 5.87e12 bytes (5.34 TiB) raw.

Several of the tables are also dumped with mysqldump should anyone find them useful (for the database definition, see the documentation [1]); the gzip-compressed SQL dumps (.sql.gz) can be read directly into a MySQL database but may be less convenient for other database formats.

In addition, "stub" dumps with filenames like stub-meta-history.xml.gz, stub-meta-current.xml.gz, and stub-articles.xml.gz, contain header information only for pages and revisions, omitting the actual page content.  



h3. Challenges:

* Validate the XML

* Create a metadata table

<page>    <title>AmericanSamoa</title>    <id>6</id>    <revision>      <id>133452270</id>      <timestamp>2007-05-25T17:12:06Z</timestamp>      <contributor>        <username>Gurch</username>        
<page>    <title>AppliedEthics</title>    <id>8</id>    <revision>      <id>133452279</id>      <timestamp>2007-05-25T17:12:09Z</timestamp>      <contributor>        <username>Gurch</username>        
<page>    <title>AccessibleComputing</title>    <id>10</id>    <revision>      <id>133452289</id>      <timestamp>2007-05-25T17:12:12Z</timestamp>      <contributor>        <username>Gurch</username> 
<page>    <title>Anarchism</title>    <id>12</id>    <revision>      <id>275854375</id>      <timestamp>2009-03-08T18:35:46Z</timestamp>      <contributor>        <username>Jadabocho</username>       
<page>    <title>AfghanistanHistory</title>    <id>13</id>    <revision>      <id>74466652</id>      <timestamp>2006-09-08T04:15:52Z</timestamp>      <contributor>        <username>Rory096</username> 
<page>    <title>AfghanistanGeography</title>    <id>14</id>    <revision>      <id>74466619</id>      <timestamp>2006-09-08T04:15:36Z</timestamp>      <contributor>        <username>Rory096</username
<page>    <title>AfghanistanPeople</title>    <id>15</id>    <revision>      <id>135089040</id>      <timestamp>2007-06-01T13:59:37Z</timestamp>      <contributor>        <username>RussBot</username> 
<page>    <title>AfghanistanEconomy</title>    <id>17</id>    <revision>      <id>74466531</id>      <timestamp>2006-09-08T04:14:58Z</timestamp>      <contributor>        <username>Rory096</username> 
<page>    <title>AfghanistanCommunications</title>    <id>18</id>    <revision>      <id>74466499</id>      <timestamp>2006-09-08T04:14:42Z</timestamp>      <contributor>        <username>Rory096</use
<page>    <title>AfghanistanTransportations</title>    <id>19</id>    <revision>      <id>74466423</id>      <timestamp>2006-09-08T04:14:07Z</timestamp>      <contributor>        <username>Rory096</us
<page>    <title>AfghanistanMilitary</title>    <id>20</id>    <revision>      <id>74466354</id>      <timestamp>2006-09-08T04:13:27Z</timestamp>      <contributor>        <username>Rory096</username>
<page>    <title>AfghanistanTransnationalIssues</title>    <id>21</id>    <revision>      <id>46448859</id>      <timestamp>2006-04-01T12:08:42Z</timestamp>      <contributor>        <username>Gurch</
<page>    <title>AssistiveTechnology</title>    <id>23</id>    <revision>      <id>74466798</id>      <timestamp>2006-09-08T04:17:00Z</timestamp>      <contributor>        <username>Rory096</username>
<page>    <title>AmoeboidTaxa</title>    <id>24</id>    <revision>      <id>74466889</id>      <timestamp>2006-09-08T04:17:51Z</timestamp>      <contributor>        <username>Rory096</username>       
<page>    <title>Autism</title>    <id>25</id>    <revision>      <id>275108378</id>      <timestamp>2009-03-05T05:36:47Z</timestamp>      <contributor>        <username>Eubulides</username>        <i
<page>    <title>AlbaniaHistory</title>    <id>27</id>    <revision>      <id>74467016</id>      <timestamp>2006-09-08T04:18:56Z</timestamp>      <contributor>        <username>Rory096</username>     
<page>    <title>AlbaniaGeography</title>    <id>28</id>    <revision>      <id>74466319</id>      <timestamp>2006-09-08T04:13:09Z</timestamp>      <contributor>        <username>Rory096</username>   
<page>    <title>AlbaniaPeople</title>    <id>29</id>    <revision>      <id>74466817</id>      <timestamp>2006-09-08T04:17:12Z</timestamp>      <contributor>        <username>Rory096</username>      
<page>    <title>AsWeMayThink</title>    <id>30</id>    <revision>      <id>74467061</id>      <timestamp>2006-09-08T04:19:17Z</timestamp>      <contributor>        <username>Rory096</username>       
<page>    <title>AllSaints</title>    <id>33</id>    <revision>      <id>197516257</id>      <timestamp>2008-03-11T17:45:40Z</timestamp>      <contributor>        <username>TexasAndroid</username>    
<page>    <title>AlbaniaGovernment</title>    <id>35</id>    <revision>      <id>74467128</id>      <timestamp>2006-09-08T04:19:45Z</timestamp>      <contributor>        <username>Rory096</username>  
<page>    <title>AlbaniaEconomy</title>    <id>36</id>    <revision>      <id>74467158</id>      <timestamp>2006-09-08T04:19:59Z</timestamp>      <contributor>        <username>Rory096</username>     
<page>    <title>Albedo</title>    <id>39</id>    <revision>      <id>270359501</id>      <timestamp>2009-02-13T02:40:12Z</timestamp>      <contributor>        <username>Renaissancee</username>       
<page>    <title>AfroAsiaticLanguages</title>    <id>40</id>    <revision>      <id>74467202</id>      <timestamp>2006-09-08T04:20:21Z</timestamp>      <contributor>        <username>Rory096</username

