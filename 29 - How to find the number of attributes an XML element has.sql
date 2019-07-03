/*
 XQuery Lab 29 - How to find the number of attributes an XML element has?
Sep 14 2008 6:23PM by Jacob Sebastian   

 

The first time I came across this question is when I started writing the TSQL function to compare two XML values. Let us see how to count the attributes an element has. Here is the XML value that we will use for the examples in this lab.

<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>


The root element "Employees" has only one attribute. The first "Employee" element has two attributes and the second employee element has 3 attributes. Let us see how to retrieve these values using XQuery.

The following query finds the attribute count of the root element.
*/


DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('count(/Employees/@*)','INT') AS AttributeCount
    
/*
AttributeCount
--------------
1
*/

/*
The next query counts the attributes of the first "Employee" element.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('count(/Employees/Employee[1]/@*)','INT') AS AttributeCount
    
/*
AttributeCount
--------------
2
*/

/*
The following query retrieves the attribute count of the second "Employee" element.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('count(/Employees/Employee[2]/@*)','INT') AS AttributeCount
    
/*
AttributeCount
--------------
3
*/

/*
If you do not know the name of elements, you can use a wildcard expression.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('count(/*/@*)','INT') AS Attributes_root,
    @x1.value('count(/*/*[1]/@*)','INT') AS Attributes_Child1,
    @x1.value('count(/*/*[2]/@*)','INT') AS Attributes_Child2
    
/*
Attributes_root Attributes_Child1 Attributes_Child2
--------------- ----------------- -----------------
1               2                 3
*/

/*
The following query retrieves the count of attributes in each Employee element.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    x.value('count(./@*)','INT') AS AttributeCount
FROM @x1.nodes('/*/*') y(x)
    
/*
Attributes_Child1
-----------------
2
3
*/

