/*
XQuery Lab 62 – Revisiting simple TSQL SELECT operations using XQuery
Jul 1 2010 11:53AM by Jacob Sebastian   

This post aims to be a quick reference source for the beginners and shows a few simple SELECT examples.

 
Reading attributes from an XML variable
*/

DECLARE @x XML 
SET @x =  '<author fname="Michael" lname="Howard" />'
   
SELECT
	@x.value('(/author/@fname)[1]', 'VARCHAR(20)') AS FirstName,
	@x.value('(/author/@lname)[1]', 'VARCHAR(20)') AS LastName
GO
/*
FirstName            LastName
-------------------- --------------------
Michael              Howard
*/

/*
Reading elements from an XML variable
*/

DECLARE @x XML 
SET @x = 
  '<author>
        <firstname>Michael</firstname>
        <lastname>Howard</lastname>
   </author>'
   
SELECT
	@x.value('(/author/firstname)[1]', 'VARCHAR(20)') AS FirstName,
	@x.value('(/author/lastname)[1]', 'VARCHAR(20)') AS LastName
GO	
/*
FirstName            LastName
-------------------- --------------------
Michael              Howard
*/

/*
Reading elements and attributes from an XML variable
*/

DECLARE @x XML 
SET @x = 
  '<author id="101">Michael Howard</author>'
   
SELECT
	@x.value('(/author/@id)[1]', 'INT') AS FirstName,
	@x.value('(/author)[1]', 'VARCHAR(20)') AS LastName
GO
	
/*
FirstName   LastName
----------- --------------------
101         Michael Howard
*/

/*
Reading values from an XML column
*/

DECLARE @t TABLE (DATA XML)
INSERT INTO @t (data) SELECT '
	<author>
        <firstname>Michael</firstname>
        <lastname>Howard</lastname>
   </author>'
INSERT INTO @t (data) SELECT '
	<author>
        <firstname>Jacob</firstname>
        <lastname>Sebastian</lastname>
   </author>'
   
SELECT
	data.value('(/author/firstname)[1]', 'VARCHAR(20)') AS FirstName,
	data.value('(/author/lastname)[1]', 'VARCHAR(20)') AS LastName
FROM @t 
GO
/*
FirstName            LastName
-------------------- --------------------
Michael              Howard
Jacob                Sebastian
*/

/*
Similar examples are already discussed in some of the previous XQuery labs. However, I thought of consolidating them in this post for quick reference. 
*/