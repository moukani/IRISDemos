Include DEMOMACROS

Class IRISDemo.DataLoadingUtils
{
	/// This is called from IRISDemo.Installer to load the white list that 
	/// was exported from the datalake
	ClassMethod LoadWhiteList(pFileName As %String) As %Status
	{
		#Dim oTrans As IRISDemo.Trans
		
		Set tSC = $$$OK
		Try
		{
			//TODO:
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		DO ENABLE^%NOJRN
		
		Do $System.SQL.SetIdentityInsert(0)
				
		Quit tSC
	}
}