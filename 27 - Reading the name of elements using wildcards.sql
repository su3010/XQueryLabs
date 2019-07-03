 /*
 XQuery Lab 27 - Reading the name of elements using wildcards
Sep 14 2008 1:26AM by Jacob Sebastian   

 

Most of the times we need only to read values from elements. However, there may be times when you need to read the name of elements as well. We came across this requirement when we started writing the TSQL function that compares two XML values, in the previous post.

The following example shows how to read the name of the root element of an XML value.
*/
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    @x.value('local-name(/*[1])','VARCHAR(20)') AS ElementName
/*
ElementName
--------------------
Employee 
*/

/*
The next example shows how to read the name and value of the first element under the root element.
*/
GO
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    @x.value('local-name((/*/*)[1])','VARCHAR(20)') AS ElementName,
    @x.value('(/*/*/text())[1]','VARCHAR(20)') AS ElementValue
/*
ElementName          ElementValue
-------------------- --------------------
Number               1001                
*/

/*
The next example shows how to read the name and value of the second element under the root element.
*/
GO
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    @x.value('local-name((/*/*)[2])','VARCHAR(20)') AS ElementName,
    @x.value('(/*/*/text())[2]','VARCHAR(20)') AS ElementValue
/*
ElementName          ElementValue
-------------------- --------------------
Name                 Jacob               
*/

/*
The next example shows how to read the names and values of all the elements under the root element.
*/
GO
DECLARE    @x XML
SELECT @x = '
<Employee>
    <Number>1001</Number>
    <Name>Jacob</Name>
</Employee>'

SELECT
    x.value('local-name(.)','VARCHAR(20)') AS ElementName,
    x.value('.','VARCHAR(20)') AS ElementValue
FROM @x.nodes('/*/*') y(x)
    
/*
ElementName          ElementValue
-------------------- --------------------
Number               1001                
Name                 Jacob               
*/

