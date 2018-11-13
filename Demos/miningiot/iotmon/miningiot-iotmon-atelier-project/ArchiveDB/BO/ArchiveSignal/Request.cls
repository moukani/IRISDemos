Class ArchiveDB.BO.ArchiveSignal.Request Extends (%Persistent,Ens.Request)
{
	Property TransformerCode As %String [ Required ];
	
	Property TimeOfMeasurement As %TimeStamp [ Required ];
	
	Property TransformerLoad As %Decimal[ Required ];
	 
	Property TopOilTemperature As %Decimal[ Required ];
	
	Property BottomOilTemperature As %Decimal[ Required ];
	
	Property OilVolume As %Decimal[ Required ];
	
	Property MoistureInOil As %Decimal[ Required ];
	
	Property Vibration As %Decimal[ Required ];
	
	Property VibrationLevel As %Integer[ Required ];
		
	Property Threat As %Integer[ Required ];
	
	Property ActionTaken As %String;
	
	Property FieldReport As %String (MAXLEN="");
	
	Property MaitenanceTeamMember As %String;
	
Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransformerCode</Value>
</Value>
<Value name="3">
<Value>TimeOfMeasurement</Value>
</Value>
<Value name="4">
<Value>TransformerLoad</Value>
</Value>
<Value name="5">
<Value>TopOilTemperature</Value>
</Value>
<Value name="6">
<Value>BottomOilTemperature</Value>
</Value>
<Value name="7">
<Value>OilVolume</Value>
</Value>
<Value name="8">
<Value>MoistureInOil</Value>
</Value>
<Value name="9">
<Value>Vibration</Value>
</Value>
<Value name="10">
<Value>VibrationLevel</Value>
</Value>
<Value name="11">
<Value>Threat</Value>
</Value>
<Value name="12">
<Value>ActionTaken</Value>
</Value>
<Value name="13">
<Value>FieldReport</Value>
</Value>
<Value name="14">
<Value>MaitenanceTeamMember</Value>
</Value>
</Data>
<DataLocation>^ArchiveDB.BO.Archi7FFC.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<IdLocation>^ArchiveDB.BO.Archi7FFC.RequestD</IdLocation>
<IndexLocation>^ArchiveDB.BO.Archi7FFC.RequestI</IndexLocation>
<StreamLocation>^ArchiveDB.BO.Archi7FFC.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}