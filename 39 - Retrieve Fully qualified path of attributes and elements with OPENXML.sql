/* XQuery Lab 39 - Retrieve Fully qualified path of attributes and elements with OPENXML()
Jan 23 2009 12:45PM by Jacob Sebastian   

I found this question in the MSDN SQL Server XML forum and wrote a query to help the user who posted it. I wanted to write a query using XQuery but could not write it instantly. There does not seem to be an easy way to get the full path of an element or attribute. One option I can think of, is writing a recursive function that walks through the XML tree and generates the path string. When we examined the function that compares two XML documents, we saw how to recursively walk through the elements of an XML document. We could probably use a similar approach to achieve this as well.

The sample code that I wrote for that user did not use XQuery, but used OPENXML. It was quicker to write this using OPENXML. However, this has a number of limitations: the code cannot be embedded into a function,  only one XML document can be processed at a time etc etc.

Here is the sample XML document.
*/
/*
<books>
    <book id="101">
        <title>my book</title>
        <author>Myself</author>
    </book>
    <book id="202">
        <title>your book</title>
        <author>you</author>
    </book>
</books>
*/

/*
And here is the output we are trying to generate.
*/


/*
path                                               text
-------------------------------------------------- ------------------------------
books\book\@id                                     101
books\book\title                                   my book
books\book\author                                  Myself
books\book\@id                                     202
books\book\title                                   your book
books\book\author                                  you
*/


/*
Let us start writing the query. The first step is to shred the data into a rowset using OPENXML(). Here is the code that shreds the XML document to a rowset.
*/


DECLARE 
    @idoc INT,  
    @xml XML  
    
SELECT @xml = '
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

EXEC sp_xml_preparedocument @idoc OUTPUT, @xml  
SELECT * FROM OPENXML(@idoc,'/',3)  
EXEC sp_xml_removedocument @idoc 
GO
/*
id   parentid nodetype localname prev text
---- -------- -------- --------- ---- ---------------
0    NULL     1        books     NULL NULL
2    0        1        book      NULL NULL
3    2        2        id        NULL NULL
10   3        3        #text     NULL 101
4    2        1        title     NULL NULL
11   4        3        #text     NULL my book
5    2        1        author    4    NULL
12   5        3        #text     NULL Myself
6    0        1        book      2    NULL
7    6        2        id        NULL NULL
13   7        3        #text     NULL 202
8    6        1        title     NULL NULL
14   8        3        #text     NULL your book
9    6        1        author    8    NULL
15   9        3        #text     NULL you
*/


/*
The above code builds a tabular result. The table implements a parent-child relationship, using the id and parentid columns. We can use these columns to build the relationship hierarchy. We can then write a recursive query that builds a relationship tree and can retrieve the page of each node and attribute in the XML document.

We have seen a number of posts in the past, that performs recursive operation. You can find a few of them below:

    TSQL Lab 10 - Performing recursive updates in SQL Server
    TSQL Lab 11 - Writing a recursive procedure to update the count of child items under each parent category
    TSQL Lab 12 - Writing a recursive procedure to handle more than 32 levels
    TSQL Lab 14 - Performing a recursive update for more than 32 levels
    TSQL Lab 18 - Performing Recursive Updates using CTE
    TSQL Lab 20 - Performing recursive updates using a BOTTOM to TOP recursive CTE
    Recursive CTE and Ordering of the hierarchical result

If you are not familiar with recursive queries, I would suggest reading the above articles or refer "recursive CTE" in books online or in a location of your choice. Assuming that you are familiar with recursive queries, I am presenting the final solution below.
*/


DECLARE 
    @idoc INT,  
    @xml XML  
    
SELECT @xml = '
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

EXEC sp_xml_preparedocument @idoc OUTPUT, @xml  

;WITH cte AS (
    -- shreds XML to rowset
    SELECT * FROM OPENXML(@idoc,'/',3)  
), rcte AS (
    -- anchor part of recursive query
    SELECT 0 AS Level, id, parentid, nodetype, localname, prev, 
        CAST(text AS VARCHAR(30)) AS Text,
        CAST(localname AS VARCHAR(50)) AS path,
        CAST(id AS VARBINARY(128)) AS Sort
    FROM cte WHERE id = 0
    -- recursive part
    UNION ALL
    SELECT p.level + 1, c.id, c.parentid, c.nodetype, c.localname, c.prev, 
        CAST(c.text AS VARCHAR(30)),
        CAST(p.path + CASE WHEN c.nodetype = 3 THEN '' ELSE '\' END + 
            CASE WHEN c.nodetype = 2 THEN '@' ELSE '' END +
            CASE WHEN c.nodetype = 3 THEN '' ELSE c.localname END AS VARCHAR(50)),
        CAST(p.Sort + CAST(c.id AS VARBINARY(4)) AS VARBINARY(128))
    FROM cte c
    INNER JOIN rcte p ON p.id = c.parentid
)
-- the final query
SELECT path, text FROM rcte
WHERE text IS NOT NULL
ORDER BY sort

EXEC sp_xml_removedocument @idoc 
GO
/*
OUTPUT:

path                                               text
-------------------------------------------------- ------------------------------
books\book\@id                                     101
books\book\title                                   my book
books\book\author                                  Myself
books\book\@id                                     202
books\book\title                                   your book
books\book\author                                  you
*/

/*
The sample code presented above does not handle XML namespaces. I will write a follow-up post that handles namespaces as well. I want to write an XQuery version of the above query and will try to post them soon.
*/