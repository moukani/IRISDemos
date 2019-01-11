Class IRISDemo.Data.Utils
{
classmethod LoadDemoData() as %Status
{
	set tSC = $$$OK
	
	write !!,"Loading demo data",!
	do ..LoadIndexData("/tmp/ComorbidityIndexMapping.csv")
	do ..LoadPatientDemographics("/tmp/patient_demographics.csv")
	do ..LoadPatientDiagnoses("/tmp/patient_diagnoses.csv")
	do ..LoadPatientEncounters("/tmp/patient_encounters.csv")
	
	write !!,"Loading demo data finished",!!
	quit tSC
}
classmethod LoadIndexData(fileName as %String)
{
	do ##class(IRISDemo.Data.SNOMED2ICD).%KillExtent()
	do ##class(IRISDemo.Data.ComorbidityIndex).%KillExtent()

	write !!,"Loading index data from: ",fileName,!
	set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	if objRs.Execute(fileName) {
		set count = 0
		while objRs.Next() {
			// Mapping from SNOMED to ICD
			set objMapping = ##class(IRISDemo.Data.SNOMED2ICD).%New()
			set objMapping.SNOMEDCode = objRs.Get("SNOMEDCode")
			set objMapping.ICDCode = objRs.Get("ICDCode")
			do objMapping.%Save()
			
			// Setup comorbidity index values for ICD codes
			set objIndex = ##class(IRISDemo.Data.ComorbidityIndex).%New()
			set objIndex.ICDCode = objRs.Get("ICDCode")
			set objIndex.Index = objRs.Get("CharlsonComorbidityIndex")
			set objIndex.Comorbidity = objRs.Get("Comorbidity")
			do objIndex.%Save()
			
			set count = count + 1
			write $justify(count,10)
		}
	}
}
classmethod LoadPatientDemographics(fileName as %String)
{
	do ##class(IRISDemo.Data.Patient.Demographics).%KillExtent()
	write !!,"Loading patient demographics from: ",fileName,!
	set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	if objRs.Execute(fileName) {
		set count = 0
		while objRs.Next() {
			set obj = ##class(IRISDemo.Data.Patient.Demographics).%New()
			if objRs.Get("DoB") '= "" set obj.DoB = $zdateh(objRs.Get("DoB"),3)
			set obj.PatientID = objRs.Get("PatientID")
			set obj.PostalCode = objRs.Get("PostalCode")
			set obj.Gender = objRs.Get("Gender")
			
			set obj.Lastname = ##class(%Library.PopulateUtils).LastName()
			set obj.Firstname = ##class(%Library.PopulateUtils).FirstName($select(obj.Gender="F":2,1:1))
			
			do obj.%Save()
			
			set count = count + 1
			write $justify(count,10)
		}
	}
}
classmethod LoadPatientDiagnoses(fileName as %String)
{
	do ##class(IRISDemo.Data.Patient.Diagnosis).%KillExtent()
	write !!,"Loading patient diagnoses from: ",fileName,!
	set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	if objRs.Execute(fileName) {
		set count = 0
		while objRs.Next() {
			set obj = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set obj.PatientID = objRs.Get("PatientID")
			set obj.EncounterNumber = objRs.Get("EncounterNumber")
			set obj.Code = objRs.Get("Code")
			set obj.Description = objRs.Get("Description")
			set obj.CodingStandard = objRs.Get("CodingStandard")
			if objRs.Get("OnsetDate") '= "" set obj.OnsetDate = $zdateh(objRs.Get("OnsetDate"),3)
			if objRs.Get("ToDate") '= "" set obj.ToDate = $zdate(objRs.Get("ToDate"),3)
			set obj.Status = objRs.Get("Status")
			do obj.%Save()
			
			set count = count + 1
			write $justify(count,10)
		}
	}
}
classmethod LoadPatientEncounters(fileName as %String)
{
	do ##class(IRISDemo.Data.Patient.Encounter).%KillExtent()
	write !!,"Loading patient encounters from: ",fileName,!
	set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	if objRs.Execute(fileName) {
		set count = 0
		while objRs.Next() {
			set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set obj.PatientID = objRs.Get("PatientID")
			set obj.EncounterNumber = objRs.Get("EncounterNumber")
			set obj.EncounterType = objRs.Get("EncounterType")
			if objRs.Get("StartDate") '= "" set obj.StartDate = $zdateh(objRs.Get("StartDate"),3)
			if objRs.Get("StartTime") '= "" set obj.StartTime = $ztimeh(objRs.Get("StartTime"))
			if objRs.Get("EndDate") '= "" set obj.EndDate = $zdateh(objRs.Get("EndDate"),3)
			if objRs.Get("EndTime") '= "" set obj.EndTime = $ztimeh(objRs.Get("EndTime"))
			set obj.AdmissionSource = objRs.Get("AdmissionSource")
			if (obj.StartDate '= "")&&(obj.EndDate '= "") set obj.LOS = (obj.EndDate - obj.StartDate)
			do obj.%Save()
			
			set count = count + 1
			write $justify(count,10)
		}
	}
}

}