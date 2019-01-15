Include DEMOMACROS

Class IRISDemo.Data.Encounter Extends %Persistent
{
	Property EncounterNumber As %String [ Required ];
	
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
	Method Discharge(pDischargeDestCode As %String)
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
</Data>
<DataLocation>^IRISDemo.Data.EncounterD</DataLocation>
<DefaultData>EncounterDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.EncounterD</IdLocation>
<IndexLocation>^IRISDemo.Data.EncounterI</IndexLocation>
<StreamLocation>^IRISDemo.Data.EncounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}