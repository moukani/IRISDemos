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
	
	ClassMethod StoreAndAnalyse() As %Status
	{
		Set tSC = $$$OK
		Set SentimentResult = ""
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			Set twitter = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set tweet = ##class(IRISDemo.Data.Tweets).%New()
			Set tweet.TwitterId = twitter.id 
			Set tweet.TwitterUser = twitter.user
			Set tweet.TwitterText = twitter.text
			
			Set domainId = ##class(%SYSTEM.iKnow).GetDomainId("TwitterAnalytics")
	
			Do ##class(%SYSTEM.iKnow).IndexString("TwitterAnalytics",twitter.id,twitter.text,,1,.vSrcId)
		
			Do ##class(%iKnow.Queries.SourceAPI).GetAttributes(.tResult, domainId, vSrcId)
	    
			Set iSent=""

			For
			{
				Set iSent=$Order(tResult(iSent))
				Quit:iSent=""
		
				Set sentList=tResult(iSent)
				Set sent = $ListGet(sentList, 2)
				Set SentimentResult = sent
			   
			}
			
			Set tweet.Sentiment = SentimentResult
			
			Set tSC = tweet.%Save()
			
			Do ##class(%SYSTEM.iKnow).DeleteVirtualSource("Twitter",vSrcId)
			
			Set result = {"sentiment": (SentimentResult)}
			
			Write result.%ToJSON()
		
		}
		
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}
}