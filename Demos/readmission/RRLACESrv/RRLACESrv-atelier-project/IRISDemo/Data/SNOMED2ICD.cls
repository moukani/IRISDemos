/// Persistent class, keyed on SNOMED code, to map to ICD
Class IRISDemo.Data.SNOMED2ICD Extends %Persistent
{
property SNOMEDCode as %String;
property ICDCode as %String;

index SNOMED on SNOMED;
}