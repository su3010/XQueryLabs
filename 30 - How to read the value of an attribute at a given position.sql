 /*
 XQuery Lab 30 - How to read the value of an attribute at a given position?
Sep 14 2008 6:26PM by Jacob Sebastian   

 

It is easy to read the value if we know the name of the attribute. In this post we will examine how to read the value of an attribute at a given position. We will use the same XML instance we examined in the previous post.

<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>


The following example retrieves the value of the first attribute from the first "Employee" element.
*/

DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('(/Employees/Employee[1]/@*[position()=1])[1]','VARCHAR(20)') AS AttValue
    
/*
AttValue
--------------------
1001                
*/

/*
The following example retrieves the value of the third attribute from the second "Employee" element.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT
    @x1.value('(/Employees/Employee[2]/@*[position()=3])[1]','VARCHAR(20)') AS AttValue
    
/*
AttValue
--------------------
Steve               
*/

