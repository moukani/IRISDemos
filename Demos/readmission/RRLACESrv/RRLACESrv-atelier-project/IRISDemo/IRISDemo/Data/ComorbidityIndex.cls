Class IRISDemo.Data.ComorbidityIndex Extends %Persistent
{

Property ICDCode As %String;

Property Index As %Integer;

Property Comorbidity As %String;

Index ICD On ICDCode [ Unique ];

Storage Default
{
<Data name="ComorbidityIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICDCode</Value>
</Value>
<Value name="3">
<Value>Index</Value>
</Value>
<Value name="4">
<Value>Comorbidity</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.Comorbidity1AF1D</DataLocation>
<DefaultData>ComorbidityIndexDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.Comorbidity1AF1D</IdLocation>
<IndexLocation>^IRISDemo.Data.Comorbidity1AF1I</IndexLocation>
<StreamLocation>^IRISDemo.Data.Comorbidity1AF1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
