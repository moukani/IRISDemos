Class IRISDemo.DataEnrichmentService Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/GetInfo" Method="POST" Call="GetInfo"/>
</Routes>
}

ClassMethod GetInfo()
{
	#Dim %request As %CSP.Request
	#Dim obj As %DynamicObject
	
	Set obj = %request.Content

	#Dim from As IRISDemo.CustomerAccount
	Do ##class(IRISDemo.CustomerAccount).OpenOrCreateByNumber(obj.FromAccountNumber, .from)
	
	Set obj.FromAge = $NORMALIZE(from.Age,0)
	Set obj.FromCity = from.City
	Set obj.FromGender = from.Gender
	Set obj.FromAccountAge = from.AccountAge
	
	#Dim to As IRISDemo.MerchantAccount
	Do ##class(IRISDemo.MerchantAccount).OpenOrCreateByNumber(obj.ToAccountNumber, .to)	

	Set obj.ToCity = to.City
	Set obj.ToAccountAge = to.AccountAge
	
	Write ""
	Do obj.%ToJSON()
	Quit $$$OK
}

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	Set pContinue = $$$OK
    Quit ..ConvertRequestBody()
}

/// Converts request into UTF8. Converts request into dynamic object 
ClassMethod ConvertRequestBody() As %Status
{
	#Dim %request As %CSP.Request
	#Dim obj As %DynamicObject

	Quit:'$isobject(%request.Content) $$$OK //empty request body - nothing to do

	// Convert request body into UTF8 proxyObject
	Set content = %request.Content.Read($$$MaxStringLength)
	Set content = $ZCVT(content,"I","UTF8")
	Set obj = {}.%FromJSON(content)

	Set %request.Content = obj // obj here is a valid UTF8 proxyObject with required property
	Quit $$$OK
}

}
