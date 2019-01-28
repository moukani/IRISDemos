/// Persistent class, keyed on SNOMED code, to map to ICD
Class IRISDemo.Data.SNOMED2ICD Extends %Persistent
{

Property SNOMEDCode As %String;

Property ICDCode As %String;

Index SNOMED On SNOMEDCode;

Storage Default
{
<Data name="SNOMED2ICDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SNOMEDCode</Value>
</Value>
<Value name="3">
<Value>ICDCode</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.SNOMED2ICDD</DataLocation>
<DefaultData>SNOMED2ICDDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.SNOMED2ICDD</IdLocation>
<IndexLocation>^IRISDemo.Data.SNOMED2ICDI</IndexLocation>
<StreamLocation>^IRISDemo.Data.SNOMED2ICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
