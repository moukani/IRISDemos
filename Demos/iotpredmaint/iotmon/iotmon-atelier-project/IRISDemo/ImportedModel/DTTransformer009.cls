Class IRISDemo.ImportedModel.DTTransformer009 Extends %DeepSee.PMML.Definition [ Not ProcedureBlock ]
{

XData PMML [ XMLNamespace = "http://www.intersystems.com/deepsee/pmml" ]
{
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<PMML xmlns="http://www.dmg.org/PMML-4_3" xmlns:data="http://jpmml.org/jpmml-model/InlineTable" version="4.3">
	<Header>
		<Application name="JPMML-SparkML" version="1.2.12"/>
		<Timestamp>2018-09-27T22:48:32Z</Timestamp>
	</Header>
	<DataDictionary>
		<DataField name="TransformerLoad" optype="continuous" dataType="double"/>
		<DataField name="TopOilTemperature" optype="continuous" dataType="double"/>
		<DataField name="OilVolume" optype="continuous" dataType="double"/>
		<DataField name="Threat" optype="categorical" dataType="integer">
			<Value value="0"/>
			<Value value="1"/>
		</DataField>
	</DataDictionary>
	<TreeModel functionName="classification" missingValueStrategy="nullPrediction" splitCharacteristic="multiSplit">
		<MiningSchema>
			<MiningField name="Threat" usageType="target"/>
			<MiningField name="TransformerLoad"/>
			<MiningField name="TopOilTemperature"/>
			<MiningField name="OilVolume"/>
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
					</InlineTable>
				</MapValues>
			</OutputField>
			<OutputField name="probability(0)" optype="continuous" dataType="double" feature="probability" value="0"/>
			<OutputField name="probability(1)" optype="continuous" dataType="double" feature="probability" value="1"/>
		</Output>
		<Node>
			<True/>
			<Node score="0" recordCount="1101.0">
				<SimplePredicate field="TopOilTemperature" operator="lessOrEqual" value="783.7858254"/>
				<ScoreDistribution value="0" recordCount="1101.0"/>
				<ScoreDistribution value="1" recordCount="0.0"/>
			</Node>
			<Node>
				<SimplePredicate field="TransformerLoad" operator="lessOrEqual" value="3.042271446"/>
				<Node>
					<SimplePredicate field="TransformerLoad" operator="lessOrEqual" value="1.374749693"/>
					<Node>
						<SimplePredicate field="TransformerLoad" operator="lessOrEqual" value="0.934152723"/>
						<Node score="0" recordCount="2.0">
							<SimplePredicate field="TransformerLoad" operator="lessOrEqual" value="0.226359576"/>
							<ScoreDistribution value="0" recordCount="2.0"/>
							<ScoreDistribution value="1" recordCount="0.0"/>
						</Node>
						<Node score="0" recordCount="6.0">
							<True/>
							<ScoreDistribution value="0" recordCount="4.0"/>
							<ScoreDistribution value="1" recordCount="2.0"/>
						</Node>
					</Node>
					<Node score="0" recordCount="6.0">
						<True/>
						<ScoreDistribution value="0" recordCount="6.0"/>
						<ScoreDistribution value="1" recordCount="0.0"/>
					</Node>
				</Node>
				<Node score="1" recordCount="1.0">
					<SimplePredicate field="TransformerLoad" operator="lessOrEqual" value="1.566855626"/>
					<ScoreDistribution value="0" recordCount="0.0"/>
					<ScoreDistribution value="1" recordCount="1.0"/>
				</Node>
				<Node score="0" recordCount="7.0">
					<SimplePredicate field="OilVolume" operator="lessOrEqual" value="879.8515119"/>
					<ScoreDistribution value="0" recordCount="4.0"/>
					<ScoreDistribution value="1" recordCount="3.0"/>
				</Node>
				<Node score="0" recordCount="7.0">
					<True/>
					<ScoreDistribution value="0" recordCount="6.0"/>
					<ScoreDistribution value="1" recordCount="1.0"/>
				</Node>
			</Node>
			<Node score="1" recordCount="4.0">
				<SimplePredicate field="OilVolume" operator="lessOrEqual" value="879.8515119"/>
				<ScoreDistribution value="0" recordCount="0.0"/>
				<ScoreDistribution value="1" recordCount="4.0"/>
			</Node>
			<Node score="1" recordCount="1.0">
				<SimplePredicate field="TransformerLoad" operator="lessOrEqual" value="3.849426139"/>
				<ScoreDistribution value="0" recordCount="0.0"/>
				<ScoreDistribution value="1" recordCount="1.0"/>
			</Node>
			<Node score="0" recordCount="1.0">
				<True/>
				<ScoreDistribution value="0" recordCount="1.0"/>
				<ScoreDistribution value="1" recordCount="0.0"/>
			</Node>
		</Node>
	</TreeModel>
</PMML>
}

}
