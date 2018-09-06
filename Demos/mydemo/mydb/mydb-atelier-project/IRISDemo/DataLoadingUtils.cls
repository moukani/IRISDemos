Class IRISDemo.DataLoadingUtils
{
	/// This is called from IRISDemo.Installer to create the user merchants, 
	/// customer accounts and transactions between them
	ClassMethod LoadFullDataFromCSVFile(pFileName As %String) As %Status
	{
		#Dim oTrans As IRISDemo.Trans
		
		Set tSC = $$$OK
		Try
		{
			DO DISABLE^%NOJRN
			
			Set iLine=0 //Header is consumed
			
			Set oRSRecords=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV")
			Set tSC = oRSRecords.Execute(pFileName)
			Quit:$System.Status.IsError(tSC)
						
			While oRSRecords.Next()
			{
				Set iLine=iLine+1
				
				Set product = ##class(IRISDemo.product).%New()
				Set product.name=oRSRecords.Get("Name")
				//Set product.name=oRSRecords.GetData(1)
				
				Set tSC = product.%Save()
				Quit:$System.Status.IsError(tSC)
				//If $System.Status.IsError(tSC) Quit
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		DO ENABLE^%NOJRN
				
		Quit tSC
	}
}