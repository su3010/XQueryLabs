 /*
 XQuery Lab 20 - How to change the position of elements - How to move an element up or down
Aug 17 2008 1:05AM by Jacob Sebastian   

 

Position of elements is significant in XML. The following example shows how to move an element up or down within a parent element. Here is the sample data for this lab.

<Employees>
    <Employee Name="Jacob"/>
    <Employee Name="Steve"/>
    <Employee Name="Bob"/>
</Employees>


Now let us try to move elements up and down.  Let us move Bob one level up and move Jacob one level down.
*/
DECLARE @x XML
SELECT @x = '
<Employees>
    <Employee Name="Jacob"/>
    <Employee Name="Steve"/>
    <Employee Name="Bob"/>
</Employees>'

------------------------------------------------------------
-- Move "Bob" one level up
------------------------------------------------------------
set @x.modify('
    insert /Employees/Employee[@Name="Bob"] 
    before (/Employees/Employee[. << (/Employees/Employee[@Name="Bob"])[1]])
    [last()]
    ')

SET @x.modify ('
        delete /Employees/Employee[@Name="Bob"] 
        [. is (/Employees/Employee[@Name="Bob"])[last()]]
    ')

SELECT @x
/*
<Employees>
  <Employee Name="Jacob" />
  <Employee Name="Bob" />
  <Employee Name="Steve" />
</Employees>
*/

------------------------------------------------------------
-- Move "Jacob" one level down
------------------------------------------------------------
set @x.modify('
    insert /Employees/Employee[@Name="Jacob"] 
    before (/Employees/Employee[. >> (/Employees/Employee[@Name="Bob"])[1]])
    [last()]
    ')

SET @x.modify ('
        delete (/Employees/Employee[@Name="Jacob"])[1]
    ')

SELECT @x
/*
<Employees>
  <Employee Name="Bob" />
  <Employee Name="Jacob" />
  <Employee Name="Steve" />
</Employees>
*/

