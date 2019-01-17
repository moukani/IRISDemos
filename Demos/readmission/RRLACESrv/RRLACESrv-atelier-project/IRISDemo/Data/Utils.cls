Include DEMOMACROS

Class IRISDemo.Data.Utils
{
	/// We will be adding this to all clinical dates so that the LACE score will
	/// be correctly computed in 6 months from now.
	Parameter DATEWINDOW = { $Horolog-$ZDateH("2018-12-01",3) };
	
	classmethod LoadDemoData() as %Status
	{
		set tSC = $$$OK
		try {
			write !!,"Loading demo data",!
			set tSC = ..LoadIndexData("/tmp/ComorbidityIndexMapping.csv") if $$$ISERR(tSC) quit
			set tSC = ..LoadPatientDemographics("/tmp/patient_demographics.csv") if $$$ISERR(tSC) quit
			set tSC = ..LoadPatientDiagnoses("/tmp/patient_diagnoses.csv") if $$$ISERR(tSC) quit
			set tSC = ..LoadPatientEncounters("/tmp/patient_encounters.csv") if $$$ISERR(tSC) quit
			set tSC = ..LoadTermList("/tmp/termlist_admissionsource.csv") if $$$ISERR(tSC) quit
			set tSC = ..UpdateDemoPatients() if $$$ISERR(tSC) quit
			
			set tSC = ##class(%DeepSee.Utils).%BuildCube("LACE",0,0)
			
			write !!,"Loading demo data finished",!!
		}
		catch(objException) {
			set tSC = objException.AsStatus()
		}

		quit tSC
	}
	
	classmethod LoadIndexData(fileName as %String) as %Status
	{
		#Dim objRs As %Library.ResultSet
		try {
			set tSC = ##class(IRISDemo.Data.SNOMED2ICD).%KillExtent() if $$$ISERR(tSC) quit
			set tSC = ##class(IRISDemo.Data.ComorbidityIndex).%KillExtent() if $$$ISERR(tSC) quit
	
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

			Set tSC = objRs.Execute(fileName) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadIndexDataFileException")
		
			While objRs.Next() 
			{
				// Mapping from SNOMED to ICD
				set objMapping = ##class(IRISDemo.Data.SNOMED2ICD).%New()
				set objMapping.SNOMEDCode = objRs.Get("SNOMEDCode")
				set objMapping.ICDCode = objRs.Get("ICDCode")
				set tSC = objMapping.%Save() if $$$ISERR(tSC) quit
			
				// Setup comorbidity index values for ICD codes
				set objIndex = ##class(IRISDemo.Data.ComorbidityIndex).%New()
				set objIndex.ICDCode = objRs.Get("ICDCode")
				set objIndex.Index = objRs.Get("CharlsonComorbidityIndex")
				set objIndex.Comorbidity = objRs.Get("Comorbidity")
				do objIndex.%Save() // Don't care about errors here as we will see the same ICD code many times but only need 1. The unique index will take care of this.
			}
		}
		catch(objException)
		{
			set tSC = objException.AsStatus()
		}
		quit tSC
	}
	classmethod LoadPatientDemographics(fileName as %String) as %Status
	{
		try {
			set tSC = ##class(IRISDemo.Data.Patient.Demographics).%KillExtent() if $$$ISERR(tSC) quit
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		
			Set tSC = objRs.Execute(fileName) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadIndexDataFileException")
		
			While objRs.Next() 
			{
				set obj = ##class(IRISDemo.Data.Patient.Demographics).%New()
				if objRs.Get("DoB") '= "" set obj.DoB = $zdateh(objRs.Get("DoB"),3)+..#DATEWINDOW
				set obj.PatientID = objRs.Get("PatientID")
				set obj.PostalCode = objRs.Get("PostalCode")
				set obj.Gender = objRs.Get("Gender")
				set obj.Lastname = objRs.Get("Lastname")
				set obj.Firstname = objRs.Get("Firstname")
			
				set tSC = obj.%Save() if $$$ISERR(tSC) quit
			}
		}
		catch(objException) {
			set tSC = objException.AsStatus()
		}

		quit tSC
	}
	classmethod LoadPatientDiagnoses(fileName as %String) as %Status
	{
		do {
			set tSC = ##class(IRISDemo.Data.Patient.Diagnosis).%KillExtent() if $$$ISERR(tSC) quit
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		
			Set tSC = objRs.Execute(fileName) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadIndexDataFileException")
		
			While objRs.Next() 
			{
				set obj = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
				set obj.PatientID = objRs.Get("PatientID")
				set obj.EncounterNumber = objRs.Get("EncounterNumber")
				set obj.Code = objRs.Get("Code")
				set obj.Description = objRs.Get("Description")
				set obj.CodingStandard = objRs.Get("CodingStandard")
				if objRs.Get("OnsetDate") '= "" set obj.OnsetDate = $zdateh(objRs.Get("OnsetDate"),3)+..#DATEWINDOW
				if objRs.Get("ToDate") '= "" set obj.ToDate = $zdate(objRs.Get("ToDate"),3)+..#DATEWINDOW
				set obj.Status = objRs.Get("Status")
				set tSC = obj.%Save() if $$$ISERR(tSC) quit
			}
		} while 0
		quit tSC
	}
	
	classmethod LoadPatientEncounters(fileName as %String) as %Status
	{
		try {
			set tSC = ##class(IRISDemo.Data.Patient.Encounter).%KillExtent() if $$$ISERR(tSC) quit
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		
			Set tSC = objRs.Execute(fileName) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadIndexDataFileException")
		
			While objRs.Next() 
			{
				set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
				set obj.PatientID = objRs.Get("PatientID")
				set obj.EncounterNumber = objRs.Get("EncounterNumber")
				set obj.EncounterType = objRs.Get("EncounterType")
				if objRs.Get("StartDate") '= "" set obj.StartDate = $zdateh(objRs.Get("StartDate"),3)+..#DATEWINDOW
				if objRs.Get("StartTime") '= "" set obj.StartTime = $ztimeh(objRs.Get("StartTime"))
				if objRs.Get("EndDate") '= "" set obj.EndDate = $zdateh(objRs.Get("EndDate"),3)+..#DATEWINDOW
				if objRs.Get("EndTime") '= "" set obj.EndTime = $ztimeh(objRs.Get("EndTime"))
				set obj.AdmissionSource = objRs.Get("AdmissionSource")
				set obj.AdmitReason = objRs.Get("AdmitReason")
				set obj.DischargeLocation = objRs.Get("DischargeLocation")
				if (obj.StartDate '= "")&&(obj.EndDate '= "") set obj.LOS = (obj.EndDate - obj.StartDate)
				set tSC = obj.%Save() if $$$ISERR(tSC) quit
			}
		}
		catch(objException)
		{
			set tSC = objException.AsStatus()
		}
		quit tSC
	}
	classmethod LoadTermList(fileName as %String)
	{
		try {
			set tSC = ##class(%DeepSee.TermList).%ImportCSV(fileName,,1)
		}
		catch(objException)
		{
			set tSC = objException.AsStatus()
		}
		quit tSC
	}
	/// Pick the patients we want to use on the demo and give them fixed names
	ClassMethod UpdateDemoPatients() as %Status
	{
		#dim objPat as IRISDemo.Data.Patient.Demographics
		#dim objEnc as IRISDemo.Data.Patient.Encounter
		#dim objDgn as IRISDemo.Data.Patient.Diagnosis
		
		try {
			// Remove the 3 patients first in case we have the ID numbers in the system
			for pId = 900001:1:900003 {
				set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_Data_Patient.Demographics where PatientID ='"_pId_"'")
				set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_Data_Patient.Encounter where PatientID ='"_pId_"'")
				set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_Data_Patient.Diagnosis where PatientID ='"_pId_"'")
			}

			// First - a very sick patient
			set objPat = ##class(IRISDemo.Data.Patient.Demographics).%New()
			set objPat.PatientID = "900001"
			set objPat.DoB = $zdateh("1950-02-03",3) + ..#DATEWINDOW
			set objPat.PostalCode = "02142"
			set objPat.Gender = "M"
			set objPat.Firstname = "Frederick"
			set objPat.Lastname = "Masters"
			set tSC = objPat.%Save() if $$$ISERR(tSC) quit
			// Encounter #1
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001001"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-07-01",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-07-09",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "698591006"
			set objDgn.Description = "Renal disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-07-01",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #2
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001002"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-07-21",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("09:30")
			set objEnc.EndDate = $zdateh("2018-07-29",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "698591006"
			set objDgn.Description = "Renal disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-07-01",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #3
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001003"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-08-13",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-08-17",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "698591006"
			set objDgn.Description = "Renal disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-07-01",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #4
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001004"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-08-24",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-08-31",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "698591006"
			set objDgn.Description = "Renal disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-07-01",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #5
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001005"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-10-16",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-10-25",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "59278001"
			set objDgn.Description = "Diabetes with chronic complication"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-10-16",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #6
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001006"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-11-08",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-11-10",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "698591006"
			set objDgn.Description = "Renal disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-07-01",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #7
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9001007"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-12-06",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-12-21",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "22846003"
			set objDgn.Description = "Moderate or severe liver disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-12-12",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			
			// Now a fairly sick patient
			set objPat = ##class(IRISDemo.Data.Patient.Demographics).%New()
			set objPat.PatientID = "900002"
			set objPat.DoB = $zdateh("1944-07-21",3) + ..#DATEWINDOW
			set objPat.PostalCode = "02142"
			set objPat.Gender = "F"
			set objPat.Firstname = "Katherine"
			set objPat.Lastname = "Smith"
			set tSC = objPat.%Save() if $$$ISERR(tSC) quit
			// Encounter #1
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9002001"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-10-16",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-10-25",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set objEnc.DischargeLocation = "Home"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			// Encounter #2
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9002002"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-11-08",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-11-10",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set objEnc.DischargeLocation = "Home"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "233843008"
			set objDgn.Description = "Myocardial infarction"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-12-06",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #3
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9002003"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-11-08",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-11-10",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set objEnc.DischargeLocation = "Home"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "87555007"
			set objDgn.Description = "Cerebrovascular disease"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-12-12",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			
			// Now a fairly healthy patient
			set objPat = ##class(IRISDemo.Data.Patient.Demographics).%New()
			set objPat.PatientID = "900003"
			set objPat.DoB = $zdateh("1971-08-18",3) + ..#DATEWINDOW
			set objPat.PostalCode = "02142"
			set objPat.Gender = "M"
			set objPat.Firstname = "James"
			set objPat.Lastname = "Davidson"
			set tSC = objPat.%Save() if $$$ISERR(tSC) quit
			// Encounter #1
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9003001"
			set objEnc.EncounterType = "E"
			set objEnc.StartDate = $zdateh("2018-09-16",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-09-12",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "ED"
			set objEnc.DischargeLocation = "Home"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
			set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			set objDgn.PatientID = objPat.PatientID
			set objDgn.EncounterNumber = objEnc.EncounterNumber
			set objDgn.Code = "233843008"
			set objDgn.Description = "Myocardial infarction"
			set objDgn.CodingStandard = "SNOMED"
			set objDgn.OnsetDate = $zdateh("2018-12-06",3) + ..#DATEWINDOW
			set objDgn.Status = "A"
			set tSC = objDgn.%Save() if $$$ISERR(tSC) quit
			// Encounter #2
			set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set objEnc.PatientID = objPat.PatientID
			set objEnc.EncounterNumber = "9003002"
			set objEnc.EncounterType = "I"
			set objEnc.StartDate = $zdateh("2018-11-08",3) + ..#DATEWINDOW
			set objEnc.StartTime = $ztimeh("10:00")
			set objEnc.EndDate = $zdateh("2018-11-09",3) + ..#DATEWINDOW
			set objEnc.EndTime = $ztimeh("17:00")
			set objEnc.AdmissionSource = "GA"
			set objEnc.DischargeLocation = "Home"
			set tSC = objEnc.%Save() if $$$ISERR(tSC) quit
		}
		catch(objException)
		{
			set tSC = objException.AsStatus()
		}
		quit tSC

	}
	
	ClassMethod ExportPatients()
	{
		#Dim oFile As %Library.File
		#Dim rsEncounters As %SQL.StatementResult
		#Dim oResultMetadata As %SQL.StatementMetadata
		#Dim oColumn As %SQL.StatementColumn
		
		//Do ..UpdateDemoPatients()
		
		set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"select p.PatientID, p.DoB, p.Firstname, p.Lastname, p.Gender, e. EncounterNumber, e.EncounterType, e.StartDate, e.StartTime, e.EndDate, e.EndTime, e.AdmissionSource "_
																"from IRISDemo_Data_Patient.Encounter e,  "_
																"IRISDemo_Data_Patient.Demographics p "_
																"where e.PatientID=p.PatientID")
		
		$$$ThrowSQLExceptionIfResultError(rsEncounters, "SelectPatientsForExportException")
		
		Set oFile = ##class(%Library.File).%New("/tmp/export_to_hisdb.csv")
		
		Set tSC = oFile.Open("NW")
		$$$ThrowStatusExceptionIfError(tSC, "CouldNotOpenCSVFileException")
		
		Set oResultMetadata = rsEncounters.%GetMetadata()
		
		Set tHeader=""
		For iCol=1:1:oResultMetadata.columnCount
		{
			Set oColumn = oResultMetadata.columns.GetAt(iCol)
			Set $Piece(tHeader,";",iCol)=oColumn.colName
		}
		
		Set tSC = oFile.WriteLine(tHeader)
		$$$ThrowStatusExceptionIfError(tSC, "CouldNotWriteCSVHeaderException")
		
		While rsEncounters.%Next() 
		{
			Set tRecord=""
			For iCol=1:1:oResultMetadata.columnCount
			{				
				Set $Piece(tRecord,";",iCol)=rsEncounters.%GetData(iCol)
			}
			
			Set tSC = oFile.WriteLine(tRecord)
			$$$ThrowStatusExceptionIfError(tSC, "CouldNotWriteCSVRecordrException")
		}

		Do oFile.%Close()
	}
}