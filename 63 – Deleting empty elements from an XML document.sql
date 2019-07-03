/*
XQuery Lab 63 – Deleting empty elements from an XML document
Dec 14 2010 5:04PM by Jacob Sebastian   

I saw this question on the forum today and after writing an example that demonstrates this, I thought of including it as part of the XQuery Labs.

Here is the sample XML we need to process.
*/
/*
<userdata pageid="page9" annotationSetId="80">
    <notes />
    <notes>
      <note id="332E7A17-3E57-3540-CC28-DFA1C68A7802" 
		x1="297.25" x2="297.25" y1="447.85" y2="447.85" 
		lastModified="2010-12-13T12:08:32Z" type="mynotes">
      </note>
    </notes>
    <notes />
    <notes />
    <page_hotspots />
  </userdata>

*/
/*
The task is to delete all notes elements that are empty and produce the following output.
*/
/*
<userdata pageid="page9" annotationSetId="80">
  <notes>
    <note id="332E7A17-3E57-3540-CC28-DFA1C68A7802" 
		x1="297.25" x2="297.25" y1="447.85" y2="447.85" 
		lastModified="2010-12-13T12:08:32Z" type="mynotes" />
  </notes>
  <page_hotspots />
</userdata>
*/

/*
Here is the TSQL code that deletes the empty elements using an XQuery expression. 
*/


DECLARE @x XML
SELECT @x = '
<userdata pageid="page9" annotationSetId="80">
    <notes />
    <notes>
      <note id="332E7A17-3E57-3540-CC28-DFA1C68A7802" 
		x1="297.25" x2="297.25" y1="447.85" y2="447.85" 
		lastModified="2010-12-13T12:08:32Z" type="mynotes">
      </note>
    </notes>
    <notes />
    <notes />
    <page_hotspots />
  </userdata>'

SET @x.modify('
	delete /userdata/notes[empty(./*)]
')

SELECT @x
GO
/*
<userdata pageid="page9" annotationSetId="80">
  <notes>
    <note id="332E7A17-3E57-3540-CC28-DFA1C68A7802" 
		x1="297.25" x2="297.25" y1="447.85" y2="447.85" 
		lastModified="2010-12-13T12:08:32Z" type="mynotes" />
  </notes>
  <page_hotspots />
</userdata>
*/
