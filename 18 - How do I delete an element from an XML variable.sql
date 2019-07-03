/*
 XQuery Lab 18 - How do I delete an element from an XML variable?
Aug 13 2008 12:58AM by Jacob Sebastian   

 

We had seen an example that demonstrated how to delete an attribute from an XML variable. Let us now try to delete an element from an XML document/variable. Here is the sample XML document for this lab.

<Employees>
    <Employee>
        <FirstName>Jacob</FirstName>
        <MiddleName>V</MiddleName>
        <LastName>Sebastian</LastName>
    </Employee>
</Employees>


Let us try to delete the MiddleName element. Here is the code that does this.
*/
DECLARE @x XML
SELECT @x = '
<Employees>
    <Employee>
        <FirstName>Jacob</FirstName>
        <MiddleName>V</MiddleName>
        <LastName>Sebastian</LastName>
    </Employee>
</Employees>'

DECLARE @MiddleName CHAR(1)
SELECT @MiddleName = 'J'

SET @x.modify('
    delete (/Employees/Employee/MiddleName)[1]'
 )
    
SELECT @x
/*
<Employees>
  <Employee>
    <FirstName>Jacob</FirstName>
    <LastName>Sebastian</LastName>
  </Employee>
</Employees>
*/

