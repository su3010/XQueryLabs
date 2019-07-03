 /*
 XQuery Lab 25 - Writing a TSQL Function to compare two XML values (Part 1)
Sep 13 2008 5:20PM by Jacob Sebastian   

 

Many people asked me if there is a to compare two XML values in TSQL. And my answer always was "there is not support in TSQL". Comparing two XML values is not very easy. 
Some people suggest using a CHECKSUM() but that does not seem to be giving correct results. Position of attributes is not significant in XML. Hence the following two XML instances are equal.
1.
<!-- XML Instance 1 -->
2.
<Employee FirstName="Jacob" LastName="Sebastian"/>
3.
 
4.
<!-- XML Instance 2 -->
5.
<Employee LastName="Sebastian" FirstName="Jacob"/>

If you use the CHECKSUM() function, it will return different checksum values that indicate the XML values are not equal, though they contain the same information.

Let us write a TSQL Function that compares two XML values

Earlier, I used to suggest people to go with a CLR procedure/function that uses XML APIs to iterate over the XML values and do a comparison. But this morning I thought of writing a 
TSQL function that compares two XML values.

Rather than just posting the TSQL function I created, for an easy download, I would like to invite the readers of 'XQuery Lab' series to join me in the process of developing the 
TSQL function that compares XML values. Let us work together on this and move ahead in small steps. At each step, we will learn some useful XQuery stuff.

The comparison logic

Before we start writing the function, let us define the logic we will use. Let us write a recursive function to process the XML tree. Here is the logic that I thought we will use. 
If you have a better logic, let me know and we will work together on it to improve this function.
01.
/*
02.
Function CompareXML (xml1, xml2)
03.
returns 0 for equal 1 for not equal
04.
 
05.
if the name of root elements do not match
06.
return 1
07.
 
08.
if the value of root elements do not match
09.
return 1
10.
 
11.
if the count of attributes in the root elements do not match
12.
return 1       
13.
 
14.
Run a loop over each attribute in xml1
15.
if the attribute does not exist in xml2
16.
return 1
17.
 
18.
if the value does not mach
19.
return 1
20.
loop
21.
 
22.
If the count of child elements does not match
23.
return 1
24.
 
25.
Recursively call CompareXML for each child element
26.
call compareXml with a child element of xml1 and xml2
27.
if compareXml returns 1
28.
return 1
29.
else
30.
continue recursive call
31.
loop
32.
Return 0
33.
*/

XQuery operations required

Before we could actually write this function, there are a few XQuery operations that we need to learn. We could write this function only if we know how to do the following operations on an XML value:

    Find the Name of the root element (See this post)
    Find the Value of the root element (See this post)
    Find the number of attributes an element has (See this post)
    Find the name of an attribute by position (See this post)
    Find the value of an attribute by position (See this post)
    Find if a specific attribute exists or not (See this post)
    Run a loop over all the attributes of an element (See this post)
    Find the number of child elements (See this post)
    Retrieve a child element by position (See this post)
    Run a loop over all the child elements of the root element (See this post)

Go!

We have enough XQuery knowledge to write the first version of the function that compares two XML values. I have given the steps involved in writing the function as well as 
complete source code listing in the second part of this article. XQuery Lab 36 - Writing a TSQL Function to compare two XML values (Part 2)
*/