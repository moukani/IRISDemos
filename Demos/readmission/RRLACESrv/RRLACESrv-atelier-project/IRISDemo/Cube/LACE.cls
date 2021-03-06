Class IRISDemo.Cube.LACE Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.Data.Patient.Encounter ]
{

Parameter DOMAIN = "IRIS4H";

/// This xml document defines the HoleFoods model.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube name="LACE" 
caption="LACE"
defaultListing="Listing"
nullReplacement="Self Discharge"
sourceClass="IRISDemo.Data.Patient.Encounter"
countMeasureCaption="Encounter Count">

<expression name="LScore" sourceExpression="##class(IRISDemo.Cube.Utils).GetLScore(%source.%ID)" />
<expression name="AScore" sourceExpression="##class(IRISDemo.Cube.Utils).GetAScore(%source.%ID)" />
<expression name="CScore" sourceExpression="##class(IRISDemo.Cube.Utils).GetCScore(%source.%ID)" />
<expression name="EScore" sourceExpression="##class(IRISDemo.Cube.Utils).GetEScore(%source.%ID)" />
<expression name="LACE" sourceExpression="%expression.LScore+%expression.AScore+%expression.CScore+%expression.EScore" />

<expression name="AgeDischarged" sourceExpression="##class(IRISDemo.Cube.Utils).GetAgeAtDischarge(%source.%ID)" />



<measure name="LACE Score" displayName="LACE Score" sourceExpression="%expression.LACE" type="integer" aggregate="AVG" factName="MxLACE" formatString="##.##"/>
<measure name="L Score" displayName="L Score" sourceExpression="%expression.LScore" type="integer" aggregate="AVG" factName="MxLScore" formatString="##.##"/>
<measure name="A Score" displayName="A Score" sourceExpression="%expression.AScore" type="integer" aggregate="AVG" factName="MxAScore" formatString="##.##"/>
<measure name="C Score" displayName="C Score" sourceExpression="%expression.CScore" type="integer" aggregate="AVG" factName="MxCScore" formatString="##.##"/>
<measure name="E Score" displayName="E Score" sourceExpression="%expression.EScore" type="integer" aggregate="AVG" factName="MxEScore" formatString="##.##"/>

<measure name="Length Of Stay" displayName="Length Of Stay"  sourceProperty="LOS" type="integer" aggregate="AVG" formatString="##"/>
<measure name="Emergency Count" displayName="Emergency Count" sourceExpression="$s(%expression.AScore=3:1,1:0)" type="integer" aggregate="SUM" factName="MxEmergencyCount" formatString="##"/>
<measure name="Age Discharged" displayName="Age Discharged" sourceExpression="%expression.AgeDischarged" type="integer" aggregate="AVG" factName="MxAgeDischarged" formatString="##"/>


<measure name="Patient ID"  displayName="Patient ID" sourceProperty="Patient.PatientID" type="string" />

<listing name="Listing" 
fieldList="EncounterNumber,StartDate,LOS" 
 orderBy=""/>


<dimension name="Readmission Risk" displayName="Readmission Risk">
<hierarchy name="H1">
<level name="Readmission Risk" displayName="Readmission Risk" sourceExpression="%expression.LACE" rangeExpression="[0,4]:Low;[5,9]:Moderate;[10,]:High;"  factName="DxReadmissionRisk" />
</hierarchy>
</dimension>


<dimension name="Is Emergency" displayName="Is Emergency">
<hierarchy name="H1">
<level name="Is Emergency" displayName="Is Emergency"  sourceExpression='$s(%expression.AScore=3:"True",1:"False")' sort="desc" factName="DxIsEmergency" />
</hierarchy>
</dimension>

<dimension name="Is Emergency2" displayName="Is Emergency2">
<hierarchy name="H1">
<level name="Is Emergency2" displayName="Is Emergency2" sourceExpression='$s(%expression.AScore=3:"Emergency",1:"Not Emergency")' factName="DxIsEmergency2" />
</hierarchy>
</dimension>

<dimension name="Discharge Date" displayName="Discharge Date" sourceProperty="EndDate" type="time">
<hierarchy name="H1">
<level name="Year Discharged" displayName="Year Discharged" timeFunction="Year" />
<level name="Month Discharged" displayName="Month Discharged" timeFunction="MonthYear" />
<level name="Day Discharged" displayName="Day Discharged" timeFunction="DayMonthYear" />
</hierarchy>
</dimension>

<dimension name="Discharge Location" displayName="Discharge Location">
<hierarchy name="H1">
<level name="Discharge Location" displayName="Discharge Location" sourceProperty="DischargeLocation" />
</hierarchy>
</dimension>

<dimension name="Admission Source" displayName="Admission Source">
<hierarchy name="H1">
<level name="Admission Source" displayName="Admission Source" sourceExpression='##class(%DeepSee.TermList).%Lookup("AdmissionSource",%source.AdmissionSource)' />
</hierarchy>
</dimension>

<dimension name="Encounter Type" displayName="Encounter Type">
<hierarchy name="H1">
<level name="Encounter Type" displayName="Encounter Type" sourceProperty="EncounterType" rangeExpression="E:Emergency;I:Inpatient;O:Outpatient;" />
</hierarchy>
</dimension>

<dimension name="Age Discharged" displayName="Age Discharged">
<hierarchy name="H1">
<level name="Age Group" displayName="Age Group" sourceExpression="%expression.AgeDischarged" rangeExpression="[0,10]:0-10;[11,20]:11-20;[21,30]:21-30;[31,40]:31-40;[41,50]:41-50;[51,60]:51-60;[61,70]:61-70;[71,]:71+;" />
<level name="Age Discharged" displayName="Age Discharged" sourceExpression="%expression.AgeDischarged"  />
</hierarchy>
</dimension>


</cube>
}

/// Notification that this cube is about to be built.<br/>
ClassMethod %OnBuildCube() As %Status
{
	//For now just quit and do nothing
	Quit $$$OK
	
	// pre-build Readmission Risk dimension
    // Need logic to force at least one of each: Low, Moderate, High
    // Logic needs to be based on a source properties (referenced as a subscript tVar array)
    // Is there a value for LOS that can be used to force a Low, Moderate, and High?
    // For now let's try 1, 5, and 20
    for tLOS =1,5,20 {
		Set tVar("LOS") = tLOS
	    Do ..%InjectFact("",.tVar,1)
    }
	Quit $$$OK
}

}
