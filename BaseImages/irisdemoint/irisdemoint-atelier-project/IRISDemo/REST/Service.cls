Include DEMOMACROS

/// If you are building REST services as Business Services, your business service
/// Must inherit from this class. On your REST Dispatcher class, you will have route MAP to
/// route an entire url path to be further routed by your business service.
/// You must define your XData UrlMap on your business service to achieve this.
Class IRISDemo.REST.Service Extends (%CSP.REST, Ens.BusinessService)
{
	Parameter UseSession = 1;

	Parameter CONVERTINPUTSTREAM = 1;

	Parameter CHARSET = "utf-8";

	/// This is a utility method that can be used by methods on this class and 
	ClassMethod CallBusinessService(pBusinessServiceConfigItemName As %String, pRequest As %Persistent, pResponse As %Persistent)
	{
		Set tSC = ##class(Ens.Director).CreateBusinessService(pBusinessServiceConfigItemName, .oService)
		$$$TrowStatusExceptionIfError("CreateBusinessServiceException", tSC)
		
		Set tSC = oService.ProcessInput(pRequest, .pResponse)
		$$$TrowStatusExceptionIfError("ProcessInputException", tSC)
	}
}