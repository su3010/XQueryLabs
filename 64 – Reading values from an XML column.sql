/*
XQuery Lab 64 – Reading values from an XML column
Jul 18 2011 2:19AM by Jacob Sebastian   

I got a question in my personal forum this morning requesting help to read values from an XML column. My first reaction was “Well, there is an XQuery lab demonstrating this!”. However, after reviewing the existing XQuery labs, I realized there are no posts demonstrating this.

Here is a simple example that demonstrates how to read values from an XML column.
*/

DECLARE @t TABLE (
	ID INT IDENTITY,
	Data XML
)

INSERT INTO @t (Data)
SELECT '<employee name="Jacob" />' UNION ALL
SELECT '<employee name="Michael" />'

SELECT
	x.value('@Name[1]', 'VARCHAR(20)') AS Name
FROM @t t
CROSS APPLY Data.nodes('/employee') a(x)
/*
Name
--------------------
Jacob
Michael
*/