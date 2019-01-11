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
 Set tSC = ..Adapter.InvokeMethod("Discharge",.DischargeResult,pRequest.PatientID,pRequest.EncounterNumber,pRequest.EndDate,pRequest.EndTime,pRequest.DischargeLocation)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.DischargeResult=$get(DischargeResult)
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
</MapItems>
}

}
