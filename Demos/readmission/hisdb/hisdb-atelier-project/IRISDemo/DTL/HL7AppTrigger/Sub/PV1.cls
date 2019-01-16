Class IRISDemo.DTL.HL7AppTrigger.Sub.PV1 Extends Ens.DataTransformDTL [ DependsOn = (IRISDemo.Data.Encounter, EnsLib.HL7.Segment) ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='IRISDemo.Data.Encounter' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:PV1' create='existing' language='objectscript' >
<assign value='source.EncounterType' property='target.{PatientClass}' action='set' />
<assign value='source.EncounterType' property='target.{AdmissionType}' action='set' />
<assign value='source.AdmissionSource' property='target.{AdmitSource}' action='set' />
<assign value='source.EncounterNumber' property='target.{VisitNumber}' action='set' />
<assign value='"Hospitalization"' property='target.{DischargedtoLocation}' action='set' />
<assign value='..ConvertDateTime(source.StartDate_","_source.StartTime,"%q(3)","%q")' property='target.{AdmitDateTime}' action='set' />
<assign value='..ConvertDateTime(source.EndDate_","_source.EndTime,"%q(3)","%q")' property='target.{DischargeDateTime()}' action='set' />
</transform>
}

}
