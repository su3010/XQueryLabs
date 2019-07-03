/*

 XQuery Lab 2 - An example using OUTER APPLY
Jun 26 2008 1:26AM by Jacob Sebastian   

This example has an XML document with a bit complex node structure. The XML document has 3 <Pupil> elements and each of those elements has several child elements. If you have a closer look into the XML structure you could see that, not all the child elements have same number of elements. Some of them are missing certain elements. The content of those 3 <Pupil> elements are not the same.

<Pupils>
  <Pupil>
    <PupilIdentifiers>
      <PupilID>12345</PupilID>
      <Surname>BOB</Surname>
      <Forename>HOPE</Forename>
      <Gender>M</Gender>
      <DOB>1997-02-18</DOB>
    </PupilIdentifiers>
    <Attendance>
      <TermlyAttendance>
        <SessionsPossible>96</SessionsPossible>
        <SessionDetails>
          <SessionDetail>
            <AttendanceReason>I</AttendanceReason>
            <AbsenceSessions>6</AbsenceSessions>
          </SessionDetail>
          <SessionDetail>
            <AttendanceReason>M</AttendanceReason>
            <AbsenceSessions>1</AbsenceSessions>
          </SessionDetail>
        </SessionDetails>
      </TermlyAttendance>
    </Attendance>
  </Pupil>
  <Pupil>
    <PupilIdentifiers>
      <PupilID>87389373</PupilID>
      <Surname>Shaun</Surname>
      <Forename>Allcock</Forename>
      <Gender>M</Gender>
      <DOB>1997-02-18</DOB>
    </PupilIdentifiers>
    <Attendance>
      <TermlyAttendance>
        <SessionsPossible>109</SessionsPossible>
      </TermlyAttendance>
    </Attendance>
  </Pupil>
  <Pupil>
    <PupilIdentifiers>
      <PupilID>1234eqwe5</PupilID>
      <Surname>BOBBY</Surname>
      <Forename>HOPE</Forename>
      <Gender>M</Gender>
      <DOB>1997-02-18</DOB>
    </PupilIdentifiers>
    <Attendance>
      <TermlyAttendance>
        <SessionsPossible>89</SessionsPossible>
        <SessionDetails>
          <SessionDetail>
            <AttendanceReason>S</AttendanceReason>
            <AbsenceSessions>60</AbsenceSessions>
          </SessionDetail>
          <SessionDetail>
            <AttendanceReason>X</AttendanceReason>
            <AbsenceSessions>30</AbsenceSessions>
          </SessionDetail>
        </SessionDetails>
      </TermlyAttendance>
    </Attendance>
  </Pupil>
</Pupils>


The following output needs to be generated from the above XML document.

/*
UPN             Surname    Forename   SessionsPossible AttendanceReason AttendanceSessions
--------------- ---------- ---------- ---------------- ---------------- ------------------
12345           BOB        HOPE       96               I                6                 
12345           BOB        HOPE       96               M                1                 
87389373        Shaun      Allcock    109              NULL             NULL
1234eqwe5       BOBBY      HOPE       89               S                60                
1234eqwe5       BOBBY      HOPE       89               X                30      
*/

We need to generate a row for each <SessionDetail> element. That is not very hard. But the tricky part is that, the second <Pupil> element does not have a <SessionDetail> element, but still we need to display a row having Session information shown as NULL.

A query using OUTER APPLY can be written to achieve the results required in this lab.
*/
DECLARE @x XML
SELECT @x = '
<Pupils>
  <Pupil>
    <PupilIdentifiers>
      <PupilID>12345</PupilID>
      <Surname>BOB</Surname>
      <Forename>HOPE</Forename>
      <Gender>M</Gender>
      <DOB>1997-02-18</DOB>
    </PupilIdentifiers>
    <Attendance>
      <TermlyAttendance>
        <SessionsPossible>96</SessionsPossible>
        <SessionDetails>
          <SessionDetail>
            <AttendanceReason>I</AttendanceReason>
            <AbsenceSessions>6</AbsenceSessions>
          </SessionDetail>
          <SessionDetail>
            <AttendanceReason>M</AttendanceReason>
            <AbsenceSessions>1</AbsenceSessions>
          </SessionDetail>
        </SessionDetails>
      </TermlyAttendance>
    </Attendance>
  </Pupil>
  <Pupil>
    <PupilIdentifiers>
      <PupilID>87389373</PupilID>
      <Surname>Shaun</Surname>
      <Forename>Allcock</Forename>
      <Gender>M</Gender>
      <DOB>1997-02-18</DOB>
    </PupilIdentifiers>
    <Attendance>
      <TermlyAttendance>
        <SessionsPossible>109</SessionsPossible>
      </TermlyAttendance>
    </Attendance>
  </Pupil>
  <Pupil>
    <PupilIdentifiers>
      <PupilID>1234eqwe5</PupilID>
      <Surname>BOBBY</Surname>
      <Forename>HOPE</Forename>
      <Gender>M</Gender>
      <DOB>1997-02-18</DOB>
    </PupilIdentifiers>
    <Attendance>
      <TermlyAttendance>
        <SessionsPossible>89</SessionsPossible>
        <SessionDetails>
          <SessionDetail>
            <AttendanceReason>S</AttendanceReason>
            <AbsenceSessions>60</AbsenceSessions>
          </SessionDetail>
          <SessionDetail>
            <AttendanceReason>X</AttendanceReason>
            <AbsenceSessions>30</AbsenceSessions>
          </SessionDetail>
        </SessionDetails>
      </TermlyAttendance>
    </Attendance>
  </Pupil>
</Pupils>'

SELECT
    Pupil.value('PupilID[1]' ,'varchar(15)') as UPN,
    Pupil.value('Surname[1]' ,'varchar(10)') as Surname,
    Pupil.value('Forename[1]' ,'varchar(10)') as Forename,
    att.value('SessionsPossible[1]' ,'int') as SessionsPossible,
    det.value('AttendanceReason[1]' ,'varchar(5)') as AttendanceReason,
    det.value('AbsenceSessions[1]' ,'varchar(5)') as AttendanceSessions
FROM 
@x.nodes('//Pupils/Pupil/PupilIdentifiers') Pupils(Pupil)
OUTER APPLY Pupil.nodes('../Attendance/TermlyAttendance') Term(att)
OUTER APPLY att.nodes('SessionDetails/SessionDetail') Sess(det)

/*
UPN             Surname    Forename   SessionsPossible AttendanceReason AttendanceSessions
--------------- ---------- ---------- ---------------- ---------------- ------------------
12345           BOB        HOPE       96               I                6                 
12345           BOB        HOPE       96               M                1                 
87389373        Shaun      Allcock    109              NULL             NULL
1234eqwe5       BOBBY      HOPE       89               S                60                
1234eqwe5       BOBBY      HOPE       89               X                30      
*/

