Class RRLACESrv.BO.LACESoap Extends Ens.BusinessOperation [ ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Method Admit(pRequest As RRLACESrv.BO.AdmitRequest, Output pResponse As RRLACESrv.BO.AdmitResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
 Set tSC = ..Adapter.InvokeMethod("Admit",.AdmitResult,pRequest.PatientID,pRequest.EncounterNumber,pRequest.EncounterType,pRequest.StartDate,pRequest.StartTime,pRequest.AdmissionSource)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.AdmitResult=$get(AdmitResult)
 Quit $$$OK
}

Method Discharge(pRequest As RRLACESrv.BO.DischargeRequest, Output pResponse As RRLACESrv.BO.DischargeResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
 Set tSC = ..Adapter.InvokeMethod("Discharge",.DischargeResult,pRequest.PatientID,pRequest.EncounterNumber,pRequest.EncounterType,pRequest.AdmissionSource,pRequest.StartDate,pRequest.StartTime,pRequest.EndDate,pRequest.EndTime,pRequest.DischargeLocation)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.DischargeResult=$get(DischargeResult)
 Quit $$$OK
}
Method Search(pRequest As IRISDemo.Message.PatientSearch.Request, Output pResponse As IRISDemo.Message.PatientSearch.Response) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
 Set tSC = ..Adapter.InvokeMethod("Search",.SearchResult,pRequest.PatientID,pRequest.Lastname,pRequest.Firstname)  Quit:$$$ISERR(tSC) tSC
 Set pResponse = ##class(IRISDemo.Message.PatientSearch.Response).%New()
 do pResponse.SearchResult.CopyFrom(SearchResult)
 Quit $$$OK
}
XData MessageMap
{
<MapItems>
	<MapItem MessageType="RRLACESrv.BO.AdmitRequest">
		<Method>Admit</Method>
	</MapItem>
	<MapItem MessageType="RRLACESrv.BO.DischargeRequest">
		<Method>Discharge</Method>
	</MapItem>
	<MapItem MessageType="IRISDemo.Message.PatientSearch.Request">
		<Method>Search</Method>
	</MapItem>
</MapItems>
}

}
