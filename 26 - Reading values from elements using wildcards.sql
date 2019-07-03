/*
 XQuery Lab 26 - Reading values from elements using wildcards
Sep 14 2008 1:23AM by Jacob Sebastian   

 

It is easy to read information when we know the name of the element to be processed. In this post, let us examine how to read values from elements using wildcards. This is one of the functionality we needed to write the function we wanted to write in the previous post, to compare two XML values.

The following example shows the usage of an asterisk (*) to represent an element.
*/
DECLARE @x1 XML
SELECT @x1 = '<Employee>Jacob Sebastian</Employee>'

SELECT @x1.value('(/*/text())[1]','VARCHAR(20)') AS Value
/*
Value
--------------------
Jacob Sebastian     
*/

/*
We retrieved the value from the root element, in the previous example. Now, let us se how to read the values from a level down in the XML tree. 
The following example shows how to read values from the second level elements from the XML tree.
*/
GO
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    @x.value('(/*/*/text())[1]','VARCHAR(20)') AS Value
    
/*
Value
--------------------
1001   
*/

/*
The above example reads the value of the first child element. The following example reads the value from the second child element.
*/

GO
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    @x.value('(/*/*/text())[2]','VARCHAR(20)') AS Value
    
/*
Value
--------------------
Jacob                
*/

/*
The following example shows how to read the values of all the child elements at the second level in the XML tree.
*/
GO
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    x.value('.','VARCHAR(20)') AS Value
FROM @x.nodes('/*/*') y(x)
    
/*
Value
--------------------
1001                
Jacob 
*/

