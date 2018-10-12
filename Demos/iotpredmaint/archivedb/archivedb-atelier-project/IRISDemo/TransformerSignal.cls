Class IRISDemo.TransformerSignal Extends %Persistent
{
	Property Transformer As Transformer [ Required ];
	
	Property TimeOfMeasurement As %TimeStamp [ Required ];
	
	ForeignKey TransformerFK(Transformer) References Transformer();
	
	/// "load" on text file
	Property TransformerLoad As %Float;
	
	/// "tot" on text file. 
	Property TopOilTemperature As %Float;
	
	/// "bot" on text file
	Property BottomOilTemperature As %Float;
	
	/// "ov" on text file
	Property OilVolume As %Float;
	
	/// "mio" on text file
	Property MoistureInOil As %Float;
	
	/// "vibration" on text file
	Property Vibration As %Float;
	
	/// "vib_level" on text file
	Property VibrationLevel As %Integer;
		
	/// This is what is being predicted. This will be filled by the iotmon instance (IRIS Interoperability)
	Property Threat As %Integer;
	
Storage Default
{
<Data name="TransformerSignalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Transformer</Value>
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
</Data>
<DataLocation>^IRISDemo.TransformerSignalD</DataLocation>
<DefaultData>TransformerSignalDefaultData</DefaultData>
<IdLocation>^IRISDemo.TransformerSignalD</IdLocation>
<IndexLocation>^IRISDemo.TransformerSignalI</IndexLocation>
<StreamLocation>^IRISDemo.TransformerSignalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}