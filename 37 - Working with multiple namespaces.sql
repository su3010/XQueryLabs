 /*
 XQuery Lab 37 - Working with multiple namespaces
Oct 11 2008 8:36PM by Jacob Sebastian   

 

We have seen several XQuery examples in the previous posts in this series. We briefly discussed XML namespaces in a couple of posts 
earlier (XML Namespaces, SQL Server 2005 XML and Default Namespaces). Some times, reading values from an XML document having namespace 
declarations might seem little tricky. Let us look at a few examples having namespace declarations and see how to read information from the XML documents.

Here is the sample XML we will examine in this lab.

<Configuration
  xmlns:db="urn:jacobsebastian.blogspot.com/databaseconnection"
  xmlns:net="urn:jacobsebastian.blogspot.com/internetconnection">
  <net:Connection>
    <net:Provider>World Wide Internet Providers</net:Provider>
    <net:Speed>512 KBPS</net:Speed>
  </net:Connection>
  <db:Connection>
    <db:Provider>SQL Client Provider</db:Provider>
    <db:Protocol>TCP/IP</db:Protocol>
    <db:Authentication>Windows</db:Authentication>
  </db:Connection>
</Configuration>


This XML document has two namespace declarations. However, it does not have a default namespace. Alternatively, we could make one of 
the namespaces as default namespace. That will give us 3 different representations of the same XML document. Let us see how to 
read information from the three different representations of the XML document.

Example 1:

This example reads information from the version of the XML document that does not have any default namespace.
*/


DECLARE @x XML
SELECT @x = '
<Configuration
  xmlns:db="urn:jacobsebastian.blogspot.com/databaseconnection"
  xmlns:net="urn:jacobsebastian.blogspot.com/internetconnection">
  <net:Connection>
    <net:Provider>World Wide Internet Providers</net:Provider>
    <net:Speed>512 KBPS</net:Speed>
  </net:Connection>
  <db:Connection>
    <db:Provider>SQL Client Provider</db:Provider>
    <db:Protocol>TCP/IP</db:Protocol>
    <db:Authentication>Windows</db:Authentication>
  </db:Connection>
</Configuration>'

;WITH XMLNAMESPACES(
    'urn:jacobsebastian.blogspot.com/databaseconnection' AS db,
    'urn:jacobsebastian.blogspot.com/internetconnection' AS net
)
SELECT
    n.value('net:Provider[1]','VARCHAR(30)') AS NetProvider,
    n.value('net:Speed[1]','VARCHAR(10)') AS NetSpeed,
    d.value('db:Provider[1]','VARCHAR(20)') AS DBProvider,
    d.value('db:Protocol[1]','VARCHAR(10)') AS DBProtocol
FROM @x.nodes('Configuration/net:Connection') x1(n)
CROSS APPLY @x.nodes('Configuration/db:Connection') x2(d)

/*
NetProvider                    NetSpeed   DBProvider           DBProtocol
------------------------------ ---------- -------------------- ----------
World Wide Internet Providers  512 KBPS   SQL Client Provider  TCP/IP    
*/

/*
Example 2

This version of the XML document specifies the first namespace as the default namespace. Elements belonging to the default namespace are not 
prefixed with a namespace prefix. Note that the first namespace is declared as DEFAULT in the WITH XMLNAMESPACES block.
*/
GO
DECLARE @x XML
SELECT @x = '
<Configuration
  xmlns="urn:jacobsebastian.blogspot.com/databaseconnection"
  xmlns:net="urn:jacobsebastian.blogspot.com/internetconnection">
  <net:Connection>
    <net:Provider>World Wide Internet Providers</net:Provider>
    <net:Speed>512 KBPS</net:Speed>
  </net:Connection>
  <Connection>
    <Provider>SQL Client Provider</Provider>
    <Protocol>TCP/IP</Protocol>
    <Authentication>Windows</Authentication>
  </Connection>
</Configuration>'

;WITH XMLNAMESPACES(
    DEFAULT 'urn:jacobsebastian.blogspot.com/databaseconnection',
    'urn:jacobsebastian.blogspot.com/internetconnection' AS net
)
SELECT
    n.value('net:Provider[1]','VARCHAR(30)') AS NetProvider,
    n.value('net:Speed[1]','VARCHAR(10)') AS NetSpeed,
    d.value('Provider[1]','VARCHAR(20)') AS DBProvider,
    d.value('Protocol[1]','VARCHAR(10)') AS DBProtocol
FROM @x.nodes('Configuration/net:Connection') x1(n)
CROSS APPLY @x.nodes('Configuration/Connection') x2(d)

/*
NetProvider                    NetSpeed   DBProvider           DBProtocol
------------------------------ ---------- -------------------- ----------
World Wide Internet Providers  512 KBPS   SQL Client Provider  TCP/IP    
*/

/*
Example 3

This is the third variation of the XML document that specifies the second namespace as the default namespace. 
The following example shows how to read information from this version of the XML document.
*/
GO
DECLARE @x XML
SELECT @x = '
<Configuration
  xmlns:db="urn:jacobsebastian.blogspot.com/databaseconnection"
  xmlns="urn:jacobsebastian.blogspot.com/internetconnection">
  <Connection>
    <Provider>World Wide Internet Providers</Provider>
    <Speed>512 KBPS</Speed>
  </Connection>
  <db:Connection>
    <db:Provider>SQL Client Provider</db:Provider>
    <db:Protocol>TCP/IP</db:Protocol>
    <db:Authentication>Windows</db:Authentication>
  </db:Connection>
</Configuration>'

;WITH XMLNAMESPACES(
    'urn:jacobsebastian.blogspot.com/databaseconnection' AS db,
    DEFAULT 'urn:jacobsebastian.blogspot.com/internetconnection'
)
SELECT
    n.value('Provider[1]','VARCHAR(30)') AS NetProvider,
    n.value('Speed[1]','VARCHAR(10)') AS NetSpeed,
    d.value('db:Provider[1]','VARCHAR(20)') AS DBProvider,
    d.value('db:Protocol[1]','VARCHAR(10)') AS DBProtocol
FROM @x.nodes('Configuration/Connection') x1(n)
CROSS APPLY @x.nodes('Configuration/db:Connection') x2(d)

/*
NetProvider                    NetSpeed   DBProvider           DBProtocol
------------------------------ ---------- -------------------- ----------
World Wide Internet Providers  512 KBPS   SQL Client Provider  TCP/IP    
*/

/*
Reading information from SQL Server Maintenance Plan XML document

It is Kyle Gerbrandt who inspired me to write this post. After reading the XQuery Labs, he mentioned that it does not contain enough articles to explain 
how to work with XML documents having namespace declarations. He is working on a DBA Database Automation System where he needs to read information from 
the XML documents that SQL Server internally uses to store information about Maintenance Plans. Here is a sample XML document he sent me. 
(I have edited the document and kept only the data needed for this example). Here is the XML document.


<DTS:Executable xmlns:DTS="www.microsoft.com/SqlServer/Dts">
  <DTS:Executable DTS:ExecutableType="STOCK:SEQUENCE">
    <DTS:Executable 
        DTS:ExecutableType="Microsoft...." 
        DTS:ThreadHint="0">
      <DTS:ObjectData>
        <SQLTask:SqlTaskData 
              xmlns:SQLTask="www.microsoft.com/sqlserver/dts/tasks/sqltask" 
              SQLTask:TaskName="Shrink Database Task" >
        </SQLTask:SqlTaskData>
      </DTS:ObjectData>
    </DTS:Executable>
  </DTS:Executable>
</DTS:Executable>


The task is to read the value of the attribute: SQLTask:TaskName. This XML document is bit different from the XML documents we have seen previously. 
There are two different namespaces we need to handle in this example. The element that holds the attribute we need to read belongs to a different 
namespace than its parent node. Let us see how to read the value of the above attribute from this XML document.
*/
GO
DECLARE @xml XML
SELECT @xml = '
<DTS:Executable xmlns:DTS="www.microsoft.com/SqlServer/Dts">
  <DTS:Executable DTS:ExecutableType="STOCK:SEQUENCE">
    <DTS:Executable 
        DTS:ExecutableType="Microsoft...." 
        DTS:ThreadHint="0">
      <DTS:ObjectData>
        <SQLTask:SqlTaskData 
              xmlns:SQLTask="www.microsoft.com/sqlserver/dts/tasks/sqltask" 
              SQLTask:TaskName="Shrink Database Task" >
        </SQLTask:SqlTaskData>
      </DTS:ObjectData>
    </DTS:Executable>
  </DTS:Executable>
</DTS:Executable>'

;WITH XMLNAMESPACES (
    'www.microsoft.com/SqlServer/Dts' as DTS, 
    'www.microsoft.com/sqlserver/dts/tasks/sqltask' as SQLTask
)
SELECT 
    x.value('(@SQLTask:TaskName)','varchar(50)') as TaskName
FROM
@xml.nodes('
    /DTS:Executable/DTS:Executable/DTS:Executable/DTS:ObjectData/SQLTask:SqlTaskData'
) v(x)
/*
TaskName
--------------------------------------------------
Shrink Database Task                              
*/

