Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

ClassMethod LoadTransactionalData(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		
		Set tSC = ##class(IRISDemo.DataLoadingUtils).LoadFullDataFromCSVFile("/tmp/training_set.csv")
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC 
}

ClassMethod FixDSW() As %Status
{
	Set ^%SYS("CSP","DefaultFileCharset")="utf-8"
	Quit $$$OK
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

	<Invoke Class="IRISConfig.InstallerBase" Method="CSPAppEnableAnalytics" CheckStatus="false">
		<Arg name="pCSPAppName" Value="/csp/${Namespace}"/>
	</Invoke>
	
	<Namespace Name="${Namespace}" Create="no">
	<Invoke Class="IRISConfig.Installer" Method="FixDSW" CheckStatus="false" />
	
	<Compile Class="BI.Transactions" IgnoreErrors="true"/>
	
	<Log Text="Building cubes..." Level="0"/>	
	<Invoke Class="%DeepSee.Utils" Method="%BuildCube" CheckStatus="false">
		<Arg name="pCubeName" Value="Transactions"/>
	</Invoke>

		<Invoke Class="%DeepSee.Utils" Method="%BuildCube" CheckStatus="false">
		<Arg name="pCubeName" Value="Accounts"/>
	</Invoke>
	
	<Import File="/tmp/installers/" Recurse="true"/>
	
	<Invoke Class="MDX2JSON.Installer" Method="setup" CheckStatus="true" />

	<Invoke Class="DSW.Installer" Method="setup" CheckStatus="true" />
	</Namespace>
</Manifest>
}
}