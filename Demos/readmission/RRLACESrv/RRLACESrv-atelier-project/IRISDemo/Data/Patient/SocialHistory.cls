Class IRISDemo.Data.Patient.SocialHistory Extends %Persistent
{
Property Facility As %String;

Property FromDate As %Date(FORMAT=3);

Property FromTime As %Time(FORMAT=2);

Property PatientID As %String[Required];

Property SocialHabitCategory As %String;

Property Status As %String;

Property ToDate As %Date(FORMAT=3);

Property ToTime As %Time(FORMAT=2);

Property EnteredBy As %String;

Property SocialHabitCode As %String;

Property SocialHabitDescription As %String;

Property Quantity As %String;

Property EncounterNumber As %String[Required];

Index Facility On Facility;

Index Dates On (FromDate, ToDate);

Index PatientID On PatientID;

Index SocialHabitCode On SocialHabitCode;
Storage Default
{
<Data name="SocialHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Facility</Value>
</Value>
<Value name="3">
<Value>FromDate</Value>
</Value>
<Value name="4">
<Value>FromTime</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>SocialHabitCategory</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>ToDate</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>EnteredBy</Value>
</Value>
<Value name="11">
<Value>SocialHabitCode</Value>
</Value>
<Value name="12">
<Value>SocialHabitDescription</Value>
</Value>
<Value name="13">
<Value>Quantity</Value>
</Value>
<Value name="14">
<Value>EncounterNumber</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Dat68DC.SocialHistoryD</DataLocation>
<DefaultData>SocialHistoryDefaultData</DefaultData>
<IdLocation>^IRISDemo.Dat68DC.SocialHistoryD</IdLocation>
<IndexLocation>^IRISDemo.Dat68DC.SocialHistoryI</IndexLocation>
<StreamLocation>^IRISDemo.Dat68DC.SocialHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}