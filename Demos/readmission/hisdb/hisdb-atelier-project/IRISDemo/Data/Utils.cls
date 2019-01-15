Include DEMOMACROS

Class IRISDemo.Data.Utils
{
	/// This is being called from IRISConfig.Installer when the image is built
	/// This method loads all the encounters and patients from a file that was generated
	/// by the RRLACESrv image.
	ClassMethod LoadEncounters(pFileName as %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		Do ..CreateEncounterDischargeDest()
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV2")

		Set tSC = objRs.Execute(pFileName) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadEncounterFileException")
		
		While objRs.Next() 
		{
			set objEncounter = ##class(IRISDemo.Data.Encounter).%New()
			Set objEncounter.EncounterNumber = objRs.Get("EncounterNumber")
			Set objEncounter.EncounterType = objRs.Get("EncounterType")
			Set objEncounter.StartDate = objRs.Get("StartDate")
			Set objEncounter.StartTime = objRs.Get("StartTime")
			Set objEncounter.EndDate = objRs.Get("EndDate")
			Set objEncounter.EndTime = objRs.Get("EndTime")
			
			// All records coming from RRLACESrv are of patients that have been discharged
			Set objEncounter.EncounterStatus="D"	//Discharged
			Set objEncounter.DischargeDestination=##class(EncounterDischargeDest).DischargeDestCodeIndexOpen("001") // Send to home
			
			Set objPatient = ##class(IRISDemo.Data.Patient).MRNIndexOpen(objRs.Get("PatientID"))
			
			If objPatient=""
			{
				Set objPatient = ##class(IRISDemo.Data.Patient).%New()
				Set objPatient.MRN=objRs.Get("PatientID")
			}
			
			Set objEncounter.Patient=objPatient
			Set objPatient.DoB=objRs.Get("DoB")
			Set objPatient.FirstName=objRs.Get("FirstName")
			Set objPatient.Gender=objRs.Get("Gender")
			Set objPatient.LastName=objRs.Get("LastName")
			
			Set tSC = objEncounter.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "EncounterSaveException")
		}
		
		Do ..CreateDemoEncounters()
	}
	
	/// Called from REST service on IRISDemo.REST.Encounter
	ClassMethod ResetDemo()
	{
		Set tEncounterID = ""
		For
		{
			Set tEncounterID=$Order(^Demo.EncounterIDs(tEncounterID))
			Quit:tEncounterID=""
			
			Set objEncounter=##class(IRISDemo.Data.Encounter).%OpenId(tEncounterID)
			Set objEncounter.EndDate=""
			Set objEncounter.EndTime=""
			Set objEncounter.DischargeDestination=""
			
			Set tSC = objEncounter.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "ResetDemoException")
		}
	}
	
	/// This method creates new encounters for the patients that we know we are going
	/// to be using on the demo
	ClassMethod CreateDemoEncounters() [ Private ]
	{
		Set ^Demo.EncounterIDs=367438 // A random starting point for our new Encounter Numbers
		
		Do ..CreateDemoEncounter("900001", $Horolog-4)
		Do ..CreateDemoEncounter("900002", $Horolog-2)
		Do ..CreateDemoEncounter("900003", $Horolog-1)
	}
	
	ClassMethod CreateDemoEncounter(pMRN As %String, pStartDate As %Date) [ Private ]
	{
		set objEncounter = ##class(IRISDemo.Data.Encounter).%New()
		Set objEncounter.EncounterNumber = $Translate($Justify($Increment(^Demo.EncounterIDs),10)," ","0")
		Set objEncounter.EncounterType = "I" //Inpatient
		Set objEncounter.StartDate = pStartDate
		Set objEncounter.StartTime = $Piece($H,",",2)
				
		Set objEncounter.Patient = ##class(IRISDemo.Data.Patient).MRNIndexOpen(pMRN)
		
		If objEncounter.Patient="" $$$ThrowException("PatientNotFoundException", "Patient with MRN "_pMRN_" was not found.")
		
		Set tSC = objEncounter.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "EncounterSaveException")
		
		Set ^Demo.EncounterIDs(objEncounter.%Id())=""
	}

	ClassMethod CreateEncounterDischargeDest() [ Private ]
	{
		// That is just another way of doing some quick and dirty SQL:
		
		&SQL(INSERT INTO IRISDemo_Data.EncounterDischargeDest (Code, Description) values ('001', 'Home'))
		&SQL(INSERT INTO IRISDemo_Data.EncounterDischargeDest (Code, Description) values ('002', 'ICU'))
		&SQL(INSERT INTO IRISDemo_Data.EncounterDischargeDest (Code, Description) values ('003', 'Deceased'))
	}

}