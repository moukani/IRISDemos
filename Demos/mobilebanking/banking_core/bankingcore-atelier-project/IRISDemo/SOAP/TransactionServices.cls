Include DEMOMACROS

/// This class exposes banking transactional services to the organization. 
/// It shows how to correctly deal with exceptions when using SOAP (by using Faults) and good
/// practices on trapping errors. 
Class IRISDemo.SOAP.TransactionServices Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "TransactionServices";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://bankingcore.demo";

//Parameter LOCATION = "http://bankingcore/csp/app/IRISDemo.Services.TransactionServices.cls";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Method CreateTransaction(pTransDateTime As %TimeStamp, pTransType As %String, pAmount As %Double, pFromAccountNumber As %String, pToAccountNumber As %String) As %String [ WebMethod ]
{
	Set tSC = $$$OK
	Try
	{
		Set tTransactionID = ##class(IRISDemo.MobileTransaction).CreateTransaction(pTransDateTime,pTransType,pAmount,pFromAccountNumber,pToAccountNumber,0)
		
		Return tTransactionID
	}
	Catch (oException)
	{
		$$$SOAPFaultWithException(oException)
	}
}

}
