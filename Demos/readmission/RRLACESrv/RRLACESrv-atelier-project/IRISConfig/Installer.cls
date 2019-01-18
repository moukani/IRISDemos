Include %occInclude 

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

ClassMethod LoadTransactionalData(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		
		Do ##class(IRISDemo.Data.Utils).LoadDemoData()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC 
}

ClassMethod ExportPatients(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		
		Do ##class(IRISDemo.Data.Utils).ExportPatients()
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
	</Namespace>
	
	<Log Text="Loading transactional data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadTransactionalData" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	<Log Text="Exporting data for HIS Database..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="ExportPatients" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>


</Manifest>
}
}