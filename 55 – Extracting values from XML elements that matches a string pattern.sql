/*
 XQuery Lab 55 – Extracting values from XML elements that matches a string pattern
Apr 7 2010 9:48AM by Jacob Sebastian   

Here is another XQuery exercise that uses the contains() function to match a string pattern against an XML element and retrieves values from a sibling element.

Here is the input data for this challenge.
*/

/*
<ArrayOfCustomField>
      <CustomField>
            <Name>abc</Name>
            <Value>Some Value</Value>
      </CustomField>
      <CustomField>
            <Name>SKU,AlphaNumeric,20</Name>
            <Value>XXX111</Value>
      </CustomField>
      <CustomField>
            <Name>Another Name</Name>
            <Value>Another Value</Value>
      </CustomField>
</ArrayOfCustomField>
*/
/*
The task is to retrieve the text from the Value element where the Name contains “SKU”. In this case, the result needs to be “XXX111”.

Here is the query that performs the above task.
*/

DECLARE @x XML
SELECT @x = '
<ArrayOfCustomField>
      <CustomField>
            <Name>abc</Name>
            <Value>Some Value</Value>
      </CustomField>
      <CustomField>
            <Name>SKU,AlphaNumeric,20</Name>
            <Value>XXX111</Value>
      </CustomField>
      <CustomField>
            <Name>Another Name</Name>
            <Value>Another Value</Value>
      </CustomField>
</ArrayOfCustomField>'

SELECT
	x.value('Value[1]','VARCHAR(30)') AS value
FROM @x.nodes('/ArrayOfCustomField/CustomField') a(x)
CROSS APPLY x.nodes('Name[contains(.,"SKU")]') b(y)

/*
value
------------------------------
XXX111
*/