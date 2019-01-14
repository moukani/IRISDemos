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
Method Discharge(PatientID as %String,EncounterNumber as %String,EncounterType as %String,AdmissionSource as %String,StartDate as %Date,StartTime as %Time,EndDate as %Date,EndTime as %Time,DischargeLocation as %String) As %Status [ WebMethod ]
{
	set tSC = $$$OK
	
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

	quit tSC
}
method Search(PatientID as %String, Lastname as %String, Firstname as %String) as %Stream.GlobalBinary [ WebMethod ]
{
	set objStream = ##class(%Stream.GlobalCharacter).%New()
	
	// Get null string set to char(o) - zero
	set PatientID = $translate(PatientID,$char(0))
	set Lastname = $translate(Lastname,$char(0))
	set Firstname = $translate(Firstname,$char(0))
	
	set sql = "select PatientID,Lastname,Firstname,Gender,DoB from IRISDemo_Data_Patient.Demographics"
	set first = 1
	if PatientID '= "" {
		set sql = sql _ " where PatientID = '"_PatientID_"'"
	}
	else {
		if Lastname '= "" set sql = sql_" where Lastname %Startswith '"_Lastname_"'", first = 0
		if Firstname '= "" set sql = sql_" "_$select('first:"and",1:"where")_" Firstname %Startswith '"_Firstname_"'"
		set sql = sql_" order by Lastname,Firstname"
	}
	
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,sql)
	while objSQL.%Next() {
		set data= $listbuild(objSQL.%Get("PatientID"),objSQL.%Get("Lastname"),objSQL.%Get("Firstname"),objSQL.%Get("Gender"),objSQL.%Get("DoB"))
		do objStream.WriteLine(data)
	}
	
	quit objStream
}

}
