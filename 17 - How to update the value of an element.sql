/*
 XQuery Lab 17 - How to update the value of an element
Aug 12 2008 12:55AM by Jacob Sebastian   

 

In the previous labs, we have seen several examples of inserting/updating/deleting attributes. The syntax for updating the values of elements is slightly different from that of attributes. Let us see an example to understand this.

<Employees>
    <Employee>
        <FirstName>Jacob</FirstName>
        <MiddleName>V</MiddleName>
        <LastName>Sebastian</LastName>
    </Employee>
</Employees>


This is the sample XML. We need to update the MiddleName with a different value. Here is the code that does it.
*/
DECLARE @x XML
SELECT @x = '
<Employees>
    <Employee>
        <FirstName>Jacob</FirstName>
        <MiddleName>V</MiddleName>
        <LastName>Sebastian</LastName>
    </Employee>
</Employees>'

DECLARE @MiddleName CHAR(1)
SELECT @MiddleName = 'J'

SET @x.modify('
    replace value of (/Employees/Employee/MiddleName/text())[1]
    with sql:variable("@MiddleName")' )
    
SELECT @x
/*
<Employees>
  <Employee>
    <FirstName>Jacob</FirstName>
    <MiddleName>J</MiddleName>
    <LastName>Sebastian</LastName>
  </Employee>
</Employees>
*/

