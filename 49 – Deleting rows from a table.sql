/*
 XQuery Lab 49 – Deleting rows from a table based on the data in an XML document
Aug 26 2009 11:24AM by Jacob Sebastian   

We have seen a few examples that demonstrated how to delete elements and attributes from XML documents. In this lab, let us see how to delete rows from a table, based on the data in an XML document.
*/
DECLARE @t TABLE (id INT)
INSERT INTO @t(id) 
SELECT 1 UNION ALL 
SELECT 2 UNION ALL 
SELECT 3

SELECT * FROM @t 
/*
id
-----------
1
2
3
*/

declare @XmlData xml 
set  @XmlData = '
<PersonalInformationObject>
   <Skills>
    <SkillObject>
        <SkillId>1</SkillId>
    </SkillObject>
    <SkillObject>
        <SkillId>2</SkillId>
    </SkillObject>
    </Skills>
</PersonalInformationObject>'

DELETE t
FROM @t t
CROSS APPLY @XmlData.nodes('
    /PersonalInformationObject/Skills/SkillObject/SkillId
    [. = sql:column("id")]')
 a(x)

SELECT * FROM @t 
/*
id
-----------
3
*/

/*
Note the usage of CROSS APPLY and the way the join is established between the table and the XML document using the sql:column() function within the XQuery expression.
*/
