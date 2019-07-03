/*
 XQuery Lab 7 - Extracting a comma separated list of values
Jul 11 2008 2:44PM by Jacob Sebastian   

This may be a very simple example. I don't know if this specific example would help anyone. However, the approach may give some of you a hint that can solve another problem that you may be trying to solve. In fact, the purpose of this whole series is to show some examples that might help some one solve a similar problem.

Here is the problem we are trying to attend in this session. A colleague needed a query that retrieves a comma separated list of values from an XML fragment. The XML is very simple. Here is how it looks like.

<Type Value="01" />
<Type Value="02" />


What we need to generate is a comma separated list as given below.

"01,02"


Lets start looking at the code.
*/
DECLARE @x XML
SELECT @x = '
<Type Value="01"/>
<Type Value="02"/>'

SELECT @x.query('data(Type/@Value)') AS Val
/*
Val
-------------------------------------------
01 02
*/

/*
The above query returns a space separated list with the values stored in the XML fragment. We used the "query()" method of XML data type. So far we have a space separated list of values. Now we can easily apply REPLACE() function on this value and turn it to a comma separated list.

Wait a second, there is a problem. The result returned by the "query()" method is an XML data type. Hence we cannot use it in the REPLACE function. We need to retrieve the string value from the XML result.
*/
GO
DECLARE @x XML
SELECT @x = '
<Type Value="01"/>
<Type Value="02"/>'

SELECT @x.query('data(Type/@Value)').value('.','varchar(100)') AS Val
/*
Val
-------------------------------------------
01 02
*/

/*
The "value()" method of the XML data type retrieves a string value from the result produced by the "query()" method. Now let us apply the REPLACE() function on the results of the above query.
*/
GO
DECLARE @x XML
SELECT @x = '
<Type Value="01"/>
<Type Value="02"/>'

SELECT REPLACE(
    @x.query('data(Type/@Value)').value('.','varchar(100)'),' ',','
) AS Val
/*
Val
-------------------------------------------
01,02
*/

/*
Well, that gave us exactly what we were looking for. In the above example, we assigned the XML fragment to an XML variable and processed it. This is much easier to work with and understand. However, in the requirement I mentioned earlier in this post, a single query was needed. Here is a different version of the query that performs the entire operation in a single query.
*/
SELECT REPLACE(
    CAST(
            '<Type Value="01"/><Type Value="02"/>' AS XML
        ).query('data(Type/@Value)').value('.','varchar(100)'),
    ' ',
    ','
)

