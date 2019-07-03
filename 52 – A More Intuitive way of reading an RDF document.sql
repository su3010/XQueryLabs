/*
XQuery Lab 52 – A More Intuitive way of reading an RDF document
Feb 25 2010 12:00AM by Jacob Sebastian   

After reading XQuery Lab 51, my friend and database expert Brad Schulz send me a note showing another way of achieving the same results. The approach he suggested was much cleaner than my original version.

My code used the following expression in the WHERE clause to filter the records where @about and @resource attributes match.
*/

/*
y.value('@r:resource[1]','VARCHAR(100)') = 
	z.value('@about','VARCHAR(100)')
*/


/*
Brad suggested a different approach where the entire query is moved into a CROSS APPLY  and the outer query can select columns returned by the CROSS APPLY operator and apply filters on them.
Here is the version of the query that Brad wrote.
*/

DECLARE @x XML
SELECT @x = '
<RDF xmlns:r="http://www.w3.org/TR/RDF/"
      xmlns:d="http://purl.org/dc/elements/1. 0/"
      xmlns="http://dmoz.org/rdf/">
  <Topic r:id="Top/World/Afrikaans/Besigheid">
    <catid>724829</catid>
    <link r:resource="http://www.videos-sa.com" />
    <link r:resource="http://besigheidcenturion.co.za/bc/" />
  </Topic>
  <ExternalPage about="http://www.videos-sa.com">
    <d:Title>Kobus Petzer Videoproduksies</d:Title>
    <d:Description>Vervaardiging van...</d:Description>
    <topic>Top/World/Afrikaans/Besigheid</topic>
  </ExternalPage>
  <ExternalPage about="http://besigheidcenturion.co.za/bc/">
    <d:Title>Besigheid Centurion</d:Title>
    <d:Description>Sakeportaal vir ...</d:Description>
    <topic>Top/World/Afrikaans/Besigheid</topic>
  </ExternalPage>
  <ExternalPage about="http://besigheidcenturion.co.za/bc/">
    <d:Title>Besigheid Centurion</d:Title>
    <d:Description>Sakeportaal vir ...</d:Description>
    <topic>Top/World/Afrikaans/Besigheid</topic>
  </ExternalPage>
</RDF>'

;WITH XMLNAMESPACES(
      'http://www.w3.org/TR/RDF/' as r,
      'http://purl.org/dc/elements/1. 0/' as d,
      default 'http://dmoz.org/rdf/'     
)
SELECT 
	[Resource], 
	About, 
	Title, 
	CatID
FROM @x.nodes('RDF/Topic') a(x)
CROSS APPLY x.nodes('link') b(y)
CROSS APPLY  @x.nodes('RDF/ExternalPage') c(z)
CROSS APPLY (
	SELECT 
		y.value('@r:resource[1]','VARCHAR(100)') AS [Resource],
        	z.value('@about','VARCHAR(100)') AS About,
        	z.value('d:Title[1]','VARCHAR(100)') AS Title,
        	x.value('catid[1]','VARCHAR(100)') AS CatID
) F
WHERE [Resource] = About
      
/*
Resource           About            Title         CatID 
------------------ ---------------- ------------- ------
http://www.videos- http://www.video Kobus Petzer  724829
http://besigheidce http://besigheid Besigheid Cen 724829
http://besigheidce http://besigheid Besigheid Cen 724829
*/      