Class Timesheet.Activity Extends %Persistent
{

Property Title As %String (MAXLEN=100) [Required];

Relationship ActivityType As Timesheet.ActivityType [ Cardinality = one, Inverse = Activities ];

Index ActivityTypeIndex On ActivityType;

Relationship Project As Timesheet.Project [ Cardinality = one, Inverse = Activities ];

Index ProjectIndex On Project;

Property Completed As %Boolean;

Relationship WorkItems As Timesheet.WorkItem [ Cardinality = many, Inverse = Activity ];

Storage Default
{
<Data name="ActivityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>ActivityType</Value>
</Value>
<Value name="4">
<Value>Project</Value>
</Value>
<Value name="5">
<Value>Completed</Value>
</Value>
</Data>
<DataLocation>^Timesheet.ActivityD</DataLocation>
<DefaultData>ActivityDefaultData</DefaultData>
<IdLocation>^Timesheet.ActivityD</IdLocation>
<IndexLocation>^Timesheet.ActivityI</IndexLocation>
<StreamLocation>^Timesheet.ActivityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
