Class IRISDemo.Data.Patient.Diagnosis Extends %Persistent
{

Property OnsetDate As %Date(FORMAT=3);

Property PatientID As %String[Required];

Property ToDate As %Date(FORMAT=3);

Property Code As %String;

Property Description As %String(MAXLEN = "");

Property EnteredBy As %String;

Property Status As %String;

Property EncounterNumber As %String[Required];

Property ComorbidityID As %Integer;

Property CategoryCode As %String;

Property CategoryDescription As %String;

Property CodingStandard As %String;

Index OnsetDate On OnsetDate;

Index PatientID On PatientID;

Index Code On Code;

Index EncounterNumber On EncounterNumber;

Storage Default
{
<Data name="DiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiagnosisDate</Value>
</Value>
<Value name="3">
<Value>Facility</Value>
</Value>
<Value name="4">
<Value>OnsetDate</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>ToDate</Value>
</Value>
<Value name="7">
<Value>Code</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
<Value name="9">
<Value>EnteredBy</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>EncounterNumber</Value>
</Value>
<Value name="12">
<Value>ComorbidityID</Value>
</Value>
<Value name="13">
<Value>CategoryCode</Value>
</Value>
<Value name="14">
<Value>CategoryDescription</Value>
</Value>
<Value name="15">
<Value>CodingStandard</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.Pa68DC.DiagnosisD</DataLocation>
<DefaultData>DiagnosisDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.Pa68DC.DiagnosisD</IdLocation>
<IndexLocation>^IRISDemo.Data.Pa68DC.DiagnosisI</IndexLocation>
<StreamLocation>^IRISDemo.Data.Pa68DC.DiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}