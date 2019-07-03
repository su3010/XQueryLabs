/*
 XQuery Lab 36 - Writing a TSQL Function to compare two XML values (Part 2)
Sep 14 2008 7:41PM by Jacob Sebastian   

 

In the previous post we discussed the logic we will apply to write the function that compares two XML values. We will write a function that accepts two XML variables and will compare elements and attributes as per the logic we discussed in the previous post.

I look forward to hear from you with alternate logic as well as suggestions to improve it. This function is not created keeping performance in mind. Instead, it is created to demonstrate a variety of XQuery methods and usages. The purpose of XQuery Lab is to demonstrate different XQuery usages and help people learn XQuery. May be, we will write an optimized version of this function later on.

Let us start writing the function. Here is the declaration of the function.
*/


CREATE FUNCTION CompareXml
(
    @xml1 XML,
    @xml2 XML
)
RETURNS INT
AS 
BEGIN
    DECLARE @ret INT
    SELECT @ret = 0
    
    -- other code here
        
    RETURN @ret
END


/*
The function will return 1 if the values do not match and 0 if they matches. If one of the arguments is NULL we will return 1 to indicate that they are not equal.
 So "SELECT dbo.CompareXML(NULL, NULL)" will return 1.
*/


IF @xml1 IS NULL OR @xml2 IS NULL BEGIN
    RETURN 1
END



/*
First of all, let us match the name of the root element of both XML values. If the names do not match, we will return 1.
*/


 IF  (SELECT @xml1.value('(local-name((/*)[1]))','VARCHAR(MAX)')) 
    <> 
    (SELECT @xml2.value('(local-name((/*)[1]))','VARCHAR(MAX)'))
BEGIN
    RETURN 1
END






/*
Now, let us match the text/data each XML variable stores.
*/


DECLARE @elValue1 VARCHAR(MAX), @elValue2 VARCHAR(MAX)
SELECT
    @elValue1 = @xml1.value('((/*)[1])','VARCHAR(MAX)'),
    @elValue2 = @xml2.value('data((/*)[1])','VARCHAR(MAX)')
    

IF  @elValue1 <> @elValue2
BEGIN
    RETURN 1
END



/*
Next, let us match the number of attributes each root element has.
*/


DECLARE @attCnt1 INT, @attCnt2 INT
SELECT
    @attCnt1 = @xml1.query('count(/*/@*)').value('.','INT'),
    @attCnt2 = @xml2.query('count(/*/@*)').value('.','INT')
    
IF  @attCnt1 <> @attCnt2 BEGIN
    RETURN 1
END



/*
Now, let us create a loop that runs over all the attributes of the first XML value and matches the attributes (name and value) with the attributes of the second XML value. If the attribute is missing in the second XML value or the value is different, we will return 1.
*/
DECLARE @cnt INT
DECLARE @attName VARCHAR(MAX)
DECLARE @attValue VARCHAR(MAX)

SELECT @cnt = 1
    
WHILE @cnt <= @attCnt1 BEGIN
    SELECT @attName = NULL, @attValue = NULL
    SELECT
        @attName = @xml1.value('
            local-name((/*/@*[sql:variable("@cnt")])[1])', 
            'varchar(MAX)'),
        @attValue = @xml1.value('
            (/*/@*[sql:variable("@cnt")])[1]', 
            'varchar(MAX)')
    
    -- check if the attribute exists in the other XML document
    IF @xml2.exist(
            '(/*/@*[local-name()=sql:variable("@attName")])[1]'
        ) = 0
    BEGIN
        RETURN 1
    END
    
    IF  @xml2.value(
                '(/*/@*[local-name()=sql:variable("@attName")])[1]', 
                'varchar(MAX)'
            )
        <>
        @attValue
    BEGIN
        RETURN 1
    END
    
    SELECT @cnt = @cnt + 1
END

/*
If the operation succeeds so far, let us move ahead and validate the child elements. First of all, let us match the number of child elements each XML value has.
*/
DECLARE @elCnt1 INT, @elCnt2 INT
SELECT
    @elCnt1 = @xml1.query('count(/*/*)').value('.','INT'),
    @elCnt2 = @xml2.query('count(/*/*)').value('.','INT')
    

IF  @elCnt1 <> @elCnt2
BEGIN
    RETURN 1
END

/*
If the count of child elements matches, let us process each child element recursively. We will create a loop that runs over all the child elements and recursively call the "CompareXml" function.
*/
SELECT @cnt = 1
DECLARE @x1 XML, @x2 XML
WHILE @cnt <= @elCnt1 BEGIN
    SELECT 
        @x1 = @xml1.query('/*/*[sql:variable("@cnt")]'),
        @x2 = @xml2.query('/*/*[sql:variable("@cnt")]')
    
    IF dbo.CompareXml( @x1, @x2 ) = 1
    BEGIN
        RETURN 1
    END
    
    SELECT @cnt = @cnt + 1
END

/*
Complete Source Listing

Here is the complete listing of the function.
*/
GO
CREATE FUNCTION CompareXml
(
    @xml1 XML,
    @xml2 XML
)
RETURNS INT
AS 
BEGIN
    DECLARE @ret INT
    SELECT @ret = 0

    
    -- -------------------------------------------------------------
    -- If one of the arguments is NULl then we assume that they are
    -- not equal. 
    -- -------------------------------------------------------------
    IF @xml1 IS NULL OR @xml2 IS NULL BEGIN
        RETURN 1
    END

    -- -------------------------------------------------------------
    -- Match the name of the elements 
    -- -------------------------------------------------------------
    IF  (SELECT @xml1.value('(local-name((/*)[1]))','VARCHAR(MAX)')) 
        <> 
        (SELECT @xml2.value('(local-name((/*)[1]))','VARCHAR(MAX)'))
    BEGIN
        RETURN 1
    END

    -- -------------------------------------------------------------
    -- Match the value of the elements
    -- -------------------------------------------------------------
    DECLARE @elValue1 VARCHAR(MAX), @elValue2 VARCHAR(MAX)
    SELECT
        @elValue1 = @xml1.value('((/*)[1])','VARCHAR(MAX)'),
        @elValue2 = @xml2.value('data((/*)[1])','VARCHAR(MAX)')
        

    IF  @elValue1 <> @elValue2
    BEGIN
        RETURN 1
    END
    
    -- -------------------------------------------------------------
    -- Match the number of attributes 
    -- -------------------------------------------------------------
    DECLARE @attCnt1 INT, @attCnt2 INT
    SELECT
        @attCnt1 = @xml1.query('count(/*/@*)').value('.','INT'),
        @attCnt2 = @xml2.query('count(/*/@*)').value('.','INT')
        
    IF  @attCnt1 <> @attCnt2 BEGIN
        RETURN 1
    END


    -- -------------------------------------------------------------
    -- Match the attributes of attributes 
    -- Here we need to run a loop over each attribute in the 
    -- first XML element and see if the same attribut exists
    -- in the second element. If the attribute exists, we
    -- need to check if the value is the same.
    -- -------------------------------------------------------------
    DECLARE @cnt INT
    DECLARE @attName VARCHAR(MAX)
    DECLARE @attValue VARCHAR(MAX)
    
    SELECT @cnt = 1
        
    WHILE @cnt <= @attCnt1 BEGIN
        SELECT @attName = NULL, @attValue = NULL
        SELECT
            @attName = @xml1.value(
                'local-name((/*/@*[sql:variable("@cnt")])[1])', 
                'varchar(MAX)'),
            @attValue = @xml1.value(
                '(/*/@*[sql:variable("@cnt")])[1]', 
                'varchar(MAX)')
        
        -- check if the attribute exists in the other XML document
        IF @xml2.exist(
                '(/*/@*[local-name()=sql:variable("@attName")])[1]'
            ) = 0
        BEGIN
            RETURN 1
        END
        
        IF  @xml2.value(
                '(/*/@*[local-name()=sql:variable("@attName")])[1]', 
                'varchar(MAX)')
            <>
            @attValue
        BEGIN
            RETURN 1
        END
        
        SELECT @cnt = @cnt + 1
    END

    -- -------------------------------------------------------------
    -- Match the number of child elements 
    -- -------------------------------------------------------------
    DECLARE @elCnt1 INT, @elCnt2 INT
    SELECT
        @elCnt1 = @xml1.query('count(/*/*)').value('.','INT'),
        @elCnt2 = @xml2.query('count(/*/*)').value('.','INT')
        

    IF  @elCnt1 <> @elCnt2
    BEGIN
        RETURN 1
    END
            
            
    -- -------------------------------------------------------------
    -- Start recursion for each child element
    -- -------------------------------------------------------------
    SELECT @cnt = 1
    DECLARE @x1 XML, @x2 XML
    WHILE @cnt <= @elCnt1 BEGIN
        SELECT 
            @x1 = @xml1.query('/*/*[sql:variable("@cnt")]'),
            @x2 = @xml2.query('/*/*[sql:variable("@cnt")]')
        
        IF dbo.CompareXml( @x1, @x2 ) = 1
        BEGIN
            RETURN 1
        END
        
        SELECT @cnt = @cnt + 1
    END
    
    RETURN @ret
END

GO
/*
Using the function

Let us test the function.
*/
DECLARE @x1 XML, @x2 XML
SELECT @x1= '
<Employees>
    <Employee FirstName="Jacob" LastName="Sebastian" />
</Employees>'

SELECT @x2= '
<Employees>
    <Employee LastName="Sebastian" FirstName="Jacob"/>
    <Employee LastName="Sebastian" FirstName="Jacob"/>
</Employees>'

SELECT dbo.CompareXml(@x1, @x2) AS Result
/*
Result
-----------
1
*/

SELECT @x1= '
<Employees>
    <Employee FirstName="Jacob" LastName="Sebastian" />
</Employees>'

SELECT @x2= '
<Employees>
    <Employee LastName="Sebastian" FirstName="Jacob"/>
</Employees>'

SELECT dbo.CompareXml(@x1, @x2) AS Result
/*
Result
-----------
0
*/

/*
What next?

The current version of the function does not work with XML instances having namespace declarations. I am trying to improve this function and trying to take care of stuff that are missing in this version. I would like to hear the following from people who use this.

    Problems you faced
    Your suggestions
    Cases where the function does not produce expected results
    Anything else that you would like to share.

*/