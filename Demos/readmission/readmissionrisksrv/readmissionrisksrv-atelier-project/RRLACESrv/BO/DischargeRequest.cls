Class RRLACESrv.BO.DischargeRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "RRLACESrv.BO.DischargeResponse";

Property PatientID As %String;

Property EncounterNumber As %String;

Property EndDate As %Date(FORMAT=3);

Property EndTime As %Time(FORMAT=2);

Property DischargeLocation As %String;

Storage Default
{
<Data name="DischargeRequestDefaultData">
<Subscript>"DischargeRequest"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>DischargeLocation</Value>
</Value>
</Data>
<DefaultData>DischargeRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
