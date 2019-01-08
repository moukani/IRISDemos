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

Method CreateTicketForTwitter(pTwitterID As %String, pTwitterUser As %String, pTwitterText As %String(MAXLEN=""), pTwitterSentiment As %String) [ WebMethod ]
{	
	Set tSC = $$$OK
	Try
	{
		If pTwitterID="" $$$ThrowException("ParameterIsRequired","pTwitterID")
		If pTwitterUser="" $$$ThrowException("ParameterIsRequired","pTwitterUser")
		If pTwitterText="" $$$ThrowException("ParameterIsRequired","pTwitterText")
		If pTwitterSentiment="" $$$ThrowException("ParameterIsRequired","pTwitterSentiment")
		
		Set obj = ##class(IRISDemo.Ticket).%New()
		Set obj.TicketID = pTwitterID
		Set obj.TicketUser = pTwitterUser
		Set obj.TicketText = pTwitterText
		Set obj.TicketFeedback = pTwitterSentiment
		Set obj.TicketDate = $PIECE($NOW(),",",1)

		Set sc = obj.%Save()
		
		//Example for testing %Status error and throwing an exception:
		$$$ThrowStatusExceptionIfError(tSC, "CouldNotSaveCallcenterTicket")
		
		//Example of testing SQLCODE variable if you are using %SQL.Statement
		$$$ThrowSQLExceptionIfError("CouldNotSaveCallcenterTicket")
		
	}
	Catch (oException)
	{
		$$$SOAPFaultWithException(oException)
	}
}


}