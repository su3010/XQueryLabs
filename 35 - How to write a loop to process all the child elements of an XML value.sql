 /*
 XQuery Lab 35 - How to write a loop to process all the child elements of an XML value?
Sep 14 2008 6:46PM by Jacob Sebastian   

 

In the previous lab, we saw how to write a loop to process all the attributes of an element. We then discussed how to find the number of child elements that a parent element has. 
We also discussed how to retrieve a child element at the specified position. That is all we need to write a piece of code that runs a loop over all the child elements of an XML value.

Here is the XML that we will use for the example presented in this lab.

<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>


We will write a loop that does not do anything interesting, but just print the child element to the output window. This might give you enough ideas to write the kind of loop that you need in your specific case.
*/
-- XML instance
DECLARE    @x1 XML
SELECT @x1 = '
<Employees Dept="IT">
  <Employee Number="1001" Name="Jacob"/>
  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
</Employees>'

DECLARE 
    @cnt INT, 
    @totCnt INT,
    @child XML

-- counter variables
SELECT 
    @cnt = 1,
    @totCnt = @x1.value('count(/Employees/Employee)','INT')

-- loop
WHILE @cnt <= @totCnt BEGIN
    SELECT
        @child = @x1.query('/Employees/Employee[position()=sql:variable("@cnt")]')

    PRINT 'Processing Child Element: ' + CAST(@cnt AS VARCHAR)
    PRINT 'Child element:  ' + CAST(@child AS VARCHAR(100))
    PRINT ''
    
    -- incremet the counter variable
    SELECT @cnt = @cnt + 1
END

/*
OUTPUT:

Processing Child Element: 1
Child element:  <Employee Number="1001" Name="Jacob"/>
 
Processing Child Element: 2
Child element:  <Employee Number="1002" Name="Bob" ReportsTo="Steve"/>
*/

