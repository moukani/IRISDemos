Include Ensemble

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
ClassMethod ThrowStatusExceptionIfError(pSC As %Status, pExceptionName As %String, pSessionId As %String = "")
{
		If $System.Status.IsError(pSC) 
		{
			If pSessionId'=""
			{
				Set tSessionId="("_pSessionId_")"
			}
			Else
			{
				Set tSessionId=""
			}
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
				If statusException.Location=""
				{
					Set statusException.Location=$System_tSessionId_" => Unknown"
				}
				ElseIf statusException.Location'[" => "
				{
					Set statusException.Location=$System_tSessionId_" => "_statusException.Location
				}
				Set e=statusException
			} 
			Else 
			{
				//If the developer hasn't given us a pExceptionName, I want an UNDEFINED to be raised
				Set statusException.Name=tSOAPFaultString //Original error on the other system is better
				Set statusException.Location=$System_tSessionId_" => "_tSOAPFaultActor //$System from the other system is better
				Set e = ##class(%Exception.General).%New(pExceptionName,pExceptionName,,, statusException)
			}	
			
			Throw e
		}
}

/// This method is called on the include macro DEMOMACROS.inc by the macro of the same name
/// It must be used only inside a SOAP service to report a SOAP Fault based on an exception that
/// was captured by a Try/Catch block
ClassMethod SOAPFaultWithException(pException As %Exception.AbstractException, pSessionId As %String = "")
{
		If pSessionId'=""
		{
			Set tSessionId="("_pSessionId_")"
		}
		Else
		{
			Set tSessionId=""
		}
		
		Set tLocation = pException.Location
		If tLocation = ""
		{
			Set tLocation = $System_tSessionId
		}
		
		If pException.%ClassName()="StatusException"	
		{ 
			Set f = ##class(%SOAP.WebService).MakeStatusFault(pException.Code, pException.Name, pException.AsStatus(), tLocation) 
		} 
		Else 
		{ 
			Set f = ##class(%SOAP.WebService).MakeFault(pException.Code, pException.Name, "", tLocation)	
		} 
		
		Do ##class(%SOAP.WebService).ReturnFault(f)
}

/// This will convert
ClassMethod ExceptionAsJSON(pException As %Exception.AbstractException, pSessionId As %String = "") As %Library.DynamicObject
{
		If pSessionId'=""
		{
			Set tSessionId="("_pSessionId_")"
		}
		Else
		{
			Set tSessionId=""
		}

		Set o={}
		Set o.Name=pException.Name
		Set o.Code=pException.Code
		Set o.Location=pException.Location
		If o.Location=""
		{
			Set o.Location=$System_tSessionId
		}
		ElseIf o.Location'[" => "
		{
			Set o.Location=$System_tSessionId_" => "_o.Location
		}
		
		If pException.Data'=""
		{
			Set o.Data=pException.Data
		}
		
		If pException.InnerException'=""
		{
			Set o.InnerException=..ExceptionAsJSON(pException.InnerException)
		}
		
		Quit o
}

ClassMethod IndexProductionItems() As %Status
{
		Set tSC = $System.Status.OK()
		Try
		{
			Lock ^IRIS.Temp.IRISDemoIndex
			Kill ^IRIS.Temp.IRISDemoIndex
			
			Set tConfigItem=""
			For
			{
				Set tConfigItem=$Order($$$EnsRuntime("ConfigItem", tConfigItem))
				Quit:tConfigItem=""
				
				Set tClassName=$Get($$$EnsRuntime("ConfigItem", tConfigItem, "ClassName"))
				Set tBusinessType=$Get($$$EnsRuntime("ConfigItem", tConfigItem, "BusinessType"))
				
				Continue:tBusinessType'=1 //Business Services

				Set ^IRIS.Temp.IRISDemoIndex("BS",tClassName)=tConfigItem
			}	
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}

		Lock -^IRIS.Temp.IRISDemoIndex

		Quit tSC
}

ClassMethod GetBusinessServiceConfigItemName(pClassName As %String, Output pConfigItemName As %String) As %Status
{
		Set tSC = $System.Status.OK()
		Try
		{
			If '$Data(^IRIS.Temp.IRISDemoIndex)
			{
				Set tSC = ..IndexProductionItems()
				Quit:$$$ISERR(tSC)
			}
			
			Lock ^IRIS.Temp.IRISDemoIndex#"S"

			Set pConfigItemName=$Get(^IRIS.Temp.IRISDemoIndex("BS", pClassName))
			
			If pConfigItemName
			{
				Set tSC = $System.Status.Error(5001, "There is no business service configured with class name "_pClassName)
				Quit
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}

		Lock -^IRIS.Temp.IRISDemoIndex

		Quit tSC
}

}
