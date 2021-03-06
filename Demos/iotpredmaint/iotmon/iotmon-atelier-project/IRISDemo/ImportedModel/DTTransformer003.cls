Class IRISDemo.ImportedModel.DTTransformer003 Extends %DeepSee.PMML.Definition [ Not ProcedureBlock ]
{

XData PMML [ XMLNamespace = "http://www.intersystems.com/deepsee/pmml" ]
{
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<PMML xmlns="http://www.dmg.org/PMML-4_3" xmlns:data="http://jpmml.org/jpmml-model/InlineTable" version="4.3">
	<Header>
		<Application name="JPMML-SparkML" version="1.2.12"/>
		<Timestamp>2018-09-27T22:48:27Z</Timestamp>
	</Header>
	<DataDictionary>
		<DataField name="TopOilTemperature" optype="continuous" dataType="double"/>
		<DataField name="OilVolume" optype="continuous" dataType="double"/>
		<DataField name="MoistureInOil" optype="continuous" dataType="double"/>
		<DataField name="Vibration" optype="continuous" dataType="double"/>
		<DataField name="Threat" optype="categorical" dataType="integer">
			<Value value="0"/>
			<Value value="1"/>
			<Value value="2"/>
			<Value value="3"/>
			<Value value="4"/>
			<Value value="5"/>
		</DataField>
	</DataDictionary>
	<TreeModel functionName="classification" missingValueStrategy="nullPrediction" splitCharacteristic="multiSplit">
		<MiningSchema>
			<MiningField name="Threat" usageType="target"/>
			<MiningField name="TopOilTemperature"/>
			<MiningField name="OilVolume"/>
			<MiningField name="MoistureInOil"/>
			<MiningField name="Vibration"/>
		</MiningSchema>
		<Output>
			<OutputField name="pmml(prediction)" optype="categorical" dataType="integer" feature="predictedValue"/>
			<OutputField name="prediction" optype="categorical" dataType="double" feature="transformedValue">
				<MapValues outputColumn="data:output">
					<FieldColumnPair field="pmml(prediction)" column="data:input"/>
					<InlineTable>
						<row>
							<data:input>0</data:input>
							<data:output>0</data:output>
						</row>
						<row>
							<data:input>1</data:input>
							<data:output>1</data:output>
						</row>
						<row>
							<data:input>2</data:input>
							<data:output>2</data:output>
						</row>
						<row>
							<data:input>3</data:input>
							<data:output>3</data:output>
						</row>
						<row>
							<data:input>4</data:input>
							<data:output>4</data:output>
						</row>
						<row>
							<data:input>5</data:input>
							<data:output>5</data:output>
						</row>
					</InlineTable>
				</MapValues>
			</OutputField>
			<OutputField name="probability(0)" optype="continuous" dataType="double" feature="probability" value="0"/>
			<OutputField name="probability(1)" optype="continuous" dataType="double" feature="probability" value="1"/>
			<OutputField name="probability(2)" optype="continuous" dataType="double" feature="probability" value="2"/>
			<OutputField name="probability(3)" optype="continuous" dataType="double" feature="probability" value="3"/>
			<OutputField name="probability(4)" optype="continuous" dataType="double" feature="probability" value="4"/>
			<OutputField name="probability(5)" optype="continuous" dataType="double" feature="probability" value="5"/>
		</Output>
		<Node>
			<True/>
			<Node>
				<SimplePredicate field="TopOilTemperature" operator="lessOrEqual" value="80.15538566"/>
				<Node score="0" recordCount="994.0">
					<SimplePredicate field="TopOilTemperature" operator="lessOrEqual" value="77.7835393"/>
					<ScoreDistribution value="0" recordCount="994.0"/>
					<ScoreDistribution value="1" recordCount="0.0"/>
					<ScoreDistribution value="2" recordCount="0.0"/>
					<ScoreDistribution value="3" recordCount="0.0"/>
					<ScoreDistribution value="4" recordCount="0.0"/>
					<ScoreDistribution value="5" recordCount="0.0"/>
				</Node>
				<Node>
					<SimplePredicate field="OilVolume" operator="lessOrEqual" value="944.5162317"/>
					<Node>
						<SimplePredicate field="OilVolume" operator="lessOrEqual" value="907.7994454"/>
						<Node score="0" recordCount="13.0">
							<SimplePredicate field="OilVolume" operator="lessOrEqual" value="906.1749935"/>
							<ScoreDistribution value="0" recordCount="13.0"/>
							<ScoreDistribution value="1" recordCount="0.0"/>
							<ScoreDistribution value="2" recordCount="0.0"/>
							<ScoreDistribution value="3" recordCount="0.0"/>
							<ScoreDistribution value="4" recordCount="0.0"/>
							<ScoreDistribution value="5" recordCount="0.0"/>
						</Node>
						<Node score="0" recordCount="2.0">
							<True/>
							<ScoreDistribution value="0" recordCount="1.0"/>
							<ScoreDistribution value="1" recordCount="1.0"/>
							<ScoreDistribution value="2" recordCount="0.0"/>
							<ScoreDistribution value="3" recordCount="0.0"/>
							<ScoreDistribution value="4" recordCount="0.0"/>
							<ScoreDistribution value="5" recordCount="0.0"/>
						</Node>
					</Node>
					<Node score="0" recordCount="20.0">
						<True/>
						<ScoreDistribution value="0" recordCount="20.0"/>
						<ScoreDistribution value="1" recordCount="0.0"/>
						<ScoreDistribution value="2" recordCount="0.0"/>
						<ScoreDistribution value="3" recordCount="0.0"/>
						<ScoreDistribution value="4" recordCount="0.0"/>
						<ScoreDistribution value="5" recordCount="0.0"/>
					</Node>
				</Node>
				<Node score="1" recordCount="1.0">
					<True/>
					<ScoreDistribution value="0" recordCount="0.0"/>
					<ScoreDistribution value="1" recordCount="1.0"/>
					<ScoreDistribution value="2" recordCount="0.0"/>
					<ScoreDistribution value="3" recordCount="0.0"/>
					<ScoreDistribution value="4" recordCount="0.0"/>
					<ScoreDistribution value="5" recordCount="0.0"/>
				</Node>
			</Node>
			<Node score="1" recordCount="35.0">
				<SimplePredicate field="TopOilTemperature" operator="lessOrEqual" value="83.85991517"/>
				<ScoreDistribution value="0" recordCount="0.0"/>
				<ScoreDistribution value="1" recordCount="35.0"/>
				<ScoreDistribution value="2" recordCount="0.0"/>
				<ScoreDistribution value="3" recordCount="0.0"/>
				<ScoreDistribution value="4" recordCount="0.0"/>
				<ScoreDistribution value="5" recordCount="0.0"/>
			</Node>
			<Node>
				<SimplePredicate field="TopOilTemperature" operator="lessOrEqual" value="90.25474132"/>
				<Node>
					<SimplePredicate field="MoistureInOil" operator="lessOrEqual" value="0.534493134"/>
					<Node score="1" recordCount="8.0">
						<SimplePredicate field="OilVolume" operator="lessOrEqual" value="921.2647829"/>
						<ScoreDistribution value="0" recordCount="0.0"/>
						<ScoreDistribution value="1" recordCount="3.0"/>
						<ScoreDistribution value="2" recordCount="3.0"/>
						<ScoreDistribution value="3" recordCount="2.0"/>
						<ScoreDistribution value="4" recordCount="0.0"/>
						<ScoreDistribution value="5" recordCount="0.0"/>
					</Node>
					<Node score="2" recordCount="11.0">
						<True/>
						<ScoreDistribution value="0" recordCount="0.0"/>
						<ScoreDistribution value="1" recordCount="4.0"/>
						<ScoreDistribution value="2" recordCount="7.0"/>
						<ScoreDistribution value="3" recordCount="0.0"/>
						<ScoreDistribution value="4" recordCount="0.0"/>
						<ScoreDistribution value="5" recordCount="0.0"/>
					</Node>
				</Node>
				<Node score="1" recordCount="1.0">
					<SimplePredicate field="OilVolume" operator="lessOrEqual" value="880.2610517"/>
					<ScoreDistribution value="0" recordCount="0.0"/>
					<ScoreDistribution value="1" recordCount="1.0"/>
					<ScoreDistribution value="2" recordCount="0.0"/>
					<ScoreDistribution value="3" recordCount="0.0"/>
					<ScoreDistribution value="4" recordCount="0.0"/>
					<ScoreDistribution value="5" recordCount="0.0"/>
				</Node>
				<Node score="2" recordCount="16.0">
					<True/>
					<ScoreDistribution value="0" recordCount="0.0"/>
					<ScoreDistribution value="1" recordCount="1.0"/>
					<ScoreDistribution value="2" recordCount="15.0"/>
					<ScoreDistribution value="3" recordCount="0.0"/>
					<ScoreDistribution value="4" recordCount="0.0"/>
					<ScoreDistribution value="5" recordCount="0.0"/>
				</Node>
			</Node>
			<Node>
				<SimplePredicate field="OilVolume" operator="lessOrEqual" value="906.1749935"/>
				<Node score="4" recordCount="5.0">
					<SimplePredicate field="OilVolume" operator="lessOrEqual" value="889.8451283"/>
					<ScoreDistribution value="0" recordCount="0.0"/>
					<ScoreDistribution value="1" recordCount="0.0"/>
					<ScoreDistribution value="2" recordCount="0.0"/>
					<ScoreDistribution value="3" recordCount="0.0"/>
					<ScoreDistribution value="4" recordCount="3.0"/>
					<ScoreDistribution value="5" recordCount="2.0"/>
				</Node>
				<Node score="3" recordCount="12.0">
					<True/>
					<ScoreDistribution value="0" recordCount="0.0"/>
					<ScoreDistribution value="1" recordCount="0.0"/>
					<ScoreDistribution value="2" recordCount="0.0"/>
					<ScoreDistribution value="3" recordCount="6.0"/>
					<ScoreDistribution value="4" recordCount="6.0"/>
					<ScoreDistribution value="5" recordCount="0.0"/>
				</Node>
			</Node>
			<Node score="3" recordCount="4.0">
				<SimplePredicate field="Vibration" operator="lessOrEqual" value="2.000322218"/>
				<ScoreDistribution value="0" recordCount="0.0"/>
				<ScoreDistribution value="1" recordCount="0.0"/>
				<ScoreDistribution value="2" recordCount="0.0"/>
				<ScoreDistribution value="3" recordCount="4.0"/>
				<ScoreDistribution value="4" recordCount="0.0"/>
				<ScoreDistribution value="5" recordCount="0.0"/>
			</Node>
			<Node score="5" recordCount="14.0">
				<True/>
				<ScoreDistribution value="0" recordCount="0.0"/>
				<ScoreDistribution value="1" recordCount="0.0"/>
				<ScoreDistribution value="2" recordCount="0.0"/>
				<ScoreDistribution value="3" recordCount="5.0"/>
				<ScoreDistribution value="4" recordCount="2.0"/>
				<ScoreDistribution value="5" recordCount="7.0"/>
			</Node>
		</Node>
	</TreeModel>
</PMML>
}

}
