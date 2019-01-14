Class IRISDemo.Utils
{
/// Creates the relevant HL7 message. This will always be an ADT_A03 discharge
/// PatientID is the patient identifier
/// Type is either "F" for file or "T" for TCP/IP
/// admitDate and dischargeDate are always of the format YYYY-MM-DD
classmethod OutputHL7(PatientID as %String,Type as %String,admitDate as %String,dischargeDate as %String,encounterType as %String = "E",admissionSource as %String = "DEMO",dischargeLocation as %String ="DEMO") as %Status
{
	if PatientID = "" quit $system.Status.Error(5001,"Patient Must be selected")
	
	set admitDate = $zdateh(admitDate,3,,,,,,,"")
	if admitDate = "" quit $system.Status.Error(5001,"Invalid admit date")
	set dischargeDate = $zdateh(dischargeDate,3,,,,,,,"")
	if dischargeDate = "" quit $system.Status.Error(5001,"Invalid discharge date")
	set admitDate = $zdate(admitDate,8)_"000000"
	set dischargeDate = $zdate(dischargeDate,8)_"000000"
	
	set objMsg = ##class(EnsLib.HL7.Message).%New()
	set objMsg.DocType = "2.5:ADT_A03"
	
	set msgCode = $piece($piece(objMsg.DocType,":",2),"_",1)
	set trgEvent = $piece($piece(objMsg.DocType,":",2),"_",2)
	
	set encNum = "IRISDemo_"_PatientID_"_1"
	
	do {
		set objMSH = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objMSH.SetValueAt("MSH",0) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("|",1) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("^~\&",2) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("DEMO",3) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("DEMO",4) if $$$ISERR(tSC) quit

		set tSC = objMSH.SetValueAt(dischargeDate,7) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt(msgCode,9.1) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt(trgEvent,9.2) if $$$ISERR(tSC) quit
		set tSC = objMSH.SetValueAt("2.5",12) if $$$ISERR(tSC) quit
	
		set objEVN = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objEVN.SetValueAt("EVN",0) if $$$ISERR(tSC) quit
		set tSC = objEVN.SetValueAt(dischargeDate,2) if $$$ISERR(tSC) quit
		set tSC = objEVN.SetValueAt("EVN",0) if $$$ISERR(tSC) quit
	
		set objPID = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objPID.SetValueAt("PID",0) if $$$ISERR(tSC) quit
		set tSC = objPID.SetValueAt(PatientID,2) if $$$ISERR(tSC) quit
		
		set objPV1 = ##class(EnsLib.HL7.Segment).%New()
		set tSC = objPV1.SetValueAt("PV1",0) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(encounterType,2) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(encounterType,4) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(admissionSource,14) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(encNum,19) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(dischargeLocation,37) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(admitDate,44) if $$$ISERR(tSC) quit
		set tSC = objPV1.SetValueAt(dischargeDate,45) if $$$ISERR(tSC) quit
		
		set tSC = objMsg.SetSegmentAt(objMSH,1) if $$$ISERR(tSC) quit
		set tSC = objMsg.SetSegmentAt(objEVN,2) if $$$ISERR(tSC) quit
		set tSC = objMsg.SetSegmentAt(objPID,3) if $$$ISERR(tSC) quit
		set tSC = objMsg.SetSegmentAt(objPV1,4) if $$$ISERR(tSC) quit
	}
	while 0
	
	if Type = "F" {
		if '$data(directory) set directory = "/hl7files/in/"
		set file = directory_"IRISDemo.hl7"
		// Delete any existing files first
		do ##class(%Library.File).Delete(file)
		// Output the file
		do objMsg.OutputToFile(file)
	}
	elseif Type = "T" {
		//todo
	}
	
	quit tSC
}
}