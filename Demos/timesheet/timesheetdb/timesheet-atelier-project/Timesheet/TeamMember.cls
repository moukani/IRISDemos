Class Timesheet.TeamMember Extends %Persistent
{

Relationship Team As Timesheet.Team [ Cardinality = one, Inverse = TeamMember ];

Index TeamIndex On Team;

Relationship Member As Timesheet.Member [ Cardinality = one, Inverse = TeamMember ];

Index MemberIndex On Member;

Storage Default
{
<Data name="TeamMemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Team</Value>
</Value>
<Value name="3">
<Value>Member</Value>
</Value>
</Data>
<DataLocation>^Timesheet.TeamMemberD</DataLocation>
<DefaultData>TeamMemberDefaultData</DefaultData>
<IdLocation>^Timesheet.TeamMemberD</IdLocation>
<IndexLocation>^Timesheet.TeamMemberI</IndexLocation>
<StreamLocation>^Timesheet.TeamMemberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
