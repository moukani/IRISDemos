Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

ClassMethod LoadTransactionalData(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		
		//Set tSC = ##class(IRISDemo.DataLoadingUtils).LoadWhiteList("/tmp/whitelist.csv")
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC
}

/// This method will create an Interoperability credential meant to be used on Interoperability Productions.
/// It will use the standard SuperUser/sys password for demos.
ClassMethod CreateCredentials(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set tNS=$Namespace
		ZN pNamespace
		
		Set tSC = ##class(Ens.Config.Credentials).SetCredential("ArchiveDB", "SuperUser", "sys", 1)
		Quit:$System.Status.IsError(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
	Quit tSC
}

ClassMethod CreateWebApp(pVars, pLogLevel, tInstaller) As %Status
{
	Set Namespace=tInstaller.Evaluate("${Namespace}")
	Do tInstaller.PushNS("%SYS")
	Do ##class(Security.System).GetInstallationSecuritySetting(.security)
	Set cspProperties("AutheEnabled") = 32
	Set cspProperties("NameSpace") = Namespace
	Set cspProperties("GroupById") = "wf"
	Set cspProperties("CookiePath") = "/wf/"
	Set cspProperties("IsNameSpaceDefault") = $$$NO
	Set cspProperties("DispatchClass") = "Workflow.REST"
	Set tSC = ##class(Security.Applications).Create("/wf/rest", .cspProperties)
	Do tInstaller.PopNS()
	If $$$ISERR(tSC) Throw ##class(%Installer.Exception).CreateFromStatus(tSC)
	Quit $$$OK
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	
	<Log Text="Configuring credentials..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="CreateCredentials" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Namespace Name="${Namespace}" Create="no">
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>
        <Import File="/tmp/installers/" Recurse="true"/>
        <CSPApplication Url="/wf" Recurse="1"  AuthenticationMethods="32" AutoCompile="1" CookiePath="/wf/" CSPZENEnabled="1" GroupById="wf" Directory="/shared/WorkflowUI/workflow/" />
	    <RunInstall Class="IRISConfig.Installer" Method="CreateWebApp"/>
	</Namespace>
	
	<Log Text="Loading transactional data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadTransactionalData" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Var Name="Password" Value="jsmith123!"/>
	<User Username="jsmith" Fullname="John Smith" Enabled="true" Roles="AppRole" PasswordVar="Password"/>
	
	<Invoke Class="IRISConfig.Installer" Method="AddWFRole" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pRoleName" Value="Maintenance Team"/>
	</Invoke>
	
	<Invoke Class="IRISConfig.Installer" Method="AddWFUser" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pUserName" Value="jsmith"/>
		<Arg name="pFullName" Value="John Smith"/>
		<Arg name="pRoleName" Value="Maintenance Team"/>
	</Invoke>

	<Invoke Class="IRISConfig.Installer" Method="AddWFUser" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pUserName" Value="SuperUser"/>
		<Arg name="pFullName" Value="Jane Smith"/>
		<Arg name="pRoleName" Value="Maintenance Team"/>
	</Invoke>
	
</Manifest>
}

}
