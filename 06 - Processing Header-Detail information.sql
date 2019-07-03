/*
 XQuery Lab 6 - Processing Header-Detail information
Jul 11 2008 2:37PM by Jacob Sebastian   

I came across a post in the MSDN SQL Server XML forum asking for some sample code that reads information from the XML instance and inserts it into two tables. At first glance, the request looked simple. But then I realized, that while inserting the information to the tables, I need to establish a relationship between the rows.

Here is the XML instance that we need to process.

<Member>
  <MemHeader>
    <SrcCode>B</SrcCode>
    <EID>100000</EID>
    <MemID>HSG-200</MemID>
  </MemHeader>
  <AttributeList>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>First</AttributeName>
      <Currentvalue>Lee</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Middle</AttributeName>
      <Currentvalue>Marvin</Currentvalue>
    </Item>
    <Item>
      <Groupname>Name</Groupname>
      <AttributeName>Last</AttributeName>
      <Currentvalue>Bruised</Currentvalue>
    </Item>
  </AttributeList>
</Member>
<Member>
  <MemHeader>
    <SrcCode>C</SrcCode>
    <EID>120202</EID>
    <MemID>CTX-300</MemID>
  </MemHeader>
  <AttributeList>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>First</AttributeName>
      <Currentvalue>Barry</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Middle</AttributeName>
      <Currentvalue>M</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Last</AttributeName>
      <Currentvalue>Humphries</Currentvalue>
    </Item>
    <Item>
      <Groupname>ADDRESS</Groupname>
      <AttributeName>Line1</AttributeName>
      <Currentvalue>40 Fore Street</Currentvalue>
    </Item>
  </AttributeList>
</Member>


The XML document contains HEADER and DETAIL information. HEADER part of the information should go to a parent table. Then the DETAIL part of the information should go to a child table. The PRIMARY key of the parent table should be updated in the CHILD table to establish a correct PKEY-FKEY relationship.

So we need to insert the header information to the header table first, and then insert the information to the detail table. When inserting information to the detail table, we need to find a way to link to the parent table, so that we can insert the Primary Key of the parent table to the child table.

The header element (MemHeader) in the XML document does not have a unique ID. If we are optimistic and assume that we could make each header element unique by combining SrcCode, EID and MemID elements, then the process will be easy. Here is a piece of sample code that performs the requested operation based on the above assumption.
*/
DECLARE @x XML
SELECT @x = '
<Member>
  <MemHeader>
    <SrcCode>B</SrcCode>
    <EID>100000</EID>
    <MemID>HSG-200</MemID>
  </MemHeader>
  <AttributeList>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>First</AttributeName>
      <Currentvalue>Lee</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Middle</AttributeName>
      <Currentvalue>Marvin</Currentvalue>
    </Item>
    <Item>
      <Groupname>Name</Groupname>
      <AttributeName>Last</AttributeName>
      <Currentvalue>Bruised</Currentvalue>
    </Item>
  </AttributeList>
</Member>
<Member>
  <MemHeader>
    <SrcCode>C</SrcCode>
    <EID>120202</EID>
    <MemID>CTX-300</MemID>
  </MemHeader>
  <AttributeList>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>First</AttributeName>
      <Currentvalue>Barry</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Middle</AttributeName>
      <Currentvalue>M</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Last</AttributeName>
      <Currentvalue>Humphries</Currentvalue>
    </Item>
    <Item>
      <Groupname>ADDRESS</Groupname>
      <AttributeName>Line1</AttributeName>
      <Currentvalue>40 Fore Street</Currentvalue>
    </Item>
  </AttributeList>
</Member>'

-- header table
DECLARE @MemberHeader TABLE (
    MemHeaderID INT IDENTITY, -- primary key
    srcCode VARCHAR(20),
    EID VARCHAR(20),
    MemID VARCHAR(20) )

-- detail table
DECLARE @AttributeList TABLE (
    AttListID INT IDENTITY, -- primary key
    MemHeaderID INT,        -- foreign key
    GroupName VARCHAR(20),
    AttributeName VARCHAR(20), 
    CurrentValue VARCHAR(20) )

-- insert into header 
INSERT INTO @MemberHeader( srcCode, Eid, MemID )
SELECT
    x.value('SrcCode[1]','VARCHAR(20)'),
    x.value('EID[1]','VARCHAR(20)'),
    x.value('MemID[1]','VARCHAR(20)')
FROM @x.nodes('/Member/MemHeader') mh(x)    
    
-- insert into details
INSERT INTO @AttributeList( MemHeaderID, GroupName, AttributeName, CurrentValue )
SELECT
    h.MemHeaderID,
    d.GroupName,
    d.AttributeName,
    d.CurrentValue
FROM (
    SELECT
        h.value('(MemHeader/SrcCode)[1]','VARCHAR(20)') SrcCode,
        h.value('(MemHeader/EID)[1]','VARCHAR(20)') Eid,
        h.value('(MemHeader/MemID)[1]','VARCHAR(20)') MemID,
        d.value('Groupname[1]','VARCHAR(20)') AS GroupName,
        d.value('AttributeName[1]','VARCHAR(20)') AS AttributeName,
        d.value('Currentvalue[1]','VARCHAR(20)') AS CurrentValue
    FROM @x.nodes('/Member') mh(h)
    CROSS APPLY h.nodes('AttributeList/Item') al(d)
) d
INNER JOIN @MemberHeader h ON 
    h.srcCode = d.srcCode
    AND h.Eid = d.Eid
    AND h.MemID = d.MemID

-- test the value
SELECT * FROM @MemberHeader
/*
MemHeaderID srcCode              EID                  MemID
----------- -------------------- -------------------- --------------------
1           B                    100000               HSG-200             
2           C                    120202               CTX-300   
*/

SELECT * FROM @AttributeList
/*
AttListID   MemHeaderID GroupName            AttributeName        CurrentValue
----------- ----------- -------------------- -------------------- --------------------
1           1           NAME                 First                Lee                 
2           1           NAME                 Middle               Marvin              
3           1           Name                 Last                 Bruised             
4           2           NAME                 First                Barry               
5           2           NAME                 Middle               M                   
6           2           NAME                 Last                 Humphries           
7           2           ADDRESS              Line1                40 Fore Street      
*/

/*
However, it could happen that the combination of SrcCode, EID and MemID is not unique. If that is the case, the above code will not work. We will get incorrect results if that is the case. What is the next best option?

One way to handle this is to run a loop over the Header element and insert each element (header and details) one by one. Writing a loop over the XML elements is pretty easy. I have explained it in XML Workshop XVII - Writing a LOOP to process XML elements in TSQL at www.sqlservercentral.com. So the next approach we will take would involve the following.

    run a loop over all the <member> elements
        For each element
            Insert the information to header table
            Take the value of the new identity key inserted to server by calling SCOPE_IDENTITY()
            Insert the value to the detail table (along with the primary key of the server
        next element
    end loop

Let us see how the code looks like.
*/
GO
DECLARE @x XML
SELECT @x = '
<Member>
  <MemHeader>
    <SrcCode>B</SrcCode>
    <EID>100000</EID>
    <MemID>HSG-200</MemID>
  </MemHeader>
  <AttributeList>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>First</AttributeName>
      <Currentvalue>Lee</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Middle</AttributeName>
      <Currentvalue>Marvin</Currentvalue>
    </Item>
    <Item>
      <Groupname>Name</Groupname>
      <AttributeName>Last</AttributeName>
      <Currentvalue>Bruised</Currentvalue>
    </Item>
  </AttributeList>
</Member>
<Member>
  <MemHeader>
    <SrcCode>C</SrcCode>
    <EID>120202</EID>
    <MemID>CTX-300</MemID>
  </MemHeader>
  <AttributeList>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>First</AttributeName>
      <Currentvalue>Barry</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Middle</AttributeName>
      <Currentvalue>M</Currentvalue>
    </Item>
    <Item>
      <Groupname>NAME</Groupname>
      <AttributeName>Last</AttributeName>
      <Currentvalue>Humphries</Currentvalue>
    </Item>
    <Item>
      <Groupname>ADDRESS</Groupname>
      <AttributeName>Line1</AttributeName>
      <Currentvalue>40 Fore Street</Currentvalue>
    </Item>
  </AttributeList>
</Member>'

DECLARE @MemberHeader TABLE (
    MemHeaderID INT IDENTITY, -- primary key
    srcCode VARCHAR(20),
    EID VARCHAR(20),
    MemID VARCHAR(20) )

DECLARE @AttributeList TABLE (
    AttListID INT IDENTITY, -- primary key
    MemHeaderID INT,        -- foreign key
    GroupName VARCHAR(20),
    AttributeName VARCHAR(20), 
    CurrentValue VARCHAR(20) )
    
DECLARE @cnt INT, @max INT, @MemHeaderID INT
SELECT @cnt = 1
SELECT @max = @x.query('<e>
                            { count(/Member) }
                        </e>'
                       ).value('e[1]','int') 

WHILE @cnt <= @max BEGIN
    -- insert Header
    INSERT INTO @MemberHeader( srcCode, Eid, MemID )
    SELECT
        x.value('(MemHeader/SrcCode)[1]','VARCHAR(20)'),
        x.value('(MemHeader/EID)[1]','VARCHAR(20)'),
        x.value('(MemHeader/MemID)[1]','VARCHAR(20)')
    FROM @x.nodes('/Member[position()=sql:variable("@cnt")]') mh(x)    
    SELECT @MemHeaderID = SCOPE_IDENTITY()
    
    -- insert Details
    INSERT INTO @AttributeList( MemHeaderID, GroupName, AttributeName, CurrentValue )
    SELECT
        @MemHeaderID,
        d.value('Groupname[1]','VARCHAR(20)'),
        d.value('AttributeName[1]','VARCHAR(20)'),
        d.value('Currentvalue[1]','VARCHAR(20)')
    FROM @x.nodes('/Member[position()=sql:variable("@cnt")]') mh(x)
    CROSS APPLY x.nodes('AttributeList/Item') al(d)    
    
    SELECT @cnt = @cnt + 1
END

-- test the values

SELECT * FROM @MemberHeader
/*
MemHeaderID srcCode              EID                  MemID
----------- -------------------- -------------------- --------------------
1           B                    100000               HSG-200             
2           C                    120202               CTX-300   
*/

SELECT * FROM @AttributeList
/*
AttListID   MemHeaderID GroupName            AttributeName        CurrentValue
----------- ----------- -------------------- -------------------- --------------------
1           1           NAME                 First                Lee                 
2           1           NAME                 Middle               Marvin              
3           1           Name                 Last                 Bruised             
4           2           NAME                 First                Barry               
5           2           NAME                 Middle               M                   
6           2           NAME                 Last                 Humphries           
7           2           ADDRESS              Line1                40 Fore Street      
*/

