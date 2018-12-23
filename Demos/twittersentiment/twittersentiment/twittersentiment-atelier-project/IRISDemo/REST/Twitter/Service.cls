Include DEMOMACROS
Class IRISDemo.REST.Twitter.Service Extends %CSP.REST
{

	Parameter UseSession = 1;
	
	Parameter CONVERTINPUTSTREAM = 1;
	
	Parameter CHARSET = "utf-8";
	
	Parameter HandleCorsRequest = 1;

	XData UrlMap
	{
		<Routes>
		  <Route Url="/" Method="POST" Call="StoreAndAnalyse"/>
		</Routes>
	}
	
	/// <p>We are storing the tweet on our persistent table because we may decide to rebuild the entire domain
	/// with new configurations, dictionaries, etc. and we don't want to re-read all this data from Twitter again.</p>
	/// <p>Also, having the data locally will allow us to apply other techniques in the future, combining NLP with ML
	/// for instance.</p>
	/// <p>By storing the tweeet on disk, a trigger will add its text to the TwitterAnalytics NLP domain. We will
	/// then call EvaluateSentiment() on the tweet to compute if it has a negative sentiment or positive sentiment.</p>
	ClassMethod StoreAndAnalyse() As %Status
	{
		Set tSC = $$$OK
		
		Try
		{
			/* 
			First, let's prepare our response object. "do" is a prefix for variables that
			stands for "dynamic object". It is just a convention.
			*/
			Set %response.ContentType=..#CONTENTTYPEJSON
			Set doResponse={} 
			Set doResponse.CallResult={} //If there is an error, this property will hold the error information
			
			// Let's now take the JSON POST data and parse it as a dynamic object so we can use its properties.
			Set doPOSTData = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			//TODO: Verify if the right parameters are present and throw an exception if they aren't
			
			// Here is the first thing this method does. Let's create a a new record on our
			// persistent table to store the data. Our persistent table has a trigger that will make sure
			// that the tweet data will be kept in sync with the NLP Domain
			
			//TODO: Verify if an object with this Tweet ID already exist and open it 
			
			Set tweet = ##class(IRISDemo.Data.Tweets).%New()
			Set tweet.TwitterId = doPOSTData.id 
			Set tweet.TwitterUser = doPOSTData.user
			Set tweet.TwitterText = doPOSTData.text
			
			Set tSC = tweet.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PersistingTweetException")
			
			Do tweet.EvaluateSentiment()
									
			// Populating our REST response
			Set doResponse.sentiment=$Case(tweet.HasNegativeSentiment,0:"positive",1:"negative")			
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
			
			Set doResponse.CallResult.Status="Error"
			Set doResponse.CallResult.Exception=$$$ExceptionAsJSON(oException)
		}
		
		Write doResponse.%ToJSON()
		
		// As all %Status errors have been transformed into exceptions
		// we don't need to worry about returning tSC
		Quit tSC
	}
}