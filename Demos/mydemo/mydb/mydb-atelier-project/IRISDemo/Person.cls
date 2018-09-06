Class IRISDemo.Person Extends %Persistent
{	
	Property Name As %String; 

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^IRISDemo.PersonD</IdLocation>
<IndexLocation>^IRISDemo.PersonI</IndexLocation>
<StreamLocation>^IRISDemo.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}