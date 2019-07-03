/*
XQuery Lab 51 – Querying an RDF document using TSQL and XQuery
Feb 16 2010 3:36PM by Jacob Sebastian   

This installment of XQuery Labs presents a script that reads information from an RDF document using TSQL and XQuery.

One of my friends approached me recently with a request to write a TSQL query that reads information from an RDF document. Here is the sample XML document he wanted to process.
*/

/*
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
</RDF>
*/

/*
The challenge is to read the resource names from the Link element and join it with the about attribute in the ExternalPage element. Here is the output required from the above XML document.
*/

/*
Resource           About            Title         CatID 
------------------ ---------------- ------------- ------
http://www.videos- http://www.video Kobus Petzer  724829
http://besigheidce http://besigheid Besigheid Cen 724829
http://besigheidce http://besigheid Besigheid Cen 724829
*/    

/*
While writing the query to get the above result is pretty much straight forward, many people find it difficult because of the namespace declarations present in the XML document.

Here is the TSQL code that queries the above XML document and produces the required output.  
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
      y.value('@r:resource[1]','VARCHAR(100)') AS Resource,
      z.value('@about','VARCHAR(100)') AS About,
      z.value('d:Title[1]','VARCHAR(100)') AS Title,
      x.value('catid[1]','VARCHAR(100)') AS CatID
FROM @x.nodes('RDF/Topic') a(x)
CROSS APPLY x.nodes('link') b(y)
CROSS APPLY  @x.nodes('RDF/ExternalPage') c(z)
WHERE y.value('@r:resource[1]','VARCHAR(100)') = 
	z.value('@about','VARCHAR(100)')
      
/*
Resource           About            Title         CatID 
------------------ ---------------- ------------- ------
http://www.videos- http://www.video Kobus Petzer  724829
http://besigheidce http://besigheid Besigheid Cen 724829
http://besigheidce http://besigheid Besigheid Cen 724829
*/      


