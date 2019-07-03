/*
XQuery Lab 61 – Writing a Recursive CTE to process an XML document
Jun 29 2010 7:02PM by Jacob Sebastian   

We have seen several examples of writing recursive queries in the earlier blog posts. For a quick recap, you can find some of those posts in the list given below.

    TSQL Lab 10 - Performing recursive updates in SQL Server
    TSQL Lab 11 - Writing a recursive procedure to update the count of child items under each parent category
    TSQL Lab 12 - Writing a recursive procedure to handle more than 32 levels
    TSQL Lab 14 - Performing a recursive update for more than 32 levels
    TSQL Lab 18 - Performing Recursive Updates using CTE
    TSQL Lab 20 - Performing recursive updates using a BOTTOM to TOP recursive CTE
    Recursive CTE and Ordering of the hierarchical result

In this XQuery Lab, we will see how to write a recursive CTE to process all the elements and attributes of an XML Document. In XQuery Lab 39, we saw an example that generated the fully qualified path to all the elements and attributes of an XML document using OPENXML(). In this lab, let us look at a new version of the same code using XQuery (instead of OPENXML).

This code is a stripped down version of XQuery Lab 58 which presented a generic function to query the content of an XML document. 
*/
DECLARE @x XML  
SELECT @x = '
<books>
    <book id="101">
        <title>my book</title>
        <author>Myself</author>
    </book>
    <book id="202">
        <title>your book</title>
        <author>you</author>
    </book>
</books>'

;WITH cte AS ( 
    SELECT 
        1 AS lvl, 
        x.value('local-name(.)','VARCHAR(MAX)') AS FullPath, 
        x.value('text()[1]','VARCHAR(MAX)') AS Value, 
        x.query('.') AS CurrentNode,        
        CAST(CAST(1 AS VARBINARY(4)) AS VARBINARY(MAX)) AS Sort
    FROM @x.nodes('/*') a(x) 
    UNION ALL 
    SELECT 
        p.lvl + 1 AS lvl, 
        CAST( 
            p.FullPath 
            + '/' 
            + c.value('local-name(.)','VARCHAR(MAX)') AS VARCHAR(MAX) 
        ) AS FullPath, 
        CAST( c.value('text()[1]','VARCHAR(MAX)') AS VARCHAR(MAX) ) AS Value, 
        c.query('.')  AS CurrentNode,        
        CAST( 
            p.Sort 
            + CAST( (lvl + 1) * 1024 
            + (ROW_NUMBER() OVER(ORDER BY (SELECT 1)) * 2) AS VARBINARY(4) 
        ) AS VARBINARY(MAX) ) AS Sort
    FROM cte p 
    CROSS APPLY CurrentNode.nodes('/*/*') b(c)        
), cte2 AS (
	SELECT 
		FullPath, 
		Value, 
		Sort 
	FROM cte 
	UNION ALL 
	SELECT 
		p.FullPath + '/@' + x.value('local-name(.)','VARCHAR(MAX)'), 
		x.value('.','VARCHAR(MAX)'),
		Sort 
	FROM cte p 
	CROSS APPLY CurrentNode.nodes('/*/@*') a(x) 
)
SELECT FullPath, value 
FROM cte2
WHERE Value IS NOT NULL
ORDER BY Sort 
/*
FullPath             Value
-------------------- ------------------------------
books\book\@id       101
books\book\title     my book
books\book\author    Myself
books\book\@id       202
books\book\title     your book
books\book\author    you
*/