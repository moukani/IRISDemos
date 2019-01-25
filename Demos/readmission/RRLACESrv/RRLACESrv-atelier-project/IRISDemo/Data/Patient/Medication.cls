Class IRISDemo.Data.Patient.Medication Extends %Persistent
{

Property DoseQuantity As %String;

Property Facility As %String;

Property FromDate As %Date(FORMAT=3);

Property FromTime As %Time(FORMAT=2);

Property Indication As %String;

Property PatientID As %String[Required];

Property ToDate As %Date(FORMAT=3);

Property ToTime As %Time(FORMAT=2);

Property DosageFormCode As %String;

Property DosageFormDescription As %String;

Property DoseUoM As %String;

Property DrugProductCode As %String;

Property DrugProductDescription As %String;

Property EnteredBy As %String;

Property RouteCode As %String;

Property RouteDescription As %String;

Property EncounterNumber As %String[Required];

Index Facility On Facility;

Index Dates On (FromDate, ToDate);

Index PatientID On PatientID;

Index DrugProductCode On DrugProductCode;

Index DrugProductDescription On DrugProductDescription;

Index EncounterNumber On EncounterNumber;

Storage Default
{
<Data name="MedicationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DoseQuantity</Value>
</Value>
<Value name="3">
<Value>Facility</Value>
</Value>
<Value name="4">
<Value>FromDate</Value>
</Value>
<Value name="5">
<Value>FromTime</Value>
</Value>
<Value name="6">
<Value>Indication</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>ToDate</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>DosageFormCode</Value>
</Value>
<Value name="11">
<Value>DosageFormDescription</Value>
</Value>
<Value name="12">
<Value>DoseUoM</Value>
</Value>
<Value name="13">
<Value>DrugProductCode</Value>
</Value>
<Value name="14">
<Value>DrugProductDescription</Value>
</Value>
<Value name="15">
<Value>EnteredBy</Value>
</Value>
<Value name="16">
<Value>RouteCode</Value>
</Value>
<Value name="17">
<Value>RouteDescription</Value>
</Value>
<Value name="18">
<Value>EncounterNumber</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.P68DC.MedicationD</DataLocation>
<DefaultData>MedicationDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.P68DC.MedicationD</IdLocation>
<IndexLocation>^IRISDemo.Data.P68DC.MedicationI</IndexLocation>
<StreamLocation>^IRISDemo.Data.P68DC.MedicationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}