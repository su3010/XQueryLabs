/*
XQuery Lab 1 - Transforming rows to columns
Jun 26 2008 11:51PM by Jacob Sebastian     

This is the first of a series of XQuery posts I plan to write under the ‘XQuery Labs’ series. The purpose of this series is to demonstrate the usages of XML Data type methods and XQuery functions.

Input

I have an XML document which looks like the following.

<QUOTE configID="arbu05_0X4fe77d8454141612">
  <CSTICS>
    <ORDER_CFGS_VALUE>
      <Field Name="CONFIG_ID" Value="arbu05_0X4fe77d8454141612" />
      <Field Name="INST_ID" Value="2" />
      <Field Name="CHARC" Value="A7J_ID_CONFIG" />
      <Field Name="VALUE" Value="0" />
    </ORDER_CFGS_VALUE>
    <ORDER_CFGS_VALUE>
      <Field Name="CONFIG_ID" Value="arbu05_0X4fe77d8454141612" />
      <Field Name="INST_ID" Value="2" />
      <Field Name="CHARC" Value="A7J_ID_ELECTRICAL" />
      <Field Name="VALUE" Value="0" />
    </ORDER_CFGS_VALUE>
  </CSTICS>
</QUOTE>

Look at the child nodes of ORDER_CFGS_VALUE. Each ORDER_CFGS_VALUE element has 4 child nodes named field. We need to write a query that transforms those nodes into columns.

Expected output

The output should look like the following.

CONFIG_ID            INST_ID     CHARC                VALUE
-------------------- ----------- -------------------- -----------
arbu05_0X4fe77d84541 2           A7J_ID_CONFIG        0
arbu05_0X4fe77d84541 2           A7J_ID_ELECTRICAL    0

The query should return only two rows; one row for each ORDER_CFGS_VALUE. The children of ORDER_CFGS_VALUE having name CONFIG_ID, INST_ID, CHARC and VALUE should be transformed as columns.

The Query
*/
DECLARE @x XML
SELECT @x = '
<QUOTE configID="arbu05_0X4fe77d8454141612">
  <CSTICS>
    <ORDER_CFGS_VALUE>
      <Field Name="CONFIG_ID" Value="arbu05_0X4fe77d8454141612" />
      <Field Name="INST_ID" Value="2" />
      <Field Name="CHARC" Value="A7J_ID_CONFIG" />
      <Field Name="VALUE" Value="0" />
    </ORDER_CFGS_VALUE>
    <ORDER_CFGS_VALUE>
      <Field Name="CONFIG_ID" Value="arbu05_0X4fe77d8454141612" />
      <Field Name="INST_ID" Value="2" />
      <Field Name="CHARC" Value="A7J_ID_ELECTRICAL" />
      <Field Name="VALUE" Value="0" />
    </ORDER_CFGS_VALUE>
  </CSTICS>
</QUOTE>'

SELECT 
    x.value('(Field[@Name="CONFIG_ID"]/@Value)[1]','VARCHAR(20)') AS CONFIG_ID,
    x.value('(Field[@Name="INST_ID"]/@Value)[1]','INT') AS INST_ID,
    x.value('(Field[@Name="CHARC"]/@Value)[1]','VARCHAR(20)') AS CHARC,
    x.value('(Field[@Name="VALUE"]/@Value)[1]','INT') AS VALUE
FROM @x.nodes('/QUOTE/CSTICS/ORDER_CFGS_VALUE') d(x)


/*
CONFIG_ID            INST_ID     CHARC                VALUE
-------------------- ----------- -------------------- -----------
arbu05_0X4fe77d84541 2           A7J_ID_CONFIG        0
arbu05_0X4fe77d84541 2           A7J_ID_ELECTRICAL    0


Note the way filters are applied on the value of attribute "Name". The expression "Field[@Name="CONFIG_ID"]" will take you to the XML element having "CONFIG_ID" as the value of the "Name" attribute. After accessing this element, the value of the "value" attribute is retrieved with the expression "Field[@Name="CONFIG_ID"]/@Value"

Comments/Questions are welcome!

XQuery Labs - A Collection of XQuery Sample Scripts
*/