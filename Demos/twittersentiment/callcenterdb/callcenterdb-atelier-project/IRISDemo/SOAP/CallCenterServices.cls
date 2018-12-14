Include DEMOMACROS
///
/// WSDL available on:
/// http://localhost:9096/csp/app/soap/IRISDemo.SOAP.CallCenterServices.cls?WSDL=1
///
Class IRISDemo.SOAP.CallCenterServices Extends %SOAP.WebService
{
/// Name of the WebService.
Parameter SERVICENAME = "CallCenterServices";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://twitter.demo";

//Parameter LOCATION = "http://bankingcore/csp/app/IRISDemo.Services.TransactionServices.cls";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Method CreateTicketForTwitter(pTwitterID As %String, pTwitterUser As %String, pTwitterText As %String(MAXLEN=""), pTwitterSentiment As %String, pTwitterDate As %Date) [ WebMethod ]
{	
	Set tSC = $$$OK
	Try
	{
		If pTwitterID="" $$$ThrowException("ParameterIsRequired","pTwitterID")
		
		//TODO: Guardar dados na tabela para o JBoss ler
		
		//Example for testing %Status error and throwing an exception:
		//Set tSC = obj.%Save()
		//$$$ThrowStatusExceptionIfError(tSC, "CouldNotSaveCallcenterTicket")
		
		//Example of testing SQLCODE variable if you are using %SQL.Statement
		//$$$ThrowSQLExceptionIfError("CouldNotSaveCallcenterTicket")
		
		//If you want to throw an exception:
		///$$$ThrowException("ParameterIsRequired","pTwitterID")
	}
	Catch (oException)
	{
		$$$SOAPFaultWithException(oException)
	}
}


}