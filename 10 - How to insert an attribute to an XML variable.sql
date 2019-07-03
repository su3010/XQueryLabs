/*
 XQuery Lab 10 - How to insert an attribute to an XML variable
Jul 25 2008 9:41PM by Jacob Sebastian   

 

We have seen how to update the value of an attribute and how to delete an attribute from an XML variable. Let us now see how to insert an attribute to an XML variable. We could do this by using the modify() method of XML data type. Note that XQuery methods are case sensitive.

The following example inserts an attribute named "LastName" to the "Employee" element.
*/
DECLARE @x XML
SELECT @x = '<Employee FirstNam="Jacob"/>'

DECLARE @LastName VARCHAR(15)
SELECT @LastName = 'Sebastian'

-- insert an attribute
SET @x.modify('
    insert attribute LastName {sql:variable("@LastName")} as last into
    (/Employee)[1]
')

-- test the results
SELECT @x

/*
output:
<Employee FirstNam="Jacob" LastName="Sebastian" />
*/