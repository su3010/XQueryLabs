/*
 XQuery Lab 16 - How to modify an attribute specified by a variable?
Aug 8 2008 12:53AM by Jacob Sebastian   

 

In Lab 15, we saw how to modify an attribute based on the value of a variable. We used the value of a variable to locate the correct element. We located the element having a specific attribute with the value specified in a variable.

Now let us look at a bit more complex example. Assume a case where we don't know which attribute to modify. The attribute to be modified is passed to our code as a parameter. So we have a string parameter that stores the name of the attribute to be modified. Let us look at an example.
*/

DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee FirstName="Jacob" MiddleName="V" LastName="Sebastian"/>
</Employees>'

DECLARE @var VARCHAR(20)
DECLARE @val VARCHAR(20)

SELECT @var = 'MiddleName'
SELECT @val = 'J'

GO
/*
The task to modify the attribute specified by variable @var and replace the value with the value specified by variable @v. After we update, the attribute "MiddleName" should be replaced with value "J". Let us see the code.
*/
DECLARE @x XML
SELECT @x = '
<Employees>
  <Employee FirstName="Jacob" MiddleName="V" LastName="Sebastian"/>
</Employees>'

DECLARE @var VARCHAR(20)
DECLARE @val VARCHAR(20)

SELECT @var = 'MiddleName'
SELECT @val = 'J'


SET @x.modify('
    replace value of (
        /Employees/Employee/@*[local-name()=sql:variable("@var")]
    )[1]
    with sql:variable("@val")
')

select @x

/*
<Employees>
  <Employee FirstName="Jacob" MiddleName="J" LastName="Sebastian" />
</Employees>
*/


