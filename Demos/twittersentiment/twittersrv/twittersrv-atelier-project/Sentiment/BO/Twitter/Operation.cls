Include DEMOMACROS

Class Sentiment.BO.Twitter.Operation extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method EvaluateSentiment(pInput As Sentiment.BO.Twitter.EvaluateSentimentReq, Output pOutput As Ens.Response) As %Status
{
	Set tSC = $$$OK
	Try
	{
		
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	Quit tSC
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="Sentiment.BO.Twitter.EvaluateSentimentReq">
        <Method>EvaluateSentiment</Method>
    </MapItem>
</MapItems>
}

}