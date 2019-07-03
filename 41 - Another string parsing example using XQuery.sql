/*
 XQuery Lab 41 - Another string parsing example using XQuery
Feb 5 2009 9:01PM by Jacob Sebastian   

 

We have seen a number of string parsing/manipulating examples using XQuery and FOR XML in the previous sessions of XQuery Labs.  This session presents yet another string parsing example using XML data type methods.

Here is the string value that we need to parse.

'id1-s1,s2,s3|id2-s4,s5,s6|id3-s7,s8,s9'


We need to parse the above string and generate a row set as follows:

idname id1  id2  id3
------ ---- ---- ----
id1    s1   s2   s3 
id2    s4   s5   s6 
id3    s7   s8   s9 


Let us try do the parsing using XQuery methods. Before we can apply XQuery method on this value, we need to convert it to a well formed XML value. Let us use the REPLACE() function to convert this string to a well-formed XML value as given in the following example:

<v>
  <i>id1</i>
  <a>s1</a>
  <a>s2</a>
  <a>s3</a>
</v>
<v>
  <i>id2</i>
  <a>s4</a>
  <a>s5</a>
  <a>s6</a>
</v>
<v>
  <i>id3</i>
  <a>s7</a>
  <a>s8</a>
  <a>s9</a>
</v>



The following code shows the REPLACE() operation needed to transform the original string to the XML representation.
*/

DECLARE @str VARCHAR(MAX), @x XML
SELECT @str = 'id1-s1,s2,s3|id2-s4,s5,s6|id3-s7,s8,s9'
SELECT @x = REPLACE(
                REPLACE(
                    '<v><i>' + 
                    REPLACE(
                        @str,'|','</a></v><v><i>'
                    ) 
                    + '</a></v>','-','</i><a>'
                ),',','</a><a>'
            )
GO
/*
Now let us use XQuery to retrieve the information from the XML document. Here is the complete source code listing.
*/
DECLARE @str VARCHAR(MAX), @x XML
SELECT @str = 'id1-s1,s2,s3|id2-s4,s5,s6|id3-s7,s8,s9'
SELECT @x = REPLACE(
                REPLACE(
                    '<v><i>' + 
                    REPLACE(
                        @str,'|','</a></v><v><i>'
                    ) 
                    + '</a></v>','-','</i><a>'
                ),',','</a><a>'
            )

SELECT @x
SELECT 
    x.value('i[1]', 'CHAR(3)') AS idname,
    x.value('a[1]','CHAR(3)') AS id1,
    x.value('a[2]','CHAR(3)') AS id2,
    x.value('a[3]','CHAR(3)') AS id3
FROM @x.nodes('/v') a(x)

/*
idname id1  id2  id3
------ ---- ---- ----
id1    s1   s2   s3 
id2    s4   s5   s6 
id3    s7   s8   s9 
*/

/*
Notes:


This is yet another string parsing example using XQuery methods. The purpose of XQuery labs series is to help people learn XQuery within the context of SQL Server. 
The approach presented in this series of articles may be good in some cases and may not be ideal for other cases.

*/