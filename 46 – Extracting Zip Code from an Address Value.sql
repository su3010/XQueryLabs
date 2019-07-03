/*
XQuery Lab 46 – Extracting Zip Code from an Address Value
Aug 12 2009 10:11AM by Jacob Sebastian   

I just came across a task to extract ZIP code values from the address column of a table. The address is a single string that contains information such as street, city, state, zip code, apartment number etc. The data comes from a legacy system where the address information is not stored in separate columns. The task is to extract the zip code from such an address value.

Here are some sample address values (The address values are not real)

CustomerID  CustomerAddress
----------- --------------------------------------------------
1           12 20 97TH STREET NEW GARDENS, NY  11415  APT 8P
2           20-10 93RD STREET #8A VICTORIA NY 11106 19TH FLR
3           290 BERKELEY STREET APT24D  NYC, NY  10038
4           351-250  345 STREET PANAMA BEACH 11414  APT4F


Looking at the pattern (in this specific case), I found that the following logic will help to identify the correct zip code values

    break the address string into words using SPACE as the breaking point
    Examine each 5 characters long words
    If the word is a number, it could be the zip code

Note that this logic may not work for every case. You might find data that is quite different than what I have. For the specific set of data that I had, the above logic worked perfect.

Step #1 above can be achieved using XQuery, as explained in http://beyondrelational.com/blogs/jacob/archive/2008/08/14/xquery-lab-19-how-to-parse-a-delimited-string.aspx. LEN() and ISNUMERIC() functions can be applied on the result of #1 to perform the rest of the validations.
*/

DECLARE @t TABLE (CustomerID INT, CustomerAddress VARCHAR(50))
INSERT INTO @t(CustomerID, CustomerAddress) 
    SELECT 1, '12 20 97TH STREET NEW GARDENS, NY  11415  APT 8P' UNION ALL
    SELECT 2, '20-10 93RD STREET #8A VICTORIA NY 11106 19TH FLR' UNION ALL
    SELECT 3, '290 BERKELEY STREET APT24D  NYC, NY  10038' UNION ALL
    SELECT 4, '351-250  345 STREET PANAMA BEACH 11414  APT4F'
    
;WITH cte AS (
    SELECT 
        CustomerID,
        CAST('<i>' + 
            REPLACE(CustomerAddress, ' ', '</i><i>') + '</i>' AS XML)
             AS CustomerAddress
    FROM @t
)
SELECT 
    CustomerID,
    x.i.value('.', 'VARCHAR(10)') AS ZipCode
FROM cte
CROSS APPLY CustomerAddress.nodes('//i[string-length(.)=5][number()>0]') 
    x(i)
    
/*
CustomerID  ZipCode
----------- ----------
1           11415
2           11106
3           10038
4           11414
*/

 