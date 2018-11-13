Include DEMOMACROS

Class IRISDemo.DataLoadingUtils
{	
	Parameter OVERFLOWDIR = "/to_iotmon/";
	
	/// This is called from IRISDemo.Installer to create the user merchants, 
	/// customer accounts and transactions between them
	ClassMethod LoadFullDataFromCSVFile(pFileName As %String, pImageBuildTS As %TimeStamp) As %Status
	{
		#Dim oRSInsert As %SQL.Statement
		#Dim oSignal As IRISDemo.TransformerSignal
		
		Set tSC = $$$OK
		Try
		{
			DO DISABLE^%NOJRN
			
			//TODO:
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		DO ENABLE^%NOJRN
				
		Quit tSC
	}
}