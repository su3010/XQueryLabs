/*
 XQuery Lab 15 - How to locate and modify an attribute using a variable?
Aug 7 2008 12:49AM by Jacob Sebastian   

 

Earlier in XQuery lab, we have seen how to modify the value of an attribute. So it is easy when we know which element to update and which attribute to modify. Let us look at a slightly different example. Assume that we need to modify a given attribute of a node. We need to identify the correct node based on the value of another attribute. The value of this attribute is passed as a parameter and we need to locate a node that has an attribute with a specific value stored in the variable. Let us look at an example.
*/
DECLARE @x XML
SELECT @x = '
<Root> 
  <Variables> 
    <Variable VariableName="V1" Value="1" /> 
    <Variable VariableName="V2" Value="2" /> 
    <Variable VariableName="V3" Value="3" /> 
  </Variables> 
</Root>'

DECLARE @var VARCHAR(20)
DECLARE @val VARCHAR(20)

SELECT @var = 'V3'
SELECT @val = '6'
GO
/*
The variable @var contains value "V3". We need to locate the XML node which is having value "V3" in the "VariableName" attribute and update the value of the "Value" attribute with the value specified by variable "@val". This should update the 3rd row and replace the value of "value" attribute to "6". Let us see the code that demonstrates this.
*/
DECLARE @x XML
SELECT @x = '
<Root> 
  <Variables> 
    <Variable VariableName="V1" Value="1" /> 
    <Variable VariableName="V2" Value="2" /> 
    <Variable VariableName="V3" Value="3" /> 
  </Variables> 
</Root>'

DECLARE @var VARCHAR(20)
DECLARE @val VARCHAR(20)

SELECT @var = 'V3'
SELECT @val = '6'


SET @x.modify('
    replace value of (
        /Root/Variables/Variable[@VariableName=sql:variable("@var")]/@Value
    )[1]
    with sql:variable("@val")
')

SELECT @x

/*
<Root>
  <Variables>
    <Variable VariableName="V1" Value="1" />
    <Variable VariableName="V2" Value="2" />
    <Variable VariableName="V3" Value="6" />
  </Variables>
</Root>
*/

GO
/*
The example we saw above used an XML variable. Let us now see how to perform the same operation in an XML column.
*/
DECLARE @t TABLE (data XML)
INSERT INTO @t (data) SELECT '
<Root> 
  <Variables> 
    <Variable VariableName="V1" Value="1" /> 
    <Variable VariableName="V2" Value="2" /> 
    <Variable VariableName="V3" Value="3" /> 
  </Variables> 
</Root>'

DECLARE @var VARCHAR(20)
DECLARE @val VARCHAR(20)

SELECT @var = 'V3'
SELECT @val = '6'

UPDATE @t 
SET data.modify('
    replace value of (/Root/Variables/Variable[@VariableName=sql:variable("@var")]/@Value)[1]
    with sql:variable("@val")
')

SELECT * FROM @t

/*
<Root>
  <Variables>
    <Variable VariableName="V1" Value="1" />
    <Variable VariableName="V2" Value="2" />
    <Variable VariableName="V3" Value="6" />
  </Variables>
</Root>
*/

