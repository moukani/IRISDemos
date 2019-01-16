Class IRISDemo.Message.EmailRequest Extends Ens.Request
{

Property From As %String;

Property To As %String;

Property Subject As %String;

Property MessageText As %String(MAXLEN = "");

Storage Default
{
<Data name="EmailRequestDefaultData">
<Subscript>"EmailRequest"</Subscript>
<Value name="1">
<Value>From</Value>
</Value>
<Value name="2">
<Value>To</Value>
</Value>
<Value name="3">
<Value>Subject</Value>
</Value>
<Value name="4">
<Value>MessageText</Value>
</Value>
</Data>
<DefaultData>EmailRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
