Class IRISDemo.TransformerModel Extends %Persistent
{
	Property Code As %String [ Required ];
	
	Property Manufacturer As %String [ Required ];
		
	Index CodeIndex On Code [ Unique ];

Storage Default
{
<Data name="TransformerModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Manufacturer</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.TransformerModelD</DataLocation>
<DefaultData>TransformerModelDefaultData</DefaultData>
<IdLocation>^IRISDemo.TransformerModelD</IdLocation>
<IndexLocation>^IRISDemo.TransformerModelI</IndexLocation>
<StreamLocation>^IRISDemo.TransformerModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}