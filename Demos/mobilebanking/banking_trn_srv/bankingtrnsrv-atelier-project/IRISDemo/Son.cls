Class IRISDemo.Son Extends %SerialObject
{
	Property A As %String;
	
	Property B As %String [ ReadOnly ];
	
	Method BGet() As %String [ Internal, ServerOnly = 1 ]
	{
		Quit "hahaha"
	}
	
Storage Default
{
<Data name="SonState">
<Value name="1">
<Value>A</Value>
</Value>
<Value name="2">
<Value>B</Value>
</Value>
</Data>
<State>SonState</State>
<StreamLocation>^IRISDemo.SonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}