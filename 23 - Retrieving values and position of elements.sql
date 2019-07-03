 /*
 XQuery Lab 23 - Retrieving values and position of elements
Aug 21 2008 1:13AM by Jacob Sebastian   

 

I wrote this query a few months back to help some one in the XML forums. Here is the sample XML data for this lab.

<Names>
    <Name>Jacob</Name>
    <Name>Steve</Name>
    <Name>Bob</Name>
</Names>


The task is to read the value from the <name> elements. Well that is pretty simple. The tough part is that, we need to retrieve the position of each element too. We need to retrieve 1 for Jacob, 2 for Steve and 3 for Bob.

XQuery does not provide a function to retrieve this information. The "position()" function cannot be used in the value() method. Hence I wrote the following query, which is little funny. It joins the XML nodes with a system table spt_values which contains a sequence of numbers. The number column is joined with the position() of each element and that gives us the position of each element. Here is the query:
*/
DECLARE @x XML 
SELECT @x = ' 
<Names>
    <Name>Jacob</Name>
    <Name>Steve</Name>
    <Name>Bob</Name>
</Names>'

SELECT
    p.number as Position,
    x.value('.','VARCHAR(10)') AS Name
FROM
master..spt_values p
cross APPLY @x.nodes('/Names/Name[position()=sql:column("number")]') n(x) 
where p.type = 'p'

/*
Position    Name
----------- ----------
1           Jacob     
2           Steve     
3           Bob       
*/

