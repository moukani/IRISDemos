ROUTINE DEMOMACROS [Type=INC]

 //#define TrowStatusExceptionIfError(%Name,%Status) If $System.Status.IsError(tSC) Set tFaultCode=$Piece($Piece($System.Status.GetErrorText(tSC),"faultcode=",2),$C(13)) Set tFaultActor=$Piece($Piece($System.Status.GetErrorText(tSC),"faultactor=",2),$C(13)) Set e = ##class(%Exception.StatusException).CreateFromStatus(%Status) If tFaultCode'="" { Set e.Name=tFaultCode,e.Location=tFaultActor}	Throw e
#define ThrowStatusExceptionIfError(%Status, %Name, %sessionId)	Do ##class(IRISDemo.Utils).TrowStatusExceptionIfError(%Status, %Name, %sessionId)
#define ThrowStatusExceptionIfError(%Status, %Name)	Do ##class(IRISDemo.Utils).TrowStatusExceptionIfError(%Status, %Name)

#define ThrowException(%Name,%Details) Set e = ##class(%Exception.General).%New(%Name, %Name,,%Details) Throw e

 //#define SOAPFaultWithException(%e) If %e.%ClassName()="StatusException"	{ Set f = ##class(%SOAP.WebService).MakeStatusFault(%e.Name, %e.Code, %e.AsStatus(), $System) } Else { Set f = ##class(%SOAP.WebService).MakeFault(%e.Name, %e.Code, $System)	} Do ##class(%SOAP.WebService).ReturnFault(f) 
#define SOAPFaultWithException(%exception, %sessionId)	Do ##class(IRISDemo.Utils).SOAPFaultWithException(%exception, %sessionId)
#define SOAPFaultWithException(%exception)	Do ##class(IRISDemo.Utils).SOAPFaultWithException(%exception)

#define ExceptionAsJSON(%exception,%sessionId) ##class(IRISDemo.Utils).ExceptionAsJSON(%exception, %sessionId)
#define ExceptionAsJSON(%exception) ##class(IRISDemo.Utils).ExceptionAsJSON(%exception)