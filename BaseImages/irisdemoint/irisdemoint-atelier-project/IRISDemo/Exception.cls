Class IRISDemo.Exception Extends (%SerialObject, %XML.Adaptor)
{
	Property Name As %String;
	
	Property Code As %String;
	
	Property Location As %String (MAXLEN="");
	
	Property Data As %String (MAXLEN="");
	
	ClassMethod CreateFromException(pException As %Exception.AbstractException) As IRISDemo.Exception
	{
		Set e = ..%New()
		Set e.Name = pException.Name
		Set e.Code = pException.Code
		Set e.Location = pException.Location
		Set e.Data = pException.Data
		
		Quit e
	}

	Method AsDynamicObject()
	{
		Set o={}
		Set o.Exception={}
		Set o.Exception.Name=..Name
		Set o.Exception.Code=..Code
		Set o.Exception.Location=..Location
		Set o.Exception.Data=..Data
		
		Quit o		
	}
	
	Method AsSOAPFault() As %SOAP.Fault
	{
		Set fault = ##class(%SOAP.WebService).MakeFault(..Name, ..Code, ..Location_" - "_..Data)
		
		Quit fault
	}
	
Storage Default
{
<Data name="ExceptionState">
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
<State>ExceptionState</State>
<StreamLocation>^IRISDemo.ExceptionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}