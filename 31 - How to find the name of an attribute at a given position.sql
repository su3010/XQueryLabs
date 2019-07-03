 /*
 XQuery Lab 31 - How to find the name of an attribute at a given position?
Sep 14 2008 6:31PM by Jacob Sebastian   

 

In the previous post we saw how to find the value of an attribute at a specified position. In this post, we will see how to find the name of an attribute at a specified position. Here is the XML instance we will use for this lab.

<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>


The following example retrieves the name of the first attribute of the first "Employee" element.
*/

DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('local-name(
        (/Employees/Employee[1]/@*[position()=1])[1]
    )','VARCHAR(20)') AS AttName
    
/*
AttName
--------------------
Number              
*/

/*
The following example retrieves the name of the third attribute of the second "Employee" element.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('local-name(
        (/Employees/Employee[2]/@*[position()=3])[1]
    )','VARCHAR(20)') AS AttName
    
/*
AttName
--------------------
ReportsTo           
*/

/*
The following example shows how to read the name of an attribute at the position specified by a variable.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

DECLARE @pos INT
SELECT @pos = 2

SELECT
    @x1.value('local-name(
        (/Employees/Employee[2]/@*[position()=sql:variable("@pos")])[1]
    )','VARCHAR(20)') AS AttName
    
/*
AttName
--------------------
Name                
*/