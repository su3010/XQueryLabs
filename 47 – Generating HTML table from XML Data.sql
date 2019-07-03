 /*
 XQuery Lab 47 – Generating HTML table from XML Data
Aug 19 2009 7:00AM by Jacob Sebastian   

Welcome to XQuery Lab 47. In this lab, we will see how to generate an HTML table from an XML document, using XQuery.

Here is the source data:

<CUST COMPANY="Company1" CONTACT="Jacob" />
<CUST COMPANY="Company1" CONTACT="Michael" />
<CUST COMPANY="Company3" CONTACT="Steve" />


 

Here is the output required

<table>
  <tr>
    <td>Company</td>
    <td>Contact</td>
  </tr>
  <tr>
    <td>Company1</td>
    <td>Jacob</td>
  </tr>
  <tr>
    <td>Company1</td>
    <td>Michael</td>
  </tr>
  <tr>
    <td>Company3</td>
    <td>Steve</td>
  </tr>
</table>


 

Here is the TSQL code using XQuery to generate the required output.
*/
DECLARE @x XML
SELECT @x = '
<CUST COMPANY="Company1" CONTACT="Jacob" />
<CUST COMPANY="Company1" CONTACT="Michael" />
<CUST COMPANY="Company3" CONTACT="Steve" />'

SELECT
    @x.query('
        <table>
            <tr>
                <td>Company</td>
                <td>Contact</td>
            </tr>
            {
                for $r in CUST
                return
                <tr>
                    <td>{data($r/@COMPANY)}</td>
                    <td>{data($r/@CONTACT)}</td>
                </tr>
            }
        </table>
')

/*
<table>
  <tr>
    <td>Company</td>
    <td>Contact</td>
  </tr>
  <tr>
    <td>Company1</td>
    <td>Jacob</td>
  </tr>
  <tr>
    <td>Company1</td>
    <td>Michael</td>
  </tr>
  <tr>
    <td>Company3</td>
    <td>Steve</td>
  </tr>
</table>
*/

