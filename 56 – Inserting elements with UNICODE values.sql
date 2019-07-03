/*
XQuery Lab 56 – Inserting elements with UNICODE values
Jun 9 2010 6:02AM by Jacob Sebastian   

I think it will be quite common that you try to insert a UNICODE value into an XML document and then you see that the INSERT did not work correctly because the value you find within the XML document is slightly different from what you inserted. I got a similar question recently and thought of adding it to the XQuery labs as it might help other people with similar problems.

The following example shows the problem.
*/
DECLARE @xml XML
SELECT @xml = '<root></root>'
	
SET @xml.modify('insert element a {"Szövl?"} as last into (/root)[1]')
SELECT @xml
/*
<root>
  <a>Szövlo</a>
</root>
*/
GO

/*
Note that the value we entered was “Szövl?”. However, the XML output shows “Szövlo” (note the missing accent mark on o). 
This can be fixed by changing your query to a UNICODE string, as given in the following example.
*/

DECLARE @xml XML
SELECT @xml = '<root></root>'
	
SET @xml.modify(N'insert element a {"Szövl?"} as last into (/root)[1]')
SELECT @xml
/*
<root>
  <a>Szövl?</a>
</root>
*/

GO
/*
Here is another version of the query that uses a variable instead of a hard-coded value.
*/

DECLARE @xml XML, @val NVARCHAR(20)

SELECT 
	@xml = '<root></root>',
	@val = N'Szövl?'
	
SET @xml.modify('insert element a {sql:variable("@val")} into (/root)[1]')
SELECT @xml
/*
<root>
  <a>Szövl?</a>
</root>
*/
