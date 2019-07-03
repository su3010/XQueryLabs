 /*
 XQuery Lab 42 - How to Execute a Dynamic OPENXML() Query?
Feb 5 2009 9:04PM by Jacob Sebastian   

 

I heard this question from many people. Executing a dynamic OPENXML() query is little tricky.

Before we look at a dynamic OPENXML() query, let us look at the static version. Here is an example document that we will parse using OPENXML() in this session.

<Employees>
    <Employee ID="1001" Name="Jacob"/>
    <Employee ID="1002" Name="Steve"/>
</Employees>


Let us write an OPENXML() query that retrieves the Employee ID and Name from the above XML value.
*/
DECLARE @hdoc INT
DECLARE @xml VARCHAR(MAX)
SELECT @xml = '
<Employees>
    <Employee ID="1001" Name="Jacob"/>
    <Employee ID="1002" Name="Steve"/>
</Employees>'


EXEC sp_xml_preparedocument @hdoc OUTPUT, @xml

SELECT *
FROM OPENXML (@hdoc, '/Employees/Employee', 1)
WITH (
    ID  varchar(10),
    Name varchar(20)
)

EXEC sp_xml_removedocument @hdoc
GO
/*
ID         Name
---------- --------------------
1001       Jacob
1002       Steve
*/

/*
Let us see how to write the dynamic version of this query.

Using sp_executesql

It is pretty easy to execute a dynamic OPENXML() query with sp_executesql. sp_executesql accepts parameterized queries and hence the document handle can be passed as a parameter to this procedure.

Here is the version of the dynamic query that can be executed with sp_executesql
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
Using EXEC()

It is not very handy to write dynamic OPENXML() queries with EXEC(). This is because there is no easy way to pass the document handle to the EXEC() function. To execute a dynamic OPENXML() query with EXEC() we need to make sure that calls to "sp_xml_preparedocument" and "sp_xml_removedocument" are also part of the dynamic query.

Here is the version of the query that can be executed with EXEC()
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
/*
ID         Name
---------- --------------------
1001       Jacob
1002       Steve
*/

