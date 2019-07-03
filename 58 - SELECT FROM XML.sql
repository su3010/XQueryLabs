/*
XQuery Lab 58 - SELECT * FROM XML
May 30 2010 11:49PM by Jacob Sebastian   

Most people find it very difficult to deal with XML documents in TSQL as there is no way to run a ‘blind’ SELECT * query on an XML document 
to get a quick view of the content stored in it. A “select TOP N *” query can quickly give you a few records from the table which will give 
you an idea about the structure of the table and the type of values stored in the columns.  One of the common queries that I run on a table 
that I am not familiar with is

SELECT TOP 1 * FROM tablename

This query will give me one record that I can review and understand the structure of the table. However, it is really hard to do something similar 
for an XML document. The “*” operator does not work for XML and hence I can write a query on the XML document only if I know the structure of the XML.

To make this easier, I have come up with a function that can give you a “SELECT * FROM XML” kind of functionality. You can pass an XML document 
to the function and it will return a tabular representation of the XML data. Here is an example that shows how you can use this function.
*/

declare @x xml
select @x = '
<employees>
    <emp name="jacob"/>
    <emp name="steve">
        <phone>123</phone>
    </emp>
</employees>
'
SELECT * FROM dbo.XMLTable(@x) 

/*
NodeName  NodeType  XPath                        TreeView      Value XmlData      
--------- --------- ---------------------------- ------------- ----- -------------
employees Element   employees[1]                 employees     NULL  <employees>..
emp       Element   employees[1]/emp[1]              emp       NULL  <emp name="..
name      Attribute employees[1]/emp[1]/@name            @name jacob NULL
emp       Element   employees[1]/emp[2]              emp       NULL  <emp name="..
name      Attribute employees[1]/emp[2]/@name            @name steve NULL
phone     Element   employees[1]/emp[2]/phone[1]         phone 123   <phone>123<..
*/


/*
The ‘XPath’ column may be very helpful as it shows the XPath expression that you can use to retrieve a specific value from the XML document. 
For example, to retrieve the phone number, you can copy the XPath expression from the above result and directly put it in a query such as:
*/

SELECT @x.value('employees[1]/emp[2]/phone[1]','VARCHAR(20)') AS Phone

/*
Phone
--------------------
123
*/
GO

/*
Here is the complete listing of the function
*/


/*----------------------------------------------------------------------------- 
  Date       : 1 May 2010 
  SQL Version: SQL Server 2005/2008 
  Author     : Jacob Sebastian 
  Email      : jacob@beyondrelational.com 
  Twitter    : @jacobsebastian  
  Blog       : http://beyondrelational.com/blogs/jacob 
  Website    : http://beyondrelational.com

  Summary: 
  This script returns a tabular representation of an XML document

  Modification History:
  Jacob Sebastian - 1 May 2010
		Created the first version
  Jacob Sebatian - 18 June 2010
		Fixed a bug in the XPath Expressiong generated
  Jacob Sebastian - 20 June 2010
		Added new column - ParentName
		Updated the 'treeview' column to show lines
		Added new column - 'Position'
		Added New Column - 'ParentPosition'
  Jacob Sebastian - 23 June 2010		
		Made the function UNICODE compatibile. (Thanks Peso)
  Jacob Sebastian - 30 June 2010		
		Corrected the casing of a few columns to make the function
		work on case sensitive SQL Server installations. 
		(Thanks Rhodri Evans)               
		
  Notes:
  If you find this script useful, let us know by writing a comment at
  http://beyondrelational.com/blogs/jacob/archive/2010/05/30/select-from-xml.aspx
	
  Disclaimer:  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A 
  PARTICULAR PURPOSE. 
-----------------------------------------------------------------------------*/ 
/* 
SELECT * FROM dbo.XMLTable(' 
<employees> 
    <emp name="jacob"/> 
    <emp name="steve"> 
        <phone>123</phone> 
    </emp> 
</employees> 
') 
*/ 
CREATE FUNCTION [dbo].[XMLTable]( 
    @x XML 
) 
RETURNS TABLE 
AS RETURN 
/*---------------------------------------------------------------------- 
This INLINE TVF uses a recursive CTE that processes each element and 
attribute of the XML document passed in. 
----------------------------------------------------------------------*/ 
WITH cte AS ( 
    /*------------------------------------------------------------------ 
    Anchor part of the recursive query. Retrieves the root element 
    of the XML document 
    ------------------------------------------------------------------*/ 
    SELECT 
        1 AS lvl, 
        x.value('local-name(.)','NVARCHAR(MAX)') AS Name, 
        CAST(NULL AS NVARCHAR(MAX)) AS ParentName,
        CAST(1 AS INT) AS ParentPosition,
        CAST(N'Element' AS NVARCHAR(20)) AS NodeType, 
        x.value('local-name(.)','NVARCHAR(MAX)') AS FullPath, 
        x.value('local-name(.)','NVARCHAR(MAX)') 
            + N'[' 
            + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS NVARCHAR) 
            + N']' AS XPath, 
        ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Position,
        x.value('local-name(.)','NVARCHAR(MAX)') AS Tree, 
        x.value('text()[1]','NVARCHAR(MAX)') AS Value, 
        x.query('.') AS this,        
        x.query('*') AS t, 
        CAST(CAST(1 AS VARBINARY(4)) AS VARBINARY(MAX)) AS Sort, 
        CAST(1 AS INT) AS ID 
    FROM @x.nodes('/*') a(x) 
    UNION ALL 
    /*------------------------------------------------------------------ 
    Start recursion. Retrieve each child element of the parent node 
    ------------------------------------------------------------------*/ 
    SELECT 
        p.lvl + 1 AS lvl, 
        c.value('local-name(.)','NVARCHAR(MAX)') AS Name, 
        CAST(p.Name AS NVARCHAR(MAX)) AS ParentName,
        CAST(p.Position AS INT) AS ParentPosition,
        CAST(N'Element' AS NVARCHAR(20)) AS NodeType, 
        CAST( 
            p.FullPath 
            + N'/' 
            + c.value('local-name(.)','NVARCHAR(MAX)') AS NVARCHAR(MAX) 
        ) AS FullPath, 
        CAST( 
            p.XPath 
            + N'/' 
            + c.value('local-name(.)','NVARCHAR(MAX)') 
            + N'[' 
            + CAST(ROW_NUMBER() OVER(
				PARTITION BY c.value('local-name(.)','NVARCHAR(MAX)')
				ORDER BY (SELECT 1)) AS NVARCHAR	) 
            + N']' AS NVARCHAR(MAX) 
        ) AS XPath, 
        ROW_NUMBER() OVER(
				PARTITION BY c.value('local-name(.)','NVARCHAR(MAX)')
				ORDER BY (SELECT 1)) AS Position,
        CAST( 
            SPACE(2 * p.lvl - 1) + N'|' + REPLICATE(N'-', 1)
            + c.value('local-name(.)','NVARCHAR(MAX)') AS NVARCHAR(MAX) 
        ) AS Tree, 
        CAST( c.value('text()[1]','NVARCHAR(MAX)') AS NVARCHAR(MAX) ) AS Value, 
        c.query('.') AS this,        
        c.query('*') AS t, 
        CAST( 
            p.Sort 
            + CAST( (lvl + 1) * 1024 
            + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS VARBINARY(4) 
        ) AS VARBINARY(MAX) ) AS Sort, 
        CAST( 
            (lvl + 1) * 1024 
            + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS INT 
        ) 
    FROM cte p 
    CROSS APPLY p.t.nodes('*') b(c)        
), cte2 AS ( 
    SELECT 
        lvl AS Depth, 
        Name AS NodeName, 
        ParentName,
        ParentPosition,
        NodeType, 
        FullPath, 
        XPath, 
        Position,
        Tree AS TreeView, 
        Value, 
        this AS XMLData, 
        Sort, ID 
    FROM cte 
    UNION ALL 
    /*------------------------------------------------------------------ 
    Attributes do not need recursive calls. So add the attributes 
    to the query output at the end. 
    ------------------------------------------------------------------*/ 
    SELECT 
        p.lvl, 
        x.value('local-name(.)','NVARCHAR(MAX)'), 
        p.Name,
        p.Position,
        CAST(N'Attribute' AS NVARCHAR(20)), 
        p.FullPath + N'/@' + x.value('local-name(.)','NVARCHAR(MAX)'), 
        p.XPath + N'/@' + x.value('local-name(.)','NVARCHAR(MAX)'), 
        1,
        SPACE(2 * p.lvl - 1) + N'|' + REPLICATE('-', 1) 
			+ N'@' + x.value('local-name(.)','NVARCHAR(MAX)'), 
        x.value('.','NVARCHAR(MAX)'), 
        NULL, 
        p.Sort, 
        p.ID + 1 
    FROM cte p 
    CROSS APPLY this.nodes('/*/@*') a(x) 
) 
SELECT 
    ROW_NUMBER() OVER(ORDER BY Sort, ID) AS ID, 
    ParentName, ParentPosition,Depth, NodeName, Position,  
    NodeType, FullPath, XPath, TreeView, Value, XMLData
FROM cte2

GO

/*
Next Steps

    The function currently does not support namespaces. The next version will add support for namespaces
    Let me know your comments and feedback on this function. 

*/