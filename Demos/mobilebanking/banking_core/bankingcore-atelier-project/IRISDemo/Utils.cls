Class IRISDemo.Utils
{
	/// This method is called on the include macro DEMOMACROS.inc by the macro of the same name
	/// The macro is used in two scenarios:
	/// 1- When we call a SOAP Business Operation. It can transform a SOAP Fault into a Status code and 
	///    we may been to throw it as an exception when we are using Try/Catch error handling style. In 
	///    this scenario, the exception's name will be set with the SOAP Fault's faultcode attribute.
	///
	/// 2- When we need to raise a new exception with a Status code received from a method call
	///    that has nothing to do with SOAP. In this scenario, pExceptionName can be used to enrich
	///    the created exception with a more meaningful name.  
	ClassMethod TrowStatusExceptionIfError(pSC As %Status, pExceptionName As %String)
	{
		If $System.Status.IsError(pSC) 
		{
			//Just in case this Status String came from another system and includes SOAP details
			Set tSOAPFaultString=$Piece($Piece($System.Status.GetErrorText(pSC),"faultstring=",2),$C(13)) 
			Set tSOAPFaultActor=$Piece($Piece($System.Status.GetErrorText(pSC),"faultactor=",2),$C(13)) 
			
			//Let's create a simple status exception first
			Set statusException = ##class(%Exception.StatusException).CreateFromStatus(pSC) 
			
			//
			If tSOAPFaultString="" 
			{ 
				If $Get(pExceptionName)'="" Set statusException.Name=pExceptionName 
				//Location is already set by CreateFromStatus
				Set e=statusException
			} 
			Else 
			{
				//If the developer hasn't given us a pExceptionName, I want an UNDEFINED to be raised
				Set statusException.Name=tSOAPFaultString //Original error on the other system is better
				Set statusException.Location=tSOAPFaultActor //Location on the other system is better
				Set e = ##class(%Exception.General).%New(pExceptionName,pExceptionName,,, statusException)
			}	
			
			Throw e
		}
	}
	
	/// This method is called on the include macro DEMOMACROS.inc by the macro of the same name
	/// It must be used only inside a SOAP service to report a SOAP Fault based on an exception that
	/// was captured by a Try/Catch block
	ClassMethod SOAPFaultWithException(pException As %Exception.AbstractException)
	{
		If pException.%ClassName()="StatusException"	
		{ 
			Set f = ##class(%SOAP.WebService).MakeStatusFault(pException.Code, pException.Name, pException.AsStatus(), $System) 
		} 
		Else 
		{ 
			Set f = ##class(%SOAP.WebService).MakeFault(pException.Code, pException.Name, "", $System)	
		} 
		
		Do ##class(%SOAP.WebService).ReturnFault(f)
	}
	
	/// This will convert
	ClassMethod ExceptionAsJSON(pException As %Exception.AbstractException) As %Library.DynamicObject
	{
		Set o={}
		Set o.Exception={}
		Set o.Exception.Name=pException.Name
		Set o.Exception.Code=pException.Code
		Set o.Exception.Location=pException.Location
		Set o.Exception.Data=pException.Data
		
		Quit o
	}

}