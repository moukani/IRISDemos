Include DEMOMACROS

Class IRISDemo.Data.Utils
{
	/// We will be adding this to all clinical dates so that the LACE score will
	/// be correctly computed in 6 months from now.
	Parameter DATEWINDOW = { $Horolog-$ZDateH("2017-04-01",3) };
	
	Classmethod LoadDemoData()
	{
		Write !!,"Loading demo data",!
		Do ..LoadIndexData("/tmp/ComorbidityIndexMapping.csv")
		
		Do ..LoadPatientDemographics("/tmp/patient_demographics.csv")
		
		Do ..LoadPatientDiagnoses("/tmp/patient_diagnoses.csv")
		
		Do ..LoadPatientEncounters("/tmp/patient_encounters.csv")
		
		Do ..LoadTermList("/tmp/termlist_admissionsource.csv")
		
		Do ..UpdateDemoPatients()
		
		Set tSC = ##class(%DeepSee.Utils).%BuildCube("LACE",0,0)
		$$$ThrowStatusExceptionIfError(tSC, "BuildLACECubeException")
		
		write !!,"Loading demo data finished",!!
	}
	
	Classmethod LoadIndexData(fileName as %String)
	{
		Set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute(fileName) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadIndexDataFileException")
	
		While objRs.Next() 
		{
			// Mapping from SNOMED to ICD
			Set objMapping = ##class(IRISDemo.Data.SNOMED2ICD).%New()
			Set objMapping.SNOMEDCode = objRs.Get("SNOMEDCode")
			Set objMapping.ICDCode = objRs.Get("ICDCode")
			Set tSC = objMapping.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "SNOMED2ICDMappingSaveException")
		
			// Setup comorbidity index values for ICD codes
			Set objIndex = ##class(IRISDemo.Data.ComorbidityIndex).%New()
			Set objIndex.ICDCode = objRs.Get("ICDCode")
			Set objIndex.Index = objRs.Get("CharlsonComorbidityIndex")
			Set objIndex.Comorbidity = objRs.Get("Comorbidity")
			do objIndex.%Save() // Don't care about errors here as we will see the same ICD code many times but only need 1. The unique index will take care of this.
		}
	}
	
	Classmethod LoadPatientDemographics(fileName as %String)
	{
		Set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
		Set tSC = objRs.Execute(fileName) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadPatientDemographicsFileException")
	
		While objRs.Next() 
		{
			Set obj = ##class(IRISDemo.Data.Patient.Demographics).%New()
			
			If objRs.Get("DoB") '= "" Set obj.DoB = $zdateh(objRs.Get("DoB"),3)+..#DATEWINDOW
			Set obj.PatientID = objRs.Get("PatientID")
			Set obj.PostalCode = objRs.Get("PostalCode")
			Set obj.Gender = objRs.Get("Gender")
			Set obj.Lastname = objRs.Get("Lastname")
			Set obj.Firstname = objRs.Get("Firstname")
		
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PatientDemographicsSaveException")
		}
	}
	
	Classmethod LoadPatientDiagnoses(fileName as %String)
	{
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
		Set tSC = objRs.Execute(fileName) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadPatientDiagnosesFileException")
	
		While objRs.Next() 
		{
			Set obj = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
			
			Set obj.PatientID = objRs.Get("PatientID")
			Set obj.EncounterNumber = objRs.Get("EncounterNumber")
			Set obj.Code = objRs.Get("Code")
			Set obj.Description = objRs.Get("Description")
			Set obj.CodingStandard = objRs.Get("CodingStandard")
			If objRs.Get("OnsetDate") '= "" set obj.OnsetDate = $zdateh(objRs.Get("OnsetDate"),3)+..#DATEWINDOW
			If objRs.Get("ToDate") '= "" set obj.ToDate = $zdate(objRs.Get("ToDate"),3)+..#DATEWINDOW
			Set obj.Status = objRs.Get("Status")
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "DiagnosisSaveException")
		}
	}
	
	Classmethod LoadPatientEncounters(fileName as %String)
	{
		Set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
		Set tSC = objRs.Execute(fileName) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadPatientEncountersFileException")
	
		While objRs.Next() 
		{
			set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
			set obj.Patient = ##class(IRISDemo.Data.Patient.Demographics).PatientIDIndexOpen(objRs.Get("PatientID"))
			If obj.Patient=""
			{
				// Skip this encounter. There is no patient for it.
				Continue
			}
			
			set obj.EncounterNumber = objRs.Get("EncounterNumber")
			set obj.EncounterType = objRs.Get("EncounterType")
			if objRs.Get("StartDate") '= "" set obj.StartDate = $zdateh(objRs.Get("StartDate"),3)+..#DATEWINDOW
			if objRs.Get("StartTime") '= "" set obj.StartTime = $ztimeh(objRs.Get("StartTime"))
			if objRs.Get("EndDate") '= "" set obj.EndDate = $zdateh(objRs.Get("EndDate"),3)+..#DATEWINDOW
			if objRs.Get("EndTime") '= "" set obj.EndTime = $ztimeh(objRs.Get("EndTime"))
			set obj.AdmissionSource = objRs.Get("AdmissionSource")
			set obj.AdmitReason = objRs.Get("AdmitReason")
			set obj.DischargeLocation = objRs.Get("DischargeLocation")
			if $length(obj.DischargeLocation) < 4 set obj.DischargeLocation = "Home"
			if (obj.StartDate '= "")&&(obj.EndDate '= "") set obj.LOS = (obj.EndDate - obj.StartDate)
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadPatientEncountersSaveException")
		}
	}

	Classmethod LoadTermList(fileName as %String)
	{
		Set tSC = ##class(%DeepSee.TermList).%ImportCSV(fileName,,1)
		$$$ThrowStatusExceptionIfError(tSC, "LoadTermListException")
	}
	
	/// Pick the patients we want to use on the demo and give them fixed names
	ClassMethod UpdateDemoPatients()
	{
		#dim objPat as IRISDemo.Data.Patient.Demographics
		#dim objEnc as IRISDemo.Data.Patient.Encounter
		#dim objDgn as IRISDemo.Data.Patient.Diagnosis
		
		// Remove the 3 patients first in case we have the ID numbers in the system
		for pId = 900001:1:900003 {
			set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_Data_Patient.Demographics where PatientID ='"_pId_"'")
			set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_Data_Patient.Encounter where Patient->PatientID ='"_pId_"'")
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
		Set tSC = objPat.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSavePatientException")

		// Encounter #1
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001001"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog-170)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 3)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "698591006"
		set objDgn.Description = "Renal disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = objEnc.StartDate
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		
		set onset(objDgn.Code) = objDgn.OnsetDate
		
		// Encounter #2
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001002"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 155)
		set objEnc.StartTime = $ztimeh("09:30")
		set objEnc.EndDate = (objEnc.StartDate + 4)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "698591006"
		set objDgn.Description = "Renal disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = onset(objDgn.Code)
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #3
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001003"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 140)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 6)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "698591006"
		set objDgn.Description = "Renal disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = onset(objDgn.Code)
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #4
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001004"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 120)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 5)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "698591006"
		set objDgn.Description = "Renal disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = onset(objDgn.Code)
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #5
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001005"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 90)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 4)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "59278001"
		set objDgn.Description = "Diabetes with chronic complication"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = objEnc.StartDate
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		set onset(objDgn.Code) = objDgn.OnsetDate
		
		// Encounter #6
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001006"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 60)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 2)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "698591006"
		set objDgn.Description = "Renal disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = onset(objDgn.Code)
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #7
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001007"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 30)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 3)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "22846003"
		set objDgn.Description = "Moderate or severe liver disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = objEnc.StartDate
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		// Now a fairly sick patient
		set objPat = ##class(IRISDemo.Data.Patient.Demographics).%New()
		set objPat.PatientID = "900002"
		set objPat.DoB = $zdateh("1944-07-21",3) + ..#DATEWINDOW
		set objPat.PostalCode = "02142"
		set objPat.Gender = "F"
		set objPat.Firstname = "Katherine"
		set objPat.Lastname = "Smith"
		Set tSC = objPat.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSavePatientException")

		// Encounter #1
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9002001"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 90)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 9)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		set objEnc.DischargeLocation = "Home"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		// Encounter #2
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9002002"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 60)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 2)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		set objEnc.DischargeLocation = "Home"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "233843008"
		set objDgn.Description = "Myocardial infarction"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = objEnc.StartDate
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #3
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9002003"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 45)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 2)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		set objEnc.DischargeLocation = "Home"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "87555007"
		set objDgn.Description = "Cerebrovascular disease"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = objEnc.StartDate
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		// Now a fairly healthy patient
		set objPat = ##class(IRISDemo.Data.Patient.Demographics).%New()
		set objPat.PatientID = "900003"
		set objPat.DoB = $zdateh("1971-08-18",3) + ..#DATEWINDOW
		set objPat.PostalCode = "02142"
		set objPat.Gender = "M"
		set objPat.Firstname = "James"
		set objPat.Lastname = "Davidson"
		Set tSC = objPat.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSavePatientException")

		// Encounter #1
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9003001"
		set objEnc.EncounterType = "E"
		set objEnc.StartDate = ($horolog - 120)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 4)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "ED"
		set objEnc.DischargeLocation = "Home"
		Set tSC = objEnc.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
		set objDgn.PatientID = objPat.PatientID
		set objDgn.EncounterNumber = objEnc.EncounterNumber
		set objDgn.Code = "233843008"
		set objDgn.Description = "Myocardial infarction"
		set objDgn.CodingStandard = "SNOMED"
		set objDgn.OnsetDate = objEnc.StartDate
		set objDgn.Status = "A"
		Set tSC = objDgn.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #2
		set objEnc = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9003002"
		set objEnc.EncounterType = "I"
		set objEnc.StartDate = ($horolog - 60)
		set objEnc.StartTime = $ztimeh("10:00")
		set objEnc.EndDate = (objEnc.StartDate + 2)
		set objEnc.EndTime = $ztimeh("17:00")
		set objEnc.AdmissionSource = "GA"
		set objEnc.DischargeLocation = "Home"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

	}
	
	ClassMethod ExportPatients()
	{
		#Dim oFile As %Library.File
		#Dim rsEncounters As %SQL.StatementResult
		#Dim oResultMetadata As %SQL.StatementMetadata
		#Dim oColumn As %SQL.StatementColumn
		
		set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"select Patient->PatientID, Patient->DoB, Patient->Firstname, Patient->Lastname, Patient->Gender, EncounterNumber, EncounterType, StartDate, StartTime, EndDate, EndTime, AdmissionSource "_
																"from IRISDemo_Data_Patient.Encounter")
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