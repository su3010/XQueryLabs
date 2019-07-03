 /*
 XQuery Lab 48 - Sorting Query files in SQL Server Management Studio (SSMS) Solution/Project
Aug 22 2009 2:36PM by Jacob Sebastian   

I was working on my presentation for 24-hour-pass event on 2nd September and came across the sorting issue with the solution explorer. I have a number of script demos and I wanted to organize them by name. No matter, what I did, the solution explorer continued to display the script files in its own order, and not in the way I wanted them.

My Frustration increased when I opened the project XML file and found that the XML element is set to be “sorted”, but the sorting flag has no effect in the way SSMS displayed the items.

<LogicalFolder Name="Queries" Type="0" Sorted="true">

 
Though the “Sorted” attribute is set to “true”, no sorting took effect in the SSMS. As a quick work around, I opened the “.ssmssqlproj” XML file in an XML editor and modified the physical order of the elements in the project file. I saved the file and after I reopened the project, the query files were displayed in the correct order.
 
I felt so bad about this behavior and thought of writing a script that can automate this process the next time I need this. So I wrote a stored procedure that loads the content of the project file and order it and outputs a file with the sorted items.
 
Here is the content of the stored procedure that performs this.
*/

CREATE PROCEDURE SortSSMSProjectFiles
(
    @ProjectFileName VARCHAR(512)
)
AS

DECLARE @x XML, @qry NVARCHAR(500), @param NVARCHAR(100)
SELECT @qry = N'
    SELECT 
        @x = CAST(bulkcolumn AS XML) 
    FROM OPENROWSET(BULK ''' + @ProjectFileName + ''', 
        SINGLE_BLOB) AS x'
PRINT @qry
SELECT @param = '@x XML OUTPUT'
EXECUTE sp_executesql @qry, @param, @x OUTPUT 

SELECT @x.query('
<SqlWorkbenchSqlProject 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    Name="{SqlWorkbenchSqlProject/@Name}">
  <Items>
    {
        for $lf in SqlWorkbenchSqlProject/Items/LogicalFolder
        return 
            if ($lf/@Name = "Queries") 
            then 
                <LogicalFolder Name="{$lf/@Name}" 
                    Type="{$lf/@Type}" Sorted="{$lf/@Sorted}">
                    <Items>
                        {
                            for $i in $lf/Items/*
                            order by $i/@Name
                            return $i
                        }
                    </Items>
                </LogicalFolder>
            else $lf
    }
  </Items>
</SqlWorkbenchSqlProject>    
')

/*
This is how you can execute this stored procedure
*/
EXECUTE SortSSMSProjectFiles
    @ProjectFileName = 'C:\temp\demo\demo\demo.ssmssqlproj'

/*
The @ProjectFileName should point to the “.ssmssqlproj” file of your project. This stored procedure will produce an XML document. You can open it in SSMS and use “File->save as” menu to overwrite your existing project  file.

If you want to completely automate this, you can use osql.exe or sqlcmd.exe to execute this stored procedure and generate an output file in the desired location.

To demonstrate this problem, I created a demo project and added some files in random order. Here is how SSMS displays my files now.

ssms1

I wanted to get them organized and I ran the project file through my stored procedure. The stored procedure updated the project file and here is how the files are displayed in SSMS after the change.

ssms2

I tested it with my projects and it works. I would like to hear your comments and suggestions on this script.
*/