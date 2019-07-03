 /*
 XQuery Lab 50 – Reading data from Google Analytics Atom Feed
Dec 23 2009 8:21AM by Jacob Sebastian   

One of my friends emailed me this morning asking help for reading data from Google Analytics Atom feed, using Query with TSQL.

My friend sent me a sample XML document he obtained from Google Analytics and here is the query that reads information from it.
*/
DECLARE @x XML
SELECT @x = '
<feed xmlns="http://www.w3.org/2005/Atom" 
    xmlns:dxp="http://schemas.google.com/analytics/2009" 
    xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/">
  <entry>
    <id>http://www.google.com/analytics/feeds/data?ids=ga:17042320&amp;
        ga:city=(not%20set)&amp;ga:country=Canada&amp;ga:date=20091204
        &amp;filters=ga:country%3D%3DCanada&amp;start-date=2009-12-04
        &amp;end-date=2009-12-18</id>
    <updated>2009-12-17T16:00:00.001-08:00</updated>
    <title type="text">ga:country=Canada | ga:city=(not set) | 
        ga:date=20091204</title>
    <link rel="alternate" 
        type="text/html" href="http://www.google.com/analytics" />
    <dxp:dimension name="ga:country" value="Canada" />
    <dxp:dimension name="ga:city" value="(not set)" />
    <dxp:dimension name="ga:date" value="20091204" />
    <dxp:metric confidenceInterval="0.0" name="ga:entrances" 
        type="integer" value="24" />
    <dxp:metric confidenceInterval="0.0" name="ga:exits" 
        type="integer" value="24" />
  </entry>
</feed>'

;WITH XMLNAMESPACES(
    DEFAULT 'http://www.w3.org/2005/Atom',
    'http://schemas.google.com/analytics/2009' as dxp
)
SELECT
    x.value('(dxp:dimension[@name="ga:country"]/@value)[1]','VARCHAR(20)') 
        AS country,
    x.value('(dxp:dimension[@name="ga:city"]/@value)[1]','VARCHAR(20)') 
        AS city
FROM @x.nodes('feed/entry') a(x)

/*
country              city
-------------------- --------------------
Canada               (not set)
*/


