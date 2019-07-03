/*
XQuery Lab 54 – Modifying an XML document with a SELECT Query
Mar 31 2010 6:37PM by Jacob Sebastian   

Here is an interesting XQuery requirement that one of my friends sent me. The challenge is to modify an XML document stored in an XML column as part of a SELECT query.

Here is a simplified representation of the problem. Take a look at the source data before we proceed with the query.
*/

/*
id          data
----------- ----------------------------------
1           <data><code>Le code</code></data>

*/

/*
The task is to add a new element to the XML document as part of a SELECT query. The XML document needs to have an additional element to store the “ID” of the current record.  
Here is the expected result:
*/

/*
----------- -------------------------------------------
1           <data><id>1</id><code>Le code</code></data>
*/

/*
There are a number of different ways to generate the above output as part of a select query. The following code snippet demonstrates one way of doing this.
*/

DECLARE @t TABLE (
    id INT,
    data XML )

INSERT INTO @t (id, data)
SELECT 1, '
    <data>
        <code>Le code</code>
    </data>'


SELECT id, 
    data.query('
    <data>
        <id>{sql:column("id")}</id>
        {/data/code}
    </data>')
FROM @t

/*
<data>
  <id>1</id>
  <code>Le code</code>
</data>
*/