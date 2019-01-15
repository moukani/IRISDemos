Class RRLACESrv.BO.RiskResponse Extends Ens.Response [ ProcedureBlock ]
{

Property RiskScore As %Integer;

Property LScore As %Integer;

Property AScore As %Integer;

Property CScore As %Integer;

Property EScore As %Integer;

Storage Default
{
<Data name="RiskResponseDefaultData">
<Subscript>"RiskResponse"</Subscript>
<Value name="1">
<Value>RiskScore</Value>
</Value>
<Value name="2">
<Value>LScore</Value>
</Value>
<Value name="3">
<Value>AScore</Value>
</Value>
<Value name="4">
<Value>CScore</Value>
</Value>
<Value name="5">
<Value>EScore</Value>
</Value>
</Data>
<DefaultData>RiskResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
