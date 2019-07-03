/*
 XQuery Lab 24 - Reading value of an element specified by a variable
Aug 26 2008 1:16AM by Jacob Sebastian   

 

We have seen the usage of XQuery function "local-name()" in one of the previous posts. This function is very helpful when you don't know the element or attribute to process. The calling process can specify an element or attribute name in a variable and you can perform an operation (select/insert/update) on the specified element or attribute by using this function.

Here is the XML document we need to process in this lab.

<Employees>
  <Employee>
    <FirstName>Jacob</FirstName>
    <LastName>Sebastian</LastName>
  </Employee>
  <Employee>
    <FirstName>Mike</FirstName>
    <LastName>Jones</LastName>
  </Employee>
</Employees>


We need to read the value of an element specified by a variable. The variable contains the name of the element to be retrieved. It could be FirstName or LastName. The following example shows how to use local-name() function to achieve this.
*/

DECLARE @xml XML
set @xml = '
<Employees>
  <Employee>
    <FirstName>Jacob</FirstName>
    <LastName>Sebastian</LastName>
  </Employee>
  <Employee>
    <FirstName>Mike</FirstName>
    <LastName>Jones</LastName>
  </Employee>
</Employees>'

DECLARE @ElementName VARCHAR(20)
SELECT @ElementName = 'FirstName'

select x.value('.', 'varchar(20)') AS Name
FROM @xml.nodes('/Employees/Employee/*[local-name()=sql:variable("@ElementName")]') n(x)

/*
Name
--------------------
Jacob               
Mike                
*/
 