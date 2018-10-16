Class IRISDemo.REST.Dispatcher Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter UseSession = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

XData UrlMap
{
<Routes>
 <Map Prefix="/Info" Forward="IRISDemo.DataEnrichmentService"/>
</Routes>
}

}
