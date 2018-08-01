Include DEMOMACROS

/// If you are building REST services as Business Services, your business service
/// Must inherit from this class. On your REST Dispatcher class, you will have route MAP to
/// route an entire url path to be further routed by your business service.
/// You must define your XData UrlMap on your business service to achieve this.
Class IRISDemo.BS.REST.Service Extends (%CSP.REST, Ens.BusinessService)
{

Parameter UseSession = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

/// Call this method from your REST method to send a request to a business operation or business process
/// It will do it through your business service automatically
ClassMethod DispatchTo(pConfigItemName As %String, pRequest As %Persistent, Output pResponse As %Persistent)
{
	Set tSC = ##class(IRISDemo.Utils).GetBusinessServiceConfigItemName(..%ClassName(1), .tBusinessServiceConfigItemName)
	$$$TrowStatusExceptionIfError(tSC, "FindBusinessServiceConfigItemNameException")

	//$$$TRACE("tBusinessServiceConfigItemName for "_..%ClassName(1)_": "_tBusinessServiceConfigItemName)

	Set tSC = ##class(Ens.Director).CreateBusinessService(tBusinessServiceConfigItemName, .oService)
	$$$TrowStatusExceptionIfError(tSC, "CreateBusinessServiceException")
	
	Set tSC = oService.ProcessInput(pRequest, .pResponse, pConfigItemName)
	$$$TrowStatusExceptionIfError(tSC, "ProcessInputException")
}

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %Stream.Object, pHint As %String) As %Status
{
		Set tSC = $$$OK
		Try
		{
			Set tSC = ..SendRequestSync(pHint, pInput, .pOutput)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		Quit tSC
}

}
