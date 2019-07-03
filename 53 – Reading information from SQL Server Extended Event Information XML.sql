/*
XQuery Lab 53 – Reading information from SQL Server Extended Event Information XML
Mar 23 2010 6:42PM by Jacob Sebastian   

One of my friends recently sent me the following XML fragment and asked me if I can help writing a query to pull the information out of the XML document.
*/

/*
<event name="exception_ring_buffer_recorded" package="sqlos">
  <data name="error">
    <value>8134</value>
    <text />
  </data>
  <data name="severity">
    <value>16</value>
    <text />
  </data>
  <action name="tsql_stack" package="sqlserver">
    <value>
      &lt;frame level='1' 
      handle='0x010007007845CB27D81B4308000000000000000000000000' 
      line='1' offsetStart='0' offsetEnd='0'/&gt;
    </value>
    <text />
  </action>
  <action name="sql_text" package="sqlserver">
    <value>SELECT 1/0 AS DevideByZeroError;</value>
    <text />
  </action>
</event>
*/

/*
Here is the expected output from the above XML fragment:
*/

/*
Error  sql_text           tsql_stack
------ ------------------ ----------------------------
8134   SELECT 1/0 AS      0x010007007845CB27D81B430800
       DevideByZeroError; 0000000000000000000000        
*/

/*
At first glance it will look like any other XQuery example we have seen in the previous labs, but there are two challenge in this task.

First of all, we need to read values from multiple nodes and present them as columns. Secondly once of the elements (“tsql_stack”) contains an XML encoded string and we need to extract an attribute value (“handle”) from the XML encoded string.

Once way to achieve this is by retrieving the XML string and casting it to an XML data type value and then running another XQuery on the result. The following example demonstrates it.

*/


DECLARE @x XML
SELECT @x = '
<event name="exception_ring_buffer_recorded" package="sqlos" >
  <data name="error">
    <value>8134</value>
    <text />
  </data>
  <data name="severity">
    <value>16</value>
    <text />
  </data>
  <action name="tsql_stack" package="sqlserver">
    <value>
		&lt;frame level=''1'' 
		handle=''0x010007007845CB27D81B4308000000000000000000000000'' 
		line=''1'' offsetStart=''0'' offsetEnd=''0''/&gt;
	</value>
    <text />
  </action>
  <action name="sql_text" package="sqlserver">
    <value>SELECT 1/0 AS DevideByZeroError;</value>
    <text />
  </action>
</event>'

SELECT
    Error,
    ttext,
    stack.value('(frame/@handle)[1]','VARCHAR(50)') AS tstack
FROM @x.nodes('/event') a(x)
CROSS APPLY (
	SELECT CAST(
		x.value('(action[@name="tsql_stack"]/value)[1]','VARCHAR(1000)')
        AS XML
       ) AS stack,
       x.value('(data[@name="error"]/value)[1]','INT') AS Error,
       x.value('(action[@name="sql_text"]/value)[1]','VARCHAR(40)') 
		AS ttext
) ts

/*
Error  ttext              tstack
------ ------------------ ----------------------------
8134   SELECT 1/0 AS      0x010007007845CB27D81B430800
       DevideByZeroError; 0000000000000000000000        
*/