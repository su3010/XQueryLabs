 /*
 XQuery Lab 38 - Delete elements having date value older than 30 days
Oct 11 2008 8:40PM by Jacob Sebastian   

 

In some of the previous posts, we saw how to delete an element or attribute from an XML document (variable/column). In this post, let us examine one more example that deletes 
elements from an XML document matching a given criteria.

I wrote this example some time back, to help some one at one of the forums. There is a table with an XML column that contains XML documents like the one given below.

<Root>
    <Feed id="2008-08-28T09:49:34.780Z">
        <Content>some content here</Content>
    </Feed>
    <Feed id="2008-09-30T09:49:34.780Z">
        <Content>some content here</Content>
    </Feed>
</Root>


The task is to delete "feed" elements from the XML documents that is older than 30 days. In the above example, the first "feed" element is older than 30 days (today is 11 Oct 2008) 
and hence should be deleted after the operation.

Here is the sample script that performs this operation. It creates a memory table with an XML column and inserts two records. Then it performs a delete operation.
*/
-- Create a memory table
DECLARE @t TABLE (data XML)

-- Populate the table with two records
-- Record 1
INSERT INTO @t (data) SELECT '
<Root>
    <Feed id="2008-08-28T09:49:34.780Z">
        <Content>some content here</Content>
    </Feed>
    <Feed id="2008-09-30T09:49:34.780Z">
        <Content>some content here</Content>
    </Feed>
</Root>'

-- Record 2
INSERT INTO @t (data) SELECT '
<Root>
    <Feed id="2008-08-28T09:49:34.780Z">
        <Content>some content here</Content>
    </Feed>
    <Feed id="2008-09-30T09:49:34.780Z">
        <Content>some content here</Content>
    </Feed>
</Root>'

-- Take the date value to a variable for comparison
DECLARE @d AS NVARCHAR(30)
SET @d = CONVERT( NVARCHAR(30), GETDATE()-31, 126) + 'Z'

-- Perform the update
UPDATE @t SET
    data.modify ('
        delete 
        /Root/Feed[@id cast as xs:dateTime ? < 
        sql:variable("@d") cast as xs:dateTime ?]
    ')
    
-- Let us check the results
SELECT * FROM @t

/*
<Root><Feed id="2008-09-30T09:49:34.780Z"><Content>some content here</Content></Feed></Root>
<Root><Feed id="2008-09-30T09:49:34.780Z"><Content>some content here</Content></Feed></Root>
*/

