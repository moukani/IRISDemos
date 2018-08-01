Include DEMOMACROS
Class BankingSrv.BS.Transaction.Service extends IRISDemo.BS.REST.Service 
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
			Set doResponse={}
			Set doResponse.TransactionResult={}

			Set %response.ContentType=..#CONTENTTYPEJSON
			Set doNewTransaction=##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set oRequest = ##class(BankingSrv.BS.Transaction.NewTransactionReq).CreateNewFromDynamicObj(doNewTransaction)
			
			// I can't call ProcessInput directly because I am running on a class method that was called
			// by the dispatcher. The Business Service's instance hasn't been created yet. This method will
			// create it for me and call ProcessInput:
			Set tSC = ..CallBusinessService("Banking Transaction Service", oRequest, .oResponse)
			$$$TrowStatusExceptionIfError(tSC, "CallBusinessServiceException")

			Set doResponse.TransactionResult.Status="OK"
			Set doResponse.TransactionResult.TransactionId=oResponse.TransactionId
		}
		Catch (oException)
		{
			Set doResponse.TransactionResult.Status="Error"
			Set doResponse.TransactionResult.Exception=$$$ExceptionAsJSON(oException)
		}
		
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