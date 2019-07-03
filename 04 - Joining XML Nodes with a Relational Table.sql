/*
 XQuery Lab 4 - Joining XML Nodes with a Relational Table
Jun 27 2008 2:28PM by Jacob Sebastian   

Recently some one asked me if we could join XML nodes with a relational table. The answer is YES. I wrote a quick sample that demonstrates this. Here is an example.
*/
DECLARE @t TABLE (EmpID INT, EmpName VARCHAR(20))
INSERT INTO @t (EmpID, EmpName) SELECT 1, 'Jacob'
INSERT INTO @t (EmpID, EmpName) SELECT 2, 'Bob'

DECLARE @x XML
SELECT @x = '
<Employees>
    <Employee id="1" hireDate="somedate"/>
    <Employee id="2" hireDate="otherDate"/>
</Employees>'

SELECT
    t.EmpID,
    t.EmpName,
    x.value('@hireDate[1]','VARCHAR(10)') AS HireDate
FROM 
    @x.nodes('/Employees/Employee') e(x)
CROSS APPLY @t t
WHERE x.value('@id[1]','int') = t.EmpID

/*
EmpID       EmpName              HireDate
----------- -------------------- ----------
1           Jacob                somedate  
2           Bob                  otherDate 



The above example joins a memory table (@t) with an XML variable (@x) on the column EmpID and returns information. EmpName is stored in the table and HireDate is stored in the XML variable. The query joins them and returns the results.
*/