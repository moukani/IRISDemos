Class IRISDemo.Message.PatientSearch.Response extends Ens.Response
{
property SearchResult as %Stream.GlobalCharacter;
Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>Stream</Value>
</Value>
<Value name="2">
<Value>SearchResult</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}