Class IRISDemo.Cube.Utils
{

/// L Score - Length of Stay Score<br>
///  (component of LACE score)<br>
/// 
ClassMethod GetLScore(pEncounterID As IRISDemo.Data.Patient.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	set tLOS = 0
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select LOS from IRISDemo_Data_Patient.Encounter where ID = '"_pEncounterID_"'")
	if objSQL.%Next() set tLOS = objSQL.%GetData(1)

	set tLScore = $Select(tLOS<=3 : tLOS, //if LOS less than 3, score is LOS
	                      tLOS<=6 : 4,    //if LOS between 4 and 6, score is 4
	                      tLOS<=13: 5,    //if LOS between 7 and 13, score is 5
	                      tLOS>=14: 7)    //if LOS 14 or higher, score is 7
	quit tLScore
}

/// A Score - Acuity Score
///  (component of LACE score)<br>
ClassMethod GetAScore(pEncounterID As IRISDemo.Data.Patient.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	
	// Need to determine if this admission is via the emergency dept 
	// For now we'll take the encounter type but could be a lookup by admission source
	set tCScore = 0
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select EncounterType from IRISDemo_Data_Patient.Encounter where ID = '"_pEncounterID_"'")
	if objSQL.%Next() if objSQL.%GetData(1) = "E" set tCScore = 3

	quit tCScore
}

/// C Score - Comorbidities Score
///  (component of LACE score)<br>
ClassMethod GetCScore(pEncounterID As IRISDemo.Data.Patient.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	
	set tCScore = 0

	// Get the patient number
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select PatientID from IRISDemo_Data_Patient.Encounter where ID = '"_pEncounterID_"'")
	if objSQL.%Next() {
		set pId = objSQL.%GetData(1)
		// Get all the diagnoses for this patient
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select Code,CodingStandard from IRISDemo_Data_Patient.Diagnosis where PatientID = '"_pId_"'")
		while objSQL.%Next() {
			set code = objSQL.%Get("Code")
			set coding = objSQL.%Get("CodingStandard")
			if coding = "SNOMED" {
				// If the code is SNOMED then find the equivalent ICD code
				set objSQLCoding = ##class(%SQL.Statement).%ExecDirect(,"select ICDCode from IRISDemo_Data.SNOMED2ICD where SNOMEDCode = '"_code_"'")
				if objSQLCoding.%Next() set code = objSQLCoding.%Get("ICDCode")
			}
			// Get the comorbidity name and the index value
			set objSQLIndex = ##class(%SQL.Statement).%ExecDirect(,"select Comorbidity,Index from IRISDemo_Data.ComorbidityIndex where ICDCode = '"_code_"'")
			// Put them into an array keyed by the comorbidity so that we get unique values
			if objSQLIndex.%Next() set comorb(objSQLIndex.%Get("Comorbidity")) = objSQLIndex.%Get("Index")
		}
	}
	set tTotalScore = 0
	set comorb = ""
	for  {
		set comorb = $order(comorb(comorb),1,value)
		if comorb = "" quit
		set tTotalScore = tTotalScore + value
	}

	if tTotalScore<=3 {
		set tCScore = tTotalScore
	}
	else {
		set tCScore = 5
	}
	
	quit tCScore
}

/// E Score - Emergency Visits Score
///  (component of LACE score)<br>
ClassMethod GetEScore(pEncounterID As IRISDemo.Data.Patient.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	
	// tEmergencyVisits is the count of patient visits to emergency dept in the 6 months prior to current admission,
	// not including the current admission
	set tEScore = 0
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select PatientID,StartDate from IRISDemo_Data_Patient.Encounter where ID = '"_pEncounterID_"'")
	if objSQL.%Next() {
		set pId = objSQL.%GetData(1)
		set eDate = objSQL.%GetData(2)
		set lDate = (eDate - 180)
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select count(*) from IRISDemo_Data_Patient.Encounter where Patient->PatientID = '"_pId_"' and ID<>'"_pEncounterID_"' and EncounterType = 'E' and StartDate>='"_lDate_"'")
		if objSQL.%Next() {
			set tEmergencyVisits = objSQL.%GetData(1)
			if tEmergencyVisits > 4 {
				set tEScore = 4
			}
			else {
				set tEScore = tEmergencyVisits
			}
		}
	}
	quit tEScore
}
classmethod GetAgeAtDischarge(pEncounterID As IRISDemo.Data.Patient.Encounter) As %Integer
{
	set age = ""
	
	Try 
	{
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%OpenId(pEncounterID) 
		set age = $justify((objEnc.EndDate - objEnc.Patient.DoB)/365.25,0,0)
	}
	Catch {	}
	
	quit age
}
}
