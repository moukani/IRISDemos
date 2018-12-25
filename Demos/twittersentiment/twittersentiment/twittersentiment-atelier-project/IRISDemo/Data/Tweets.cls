Include DEMOMACROS

Class IRISDemo.Data.Tweets Extends %Persistent
{
	Property TwitterId As %BigInt [ Required ];
	
	Property TwitterText As %String (MAXLEN="") [ Required ];

	Property TwitterUser As %String [ Required ];
	
	/// By default, people will say only nice things about us. The REST service will
	/// only change this to TRUE if a tweet comes in with negative sentiment.
	Property Sentiment As %String (VALUELIST=",0,1,2", DISPLAYLIST=",Neutral,Positive,Negative") [ InitialExpression = 0, Required ];
	
	Property NLPExternalSourceId As %String [ SqlComputed, SqlComputeCode = {Set {NLPExternalSourceId}=":SQL:"_{TwitterUser}_":"_{TwitterId} } ];
		
	Index TwitterIdIndex On TwitterId [ Unique ];
	
	Trigger OnAddOrUpdate [Event = INSERT/UPDATE, Foreach = row/object, Time = AFTER ]
	{
		// A trigger runs inside a TRANSACTION. So it is all or nothing. If we throw an error
		// here, we will rollback the entire transaction, which is good.
		
		// A trigger is different from a method. There is not scope. So we must New the variable
		// names we create in order to prevent reusing an existing variable from another "scope".
		New tDomainId,oNLPSQLLister,tMetadataFields,tDataField,tGroupField,tIdField,tTableName,tQuery,tSC,tSourceId,tID
		
		// We are going to need the DomainId to create the Lister and call other API methods
		Set tDomainId = ##class(%SYSTEM.iKnow).GetDomainId("TwitterAnalytics")
		// One way of returning an error is by setting the variables %ok and %msg. But throwing
		// an exception is much more elegant. IRIS will catch the exception and do the rest for us.
		If tDomainId="" $$$ThrowException("NLPDomainNotFoundException", "TwitterAnalytics") 

		// We only want to populate the NLP Domain once. If we did that already
		// we don't want to do it again. I will find out how to do that in the future.
		// So we will try to find the internal SourceId for our ExternalSourceId. If we don't find
		// one, it is safe to assume this is a brand new tweet that needs to be populated into the domain
		Set tSourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(tDomainId, {NLPExternalSourceId*N}, .tSCIgnored)

		// Found it! So, we have already saved this tweet's data on the domain.
		// Until we find a way to update the domain data for a single record, we 
		// will not allow updating the domain data, but we will allow updating other
		// fields of the object for additional metadata we want to store in the future
		If tSourceId'="" Quit
		
		// Ok, that is brand new tweet. Let's populate the domain with its data
				
		// The lister is responsible for running our query and using its fields as TEXT and METADATE to
		// populate the domain
		SET oNLPSQLLister = ##class(%iKnow.Source.SQL.Lister).%New(tDomainId)
		
		// Populatig the variables we are going to use to call the Lister
		Set tMetadataFields=$ListBuild("TwitterId", "TwitterUser")
		Set tDataField="TwitterText"
		Set tGroupField="TWitterUser"
		Set tIdField="TwitterId"
		Set tTableName="IRISDemo_Data.Tweets"
		Set tQuery="select TwitterId, TwitterUser, TwitterText from IRISDemo_Data.Tweets where ID='"_{ID*N}_"'"
		
		// Calling the Lister (internally the lister use a Loader)
		Set tSC = oNLPSQLLister.ProcessList(tQuery, tIdField, tGroupField, tDataField, tMetadataFields)
		$$$ThrowStatusExceptionIfError(tSC, "NLPSQLListerProcessListException")		
	}
	
	ClassMethod OpenByTweetId(pTweetId As %String) As IRISDemo.Data.Tweets
	{
		Quit ..TwitterIdIndexOpen(pTweetId)
	}
	
	/// <p>Throws exceptions</p>
	/// <p>This method must is called by the REST service to evaluate the sentiment of a tweet that has just been saved.</p>
	/// <p>NLP can help us to evaluate sentiment more precisely because:</p>
	/// <ol>
	///		<li>It can decompose the strings into proper normalized entities and apply dictionary to correct slangs and misspellings.</li> 
	/// 	<li>It can apply dictionaries to label entities as POSITIVE or NEGATIVE.</li>
	///		<li>It can evaluate if sentences have been negated. Negation evaluation is complex and relies on NLP's language model.</li> 
	/// </ol> 
	/// <p>As you can realize, sentiment analysis is not only about verifying if a string is on our text.</p> 
	Method EvaluateSentiment()
	{
		// If we change this object, we will save it again at the end
		Set bChanged=0
		
		// By default, people only say nice things
		
		If ..Sentiment'=0
		{
			// I am using this to avoid persisting an object that hasn't changed.
			// But I am almost sure %Save is smart enough to detect that by itself
			// and avoid the work. I should check this in the future.
			Set ..Sentiment=0
			Set bChanged=1 
		}
		
		// If we don't have an ID, the trigger has never been called, so NLPExternalSourceId will be invalid
		// This tweet's data is not still on the NLP domain...
		If ..%Id()="" 
		{
			Set tSC = ..%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PersistingTweetException")
		}
				
		Set ..Sentiment = ##class(IRISDemo.NLP.Sentiment).EvaluateSentiment("TwitterAnalytics", ..NLPExternalSourceId)
		
		// If we changed the object in a way or the other...
		If bChanged || (..Sentiment'=0)
		{
			Set tSC = ..%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PersistUpdatedSentimentException")
		}
	}
	
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
<Value>NLPExternalSourceId</Value>
</Value>
<Value name="6">
<Value>HasNegativeSentiment</Value>
</Value>
<Value name="7">
<Value>NLPSourceId</Value>
</Value>
<Value name="8">
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