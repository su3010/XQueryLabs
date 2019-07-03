/*
 XQuery Lab 11 - How to insert an element to an XML variable
Jul 25 2008 9:43PM by Jacob Sebastian   

 

In the previous post we have seen how to insert an attribute to an XML variable. In this post, let us see how to insert an element to an XML variable. In the example given below, an element named "LastName" is added to the "Employee" element.
*/
DECLARE @x XML
SELECT @x = '
<Employee>
    <FirstName>Jacob</FirstName>
</Employee>'

DECLARE @LastName VARCHAR(15)
SELECT @LastName = 'Sebastian'

-- insert an attribute
SET @x.modify('
    insert element LastName {sql:variable("@LastName")} as last into
    (/Employee)[1]
')

-- test the results
SELECT @x

/*
output:
<Employee>
  <FirstName>Jacob</FirstName>
  <LastName>Sebastian</LastName>
</Employee>
*/

