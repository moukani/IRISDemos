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
		Try
		{
		
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}
}