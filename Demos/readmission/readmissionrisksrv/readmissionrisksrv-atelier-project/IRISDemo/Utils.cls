Class IRISDemo.Utils
{
classmethod OutputHL7(PatientID as %String,Type as %String,date as %String,directory as %String) as %Status
{
	set directory = ##class(%Library.File).NormalizeDirectory(directory)
	
	set date = $zdateh(date,3)
	
	if Type = "A" {
	set encNum = $extract($increment(^EncounterNumber(PatientID))+1000,2,4)
		set encNum = "DEMO_"_encNum
	}
	else {
		set encNum = $extract(^EncounterNumber(PatientID)+1000,2,4)
		set encNum = "DEMO_"_encNum
	}
	
	set objMsg = ##class(EnsLib.HL7.Message).%New()
	if Type = "A" {
		set objMsg.DocType = "2.5:ADT_A01"
	}
	else {
		set objMsg.DocType = "2.5:ADT_A03"
	}
	
	do {
		set objMSH = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objMSH.SetValueAt("MSH",0) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("|",1) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("^~\&",2) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("DEMO",3) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("DEMO",4) if $$$ISERR(tSC) quit
		set date = $zdate(date,8)
		set time = $ztime($piece($horolog,",",2))
		set datetime = date_$translate(time,":")
		set tSC = objMSH.SetValueAt(datetime,7) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt($piece(objMsg.DocType,":",1),9.1) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt($piece(objMsg.DocType,":",2),9.2) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("2.5",12) if $$$ISERR(tSC) quit
	
		set objEVN = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objEVN.SetValueAt("EVN",0) if $$$ISERR(tSC) quit
		set tSC = objEVN.SetValueAt(datetime,2) if $$$ISERR(tSC) quit
		set tSC = objEVN.SetValueAt("EVN",0) if $$$ISERR(tSC) quit
	
		set objPID = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objPID.SetValueAt("PID",0) if $$$ISERR(tSC) quit
		set tSC = objPID.SetValueAt(PatientID,2) if $$$ISERR(tSC) quit
		
		set objPV1 = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objPV1.SetValueAt("PV1",0) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt("E",2) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt("E",4) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt("DEMO",6) if $$$ISERR(tSC) quit
		
		set tSC = objPV1.SetValueAt(encNum,19) if $$$ISERR(tSC) quit
		set key = 44
		if Type = "D" set key = 45
		set tSC = objPV1.SetValueAt(datetime,key) if $$$ISERR(tSC) quit
		
		set tSC = objMsg.SetSegmentAt(objMSH,1) if $$$ISERR(tSC) quit
		set tSC = objMsg.SetSegmentAt(objEVN,2) if $$$ISERR(tSC) quit
		set tSC = objMsg.SetSegmentAt(objPID,3) if $$$ISERR(tSC) quit
		set tSC = objMsg.SetSegmentAt(objPV1,4) if $$$ISERR(tSC) quit
	}
	while 0
	
	set file = $select(Type="A":"admit",1:"discharge")
	set file = directory_file_"_"_PatientID_".hl7"
	do objMsg.OutputToFile(file)
	
	quit tSC
}
}