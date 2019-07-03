 /*
 XQuery Lab 43 - Deleting multiple elements
Mar 1 2009 9:08PM by Jacob Sebastian   

 

In XQuery Lab 18, we saw how to delete an element from an XML variable or column. Let us now see, how to delete more than one element from an XML column or variable.

Here is the sample XML that we will examine in this lab.

<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Team>ASP.NET</Team>
  </Employee>
</Employees>


Let us write a query to delete the "Team" element from all employee nodes. Here is the query.
*/


DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Team>ASP.NET</Team>
  </Employee>
</Employees>'

SET @x.modify('
    delete (/Employees/Employee/Team),
    ')
    
SELECT @x

/*
Output:
<Employees>
  <Employee>
    <Name>Jacob</Name>
  </Employee>
  <Employee>
    <Name>Steve</Name>
  </Employee>
  <Employee>
    <Name>Bob</Name>
  </Employee>
</Employees>
*/

/*
The following example shows how to apply a filter in the delete operation. The example given below deletes all "Team" elements where the value is "SQL Server".
*/
GO

DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Team>ASP.NET</Team>
  </Employee>
</Employees>'

SET @x.modify('
    delete (/Employees/Employee/Team[. = "SQL Server"]),
    ')
    
SELECT @x
/*
Output:
<Employees>
  <Employee>
    <Name>Jacob</Name>
  </Employee>
  <Employee>
    <Name>Steve</Name>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Team>ASP.NET</Team>
  </Employee>
</Employees>
*/

/*
The above example operates an XML variable. Now let us see how to perform the same operation on an XML column.
*/
DECLARE @t TABLE (data XML)
INSERT INTO @t(data) SELECT '
<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Team>SQL Server</Team>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Team>ASP.NET</Team>
  </Employee>
</Employees>'

UPDATE @t
SET data.modify('
    delete (/Employees/Employee/Team[. = "SQL Server"]),
    ')
    
SELECT * FROM @t
/*
Output:
<Employees>
  <Employee>
    <Name>Jacob</Name>
  </Employee>
  <Employee>
    <Name>Steve</Name>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Team>ASP.NET</Team>
  </Employee>
</Employees>
*/

