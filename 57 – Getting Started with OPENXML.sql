/*
XQuery Lab 57 – Getting Started with OPENXML
Jun 17 2010 8:25AM by Jacob Sebastian   

This post intends to help you get started with OPENXML() function. OPENXML() lets you shred an XML document or fragment into a result set.

Though OPENXML() has got no direct relationship with XQuery, I thought of including it in the XQuery Labs series for completeness. Just like XQuery, OPENXML() can also be used to query an XML document (with some limitations).

Reading values from elements

The following example shows a basic example that read the values of elements from an XML document using OPENXML()
*/

DECLARE @x VARCHAR(8000)
SET @x = 
  '<authors>
    <author>
        <firstname>Michael</firstname>
        <lastname>Howard</lastname>
    </author>
    <author>
        <firstname>David</firstname>
        <lastname>LeBlanc</lastname>
    </author>
   </authors>'
   
DECLARE @h INT
EXECUTE sp_xml_preparedocument @h OUTPUT, @x 

SELECT * 
FROM OPENXML(@h, '/authors/author', 2)
WITH(
	firstname VARCHAR(20),
	lastname VARCHAR(20)
)

EXECUTE sp_xml_removedocument @h 

/*
firstname            lastname
-------------------- --------------------
Michael              Howard
David                LeBlanc
*/

GO

/*

The third argument passed into the OPENXML() function (“2” in this example) indicates that we wanted to read the values of elements from the XML document.

Reading values from attributes

You can read attribute values by passing “1” instead of “2”. Here is another example that reads attribute values.

*/
DECLARE @x VARCHAR(8000)
SET @x = 
  '<authors>
    <author fname="Michael" lname="Howard"/>
    <author fname="David" lname="LeBlanc" />
   </authors>'
   
DECLARE @h INT
EXECUTE sp_xml_preparedocument @h OUTPUT, @x 

SELECT * 
FROM OPENXML(@h, '/authors/author', 1)
WITH(
	fname VARCHAR(20),
	lname VARCHAR(20)
)

EXECUTE sp_xml_removedocument @h 

/*
firstname            lastname
-------------------- --------------------
Michael              Howard
David                LeBlanc
*/
GO

/*
Reading both elements and attributes

The following example reads values from elements and attributes in a single query.
*/

DECLARE @x VARCHAR(8000)
SET @x = 
  '<authors>
    <author id="101">Jacob</author>
    <author id="102">Steve</author>
   </authors>'
   
DECLARE @h INT
EXECUTE sp_xml_preparedocument @h OUTPUT, @x 

SELECT * 
FROM OPENXML(@h, '/authors/author', 1)
WITH(
	id INT '@id',
	author VARCHAR(20) '.'
)

EXECUTE sp_xml_removedocument @h 

/*
id          author
----------- --------------------
101         Jacob
102         Steve
*/

/*
Notes

    OPENXML() was first introduced in SQL Server 2000. XQuery support and XML data type were added only in SQL Server 2005.
    OPENXML() uses MSXML Parser internally
    In many cases, OPENXML() is found to be more efficient than XQuery when processing Large XML documents.
    OPENXML() cannot be used as part of a SET operation, nor can be called from a function. It needs a three step approach – prepare document, query document and remove document
    OPENXML() is found to be more memory intensive in most cases.
    If you forget to call sp_xml_removedocument, you might end up with a memory leak.

*/

