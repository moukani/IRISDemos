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
method Risk(pRequest as RRLACESrv.BO.RiskRequest, output pResponse as RRLACESrv.BO.RiskResponse) as %Library.Status
{
	set pResponse = ##class(RRLACESrv.BO.RiskResponse).%New()
	Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
	Set tSC = ..Adapter.InvokeMethod("Risk",.RiskResult,pRequest.PatientID,pRequest.EncounterNumber) if $$$ISERR(tSC) quit
	set pResponse.RiskScore = $piece(RiskResult,",",1)
	set pResponse.AScore = $piece(RiskResult,",",2)
	set pResponse.CScore = $piece(RiskResult,",",3)
	set pResponse.EScore = $piece(RiskResult,",",4)
	set pResponse.LScore = $piece(RiskResult,",",5)
	quit tSC
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
	<MapItem MessageType="RRLACESrv.BO.RiskRequest">
		<Method>Risk</Method>
	</MapItem>
</MapItems>
}

}
