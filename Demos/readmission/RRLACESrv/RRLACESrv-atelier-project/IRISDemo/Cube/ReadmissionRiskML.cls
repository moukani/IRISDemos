Include DEMOMACROS

/// 
Class IRISDemo.Cube.ReadmissionRiskML Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.Data.Patient.Encounter, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ReadmissionRiskML" displayName="ReadmissionRiskML" disabled="false" abstract="false" sourceClass="IRISDemo.Data.Patient.Encounter" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="CausedReadmission" displayName="CausedReadmission" disabled="false" hasAll="false" allCaption="All %ID" allDisplayName="%ID" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CausedReadmission" disabled="false" sourceExpression="%cube.CausedReadmission(%source.%ID, %source.EndDate, %source.Patient)" factName="CausedReadmission" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ConditionsAtTimeOfEncounter" displayName="Conditions At Time Of Encounter" disabled="false" hasAll="false" allCaption="All %ID" allDisplayName="%ID" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ConditionsAtTimeOfEncounter" disabled="false" sourceExpression="%cube.ConditionsAtTimeOfEncounter(%source.Patient.PatientID, %source.EndDate)" factName="ConditionsAtTimeOfEncounter" list="true" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Gender" disabled="false" hasAll="false" allCaption="All Gender" allDisplayName="Gender" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Gender" disabled="false" sourceProperty="Patient.Gender" factName="Gender" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EncounterType" disabled="false" hasAll="false" allCaption="All EncounterType" allDisplayName="EncounterType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EncounterType" disabled="false" sourceProperty="EncounterType" factName="EncounterType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DischargeLocation" disabled="false" hasAll="false" allCaption="All DischargeLocation" allDisplayName="DischargeLocation" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DischargeLocation" disabled="false" sourceProperty="DischargeLocation" factName="DischargeLocation" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AdmissionSource" disabled="false" hasAll="false" allCaption="All AdmissionSource" allDisplayName="AdmissionSource" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AdmissionSource" disabled="false" sourceProperty="AdmissionSource" factName="AdmissionSource" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AdmitReason" disabled="true" hasAll="false" allCaption="All AdmitReason" allDisplayName="AdmitReason" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AdmitReason" disabled="true" sourceProperty="AdmitReason" factName="AdmitReason" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
</cube>
}

ClassMethod CausedReadmission(pEncounterId As %String, pEncounterEndDate As %Date, pPatientId As %String) As %Boolean
{
	Set dStartDate = pEncounterEndDate
	Set dEndDate = pEncounterEndDate+30
	
	Set tSQL = "select ID from IRISDemo_Data_Patient.Encounter where Patient=? and StartDate>? and EndDate<=? and ID<>?"
	
	Set objRS = ##class(%SQL.Statement).%ExecDirect(, tSQL, pPatientId, dStartDate, dEndDate, pEncounterId)
	$$$ThrowSQLExceptionIfResultError(objRS, "CausedReadmissionSQLException")
	
	If objRS.%Next()
	{
		Return 1
	}
	
	Return 0
}

ClassMethod ConditionsAtTimeOfEncounter(pMRN As %String, pLimitDate As %Date) As %List
{
	Set list=""
	
	Set tSQL = "select distinct Description from IRISDemo_Data_Patient.Diagnosis where PatientID=? and OnsetDate<=?"
	
	Set objRS = ##class(%SQL.Statement).%ExecDirect(, tSQL, pMRN, pLimitDate)
	$$$ThrowSQLExceptionIfResultError(objRS, "ConditionsAtTimeOfEncounterSQLException")
	
	While objRS.%Next()
	{
		Set list=list_$ListBuild(objRS.%GetData(1))
	}
	
	Return list
}

Parameter DOMAIN;

}
