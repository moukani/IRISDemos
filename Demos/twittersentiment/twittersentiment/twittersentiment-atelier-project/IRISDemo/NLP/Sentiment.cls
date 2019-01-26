Include (DEMOMACROS, %IKPublic)

Class IRISDemo.NLP.Sentiment
{
	/// <p>Throws exceptions</p>
	/// <p>This method is called by the IRISDemo.Data.Tweets class service to evaluate the sentiment of a tweet that has just been saved.</p>
	/// <p>NLP can help us to evaluate sentiment more precisely because:</p>
	/// <ol>
	///		<li>It can decompose the strings into proper normalized entities and apply dictionary to correct slangs and misspellings.</li> 
	/// 	<li>It can apply dictionaries to label entities as POSITIVE or NEGATIVE.</li>
	///		<li>It can evaluate if sentences have been negated. Negation evaluation is complex and relies on NLP's language model.</li>
	///		<li>It can evaluate if business terms are being mentioned based on a NLP matching dictionary and give more importance to these sentences.</li>
	///		<li>It will compute a positive or negative score based on the positive and negative feeling</li> 
	/// </ol> 
	/// <p>As you can realize, sentiment analysis is not only about verifying if a string is on our text.</p>
	/// <p> The method will take an NLP ExternalSourceId and return a float with its score (that can be positive or negative).</p>
	ClassMethod EvaluateSentiment(pNLPDomainName As %String, pNLPExternalSourceId As %String, Output pScorePerBusinessTerm As %String, pVerbose As %Boolean = 0) As %Integer
	{			
		// The Domain Id is required by most API calls
		Set tDomainId = ##class(%SYSTEM.iKnow).GetDomainId(pNLPDomainName)
		If tDomainId="" $$$ThrowException("NLPDomainNotFoundException", pNLPDomainName) 

		// Required by SentenceAPI GetAttributes
		Set tSourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(tDomainId, pNLPExternalSourceId, .tSC)
		$$$ThrowStatusExceptionIfError(tSC, "NLPGetSourceIdException")
		
		Quit ..EvaluateSentimentWithSourceId(tDomainId, tSourceId, .pScorePerBusinessTerm, pVerbose)	
	}
	
	ClassMethod EvaluateSentimentWithSourceId(pNLPDomainNameOrId As %String, pNLPSourceId As %String, Output pScorePerBusinessTerm As %String, pVerbose As %Boolean = 0) As %Integer
	{	
		// By default, this will be a neutral text
		Set iSentimentScore=0
		Kill pScorePerBusinessTerm
		
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
		
		Write:pVerbose !,"Using domain with ID ",tDomainId,!
		
		// We will be using this matching dictionary in order to focus on sentences that are directly related to our business
		Set tMatchingDictId = ##class(%iKnow.Matching.DictionaryAPI).GetDictionaryId(tDomainId, "BusinessMatchingDictionary", .tSC)
		$$$ThrowStatusExceptionIfError(tSC, "NLPGetDictionaryIdException")
		
		Write:pVerbose !,"Using business matching dictionary with ID ",tMatchingDictId,!
		/* 
		
		NLP structures text in the following way:
		- A tweet is a Source
		- A source has Sentences. Sentences are paths.
		- A path has entities in the form Concept-Relation-Concept (CRC) and can have many entities such as CRCRC...
		
		A tweet can have one or more sentences. Each can have a negative sentiment or not. Let's say that
		a negative sentiment is represented by the SENTNEGATIVE label while a positive sentiment is represented by 
		the SENTPOSITIVE label. 
		
		The catch is that a sentence can be negated. While "This is a very bad product" is clearly a SENTPOSITIVE,
		"This is not such a bad product" is not. The negation, negates the bad sentiment. But it is not a positive
		sentiment either...
		
		So, instead of categoricaly stating our tweets as neutral, positive or negative, we will be giving
		them a score. Also, a sentence that mention words that are connected to our business will have more weight (positive
		or negative) on the final score.  
		
		*/

		// Sources have sentences, let's get the sentences:			
		Set tSC = ##class(%iKnow.Queries.SentenceAPI).GetBySource(.vSentences, tDomainId, pNLPSourceId, 1, 20)
		$$$ThrowStatusExceptionIfError(tSC, "NLPSentenceAPIGetBySourceException")
		
		// Dominance will not help us too much on such short texts from twitter.
		//set tSC = ##class(%iKnow.Semantics.DominanceAPI).GetBySource(.vPaths, tDomainId, pNLPSourceId, 0, 0, $$$SDPATH)
		//$$$ThrowStatusExceptionIfError(tSC, "NLPDominanceAPIGetBySourceException")
		
		If pVerbose
		{
			Write !,"----- API Info Sentences ----- "
			Write !
			ZWrite vSentences
			Write !

			// I wanted to see the CRCs to implement a better sentiment analysis algorithm, but I am not sure I know how.
			// I tried this with the following text: "I love this. But I am not a normal person. So I will have to say that I hate it."
			// And it will return me a single CRC: "am not"-"normal person"
			// The Text Analytics UI will also show only this CRC for this text. It's strange. Will check back with Benjamin later.
			
			/*
			Set tSC = ##class(%iKnow.Queries.CrcAPI).GetBySource(.vCRCs ,tDomainId,$ListBuild(pNLPSourceId), 1, 20)
			$$$ThrowStatusExceptionIfError(tSC, "CrcAPIGetBySourceException")
			
			Write !
			ZWrite vCRCs
			Write !
			*/
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
			
			If pVerbose For iVal=1:1:$ListLength(lPathValues) { Write $ListGet(lPathValues,iVal)_" " }
									
			// This is an interesting path. Let's look at the labels that our dictionaries assigned to it
			Kill vPathAttributesResult
			Set tSC = ##class(%iKnow.Queries.PathAPI).GetAttributes(.vPathAttributesResult, tDomainId, iPathId)
			$$$ThrowStatusExceptionIfError(tSC, "GetAttributesException")
			
			// Let's index the attributes so we can easily query them:
			Set iAttr=""
			Kill vAttributes
			For 
			{
				Set iAttr=$Order(vPathAttributesResult(iAttr))
				Quit:iAttr=""
				
				Set tAttr = $ListGet(vPathAttributesResult(iAttr),2)
				Continue:tAttr=""
				
				Set vAttributes(tAttr)=""
			}
			
			If pVerbose Write " - " Set tAttr="" For  { Set tAttr=$Order(vAttributes(tAttr)) Quit:tAttr=""  Write tAttr," " }
			
			// Business Dictionary Matching
			Kill vMatches
			Set tSC = ##class(%iKnow.Matching.MatchingAPI).GetMatchesByPath(.vMatches, tDomainId, iPathId, $ListBuild(tMatchingDictId))
			$$$ThrowStatusExceptionIfError(tSC, "NLPGetMatchesByPathException")
						
			Set iMatch=""
			Set iSentimentMultiplier=1
			Kill vPathURIs
			For
			{
				Set iMatch=$Order(vMatches(iMatch))
				Quit:iMatch=""
				
				Set tURI=$ListGet(vMatches(iMatch), 4)
				
				// So we can report what broader business category this text is about and route appropriately
				Set vPathURIs(tURI)=""
				
				// If this specific sentence is directly connected to our business, then we should increase its score
				Set iSentimentMultiplier=1.2 
			}
						
			If pVerbose
			{
				Set terms=""
				Set term="" For iTerm=1:1  Set term=$Order(vPathURIs(term)) Quit:term=""  Set $Piece(terms,",",iTerm)=term
				
				Write " - ",terms
			}
			
			// By default, we have a Neutral sentiment. We need to know if this is something else
			
			//Improvements:
			// - Use attributes properties to store the word weights
			// - Use Matching Dictionaries to find concepts that are important for us. Sentiment about concepts
			//   that are not important for us should have lower weights on our final score 
			// - Return the CONCEPTS that have been on sentences with negative sentiment 
			
			Set iSentiment=0
			
			// Let's see if this looks like a negative sentiment:
			If $Data(vAttributes("sentpositive")) && $Data(vAttributes("negation"))
			{
				Set iSentiment=-1 //Negative
			} 
			ElseIf $Data(vAttributes("sentnegative")) && '$Data(vAttributes("negation"))
			{
				Set iSentiment=-1 //Negative
			}
			ElseIf $Data(vAttributes("sentpositive")) && '$Data(vAttributes("negation"))
			{
				Set iSentiment=1 //Positive
			}
			
			Set iSentiment=iSentiment*iSentimentMultiplier
			Write:pVerbose ": ",iSentiment
			
			Set iSentimentScore=iSentimentScore+iSentiment
			
			If iSentiment'=0
			{
				Set term="" 
				For iTerm=0:1  
				{
					Set term=$Order(vPathURIs(term))
					Quit:term=""  
					
					Set termSuffix=$Piece(term, ":", 2)
					Set pScorePerBusinessTerm(termSuffix)=$Get(pScorePerBusinessTerm(termSuffix))+iSentiment
				}
				
				// If no business term were found on this sentence:
				If iTerm=0
				{
					Set pScorePerBusinessTerm("others")=$Get(pScorePerBusinessTerm("others"))+iSentiment
				}
			}
			
		} //For
				
		Quit iSentimentScore	
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
				
				Write !!,"Evaluating sentiment:",!!
				Set iSentimentScore = ..EvaluateSentimentWithSourceId(tTestDomainName, tSrcId, .vScorePerBusinessTerm, 1)
				
				Write !,"Sentiment score: ",iSentimentScore
				Write !,"Score per business term: ",!
				ZWrite vScorePerBusinessTerm
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