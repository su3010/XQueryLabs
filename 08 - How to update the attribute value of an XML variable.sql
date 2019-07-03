/*
 XQuery Lab 8 - How to update the attribute value of an XML variable?
Jul 24 2008 9:35PM by Jacob Sebastian   

I just heard this question from a co-worker and wrote a small piece of sample code for him. Just wanted to share it with all of you. The following code snippet shows an example that updates the value of an attribute.

The XML fragment contains information of an employee and we are trying to update the "LastName" attribute. The current value is "Sebastian" and after update, it will become "Seb". This also shows how to access the value of a local variable from within the modify() method.
*/
DECLARE @x XML
SELECT @x = '<Employee FirstName="Jacob" LastName="Sebastian"/>'
DECLARE @Lastname VARCHAR(10)
SELECT @LastName = 'Seb'

SET @x.modify(
'
    replace value of (/Employee/@LastName)[1] 
    with sql:variable("@LastName")
')

SELECT @x
/*
output:
<Employee FirstName="Jacob" LastName="Seb" />
*/

