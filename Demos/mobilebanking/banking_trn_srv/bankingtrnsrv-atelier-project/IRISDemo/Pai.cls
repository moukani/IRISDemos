Class IRISDemo.Pai Extends %Persistent
{
	Property Son As IRISDemo.Son;
	
Storage Default
{
<Data name="PaiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Son</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.PaiD</DataLocation>
<DefaultData>PaiDefaultData</DefaultData>
<IdLocation>^IRISDemo.PaiD</IdLocation>
<IndexLocation>^IRISDemo.PaiI</IndexLocation>
<StreamLocation>^IRISDemo.PaiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}