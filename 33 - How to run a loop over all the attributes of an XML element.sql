/* XQuery Lab 33 - How to run a loop over all the attributes of an XML element?
Sep 14 2008 6:39PM by Jacob Sebastian   

 

This is one of the requirements we came across, while writing the TSQL function to compare two XML values. In one of the previous posts, 
we saw how to find the name and value of attributes at a specified location. We then saw how to find the number of attributes an element has.

So, we have discussed almost everything that we need to write a piece of code that loops through all the attributes in an element and performs some operations. 
The sample code given below runs a loop over all the attributes of an element prints the name and value of elements.
*/
-- XML instance
DECLARE    @x1 XML
SELECT @x1 = '<Employee Number="1001" Name="Jacob" Dept="IT"/>'

DECLARE 
    @cnt INT, 
    @totCnt INT,
    @attName VARCHAR(30),
    @attValue VARCHAR(30)

-- counter variables
SELECT 
    @cnt = 1,
    @totCnt = @x1.value('count(/Employee/@*)','INT')

-- loop
WHILE @cnt <= @totCnt BEGIN
    SELECT
        @attName = @x1.value(
            'local-name((/Employee/@*[position()=sql:variable("@cnt")])[1])',
            'VARCHAR(30)'),
        @attValue = @x1.value(
            '(/Employee/@*[position()=sql:variable("@cnt")])[1]',
            'VARCHAR(30)')
    
    PRINT 'Attribute Position: ' + CAST(@cnt AS VARCHAR)
    PRINT 'Attribute Name: ' + @attName
    PRINT 'Attribute Value: ' + @attValue
    PRINT ''
    
    -- increment the counter variable
    SELECT @cnt = @cnt + 1
END

/*
OUTPUT:

Attribute Position: 1
Attribute Name: Number
Attribute Value: 1001
 
Attribute Position: 2
Attribute Name: Name
Attribute Value: Jacob
 
Attribute Position: 3
Attribute Name: Dept
Attribute Value: IT
*/

