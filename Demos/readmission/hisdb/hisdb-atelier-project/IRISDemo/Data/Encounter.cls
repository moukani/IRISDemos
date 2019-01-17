Include DEMOMACROS

Class IRISDemo.Data.Encounter Extends %Persistent
{
	Property EncounterNumber As %String [ Required ];
	
	Property AdmissionSource As %String;
	
	Property Patient As Patient [ Required ];
	
	Property EncounterType As %String (VALUELIST=",I,O,E", DISPLAYLIST=",Inpatient,Outpatient,Emergency") [ Required ];
	
	Property StartDate As %Date [ Required ];
	
	Property StartTime As %Time [ Required ];
	
	Property EndDate As %Date;
	
	Property EndTime As %Time;
	
	Property EncounterStatus As %String (VALUELIST=",P,A,D", DISPLAYLIST=",Pre-Admitted,Admitted,Discharged") [ InitialExpression = {"A"} ];
	
	Property DischargeDestination As EncounterDischargeDest;
	
	ForeignKey PatientFK(Patient) References Patient();
	
	ForeignKey DischargeDestinationFK(DischargeDestination) References EncounterDischargeDest();
	
	Index PatientIndex On Patient;
	
	Index EncounterNumberIndex On EncounterNumber [ Unique ];
	
	/// Called from REST service on IRISDemo.REST.Encounter
	Method Discharge(pDischargeDestCode As %String = "")
	{
		Set ..EncounterStatus="D"
		Set ..EndDate=+$Horolog
		Set ..EndTime=$Piece($Horolog,",",2)
		
		If pDischargeDestCode'=""
		{
			Set ..DischargeDestination=##class(EncounterDischargeDest).DischargeDestCodeIndexOpen(pDischargeDestCode)
			If '$IsObject(..DischargeDestination) $$$ThrowException("DischargeDestinationNotFoundException", "Discharge Destination Code: "_pDischargeDestCode)
		}
		
		Set tSC = ..%Save()
		$$$ThrowStatusExceptionIfError(tSC, "DischargeException")
	}
	
	Trigger OnUpdate [ Event = INSERT/UPDATE, Time = AFTER, Foreach = row/object ]
	{
		// %oper is a special variable that can tell us what is the event (INSERT,UPDATE or DELETE)
		// The following code is an oversimplification. We just want to show how one could go about doing this
		If (%oper="INSERT")
		{
			If ({EncounterStatus*N}="P")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A05", {ID})
			}
			ElseIf ({EncounterStatus*N}="A")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A01", {ID})
			}
			Else
			{
				// We don't want to send HL7 messages for admissions that have been created
				// with the Discharged status.
			}
		}
		ElseIf (%oper="UPDATE")
		{
			// If this encounter was previously with the Admitted status and is now on the Discharged
			// status, then we should trigger an ADT_A03
			If ({EncounterStatus*O}="P") && ({EncounterStatus*N}="A")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A01", {ID})
			}
			ElseIf ({EncounterStatus*O}="A") && ({EncounterStatus*N}="D")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A03", {ID})
			}
			Else
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A08", {ID})
			}
		}
		Else
		{
			// You should NEVER delete anything on a clinical database.
		}
	}

Storage Default
{
<Data name="EncounterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
<Value name="3">
<Value>Patient</Value>
</Value>
<Value name="4">
<Value>EncounterType</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>EndTime</Value>
</Value>
<Value name="9">
<Value>EncounterStatus</Value>
</Value>
<Value name="10">
<Value>DischargeDestination</Value>
</Value>
<Value name="11">
<Value>AdmissionSource</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.EncounterD</DataLocation>
<DefaultData>EncounterDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.EncounterD</IdLocation>
<IndexLocation>^IRISDemo.Data.EncounterI</IndexLocation>
<StreamLocation>^IRISDemo.Data.EncounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}