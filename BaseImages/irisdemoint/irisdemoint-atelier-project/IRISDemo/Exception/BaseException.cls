Class IRISDemo.Exception.BaseException Extends (%SerialObject, %XML.Adaptor)
{
	Property Name As %String;
	
	Property Code As %String;
	
	Property Location As %String (MAXLEN="");
	
	Property Data As %String (MAXLEN="");

	Method AsDynamicObject()
	{
		Set o={}
		Set o.Exception={}
		Set o.Exception.Name=..Name
		Set o.Exception.Code=..Code
		Set o.Exception.Location=$System_" => "_..Location
		Set o.Exception.Data=..Data
		
		Quit o		
	}
	
	Method AsSOAPFault() As %SOAP.Fault
	{
		Set fault = ##class(%SOAP.WebService).MakeFault(..Name, ..Code, ..Data, $System_" => "_..Location)
		
		Quit fault
	}
	
Storage Default
{
<Data name="BaseExceptionState">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Location</Value>
</Value>
<Value name="4">
<Value>Data</Value>
</Value>
</Data>
<State>BaseExceptionState</State>
<StreamLocation>^IRISDemo.Exc41C1.BaseExceptionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}