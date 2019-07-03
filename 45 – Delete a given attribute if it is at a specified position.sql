 /*
 XQuery Lab 45 – Delete a given attribute if it is at a specified position
Jul 31 2009 10:18PM by Jacob Sebastian   

One of the readers recently asked me if we could delete an attribute with a specific name from all the elements of an XML document. 
However, the deletion should occur only if the attribute is at a given position.

Here is the sample data for this Lab.

<Employees>
  <Employee name="Jacob" city="NY" Team="SQL Server"/>
  <Employee city="FL" name="Steve" Team="SQL Server"/>
  <Employee name="Bob" city = "CA" Team="ASP.NET"/>
</Employees>


The task is the following: Delete the “name” attribute from all the elements where “name” is the first attribute in the element. 
The first and third element has “name” as the first attribute. After the delete operation, the “name” attribute should be removed from the first and third element, 
but the second element should retain the attribute.

Here is the query that performs this operation.
*/

DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee name="Jacob" city="NY" Team="SQL Server"/>
  <Employee city="FL" name="Steve" Team="SQL Server"/>
  <Employee name="Bob" city = "CA" Team="ASP.NET"/>
</Employees>'

SET @x.modify('
    delete (Employees/Employee/@*[position()=1][local-name()="name"])
    ')

SELECT @x 
/*
<Employees>
  <Employee city="NY" Team="SQL Server" />
  <Employee city="FL" name="Steve" Team="SQL Server" />
  <Employee city="CA" Team="ASP.NET" />
</Employees>
*/

