/// 
Class IRISDemo.Cube.TransformerSignals Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.TransformerSignal, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="IRISDemo.Cube.TransformerSignals" displayName="Transformer Signals" disabled="false" abstract="false" sourceClass="IRISDemo.TransformerSignal" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Threat" disabled="false" hasAll="false" allCaption="All Threat" allDisplayName="Threat" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Threat" disabled="false" sourceProperty="Threat" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension> 
  <dimension name="DateOfMeasurement" displayName="Date of Measurement" disabled="false" hasAll="false" allCaption="All TimeOfMeasurement" allDisplayName="TimeOfMeasurement" sourceProperty="TimeOfMeasurement" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="YearMeasurement" displayName="Year of Measurement" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="MonthMeasurement" displayName="Month of Measurement" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DateMeasurement" displayName="Date of Measurement" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TransformerModel" displayName="Transformer Model" disabled="false" hasAll="false" allCaption="All Model" allDisplayName="Model" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TransformerModel" displayName="Transformer Model" disabled="false" sourceProperty="Transformer.Model" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="IsThereBulging" disabled="false" hasAll="false" allCaption="All IsThereBulging" allDisplayName="IsThereBulging" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="IsThereBulging" disabled="false" sourceProperty="Transformer.IsThereBulging" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Transformer" disabled="false" hasAll="false" allCaption="All Code" allDisplayName="Code" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Transformer" disabled="false" sourceProperty="Transformer.Code" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TimeOfMeasurement" displayName="Time of Measurement" disabled="false" hasAll="false" allCaption="All TimeOfMeasurement" allDisplayName="TimeOfMeasurement" sourceProperty="TimeOfMeasurement" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="HourMeasurement" displayName="Hour of Measurement" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="MinuteMeasurement" displayName="Minute of Measurement" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="BottomOilTemperature" disabled="false" sourceProperty="BottomOilTemperature" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="MoistureInOil" disabled="false" sourceProperty="MoistureInOil" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="OilVolume" disabled="false" sourceProperty="OilVolume" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="TopOilTemperature" disabled="false" sourceProperty="TopOilTemperature" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="TransformerLoad" disabled="false" sourceProperty="TransformerLoad" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Vibration" disabled="false" sourceProperty="Vibration" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="VibrationLevel" disabled="false" sourceProperty="VibrationLevel" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}
