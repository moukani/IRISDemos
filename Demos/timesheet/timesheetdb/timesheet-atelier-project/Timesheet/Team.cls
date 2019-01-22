Class Timesheet.Team Extends %Persistent
{

Property Name As %String [ Required ];

Property Description As %String;

Relationship TeamMember As Timesheet.TeamMember [ Cardinality = many, Inverse = Team ];

Index NameIndex On Name;

Storage Default
{
<Data name="TeamDefaultData">
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
<DataLocation>^Timesheet.TeamD</DataLocation>
<DefaultData>TeamDefaultData</DefaultData>
<IdLocation>^Timesheet.TeamD</IdLocation>
<IndexLocation>^Timesheet.TeamI</IndexLocation>
<StreamLocation>^Timesheet.TeamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
