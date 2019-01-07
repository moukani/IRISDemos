Class Twitter.BS.Streaming.TwitterUser  Extends (%SerialObject, %XML.Adaptor)
{
	Index TwitterUserIdIndex On id [ IdKey ];
	
	Property id As %Integer [ Required ];
	
	Property name As %String [ Required ];
	
	Property "screen_name" As %String [ Required ];
	
	Property location As %String (MAXLEN="");
	
	Property url As %String(MAXLEN="");
	
	Property description As %String(MAXLEN="");
	
	Property "followers_count" As %Integer;
	
	Property "friends_count" As %Integer;
	
	Property "listed_count" As %Integer;
	
	Property "favourites_count" As %Integer;
	
	Property "statuses_count" As %Integer;
	
	Property "created_at" As %String;
	
	Property lang As %String;
	
	Property "profile_image_url_https" As %String (MAXLEN="");
	
	Method PopulateFromJSON(pJSONUser As %Library.DynamicObject)
	{
		#Dim iterator As %Iterator.Object
				
		Set .."created_at" = pJSONUser."created_at"
		Set ..description = pJSONUser.description
		Set .."favourites_count" = +pJSONUser."favourites_count"
		Set .."followers_count" = +pJSONUser."followers_count"
		Set .."friends_count" = +pJSONUser."friends_count"
		Set ..id=+pJSONUser.id
		Set ..lang=pJSONUser.lang
		Set .."listed_count" = +pJSONUser."listed_count"
		Set ..location = pJSONUser.location
		Set ..name = pJSONUser.name
		Set .."profile_image_url_https" = pJSONUser."profile_image_url_https"
		Set .."screen_name" = pJSONUser."screen_name"
		Set .."statuses_count" = +pJSONUser."statuses_count"
		Set ..url = pJSONUser.url
		
	}
	
Storage Default
{
<Data name="TwitterUserState">
<Value name="1">
<Value>id</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>screen_name</Value>
</Value>
<Value name="4">
<Value>location</Value>
</Value>
<Value name="5">
<Value>url</Value>
</Value>
<Value name="6">
<Value>description</Value>
</Value>
<Value name="7">
<Value>followers_count</Value>
</Value>
<Value name="8">
<Value>friends_count</Value>
</Value>
<Value name="9">
<Value>listed_count</Value>
</Value>
<Value name="10">
<Value>favourites_count</Value>
</Value>
<Value name="11">
<Value>statuses_count</Value>
</Value>
<Value name="12">
<Value>created_at</Value>
</Value>
<Value name="13">
<Value>lang</Value>
</Value>
<Value name="14">
<Value>profile_image_url_https</Value>
</Value>
</Data>
<State>TwitterUserState</State>
<StreamLocation>^Twitter.BS.Str6BDE.TwitterUserS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}