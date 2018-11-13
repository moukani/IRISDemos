Class IRISDemo.Transformer Extends %Persistent
{
	Property Code As %String [ Required ];
	
	Property Model As TransformerModel [ Required ];
	
	ForeignKey ModelFK(Model) References TransformerModel();
	
	Index CodeIndex On Code [ Unique ];
	
	/// "bulgin" on text file
	Property IsThereBulging As %Boolean;
	
Storage Default
{
<Data name="TransformerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Model</Value>
</Value>
<Value name="4">
<Value>IsThereBulging</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.TransformerD</DataLocation>
<DefaultData>TransformerDefaultData</DefaultData>
<IdLocation>^IRISDemo.TransformerD</IdLocation>
<IndexLocation>^IRISDemo.TransformerI</IndexLocation>
<StreamLocation>^IRISDemo.TransformerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}