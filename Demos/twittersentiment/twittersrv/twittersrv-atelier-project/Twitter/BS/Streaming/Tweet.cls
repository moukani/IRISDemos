Class Twitter.BS.Streaming.Tweet Extends (%Persistent,%XML.Adaptor)
{
	Index idIndex On id [ IdKey ];
	
	Property "created_at" As %String [ Required ];
	
	Property id As %Integer [ Required ];
	
	Property text As %String (MAXLEN="") [ Required ];

	Property "in_reply_to_status_id" As %Integer;
	
	Property "in_reply_to_user_id" As %Integer;
	
	Property "in_reply_to_screen_name" As %String;
	
	Property user As Twitter.BS.Streaming.TwitterUser [ Required ];
	
	Property "reply_count" As %Integer;
	
	Property "retweet_count" As %Integer;
	
	Property "favorite_count" As %Integer;
	
	Property entities As Twitter.BS.Streaming.TwitterEntities;
	
	Property retweeted As %Boolean;
	
	Property lang As %String;
	
	Property "timestamp_ms" As %Integer;
	
	Property IRISTimestamp As %TimeStamp;
	
	Method "timestamp_msSet"(pVal) As %Status
	{
		Set tSC = $$$OK
		Try
		{
			Set ..IRISTimestamp=$ZDateTime(##class(Twitter.Utils).TwitterTimestampInH(pVal),3)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		Quit tSC
	}
	 
	ClassMethod CreateFromJSON(pJSONTweet As %Library.DynamicObject) As Twitter.Tweet
	{
		#Dim iterator As %Iterator.Object
		
		Set tweet = ..%New()
		Set tweet.id = pJSONTweet.id
		Set tweet."created_at" = pJSONTweet."created_at"
		Set tweet.text = pJSONTweet.text
		Set tweet."in_reply_to_status_id" = +pJSONTweet."in_reply_to_status_id"
		Set tweet."in_reply_to_user_id" = +pJSONTweet."in_reply_to_user_id"
		Set tweet."in_reply_to_screen_name" = pJSONTweet."in_reply_to_screen_name"
		
		Set tweet."reply_count" = +pJSONTweet."reply_count"
		Set tweet."retweet_count" = +pJSONTweet."retweet_count"
		Set tweet."favorite_count" = +pJSONTweet."favorite_count"
		Set tweet.retweeted = +pJSONTweet.retweeted
		Set tweet.lang = pJSONTweet.lang
		Set tweet."timestamp_ms" = +pJSONTweet."timestamp_ms"
		
		Do tweet.user.PopulateFromJSON(pJSONTweet.user)

		Do tweet.entities.PopulateFromJSON(pJSONTweet.entities)
		
		Quit tweet
	}
Storage Default
{
<Data name="TweetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>created_at</Value>
</Value>
<Value name="3">
<Value>text</Value>
</Value>
<Value name="4">
<Value>in_reply_to_status_id</Value>
</Value>
<Value name="5">
<Value>in_reply_to_user_id</Value>
</Value>
<Value name="6">
<Value>in_reply_to_screen_name</Value>
</Value>
<Value name="7">
<Value>user</Value>
</Value>
<Value name="8">
<Value>reply_count</Value>
</Value>
<Value name="9">
<Value>retweet_count</Value>
</Value>
<Value name="10">
<Value>favorite_count</Value>
</Value>
<Value name="11">
<Value>entities</Value>
</Value>
<Value name="12">
<Value>retweeted</Value>
</Value>
<Value name="13">
<Value>lang</Value>
</Value>
<Value name="14">
<Value>timestamp_ms</Value>
</Value>
<Value name="15">
<Value>IRISTimestamp</Value>
</Value>
</Data>
<DataLocation>^Twitter.BS.Streaming.TweetD</DataLocation>
<DefaultData>TweetDefaultData</DefaultData>
<IdLocation>^Twitter.BS.Streaming.TweetD</IdLocation>
<IndexLocation>^Twitter.BS.Streaming.TweetI</IndexLocation>
<StreamLocation>^Twitter.BS.Streaming.TweetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}