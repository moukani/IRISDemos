Class Datalake.BO.Data.Operation Extends Ens.BusinessOperation
{

	Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

	Property Adapter As EnsLib.HTTP.OutboundAdapter;

	Method GetData(pRequest As BankingSrv.BS.Transaction.NewTransactionReq, Output pResponse As IRISDemo.BO.PMML.ExecuteModelReq) As %Status
	{
		Set requestBody = { "FromAccountNumber": (pRequest.FromAccountNumber), "ToAccountNumber": (pRequest.ToAccountNumber) }
			
		#Dim httpResponse As %Net.HttpResponse
		Set sc = ..Adapter.Post(.httpResponse, , requestBody.%ToJSON())
		
		Set sc = ##class(BankingSrv.DTL.BuildFeatures).Transform(pRequest, .pResponse)
		
		Set jsonResp = {}.%FromJSON(httpResponse.Data)
		
		Do pResponse.ModelData.SetAt(jsonResp.FromAge, "fromAge")
		Do pResponse.ModelData.SetAt(jsonResp.FromCity, "fromCity")
		Do pResponse.ModelData.SetAt(jsonResp.FromGender, "fromGender")
		Do pResponse.ModelData.SetAt(jsonResp.FromAccountAge, "fromAccountAge")
		Do pResponse.ModelData.SetAt(jsonResp.ToCity, "toCity")
		Do pResponse.ModelData.SetAt(jsonResp.ToAccountAge, "toAccountAge")
		Do pResponse.ModelData.SetAt((jsonResp.ToCity=jsonResp.FromCity), "isSameCity")
		
		Quit sc
	}

	XData MessageMap
	{
	<MapItems>
		<MapItem MessageType="BankingSrv.BS.Transaction.NewTransactionReq"> 
			<Method>GetData</Method>
		</MapItem>
	</MapItems>
	}

}
