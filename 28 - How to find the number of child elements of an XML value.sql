 /*
 XQuery Lab 28 - How to find the number of child elements of an XML value?
Sep 14 2008 1:30AM by Jacob Sebastian   

 

Well, this is yet another question we need to answer before we could write the TSQL function to compare two XML values. Let us look at an XML instance.

<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Number>1001</Number>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Number>1002</Number>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Number>1003</Number>
  </Employee>
</Employees>


Note that <Employees> has 3 child elements and each <Employee> element has 2 child elements each. Let us write an XQuery that returns this information. 
The following query finds the number of child elements that the Employees element has.
*/

DECLARE    @x1 XML
SELECT @x1 = '
<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Number>1001</Number>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Number>1002</Number>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Number>1003</Number>
  </Employee>
</Employees>'

SELECT
    @x1.value('count(/Employees/Employee)','INT') AS Children
/*
Children
-----------
3
*/

/*
The next example finds the number of child elements that the first Employee element has. We used a wildcard, because we want to count all the elements.
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Number>1001</Number>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Number>1002</Number>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Number>1003</Number>
  </Employee>
</Employees>'

SELECT
    @x1.value('count(/Employees/Employee[1]/*)','INT') AS Children
/*
Children
-----------
2
*/

/*
If we do not know the name of the elements, we can use a wildcard to represent the elements at a given position on the hierarchy. Here is an example:
*/
GO
DECLARE    @x1 XML
SELECT @x1 = '
<Employees>
  <Employee>
    <Name>Jacob</Name>
    <Number>1001</Number>
  </Employee>
  <Employee>
    <Name>Bob</Name>
    <Number>1002</Number>
  </Employee>
  <Employee>
    <Name>Steve</Name>
    <Number>1003</Number>
  </Employee>
</Employees>'

SELECT
    @x1.value('count(/*/*)','INT') AS ChildrenOfRootElement,
    @x1.value('count(/*/*[1]/*)','INT') AS ChildrenOfFirstChildElement
    
/*
ChildrenOfRootElement ChildrenOfFirstChildElement
--------------------- ---------------------------
3                     2
*/

