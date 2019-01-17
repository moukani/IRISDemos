Class IRISDemo.Data.Patient.Demographics Extends %Persistent
{

Property DoB As %Date(FORMAT = 3);

Property PatientID As %String [ Required ];

Property PostalCode As %String;

Property Gender As %String;

Property MaritalStatus As %String;

Property DoD As %Date(FORMAT = 3);

Property IsDead As %Boolean [ InitialExpression = 0 ];

Property Firstname As %String;

Property Lastname As %String;

Index PatientIDIndex On PatientID [ Unique ];

Index Name On (Lastname, Firstname, Gender);

Storage Default
{
<Data name="DemographicsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DoB</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>PostalCode</Value>
</Value>
<Value name="5">
<Value>Gender</Value>
</Value>
<Value name="6">
<Value>MaritalStatus</Value>
</Value>
<Value name="7">
<Value>DoD</Value>
</Value>
<Value name="8">
<Value>IsDead</Value>
</Value>
<Value name="9">
<Value>Firstname</Value>
</Value>
<Value name="10">
<Value>Lastname</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data68DC.DemographicsD</DataLocation>
<DefaultData>DemographicsDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data68DC.DemographicsD</IdLocation>
<IndexLocation>^IRISDemo.Data68DC.DemographicsI</IndexLocation>
<StreamLocation>^IRISDemo.Data68DC.DemographicsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
