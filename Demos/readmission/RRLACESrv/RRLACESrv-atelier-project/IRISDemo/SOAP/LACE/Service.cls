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
	try {
		set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set obj.PatientID = PatientID
		set obj.EncounterNumber = EncounterNumber
		set obj.EncounterType = EncounterType
		set obj.StartDate = StartDate
		set obj.StartTime = StartTime
		set obj.AdmissionSource = AdmissionSource
		set tSC = obj.%Save()
	
		// Update DeepSee
		if tSC {
			// Immediate update of Cube
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACE",obj.%Id()) 
		}
	}
	catch(objException)
	{
		set tSC = objException.AsStatus()
	}
	
	quit tSC
}

/// Discharge
Method Discharge(PatientID as %String,EncounterNumber as %String,EncounterType as %String,AdmissionSource as %String,StartDate as %Date,StartTime as %Time,EndDate as %Date,EndTime as %Time,DischargeLocation as %String) As %Status [ WebMethod ]
{
	set tSC = $$$OK
	try {
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select ID from IRISDemo_Data_Patient.Encounter where PatientID = '"_PatientID_"' and EncounterNumber = '"_EncounterNumber_"'")
		if objSQL.%Next() {
			set obj = ##class(IRISDemo.Data.Patient.Encounter).%OpenId(objSQL.%Get("ID"),,.tSC)
		}
		else {
			set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
		}

	
		// Strip out any empty string set to char(0)
		set AdmissionSource = $translate(AdmissionSource,$char(0))
		set DischargeLocation = $translate(DischargeLocation,$char(0))
	
		set obj.PatientID = PatientID
		set obj.EncounterNumber = EncounterNumber
		set obj.EncounterType = EncounterType
		set obj.AdmissionSource = AdmissionSource
		set obj.StartDate = StartDate
		set obj.StartTime = StartTime
		set obj.EndDate = EndDate
		set obj.EndTime = EndTime
		set obj.DischargeLocation = DischargeLocation
		set obj.LOS = (EndDate - StartDate) + 1
		set tSC = obj.%Save()
		
		// Update DeepSee
		if tSC {
			// Immediate update of Cube
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACE",obj.%Id()) 
		}
	}
	catch(objException)
	{
		set tSC = objException.AsStatus()
	}
	quit tSC
}
Method Risk(PatientID as %String,EncounterNumber as %String) As %String [ WebMethod ]
{
	set return = ""
	try {
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select ID from IRISDemo_Data_Patient.Encounter where EncounterNumber = '"_EncounterNumber_"'")
		if objSQL.%Next()
		{
			set encId = objSQL.%Get("ID")
			set LScore = ##class(IRISDemo.Cube.Utils).GetLScore(encId)
			set AScore = ##class(IRISDemo.Cube.Utils).GetAScore(encId)
			set CScore = ##class(IRISDemo.Cube.Utils).GetCScore(encId)
			set EScore = ##class(IRISDemo.Cube.Utils).GetEScore(encId)
			
			set RiskScore = LScore + AScore + CScore + EScore
			set return = RiskScore_","_AScore_","_CScore_","_EScore_","_LScore
		}
	}
	catch(objException)
	{
		set tSC = objException.AsStatus()
	}
	quit return
}

}
