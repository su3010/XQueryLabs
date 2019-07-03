 /*
 XQuery Lab 34 - How to retrieve the child element at a specified position?
Sep 14 2008 6:42PM by Jacob Sebastian   

Some times you might need to retrieve the XML element at a given position. It may be because you are running a loop over all the elements of the 
XML document to perform some application specific operations or you want to pass those elements to another application/stored-procedure/function etc to perform some custom processing. 
It could also be that you need to access each element individually and do some actions.

The following example demonstrates how to retrieve the child element of an XML document, at the specified position.
*/

-- XML instance
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

SELECT 
    @x1.query('/Employees/Employee[1]')

/*
OUTPUT:
<Employee Number="1001" Name="Jacob" />
*/

SELECT 
    @x1.query('/Employees/Employee[2]')

/*
OUTPUT:
<Employee Number="1002" Name="Bob" ReportsTo="Steve" />
*/

/*
The following example shows how to use a variable to specify the position of the element needed.
*/
GO
-- XML instance
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

DECLARE @i INT
SELECT @i = 2

SELECT 
    @x1.query('/Employees/Employee[sql:variable("@i")]')

/*
OUTPUT:
<Employee Number="1002" Name="Bob" ReportsTo="Steve" />
*/

SELECT 
    @x1.query('/Employees/Employee[position()=sql:variable("@i")]')
/*
OUTPUT:
<Employee Number="1002" Name="Bob" ReportsTo="Steve" />
*/