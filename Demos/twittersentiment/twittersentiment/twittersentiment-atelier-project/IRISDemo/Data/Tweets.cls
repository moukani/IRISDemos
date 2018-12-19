Class IRISDemo.Data.Tweets Extends %Persistent
{
	Property TwitterId As %BigInt;
	
	Property TwitterText As %String (MAXLEN="") [ Required ];

	Property TwitterUser As %String [ Required ];
	
	Property Sentiment As %String; 
	 
	
Storage Default
{
<Data name="TweetsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TwitterId</Value>
</Value>
<Value name="3">
<Value>TwitterText</Value>
</Value>
<Value name="4">
<Value>TwitterUser</Value>
</Value>
<Value name="5">
<Value>Sentiment</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.TweetsD</DataLocation>
<DefaultData>TweetsDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.TweetsD</IdLocation>
<IndexLocation>^IRISDemo.Data.TweetsI</IndexLocation>
<StreamLocation>^IRISDemo.Data.TweetsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}