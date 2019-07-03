 /*
 XQuery Lab 9 - How to delete an attribute from an XML variable?
Jul 25 2008 9:38PM by Jacob Sebastian   

 

In the previous lab we saw how to update the value of an attribute. Now let us see how to delete an attribute from an XML variable.
*/
DECLARE @x XML
SELECT @x = '<Employee FirstName="Jacob" LastName="Sebastian"/>'

SET @x.modify(
'
    delete (/Employee/@LastName)[1] 
')

SELECT @x
/*
output:
<Employee FirstName="Jacob" />
*/


--Note that XQuery is case sensitive and you should pay special attention to the 'casing'.