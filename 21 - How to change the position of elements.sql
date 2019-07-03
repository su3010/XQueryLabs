/*
 XQuery Lab 21 - How to change the position of elements - Move an element to a specific location
Aug 17 2008 1:08AM by Jacob Sebastian   

 

In the previous lab, we saw how to move an element up or down. Now let us see how to move an element to a specific location relative to other elements. Here is the sample data for this lab.

<Employees>
    <Employee Name="Jacob"/>
    <Employee Name="Steve"/>
    <Employee Name="Bob"/>
    <Employee Name="Mike"/>
</Employees>


Now let us move Bob before Jacob and move Jacob after Mike.
*/
DECLARE @x XML
SELECT @x = '
<Employees>
    <Employee Name="Jacob"/>
    <Employee Name="Steve"/>
    <Employee Name="Bob"/>
    <Employee Name="Mike"/>
</Employees>'

------------------------------------------------------------
-- Move "Bob" before "Jacob"
------------------------------------------------------------
set @x.modify('
    insert /Employees/Employee[@Name="Bob"] 
    before (/Employees/Employee[@Name="Jacob"])[1]
    ')

SET @x.modify ('
        delete (/Employees/Employee[@Name="Bob"])[2]
    ')

SELECT @x
/*
<Employees>
  <Employee Name="Bob" />
  <Employee Name="Jacob" />
  <Employee Name="Steve" />
  <Employee Name="Mike" />
</Employees>
*/

------------------------------------------------------------
-- Move "Jacob" after "Mike"
------------------------------------------------------------
set @x.modify('
    insert /Employees/Employee[@Name="Jacob"] 
    after (/Employees/Employee[@Name="Mike"])[1]
    ')

SET @x.modify ('
        delete (/Employees/Employee[@Name="Jacob"])[1]
    ')

SELECT @x
/*
<Employees>
  <Employee Name="Bob" />
  <Employee Name="Steve" />
  <Employee Name="Mike" />
  <Employee Name="Jacob" />
</Employees>
*/

