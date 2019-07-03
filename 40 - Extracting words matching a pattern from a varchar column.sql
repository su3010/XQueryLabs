 /*
 XQuery Lab 40 - Extracting words matching a pattern from a varchar column
Jan 27 2009 8:56PM by Jacob Sebastian   

 

We saw a number of string manipulation examples using FOR XML and XML Data Type methods. Here is yet another string parsing requirement that we will solve using the XML Data type methods. In this post, we will see how to extract words from strings stored in a column, that match with a given pattern.

As usual, I wrote this example to help a user in one of the SQL Server forums. Here is the sample data we  have for this lab.

col1
--------------------------------------------------
MOTOROLA RAZR V3 CAR CHARGER
MOTOROLA V71 BATT COVER/SLVR
POWER CHARGER MOT V223
KODAK V550 LI-ION 720mAh


Our job is to extract all words that starts with "V" from the above column, so that the result should be:

col
------------------------------
V3
V71
V223
V550


This can be achieved in a number of ways and we will examine the XML way of doing this.

Let us create a table variable to store the sample data.
*/
DECLARE @t table (col1 varchar(50)) 

INSERT INTO @t SELECT 'MOTOROLA RAZR V3 CAR CHARGER' 
INSERT INTO @t SELECT 'MOTOROLA V71 BATT COVER/SLVR' 
INSERT INTO @t SELECT 'POWER CHARGER MOT V223' 
INSERT INTO @t SELECT 'KODAK V550 LI-ION 720mAh' 

/*
The first step is to convert the string stored in each row to an XML document, breaking each word into an XML element.
*/
SELECT 
    CAST('<i>' + REPLACE(col1, ' ', '</i><i>') + '</i>' AS XML) AS col
FROM @t

/*
col
-------------------------------------------------------------
<i>MOTOROLA</i><i>RAZR</i><i>V3</i><i>CAR</i><i>CHARGER</i>
<i>MOTOROLA</i><i>V71</i><i>BATT</i><i>COVER/SLVR</i>
<i>POWER</i><i>CHARGER</i><i>MOT</i><i>V223</i>
<i>KODAK</i><i>V550</i><i>LI-ION</i><i>720mAh</i>
*/

/*
And the next step is to shred the XML document into a row-set using XML data type methods.
*/
SELECT 
    x.i.value('.', 'VARCHAR(30)') AS col
FROM (
 SELECT 
        CAST('<i>' + REPLACE(col1, ' ', '</i><i>') + '</i>' AS XML) AS col
    FROM @t
) a CROSS APPLY col.nodes('//i') x(i)

/*
col
------------------------------
MOTOROLA
RAZR
V3
CAR
CHARGER
MOTOROLA
V71
BATT
COVER/SLVR
POWER
CHARGER
MOT
V223
KODAK
V550
LI-ION
720mAh
*/


Finally, we can filter the output using the required pattern in the WHERE clause.

SELECT 
    x.i.value('.', 'VARCHAR(30)') AS col
FROM (
 SELECT 
        CAST('<i>' + REPLACE(col1, ' ', '</i><i>') + '</i>' AS XML) AS col
    FROM @t
) a CROSS APPLY col.nodes('//i') x(i)
WHERE x.i.value('.', 'VARCHAR(30)') LIKE 'V%'
GO
/*
col
------------------------------
V3
V71
V223
V550
*/

/*
Here is the complete code listing:
*/

DECLARE @t table (col1 varchar(50)) 

INSERT INTO @t SELECT 'MOTOROLA RAZR V3 CAR CHARGER' 
INSERT INTO @t SELECT 'MOTOROLA V71 BATT COVER/SLVR' 
INSERT INTO @t SELECT 'POWER CHARGER MOT V223' 
INSERT INTO @t SELECT 'KODAK V550 LI-ION 720mAh' 

SELECT 
    x.i.value('.', 'VARCHAR(30)') AS col
FROM (
 SELECT 
        CAST('<i>' + REPLACE(col1, ' ', '</i><i>') + '</i>' AS XML) AS col
    FROM @t
) a CROSS APPLY col.nodes('//i') x(i)
WHERE x.i.value('.', 'VARCHAR(30)') LIKE 'V%'

/*
col
------------------------------
V3
V71
V223
V550
*/


This approach is pretty handy and very compact to write. While this is good for small sets of data, you might find performance problems if applied on very large volume of data. Did you ever come across an interesting string manipulation requirement that solved (or want to solve) in TSQL? Feel free to share it with us!
N