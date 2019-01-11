/// IRISDemo.SOAP.LACE.Service
Class IRISDemo.SOAP.LACE.Service Extends %SOAP.WebService [ Language= objectscript, ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "LACE";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// Admit patient (new encounter)
Method Admit(PatientID as %String,EncounterNumber as %String,EncounterType as %String, StartDate As %Date, StartTime As %Time, AdmissionSource As %String) As %Status [ WebMethod ]
{
	set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
	set obj.PatientID = PatientID
	set obj.EncounterNumber = EncounterNumber
	set obj.EncounterType = EncounterType
	set obj.StartDate = StartDate
	set obj.StartTime = StartTime
	set obj.AdmissionSource = AdmissionSource
	quit obj.%Save()
}

/// Discharge
Method Discharge(PatientID as %String,EncounterNumber as %String,EndDate as %Date,EndTime as %Time,DischargeLocation as %String) As %Status [ WebMethod ]
{
	set tSC = $$$OK
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select ID from IRISDemo_Data_Patient.Encounter where PatientID = '"_PatientID_"' and EncounterNumber = '"_EncounterNumber_"'")
	if objSQL.%Next() {
		set obj = ##class(IRISDemo.Data.Patient.Encounter).%OpenId(objSQL.%Get("ID"),,.tSC)
		if tSC {
			set obj.EndDate = pInput.EndDate
			set obj.EndTime = pInput.EndTime
			set obj.DischargeLocation = DischargeLocation
			set tSC = obj.%Save()
		}
	}
	quit tSC
}

}
