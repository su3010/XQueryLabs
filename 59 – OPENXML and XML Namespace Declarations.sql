/*
 XQuery Lab 59 – OPENXML() and XML Namespace Declarations
Jun 22 2010 5:03PM by Jacob Sebastian   

In the previous post, we saw a basic example that reads information from an XML document using OPENXML(). In this post, we will focus on reading information from XML documents having namespace declarations.

Here is a simple example:
*/
DECLARE @x VARCHAR(8000)
SET @x = 
  '<a:authors xmlns:a="http://beyondrelational.com/books">
		<a:author fname="Michael" lname="Howard"/>
		<a:author fname="David" lname="LeBlanc" />
   </a:authors>'
   
DECLARE @h INT
EXECUTE sp_xml_preparedocument 
	@h OUTPUT, @x, 
	'<a:authors xmlns:a="http://beyondrelational.com/books"/>'

SELECT * 
FROM OPENXML(@h, '/a:authors/a:author', 1)
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

/*
Reading from XML Documents with default namespace declaration

The following example shows how to read values from an XML document having default namespace declaration. 
*/
GO

DECLARE @x VARCHAR(8000)
SET @x = 
  '<authors xmlns="http://beyondrelational.com/books">
		<author fname="Michael" lname="Howard"/>
		<author fname="David" lname="LeBlanc" />
   </authors>'
   
DECLARE @h INT
EXECUTE sp_xml_preparedocument 
	@h OUTPUT, 
	@x, 
	'<a:authors xmlns:a="http://beyondrelational.com/books"/>'

SELECT * 
FROM OPENXML(@h, '/a:authors/a:author', 1)
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
Note that we assigned a namespace prefix to the XML document even though the namespace was declared as default namespace in the original XML document.

Processing XML documents with multiple namespace declarations

Let us see another example that demonstrates how to process XML documents having more than one namespace declarations.
*/

DECLARE @x VARCHAR(8000)
SET @x = '
<authors 
	xmlns:b="http://beyondrelational.com/books"
	xmlns:a="http://beyondrelational.com/authors">
	<books>
		<b:name>Art of XSD</b:name>
		<a:author>Jacob Sebastian</a:author>
	</books>
</authors>'
   
DECLARE @h INT
EXECUTE sp_xml_preparedocument 
	@h OUTPUT, 
	@x, 
	'<a:authors 
		xmlns:a="http://beyondrelational.com/authors" 
		xmlns:b="http://beyondrelational.com/books"/>'

SELECT * 
FROM OPENXML(@h, '/authors/books', 1)
WITH(
	name VARCHAR(20) 'b:name',
	author VARCHAR(20) 'a:author'
)

EXECUTE sp_xml_removedocument @h 

/*
name                 author
-------------------- --------------------
Art of XSD           Jacob Sebastian
*/