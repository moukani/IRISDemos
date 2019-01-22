Class Timesheet.WorkItem Extends %Persistent
{

Relationship Activity As Timesheet.Activity [ Cardinality = one, Inverse = WorkItems ];

Index ActivityIndex On Activity;

Relationship Member As Timesheet.Member [ Cardinality = one, Inverse = WorkItems ];

Index MemberIndex On Member;

Property WorkStartDate As %DateTime;

Property WorkEndDate As %DateTime;

Property Effort As %Double;

Property Cost As %Currency;

Property Notes As %String (MAXLEN=300);

Storage Default
{
<Data name="WorkItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Activity</Value>
</Value>
<Value name="3">
<Value>WorkStartDate</Value>
</Value>
<Value name="4">
<Value>WorkEndDate</Value>
</Value>
<Value name="5">
<Value>Notes</Value>
</Value>
<Value name="6">
<Value>Member</Value>
</Value>
<Value name="7">
<Value>Effort</Value>
</Value>
<Value name="8">
<Value>Cost</Value>
</Value>
</Data>
<DataLocation>^Timesheet.WorkItemD</DataLocation>
<DefaultData>WorkItemDefaultData</DefaultData>
<IdLocation>^Timesheet.WorkItemD</IdLocation>
<IndexLocation>^Timesheet.WorkItemI</IndexLocation>
<StreamLocation>^Timesheet.WorkItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
