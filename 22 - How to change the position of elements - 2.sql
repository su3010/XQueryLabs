/*
 XQuery Lab 22 - How to change the position of elements - Move an item to a specific position
Aug 17 2008 1:11AM by Jacob Sebastian   

 

In lab 20 we saw how to move an element up or down. In lab 21 we saw how to move an element to a location relative to another element having a specific value. In this lab, let us see how to move elements to specific positions. Here is the sample data for this lab.

<Employees>
    <Employee Name="Jacob"/>
    <Employee Name="Steve"/>
    <Employee Name="Bob"/>
    <Employee Name="Mike"/>
</Employees>


Let us move Jacob to the 3rd position. Then let us move Steve as the last element.
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
-- Move "Jacob" to position 3
------------------------------------------------------------
set @x.modify('
    insert /Employees/Employee[@Name="Jacob"] 
    after (/Employees/Employee)[3]
    ')

SET @x.modify ('
        delete (/Employees/Employee[@Name="Jacob"])[1]
    ')

SELECT @x
/*
<Employees>
  <Employee Name="Steve" />
  <Employee Name="Bob" />
  <Employee Name="Jacob" />
  <Employee Name="Mike" />
</Employees>
*/

------------------------------------------------------------
-- Move "Steve" to the last position
------------------------------------------------------------
set @x.modify('
    insert /Employees/Employee[@Name="Steve"] 
    after (/Employees/Employee)[last()]
    ')

SET @x.modify ('
        delete (/Employees/Employee[@Name="Steve"])[1]
    ')

SELECT @x
/*
<Employees>
  <Employee Name="Bob" />
  <Employee Name="Jacob" />
  <Employee Name="Mike" />
  <Employee Name="Steve" />
</Employees>
*/