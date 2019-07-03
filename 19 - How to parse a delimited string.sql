/*
 XQuery Lab 19 - How to parse a delimited string?
Aug 14 2008 1:03AM by Jacob Sebastian   

 

XML Data Type functions can be used to perform a number of string operations. This post explains how to parse a delimited string using the XML approach. The XML approach helps you to avoid the WHILE-LOOP that you might need with most other approaches.

In one of my previous posts, I had presented an example which generated a delimited string using FOR XML PATH. You can read the post here. In this post, let us take the results of that lab and see if we can revert back to the input of that lab by splitting the delimited values back. This was our source data.

/*
CompanyID   CompanyCode
----------- -----------
1           1
1           2
2           1
2           2
2           3
2           4
3           1
3           2
*/


Then we generated a delimited string using FOR XML PATH and here is the output.

/*
CompanyID   CompanyString
----------- -------------------------
1           1|2
2           1|2|3|4
3           1|2
*/


Now let us take this output and see if we can split it back and get the original values.
*/
DECLARE @companies Table(    
    CompanyID INT,    
    CompanyCodes VARCHAR(100)
) 
    
insert into @companies(CompanyID, CompanyCodes) values(1,'1|2')
insert into @companies(CompanyID, CompanyCodes) values(2,'1|2|3|4')
insert into @companies(CompanyID, CompanyCodes) values(3,'1|2')

SELECT * FROM @companies
GO
/*
CompanyID   CompanyCodes
----------- -----------------------
1           1|2                                                                                                 
2           1|2|3|4                                                                                             
3           1|2                                                                                                 
*/


--Here is the query that returns the desired results.

-- create table
DECLARE @companies Table(    
    CompanyID INT,    
    CompanyCodes VARCHAR(100)
) 
    
-- insert data
insert into @companies(CompanyID, CompanyCodes) values(1,'1|2')
insert into @companies(CompanyID, CompanyCodes) values(2,'1|2|3|4')
insert into @companies(CompanyID, CompanyCodes) values(3,'1|2')

-- Query
;WITH cte AS (
    SELECT 
        CompanyID,
        CAST('<i>' + REPLACE(CompanyCodes, '|', '</i><i>') + '</i>' AS XML) AS CompanyCodes
    FROM @Companies
)
SELECT 
    CompanyID,
    x.i.value('.', 'VARCHAR(10)') AS CompanyCode
FROM cte
CROSS APPLY CompanyCodes.nodes('//i') x(i)

/*
CompanyID   CompanyCode
----------- -----------
1           1          
1           2          
2           1          
2           2          
2           3          
2           4          
3           1          
3           2      
*/


--The CTE returns a result set which transforms the delimited string to a well-formed XML fragment. The next query uses XQuery value() method to retrieve the values of the nodes.

