Class Timesheet.Member Extends %Persistent
{

Property Name As %String [ Required ];

Property Email As %String [ Required ];

Property Password As %String [ Required ];

Property isManager As %Boolean [ Required ];

Property Cost As %Currency [ Required ];

Relationship TeamMember As Timesheet.TeamMember [ Cardinality = many, Inverse = Member ];

Index NameIndex On Name;

Relationship WorkItems As Timesheet.WorkItem [ Cardinality = many, Inverse = Member ];

Storage Default
{
<Data name="MemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Email</Value>
</Value>
<Value name="4">
<Value>Password</Value>
</Value>
<Value name="5">
<Value>isManager</Value>
</Value>
<Value name="6">
<Value>cost</Value>
</Value>
<Value name="7">
<Value>Cost</Value>
</Value>
</Data>
<DataLocation>^Timesheet.MemberD</DataLocation>
<DefaultData>MemberDefaultData</DefaultData>
<IdLocation>^Timesheet.MemberD</IdLocation>
<IndexLocation>^Timesheet.MemberI</IndexLocation>
<StreamLocation>^Timesheet.MemberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
