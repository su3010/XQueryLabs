/*
 XQuery Lab 13 - Reading values from an XML variable
Aug 4 2008 12:39AM by Jacob Sebastian   

 

We have seen several example of reading values from XML variables, in the previous labs. Most of these posts are based on the examples I write for helping people at MSDN forums. Some times, you might find more than one post that shows reading values from an XML variable, but presenting different XML structures. I like this repetition of code, because, when you look for the solution of a problem, you could find several examples with different XML structures, and then you can choose the one that closely matches your specific problem.

Here is another simple example that shows reading values from an XML variable. This the XML instance that we need to process.

<ReelTriggers>
    <ReelTrigger  Name="variable1" Value="11.3" />
    <ReelTrigger  Name="variable2" Value="12.3"/>
    <ReelTrigger  Name="variable3" Value="13.3" />
</ReelTriggers>


We need to read the values from the Name and Value attributes. Note that to read an attribute name, you need to prefix it with an "@" character. This could be the reason why most of the times you don't get the expected results when you try to read values XQuery. Here is the code that reads values from this variable.
*/

DECLARE @x XML
SELECT @x =  
'<ReelTriggers>
    <ReelTrigger  Name="variable1" Value="11.3" />
    <ReelTrigger  Name="variable2" Value="12.3"/>
    <ReelTrigger  Name="variable3" Value="13.3" />
</ReelTriggers>'

SELECT
    v.value('@Name[1]','VARCHAR(20)') AS Name,
    v.value('@Value[1]','VARCHAR(20)') AS Value
FROM @x.nodes('/ReelTriggers/ReelTrigger') x(v)

/*
Name                 Value
-------------------- --------------------
variable1            11.3                
variable2            12.3                
variable3            13.3      
*/