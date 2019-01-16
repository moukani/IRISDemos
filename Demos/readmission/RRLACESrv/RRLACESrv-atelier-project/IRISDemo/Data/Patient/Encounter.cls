Class IRISDemo.Data.Patient.Encounter Extends (%Persistent, %XML.Adaptor)
{

Property EncounterType As %String;

Property EndDate As %Date(FORMAT = 3);

Property EndTime As %Time(FORMAT = 2);

Property PatientID As %String [ Required ];

Property StartDate As %Date(FORMAT = 3) [ Required ];

Property StartTime As %Time(FORMAT = 2);

Property AdmissionSource As %String;

Property AdmitReason As %String;

Property DischargeLocation As %String;

Property EncounterNumber As %String [ Required ];

Property LOS As %Integer;

Index Dates On (StartDate, EndDate);

Index PatientID On PatientID;

Index EncounterNumber On EncounterNumber;

Storage Default
{
<Data name="EncounterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EncounterType</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>FromDate</Value>
</Value>
<Value name="6">
<Value>FromTime</Value>
</Value>
<Value name="7">
<Value>Facility</Value>
</Value>
<Value name="8">
<Value>PatientID</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>StartTime</Value>
</Value>
<Value name="11">
<Value>AdmissionSource</Value>
</Value>
<Value name="12">
<Value>AdmitReason</Value>
</Value>
<Value name="13">
<Value>DischargeLocation</Value>
</Value>
<Value name="14">
<Value>EnteredBy</Value>
</Value>
<Value name="15">
<Value>Priority</Value>
</Value>
<Value name="16">
<Value>EncounterNumber</Value>
</Value>
<Value name="17">
<Value>LOS</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.Pa68DC.EncounterD</DataLocation>
<DefaultData>EncounterDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.Pa68DC.EncounterD</IdLocation>
<IndexLocation>^IRISDemo.Data.Pa68DC.EncounterI</IndexLocation>
<StreamLocation>^IRISDemo.Data.Pa68DC.EncounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
