 /*
 XQuery Lab 32 - How to check the existence of an attribute in an XML element?
Sep 14 2008 6:34PM by Jacob Sebastian   

 

You can check the existence of an attribute by using the "exist" method of the XML data type. The following example checks if the "Name" attribute exists in the "Employee" element.
*/

DECLARE    @x1 XML
SELECT @x1 = '<Employee Number="1001" Name="Jacob"/>'

IF @x1.exist('/Employee/@Name') = 1 
    SELECT 'Exists' AS Result
ELSE
    SELECT 'Does not exist' AS Result

/*
Result
------
Exists
*/

/*
The following example shows how to check the existence of an attribute specified by a variable.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '<Employee Number="1001" Name="Jacob"/>'

DECLARE @att VARCHAR(20)
SELECT @att = 'Number'

IF @x1.exist('/Employee/@*[local-name()=sql:variable("@att")]') = 1 
    SELECT 'Exists' AS Result
ELSE
    SELECT 'Does not exist' AS Result

/*
Result
------
Exists
*/

