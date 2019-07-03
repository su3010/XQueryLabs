 /*
 XQuery Lab 3 - Filtering specific nodes
Jun 27 2008 1:34AM by Jacob Sebastian   

Sometimes we need to apply a filter on the nodes of an XML document and retrieve only those nodes that meet a specific criteria. Most of the times, such filters will be applied on a given attribute value of the specific element. Here is such an example.

Here is the sample XML document that we have.

<root>
  <Branch id="1">
    <PeriodType pt="0">
      <PeriodNumber pn="1">
        <StartDate>06/23/2008</StartDate>
        <EndDate>06/24/2008</EndDate>
      </PeriodNumber>
      <PeriodNumber pn="2">
        <StartDate>06/16/2008</StartDate>
        <EndDate>06/22/2008</EndDate>
      </PeriodNumber>
      <PeriodNumber pn="3">
        <StartDate>06/09/2008</StartDate>
        <EndDate>06/15/2008</EndDate>
      </PeriodNumber>
      <PeriodNumber pn="4">
        <StartDate>06/02/2008</StartDate>
        <EndDate>06/08/2008</EndDate>
      </PeriodNumber>
    </PeriodType>
    <PeriodType pt="1">
      <PeriodNumber pn="1">
        <StartDate>06/23/2008</StartDate>
        <EndDate>06/24/2008</EndDate>
      </PeriodNumber>
    </PeriodType>
  </Branch>
</root>


We need to write a query that reads the StartDate and EndDate of all <PeriodType> elements where the "pt" attribute has a value of "1". This filter can be applied directly within the "nodes()" operator of the XML data type. Here is the expected result.

/*
StartDate               EndDate
----------------------- -----------------------
2008-06-23 00:00:00.000 2008-06-24 00:00:00.000
*/


The query should return only one row, because there is only one XML element that where the "pt" attribute of <PeriodType> is "1". Here is the query that performs this.
*/
DECLARE @dates xml

SET @dates = '
<root>
  <Branch id="1">
    <PeriodType pt="0">
      <PeriodNumber pn="1">
        <StartDate>06/23/2008</StartDate>
        <EndDate>06/24/2008</EndDate>
      </PeriodNumber>
      <PeriodNumber pn="2">
        <StartDate>06/16/2008</StartDate>
        <EndDate>06/22/2008</EndDate>
      </PeriodNumber>
      <PeriodNumber pn="3">
        <StartDate>06/09/2008</StartDate>
        <EndDate>06/15/2008</EndDate>
      </PeriodNumber>
      <PeriodNumber pn="4">
        <StartDate>06/02/2008</StartDate>
        <EndDate>06/08/2008</EndDate>
      </PeriodNumber>
    </PeriodType>
    <PeriodType pt="1">
      <PeriodNumber pn="1">
        <StartDate>06/23/2008</StartDate>
        <EndDate>06/24/2008</EndDate>
      </PeriodNumber>
    </PeriodType>
  </Branch>
</root>'

SELECT
    x.value('StartDate[1]','DATETIME') AS StartDate,
    x.value('EndDate[1]','DATETIME') AS EndDate
FROM @dates.nodes('/root/Branch/PeriodType[@pt="1"]/PeriodNumber') d(x)

/*
StartDate               EndDate
----------------------- -----------------------
2008-06-23 00:00:00.000 2008-06-24 00:00:00.000
*/

