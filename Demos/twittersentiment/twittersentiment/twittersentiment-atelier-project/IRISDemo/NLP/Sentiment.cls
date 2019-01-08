Include DEMOMACROS

Class IRISDemo.NLP.Sentiment
{
	/// <p>Throws exceptions</p>
	/// <p>This method is called by the IRISDemo.Data.Tweets class service to evaluate the sentiment of a tweet that has just been saved.</p>
	/// <p>NLP can help us to evaluate sentiment more precisely because:</p>
	/// <ol>
	///		<li>It can decompose the strings into proper normalized entities and apply dictionary to correct slangs and misspellings.</li> 
	/// 	<li>It can apply dictionaries to label entities as POSITIVE or NEGATIVE.</li>
	///		<li>It can evaluate if sentences have been negated. Negation evaluation is complex and relies on NLP's language model.</li> 
	/// </ol> 
	/// <p>As you can realize, sentiment analysis is not only about verifying if a string is on our text.</p>
	/// <p> The method will take an NLP ExternalSourceId and return an integer with the sentiment of the text:</p>
	/// <ul>
	///    <li>0: Neutral</li>
	///    <li>1: Positive</li>
	///    <li>2: Negative</li>
	/// </ul>
	ClassMethod EvaluateSentiment(pNLPDomainName As %String, pNLPExternalSourceId As %String, pVerbose As %Boolean = 0) As %Integer
	{			
		// The Domain Id is required by most API calls
		Set tDomainId = ##class(%SYSTEM.iKnow).GetDomainId(pNLPDomainName)
		If tDomainId="" $$$ThrowException("NLPDomainNotFoundException", pNLPDomainName) 

		// Required by SentenceAPI GetAttributes
		Set tSourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(tDomainId, pNLPExternalSourceId, .tSC)
		$$$ThrowStatusExceptionIfError(tSC, "NLPGetSourceIdException")
		
		Quit ..EvaluateSentimentWithSourceId(tDomainId, tSourceId, pVerbose)	
	}
	
	ClassMethod EvaluateSentimentWithSourceId(pNLPDomainNameOrId As %String, pNLPSourceId As %String, pVerbose As %Boolean = 0) As %Integer
	{	
		// By default, this will be a neutral text
		Set iSentiment = 0
		
		If pNLPDomainNameOrId?1.N
		{
			// Received the Domain Id (a number)
			Set tDomainId=pNLPDomainNameOrId
		}
		Else
		{
			// Received the domain name. Must transform it to the domain Id
			Set tDomainId = ##class(%SYSTEM.iKnow).GetDomainId(pNLPDomainNameOrId)
			If tDomainId="" $$$ThrowException("NLPDomainNotFoundException", pNLPDomainNameOrId) 			
		}

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
		Set tSC = ##class(%iKnow.Queries.SentenceAPI).GetBySource(.vSentences, tDomainId, pNLPSourceId)
		$$$ThrowStatusExceptionIfError(tSC, "NLPSentenceAPIGetBySourceException")
		
		If pVerbose
		{
			Write "----- API Info ----- "
			Write !
			ZWrite vSentences
			Write !
			
			// I wanted to see the CRCs to implement a better sentiment analysis algorithm, but I am not sure I know how.
			// I tried this with the following text: "I love this. But I am not a normal person. So I will have to say that I hate it."
			// And it will return me a single CRC: "am not"-"normal person"
			// The Text Analytics UI will also show only this CRC for this text. It's strange. Will check back with Benjamin later.
			Set tSC = ##class(%iKnow.Queries.CrcAPI).GetBySource(.vCRCs ,tDomainId,$ListBuild(pNLPSourceId))
			$$$ThrowStatusExceptionIfError(tSC, "CrcAPIGetBySourceException")
			
			Write !
			ZWrite vCRCs
			Write !
			Write "----- API Info ----- "
		}
		
		Set iSentenceNum=""
		For
		{
			Set iSentenceNum=$Order(vSentences(iSentenceNum))
			Quit:iSentenceNum=""
			
			Write:pVerbose !!,"* SENTENCE #",iSentenceNum," - "
			
			// Sentences are paths...
			Set iPathId=$ListGet(vSentences(iSentenceNum),1)
			
			// Let's get the list of entities in this path in order to see if there is enough context to
			// evaluate sentiment. Here, again, NLP is helping us by eliminating non-relevant words
			Set lPathValues = ##class(%iKnow.Queries.PathAPI).GetValue(tDomainId, iPathId,,.tSC)
			$$$ThrowStatusExceptionIfError(tSC, "GetValueException")
			
			If pVerbose For iVal=1:1:$ListLength(lPathValues) { Write $ListGet(lPathValues,iVal)_" " } Write " - "
			
			// We will not continue with this path if the number of relevant words is less than 3. 
			If $ListLength(lPathValues)<3
			{
				Write:pVerbose "Too short. Ignored."
				Continue
			}
						
			// This is an interesting path. Let's look at the labels that our dictionaries assigned to it
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
			
			If pVerbose Set tAttr="" For  { Set tAttr=$Order(vAttributes(tAttr)) Quit:tAttr=""  Write tAttr," " } Write " -> "
			
			// By default, we have a Neutral sentiment. We need to know if this is something else
			
			// Let's see if this looks like a negative sentiment:
			If $Data(vAttributes("sentpositive")) && $Data(vAttributes("negation"))
			{
				Set iSentiment=2
				Quit //Just one negative sentiment is enough. This is just a demo.
			} 
			
			If $Data(vAttributes("sentnegative")) && '$Data(vAttributes("negation"))
			{
				Set iSentiment=2
				Quit //Just one negative sentiment is enough. This is just a demo.
			}
			
			// Negative sentiments are our priority. If we are still here it is because
			// we could not find anything negative. Let's see if we can find something positive.
			// Positives must be categorical. Negating a negative sentiment is not being posistive:
			
			If $Data(vAttributes("sentpositive")) && '$Data(vAttributes("negation"))
			{
				Set iSentiment=1
				// Found this sentence to be positive. But others may be negative, so I will keep
				// going. If I don't find a negative sentiment on other sentences, this text
				// will be considered positive. This is not ideal, but this is just a demo.
			}
			
			Write:pVerbose $Case(iSentiment,0:"neutral",1:"positive",2:"negative")

		} //For
		
		Write:pVerbose !!,"**  General Sentiment: ",$Case(iSentiment,0:"neutral",1:"positive",2:"negative")
		
		Quit iSentiment		
	}
	
	ClassMethod Test()
	{
		Set tTestDomainName="TwitterAnalytics"
		
		Try
		{
			For
			{
				Write #,!,"Enter text:",!
				Read tText
				
				Quit:tText=""
				
				Set iIdentifier=$Increment(^NLP.Sentiment.Test)
				
				Write !!,"Indexing... "
				Set tSC = $System.iKnow.IndexString(tTestDomainName, iIdentifier, tText,,0, .tSrcId)
				$$$ThrowStatusExceptionIfError(tSC, "IndexStringException")
				
				Write "Source Id: ",tSrcId
				
				Write !!,"Evaluating sentiment:",!!
				Set iSentiment = ..EvaluateSentimentWithSourceId(tTestDomainName, tSrcId, 1)
				
				Read pause
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
			Do $System.Status.DisplayError(tSC)
		}
	}
}