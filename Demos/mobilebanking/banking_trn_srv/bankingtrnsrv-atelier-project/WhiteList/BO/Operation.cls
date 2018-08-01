Include DEMOMACROS

Class WhiteList.BO.Operation extends Ens.BusinessOperation {

Parameter INVOCATION = "Queue";

Method WhiteListReq(pInput As WhiteList.BS.WhiteListReq, Output pOutput As WhiteList.BS.WhiteListResp) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set oNewWhiteListReq = ##class(WhiteList.Data.WhiteListRequest).%New(pInput.RequestDate, pInput.FromAccountNumber, pInput.FromDate, pInput.ToDate)
		$$$ThrowStatusExceptionIfError(%objlasterror, "CreateWhiteListRequestException")
		
		Set tSC = oNewWhiteListReq.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "SaveWhiteListRequestException")
		
		Set pOutput.WhiteListRequestId = oNewWhiteListReq.%Id()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	Quit tSC
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="WhiteList.BS.WhiteListReq">
        <Method>WhiteListReq</Method>
    </MapItem>
</MapItems>
}

}