/*

 XQuery Lab 12 - Different ways of reading values from an XML variable
Jul 30 2008 12:33AM by Jacob Sebastian   

 

We all know that there are different ways you can write a query to retrieve a piece of information from one or more tables. XQuery is a rich query language and you can write an XQuery expression in a number of ways to retrieve a certain information. I will show you a few examples in this post.

Here is the sample XML document we will use for this lab.

<Employee>
    <ContactInfo>
        <Info Name="Email">jacob.reliancesp[at]gmail.com</Info> 
        <Info Name="Phone">+919979882144</Info> 
        <Info Name="IM">jacob[at]excellenceinfonet.com</Info> 
    </ContactInfo>
</Employee>


Let us try to read the "Email" information from the XML instance given above. Here are a few different XQuery expressions which reads the "email" information from the above XML.
*/
DECLARE @x XML
SELECT @x = '
<Employee>
    <ContactInfo>
        <Info Name="Email">jacob.reliancesp[at]gmail.com</Info> 
        <Info Name="Phone">+919979882144</Info> 
        <Info Name="IM">jacob[at]excellenceinfonet.com</Info> 
    </ContactInfo>
</Employee>'

-- option 1
SELECT @x.value('data(/Employee/ContactInfo/Info[@Name="Email"])[1]', 'varchar(30)')

-- option 2
SELECT @x.value('(/Employee/ContactInfo/Info[@Name="Email"])[1]', 'varchar(30)')

-- option 3
SELECT 
    x.value('.','varchar(30)')
FROM @x.nodes('/Employee/ContactInfo/Info[@Name="Email"]') n(x)

-- option 4
SELECT 
    x.value('(Info[@Name="Email"])[1]','varchar(30)')
FROM @x.nodes('/Employee/ContactInfo') n(x)

-- option 5
SELECT 
    x.value('(ContactInfo/Info[@Name="Email"])[1]','varchar(30)')
FROM @x.nodes('/Employee') n(x)

-- option 6
SELECT 
    x.value('.','varchar(30)')
FROM @x.nodes('/Employee/ContactInfo/Info') n(x)
WHERE x.value('(.[@Name="Email"])[1]','varchar(30)') IS NOT NULL

-- option 7
SELECT 
    x.value('.','varchar(30)')
FROM @x.nodes('/Employee/ContactInfo/Info') n(x)
WHERE x.exist('(.[@Name="Email"])[1]') = 1
/*

Though all the queries produce the same result, there may be performance differences if the XML document is larger. Also, there could be many more ways of writing this query too. These are just a few that came to the top of my mind. 
*/