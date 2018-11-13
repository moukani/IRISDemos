/// RECORDMAP: Generated from RecordMap 'IRISDemo.RM.TransformerSignal'
/// on 2018-09-26 at 16:10:31.317 [2018-09-26 16:10:31.317 UTC]
/// by user SuperUser
Class IRISDemo.RM.TransformerSignal.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property TransformerCode As %String [ Required ];

Property TimeOfMeasurement As %TimeStamp [ Required ];

Property TransformerLoad As %Float [ Required ];

Property TopOilTemperature As %Float [ Required ];

Property BottomOilTemperature As %Float [ Required ];

Property OilVolume As %Float [ Required ];

Property MoistureInOil As %Float [ Required ];

Property Vibration As %Float [ Required ];

Parameter RECORDMAPGENERATED = 1;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransformerCode</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
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
<Value>TimeOfMeasurement</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.RM.TransfoC40F.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^IRISDemo.RM.TransfoC40F.RecordD</IdLocation>
<IndexLocation>^IRISDemo.RM.TransfoC40F.RecordI</IndexLocation>
<StreamLocation>^IRISDemo.RM.TransfoC40F.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
