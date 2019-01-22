Class Timesheet.Project Extends %Persistent
{

Property Name As %String;

Property Description As %String;

Index NameIndex On Name;

Relationship Activities As Timesheet.Activity [ Cardinality = many, Inverse = Project ];

Storage Default
{
<Data name="ProjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^Timesheet.ProjectD</DataLocation>
<DefaultData>ProjectDefaultData</DefaultData>
<IdLocation>^Timesheet.ProjectD</IdLocation>
<IndexLocation>^Timesheet.ProjectI</IndexLocation>
<StreamLocation>^Timesheet.ProjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
