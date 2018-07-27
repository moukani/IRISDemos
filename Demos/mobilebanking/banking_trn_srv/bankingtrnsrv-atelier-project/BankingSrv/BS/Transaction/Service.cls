Class BankingSrv.BS.Transaction.Service extends IRISDemo.REST.Service 
{ 
	
	XData UrlMap
	{
	  <Routes>
	    <Route Url="/" Method="POST" Call="NewTransaction" />
	  </Routes>
	}
	
	ClassMethod NewTransaction() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			Set %response.ContentType=..#CONTENTTYPEJSON
			Set doNewTransaction=##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set oRequest = ##class(BankingSrv.BS.Transaction.NewTransactionReq).CreateNewFromDynamicObj(doNewTransaction)
			
			// I can't call ProcessInput directly because I am running on a class method that was called
			// by the dispatcher. The Business Service's instance hasn't been created yet. This method will
			// create it for me and call ProcessInput:
			Do ..CallBusinessService("Banking Transaction Service", oRequest, .oResponse)
		}
		Catch (oException)
		{
			Set oResponse=##class(IRISDemo.Exception).CreateFromException(oException)
		}
		
		Set doResponse=oResponse.AsDynamicObject()
		
		Write doResponse.%ToJSON()
		
		Quit $$$OK
	}
	
	Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status
	{
		Set tSC = $$$OK
		Try
		{
			Set tSC = ..SendRequestSync("Transaction Process",pInput, .pOutput)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		Quit tSC
	}

}