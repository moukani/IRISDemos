Include DEMOMACROS

Class IRISDemo.Data.Utils
{
	/// We will be adding this to all clinical dates so that the LACE score will
	/// be correctly computed in 6 months from now.
	Parameter DATEWINDOW = { $H-$ZDateH("12/01/2018") };
	
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
	
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		if objRs.Execute(fileName) {
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
	
			}
		}
	}
	classmethod LoadPatientDemographics(fileName as %String)
	{
		do ##class(IRISDemo.Data.Patient.Demographics).%KillExtent()
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		if objRs.Execute(fileName) {
			while objRs.Next() {
				set obj = ##class(IRISDemo.Data.Patient.Demographics).%New()
				if objRs.Get("DoB") '= "" set obj.DoB = $zdateh(objRs.Get("DoB"),3)+..#DATEWINDOW
				set obj.PatientID = objRs.Get("PatientID")
				set obj.PostalCode = objRs.Get("PostalCode")
				set obj.Gender = objRs.Get("Gender")
				
				set obj.Lastname = ##class(%Library.PopulateUtils).LastName()
				set obj.Firstname = ##class(%Library.PopulateUtils).FirstName($select(obj.Gender="F":2,1:1))
				
				do obj.%Save()
			}
		}
	}
	classmethod LoadPatientDiagnoses(fileName as %String)
	{
		do ##class(IRISDemo.Data.Patient.Diagnosis).%KillExtent()
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		if objRs.Execute(fileName) {
			while objRs.Next() {
				set obj = ##class(IRISDemo.Data.Patient.Diagnosis).%New()
				set obj.PatientID = objRs.Get("PatientID")
				set obj.EncounterNumber = objRs.Get("EncounterNumber")
				set obj.Code = objRs.Get("Code")
				set obj.Description = objRs.Get("Description")
				set obj.CodingStandard = objRs.Get("CodingStandard")
				if objRs.Get("OnsetDate") '= "" set obj.OnsetDate = $zdateh(objRs.Get("OnsetDate"),3)+..#DATEWINDOW
				if objRs.Get("ToDate") '= "" set obj.ToDate = $zdate(objRs.Get("ToDate"),3)+..#DATEWINDOW
				set obj.Status = objRs.Get("Status")
				do obj.%Save()
			}
		}
	}
	
	classmethod LoadPatientEncounters(fileName as %String)
	{
		do ##class(IRISDemo.Data.Patient.Encounter).%KillExtent()
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		if objRs.Execute(fileName) {
			while objRs.Next() {
				set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
				set obj.PatientID = objRs.Get("PatientID")
				set obj.EncounterNumber = objRs.Get("EncounterNumber")
				set obj.EncounterType = objRs.Get("EncounterType")
				if objRs.Get("StartDate") '= "" set obj.StartDate = $zdateh(objRs.Get("StartDate"),3)+..#DATEWINDOW
				if objRs.Get("StartTime") '= "" set obj.StartTime = $ztimeh(objRs.Get("StartTime"))
				if objRs.Get("EndDate") '= "" set obj.EndDate = $zdateh(objRs.Get("EndDate"),3)+..#DATEWINDOW
				if objRs.Get("EndTime") '= "" set obj.EndTime = $ztimeh(objRs.Get("EndTime"))
				set obj.AdmissionSource = objRs.Get("AdmissionSource")
				if (obj.StartDate '= "")&&(obj.EndDate '= "") set obj.LOS = (obj.EndDate - obj.StartDate)
				do obj.%Save()
			}
		}
	}
	
	/// Pick the patients we want to use on the demo and give them fixed names
	ClassMethod UpdateDemoPatients()
	{
		//TODO:
	}
	
	ClassMethod ExportPatients()
	{
		#Dim oFile As %Library.File
		#Dim rsEncounters As %SQL.StatementResult
		#Dim oResultMetadata As %SQL.StatementMetadata
		#Dim oColumn As %SQL.StatementColumn
		
		Do ..UpdateDemoPatients()
		
		set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"select p.PatientID, p.DoB, p.Firstname, p.Lastname, p.Gender, e. EncounterNumber, e.EncounterType, e.StartDate, e.StartTime, e.EndDate, e.EndTime "_
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