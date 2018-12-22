Include DEMOMACROS
Class IRISDemo.REST.Twitter.Service Extends %CSP.REST
{

	Parameter UseSession = 1;
	
	Parameter CONVERTINPUTSTREAM = 1;
	
	Parameter CHARSET = "utf-8";
	
	Parameter HandleCorsRequest = 1;
	
	Parameter NLPDOMAINNAME = "TwitterAnalytics";

	XData UrlMap
	{
		<Routes>
		  <Route Url="/" Method="POST" Call="StoreAndAnalyse"/>
		</Routes>
	}
	
	/// <p>This method has two very specific missions:</p>
	/// <ul>
	///      <li>Store the the new tweet on our persistent table IRISDemo.Data.Tweets.</li>
	///		 <li>Add the new tweet string to the TwitterAnalytics" domain and get the sentiment of it</li>
	/// </ul>
	/// <p>We are storing the tweet on our persistent table because we may decide to rebuild the entire domain
	/// with new configurations, dictionaries, etc. and we don't want to re-read all this data from Twitter again.</p>
	/// <p>Also, having the data locally will allow us to apply other techniques in the future, combining NLP with ML
	/// for instance.</p>
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
			// persistent table to store the data. We will store the sentiment analysis too later, but for now
			// we need an ID so we are saving it now here:
			Set tweet = ##class(IRISDemo.Data.Tweets).%New()
			Set tweet.TwitterId = doPOSTData.id 
			Set tweet.TwitterUser = doPOSTData.user
			Set tweet.TwitterText = doPOSTData.text
			
			Set tSC = tweet.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PersistingTweetException")
			
			Set tTweetId = tweet.%Id()
			
			Set tDomainId = ##class(%SYSTEM.iKnow).GetDomainId(..#NLPDOMAINNAME)
			If tDomainId="" $$$ThrowException("NLPDomainNotFoundException", ..#NLPDOMAINNAME) 
			
			Do ..NLPSave(tTweetId, .tSourceId) //Does not return a %Status. Throws exceptions instead 
			
			Set tSentiment = NLPSentiment(tDomainId, tSourceId) //Does not return a %Status. Throws exceptions instead
			
			// Populating our REST response
			Set doResponse.sentiment=tSentiment
			
			// Updating the persistent table...
			Set tweet.Sentiment = tSentiment
			Set tSC = tweet.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PersistingTweetWithSentimentException")
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
	
	ClassMethod NLPSave(pTweetId As %String, Output pSourceId As %String)
	{
		Set tWhere = "ID='"_pTweetId_"'"
		Set tMetadataFields=$ListBuild("TWitterUser")
		Set tDataField="TwitterText"
		Set tGroupField="ID"
		Set tIdField="ID"
		Set tTableName="IRISDemo_Data.Tweets"
		
		Set tSC = $System.iKnow.IndexTable(..#NLPDOMAINNAME, tTableName, tIdField, tGroupField, tDataField, tMetadataFields,tWhere)
		$$$ThrowStatusExceptionIfError(tSC, "NLPIndexTableException")
		
		Set pSourceId=":SQL:"_pTweetId_":"_pTweetId		
	}
	
	ClassMethod NLPSentiment(pDomainId As %String, pSourceId As %String) As %String
	{
		Set tSentiment = ""
		
		Set tSC = ##class(%iKnow.Queries.SourceAPI).GetAttributes(.tResult, pDomainId, pExternalSourceId)
		$$$ThrowStatusExceptionIfError(tSC, "GetAttributesException")
		
		Set iSent=""
		Set tSentiment=""
		For
		{
			Set iSent=$Order(tResult(iSent))
			Quit:iSent=""
	
			Set sentList=tResult(iSent)
			Set tSentiment = $ListGet(sentList, 2)
		}
		
		Quit tSentiment
	}
}