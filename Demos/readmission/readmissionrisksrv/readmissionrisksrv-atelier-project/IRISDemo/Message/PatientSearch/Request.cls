Class IRISDemo.Message.PatientSearch.Request extends Ens.Request
{
property PatientID as %String;
property Lastname as %String;
property Firstname as %String;
Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>Lastname</Value>
</Value>
<Value name="3">
<Value>Firstname</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}