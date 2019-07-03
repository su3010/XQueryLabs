/*
 XQuery Lab 5 - Working with Namespaces
Jun 30 2008 2:33PM by Jacob Sebastian   

Working with Namespaces is little more tricky. The following code shows an example that queries values from an XML document, having namespace declaration. Note the usage of WITH NAMESPACES which resolves the namespace references. Note also the usage of OUTER APPLY which joins the parent nodes with the child nodes.
*/
DECLARE @var XML
SET @var = '
<Customers xmlns="urnchemas-microsoft-comqlqlRowSet2">
  <Customer>
    <CompanyName>Wide World Importers</CompanyName>
    <OrderLine>
      <SKU>WWIR375</SKU>
      <Quantity>1</Quantity>
    </OrderLine>
    <OrderLine>
      <SKU>WWIRB1-2RO</SKU>
      <Quantity>16</Quantity>
    </OrderLine>
  </Customer>
  <Customer>
    <CompanyName>US Importers</CompanyName>
    <OrderLine>
      <SKU>WWIR376</SKU>
      <Quantity>1</Quantity>
    </OrderLine>
    <OrderLine>
      <SKU>WWIRB1-3RO</SKU>
      <Quantity>16</Quantity>
    </OrderLine>
  </Customer>
</Customers>'

;WITH XMLNAMESPACES(
    DEFAULT 'urnchemas-microsoft-comqlqlRowSet2' 
)
SELECT 
    x.value('CompanyName[1]','VARCHAR(20)') AS CompanyName,
    y.value('SKU[1]','VARCHAR(10)') AS Sku,
    y.value('Quantity[1]','INT') AS Quantity
FROM @var.nodes('/Customers/Customer') v(x)
OUTER APPLY x.nodes('OrderLine') o(y)

/*
CompanyName          Sku        Quantity
-------------------- ---------- -----------
Wide World Importers WWIR375    1
Wide World Importers WWIRB1-2RO 16
US Importers         WWIR376    1
US Importers         WWIRB1-3RO 16
*/

