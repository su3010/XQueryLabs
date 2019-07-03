 /*
 XQuery Lab 44 – Inserting an XML fragment into an XML Document
Jun 2 2009 10:23PM by Jacob Sebastian   

In XQuery Lab 10 we saw how to insert an attribute to an XML document and in XQuery Lab 11, we say how to insert an element to an XML Document. 
We have not seen an example that inserts an XML fragment to another XML document. So, let us see how to do this.

SQL Server 2005 does not allow inserting XML fragments into an XML document. SQL Server 2008 enhanced the “modify()” method 
of XML data type to be able to insert XML fragments into an XML document. Here is an example that demonstrates that.
*/
DECLARE @emp XML
SELECT @emp = '
<Employee>
    <FirstName>Jacob</FirstName>
    <LastName>Sebastian</LastName>
</Employee>'

DECLARE @ph XML
SELECT @ph = '<Phone>+91 9979882144</Phone>'

SET @emp.modify('
    insert sql:variable("@ph") 
    as last into (/Employee)[1]')

SELECT @emp 
/*
<Employee>
  <FirstName>Jacob</FirstName>
  <LastName>Sebastian</LastName>
  <Phone>+91 9979882144</Phone>
</Employee>
*/

