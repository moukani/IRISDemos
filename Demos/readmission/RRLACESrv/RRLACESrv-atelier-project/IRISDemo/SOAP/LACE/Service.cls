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
method Search(PatientID as %String, Lastname as %String, Firstname as %String) as %Stream.GlobalBinary [ WebMethod ]
{
	set objStream = ##class(%Stream.GlobalCharacter).%New()
	
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
