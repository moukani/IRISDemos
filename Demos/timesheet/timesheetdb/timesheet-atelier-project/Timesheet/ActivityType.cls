Class Timesheet.ActivityType Extends %Persistent
{

Property Name As %String;

Property Description As %String;

Relationship Activities As Timesheet.Activity [ Cardinality = many, Inverse = ActivityType ];

Storage Default
{
<Data name="ActivityTypeDefaultData">
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
<DataLocation>^Timesheet.ActivityTypeD</DataLocation>
<DefaultData>ActivityTypeDefaultData</DefaultData>
<IdLocation>^Timesheet.ActivityTypeD</IdLocation>
<IndexLocation>^Timesheet.ActivityTypeI</IndexLocation>
<StreamLocation>^Timesheet.ActivityTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
