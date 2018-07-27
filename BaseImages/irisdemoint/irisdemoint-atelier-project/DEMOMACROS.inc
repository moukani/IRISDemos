ROUTINE DEMOMACROS [TYPE=INC]

#define TrowStatusExceptionIfError(%Name,%Status) If $System.Status.IsError(tSC) Set e = ##class(%Exception.StatusException).CreateFromStatus(%Status) Set e.Name=%Name	Throw e

#define TrowException(%Name,%Details) Set e = ##class(%Exception.GeneralException).%New(%Name, %Name,,%Details) Throw e

#define SOAPFaultWithException(%e) If %e.%ClassName()="StatusException"	{ Set f = ##class(%SOAP.WebService).MakeStatusFault(%e.Name, %e.Code, %e.AsStatus()) } Else { Set f = ##class(%SOAP.WebService).MakeFault(%e.Name, %e.Code)	} Do ##class(%SOAP.WebService).ReturnFault(f)