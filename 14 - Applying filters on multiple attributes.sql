 /*
 XQuery Lab 14 - Applying filters on multiple attributes
Aug 6 2008 12:43AM by Jacob Sebastian   

 

In one of the previous labs, we saw an example that select specific nodes by applying a filter on the value of an attribute. Some times, it can happen that you need to apply filters on more than one  attribute to retrieve a set of nodes matching a given criteria. This post shows an example that applies filters on 2 attributes. 

Here is the sample data.

<Employees>
  <Employee id="123" dept="IT" type="Permanent">
    <Name first="Jacob" middle="V" last="Sebastian"/>
  </Employee>
  <Employee id="234" dept="IT" type="Temporary">
    <Name first="Steve" middle="K" last="Austine"/>
  </Employee>
  <Employee id="345" dept="OP" type="Permanent">
    <Name first="Smith" middle="R" last="Wills"/>
  </Employee>
</Employees>


Assume that we need to run two queries on this XML. The first query should return all employees from IT department. This should return two rows. The second query should return all the permanent employees from IT department. This should return only one row.

Let us write the first query. Let us apply a filter on the "dept" attribute.
*/
DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee id="123" dept="IT" type="Permanent">
    <Name first="Jacob" middle="V" last="Sebastian"/>
  </Employee>
  <Employee id="234" dept="IT" type="Temporary">
    <Name first="Steve" middle="K" last="Austine"/>
  </Employee>
  <Employee id="345" dept="OP" type="Permanent">
    <Name first="Smith" middle="R" last="Wills"/>
  </Employee>
</Employees>'

SELECT
    e.value('@first[1]','VARCHAR(10)') AS FirstName,
    e.value('@middle[1]','VARCHAR(10)') AS MiddleName,
    e.value('@last[1]','VARCHAR(10)') AS LastName
FROM @x.nodes('/Employees/Employee[@dept="IT"]/Name') x(e)
GO
/*
FirstName  MiddleName LastName
---------- ---------- ----------
Jacob      V          Sebastian 
Steve      K          Austine    
*/


--The following query also produces the same result. Note the changes in in the expression used with the "nodes()" method.

DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee id="123" dept="IT" type="Permanent">
    <Name first="Jacob" middle="V" last="Sebastian"/>
  </Employee>
  <Employee id="234" dept="IT" type="Temporary">
    <Name first="Steve" middle="K" last="Austine"/>
  </Employee>
  <Employee id="345" dept="OP" type="Permanent">
    <Name first="Smith" middle="R" last="Wills"/>
  </Employee>
</Employees>'

SELECT
    e.value('@first[1]','VARCHAR(10)') AS FirstName,
    e.value('@middle[1]','VARCHAR(10)') AS MiddleName,
    e.value('@last[1]','VARCHAR(10)') AS LastName
FROM @x.nodes('//Employee[@dept="IT"]/*') x(e)
GO
/*
FirstName  MiddleName LastName
---------- ---------- ----------
Jacob      V          Sebastian 
Steve      K          Austine   
*/


--Now let us write the second query. Let us add two filters: one on the "dept" attribute and the other on the "type" attribute.

DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee id="123" dept="IT" type="Permanent">
    <Name first="Jacob" middle="V" last="Sebastian"/>
  </Employee>
  <Employee id="234" dept="IT" type="Temporary">
    <Name first="Steve" middle="K" last="Austine"/>
  </Employee>
  <Employee id="345" dept="OP" type="Permanent">
    <Name first="Smith" middle="R" last="Wills"/>
  </Employee>
</Employees>'

SELECT
    e.value('@first[1]','VARCHAR(10)') AS FirstName,
    e.value('@middle[1]','VARCHAR(10)') AS MiddleName,
    e.value('@last[1]','VARCHAR(10)') AS LastName
FROM @x.nodes('//Employee[@dept="IT"][@type="Permanent"]/*') x(e)
GO
/*
FirstName  MiddleName LastName
---------- ---------- ----------
Jacob      V          Sebastian 
*/

