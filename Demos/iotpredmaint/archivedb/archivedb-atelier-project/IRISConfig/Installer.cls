Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

ClassMethod LoadTransactionalData(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace

		Set tImageBuildTS = $ZDateTime($H,3)
		
		Set oFileListRS = ##class(%ResultSet).%New("%Library.File:FileSet")
		
		Set tSC = oFileListRS.Execute("/tmp/data_files/","*.csv")
		Quit:$System.Status.IsError(tSC)
		
		While oFileListRS.Next()
		{
			Set tFileName = oFileListRS.Get("Name")
			
			Write !,"Loading file ",tFileName,"..."
			Set tSC = ##class(IRISDemo.DataLoadingUtils).LoadFullDataFromCSVFile(tFileName, tImageBuildTS)
			Quit:$System.Status.IsError(tSC)
			Write "Done!",!
			
			Write !,"Deleting file ",tFileName,"..."
			If ##class(%Library.File).Delete(tFileName) 
			{
				Write "Ok!",!
			}
			Else
			{
				Set tSC = $System.Status.DisplayError(5001,"Could not delete file "_tFileName)
				Quit
			}
		}
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC 
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<Namespace Name="${Namespace}" Create="no">
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>
        
        <Log Text="Creating Task to Send Transformer Signals to IOT Monitor Production..." Level="0"/>
        <Invoke Class="IRISDemo.SendSignalsToMonitorTask" Method="Create" CheckStatus="true"/>

	</Namespace>
	
	<Log Text="Loading transactional data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadTransactionalData" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Var Name="Password" Value="jsmith123!"/>
	<User Username="jsmith" Fullname="John Smith" Enabled="true" Roles="AppRole" PasswordVar="Password"/>

</Manifest>
}
}