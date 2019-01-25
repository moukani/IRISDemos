Class IRISDemo.Data.Patient.Observation Extends %Persistent
{

Property Facility As %String;

Property ObservationDate As %Date(FORMAT=3);

Property ObservationTime As %Time(FORMAT=2);

Property ObservationValue As %String;

Property PatientID As %String;

Property EnteredBy As %String;

Property ObservationCode As %String;

Property ObservationDescription As %String(MAXLEN = "");

Property Units As %String;

Property EncounterNumber As %String;

Index Facility On Facility;

Index ObservationDate On ObservationDate;

Index PatientID On PatientID;

Index ObservationCode On ObservationCode;

Index EncounterNumber On EncounterNumber;
Storage Default
{
<Data name="ObservationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Facility</Value>
</Value>
<Value name="3">
<Value>ObservationDate</Value>
</Value>
<Value name="4">
<Value>ObservationTime</Value>
</Value>
<Value name="5">
<Value>ObservationValue</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>EnteredBy</Value>
</Value>
<Value name="8">
<Value>ObservationCode</Value>
</Value>
<Value name="9">
<Value>ObservationDescription</Value>
</Value>
<Value name="10">
<Value>Units</Value>
</Value>
<Value name="11">
<Value>EncounterNumber</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data68DC.ObservationD</DataLocation>
<DefaultData>ObservationDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data68DC.ObservationD</IdLocation>
<IndexLocation>^IRISDemo.Data68DC.ObservationI</IndexLocation>
<StreamLocation>^IRISDemo.Data68DC.ObservationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}