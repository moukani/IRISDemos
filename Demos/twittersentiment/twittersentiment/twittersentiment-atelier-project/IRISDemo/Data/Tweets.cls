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
			Set ..Sentiment=0
			Set bChanged=1
		}
		
		// If we don't have an ID, the trigger has never been called, so NLPExternalSourceId will be invalid
		// This tweet's data is not still on the NLP domain...
		If ..%Id()="" 
		{
			Write !,"Saving ",..TwitterId
			
			Set tSC = ..%Save()
			$$$ThrowStatusExceptionIfError(tSC, "PersistingTweetException")
		}
		Else
		{
			Write !,"NOT SAVING ",..TwitterId
		}
		
		// The Domain Id is required by most API calls
		Set tDomainId = ##class(%SYSTEM.iKnow).GetDomainId("TwitterAnalytics")
		If tDomainId="" $$$ThrowException("NLPDomainNotFoundException", "TwitterAnalytics") 
		
		// Required by SentenceAPI GetAttributes
		Set tSourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(tDomainId, ..NLPExternalSourceId, .tSC)
		$$$ThrowStatusExceptionIfError(tSC, "NLPGetSourceIdException")
		
		/* 
		
		NLP structures text in the following way:
		- A tweet is a Source
		- A source has Sentences. Sentences are paths.
		- A path has entities in the form Concept-Relation-Concept (CRC) and can have many entities such as CRCRC...
		
		A tweet can have one or more sentences. Each can have a negative sentiment or not. Let's say that
		a negative sentiment is represented by the SENTNEGATIVE label while a positive sentiment is represented by 
		the SENTPOSITIVE label. 
		
		The catch is that a sentence can be negated. While "This is a very bad product" is clearly a SENTPOSITIVE,
		"This is not such a bad product" is not. The negation, negates the bad sentiment. 
		
		To find out if we have a negative sentiment, we must find on our tweet:
		- SENTPOSITIVE labels with negation
		- SENTNEGATIVE labels without negation
		
		Both would result in a SENTNEGATIVE. As we want to analyze this for each sentence on our
		tweet, we are going to use the SentenceAPI:
		
		*/

		// Sources have sentences, let's get the sentences:			
		Set tSC = ##class(%iKnow.Queries.SentenceAPI).GetBySource(.vSentences, tDomainId, tSourceId)
		$$$ThrowStatusExceptionIfError(tSC, "NLPSentenceAPIGetBySourceException")
					
		Set iSentenceNum=""
		For
		{
			Set iSentenceNum=$Order(vSentences(iSentenceNum))
			Quit:iSentenceNum=""
			
			// Sentences are paths...
			Set iPathId=$ListGet(vSentences(iSentenceNum),1)
			
			// Let's get the list of entities in this path in order to see if there is enough context to
			// evaluate sentiment. Here, again, NLP is helping us by eliminating non-relevant words
			Set lPathValues = ##class(%iKnow.Queries.PathAPI).GetValue(tDomainId, iPathId,,.tSC)
			$$$ThrowStatusExceptionIfError(tSC, "GetValueException")

			// We will not continue with this path if the number of relevant words is less than 3. 
			Continue:$ListLength(lPathValues)<3
			
			Set tSC = ##class(%iKnow.Queries.PathAPI).GetAttributes(.vPathAttributesResult, tDomainId, iPathId)
			$$$ThrowStatusExceptionIfError(tSC, "GetAttributesException")
			
			// Let's index the attributes so we can easily query them:
			Set iAttr=""
			For 
			{
				Set iAttr=$Order(vPathAttributesResult(iAttr))
				Quit:iAttr=""
				
				Set tAttr = $ListGet(vPathAttributesResult(iAttr),2)
				Continue:tAttr=""
				
				Set vAttributes(tAttr)=""
			}
			
			// By default, we have a Neutral sentiment. We need to know if this is something else
			
			// Let's see if this looks like a negative sentiment:
			If $Data(vAttributes("sentpositive")) && $Data(vAttributes("negation"))
			{
				Set ..Sentiment=2
				Quit //Just one negative sentiment is enough
			} 
			
			If $Data(vAttributes("sentnegative")) && '$Data(vAttributes("negation"))
			{
				Set ..Sentiment=2
				Quit //Just one negative sentiment is enough
			}
			
			// Negative sentiments are our priority. If we are still here it is because
			// we could not find anything negative. Let's see if we can find something positive.
			// Positives must be categorical. Negating a negative sentiment is not being posistive:
			
			If $Data(vAttributes("sentpositive")) && '$Data(vAttributes("negation"))
			{
				Set ..Sentiment=1
				Quit // Found this tweet to be exclusively positive.
			}

		} //For
		
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