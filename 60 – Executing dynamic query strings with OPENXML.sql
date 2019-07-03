/*
XQuery Lab 60 – Executing dynamic query strings with OPENXML()
Jun 24 2010 5:14PM by Jacob Sebastian   

This installment of XQuery Lab shows how to execute dynamic queries that contain OPENXML() calls. We will see examples that use EXEC() and sp_executesql.

Using EXEC()

Let us start with EXEC().
*/

DECLARE @hdoc INT
DECLARE @xml VARCHAR(MAX)
SELECT @xml = '
<Employees>
    <Employee ID="1001" Name="Jacob"/>
    <Employee ID="1002" Name="Steve"/>
</Employees>'

EXEC('
    DECLARE @hdoc INT
    EXEC sp_xml_preparedocument @hdoc OUTPUT, ''' + @xml + '''
    SELECT *
    FROM OPENXML (@hdoc, ''/Employees/Employee'', 1)
    WITH (
        ID  varchar(10),
        Name varchar(20)
    )
    EXEC sp_xml_removedocument @hdoc'
)
GO
/*
ID         Name
---------- --------------------
1001       Jacob
1002       Steve
*/

/*
Using sp_executesql

The next example shows how to use sp_executesql with OPENXML()
*/


DECLARE @hdoc INT
DECLARE @xml VARCHAR(MAX)
SELECT @xml = '
<Employees>
    <Employee ID="1001" Name="Jacob"/>
    <Employee ID="1002" Name="Steve"/>
</Employees>'

DECLARE @qry NVARCHAR(500), @param NVARCHAR(50)
SELECT @qry = N'
    SELECT *
    FROM OPENXML (@hdoc, ''/Employees/Employee'', 1)
    WITH (
        ID  varchar(10),
        Name varchar(20)
    )'
SELECT @param = N'@hdoc INT'

EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml
EXEC sp_executesql @qry, @param, @hdoc
EXEC sp_xml_removedocument @hdoc
GO
/*
ID         Name
---------- --------------------
1001       Jacob
1002       Steve
*/

/*
Your code might look simpler if you decide to handle the sp_xml_preparedocument and sp_xml_removedocument calls in the outer code. 
However, if you wish to let sp_executesql take care of that, you can do that as well. Here is another example. 

*/

DECLARE @xml VARCHAR(MAX)
SELECT @xml = '
<Employees>
    <Employee ID="1001" Name="Jacob"/>
    <Employee ID="1002" Name="Steve"/>
</Employees>'

DECLARE @qry NVARCHAR(500), @param NVARCHAR(50)
SELECT @qry = N'
	DECLARE @hdoc INT;
	EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml;
    SELECT *
    FROM OPENXML (@hdoc, ''/Employees/Employee'', 1)
    WITH (
        ID  varchar(10),
        Name varchar(20)
    );
	EXEC sp_xml_removedocument @hdoc; '
SELECT @param = N'@xml VARCHAR(MAX)'

EXEC sp_executesql @qry, @param, @xml
/*
ID         Name
---------- --------------------
1001       Jacob
1002       Steve
*/