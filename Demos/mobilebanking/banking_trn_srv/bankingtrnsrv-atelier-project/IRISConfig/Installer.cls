Include %occInclude

Class IRISConfig.Installer
{

/// This method is called by a RUN instruction inside your Dockerfile. It will
/// use environment variables defined on your Dockerfile to further parameterize
/// this setup.
ClassMethod Install()
{
	Set tSC = $$$OK
	Try
	{
		Set pVars("InstallDir")=$System.Util.GetEnviron("ISC_PACKAGE_INSTALLDIR")
		
		Set tSourceDir=$System.Util.GetEnviron("IRIS_APP_SOURCEDIR")
		If tSourceDir'="" Set pVars("SourceDir")=tSourceDir
		
		Set pVars("Namespace")=$System.Util.GetEnviron("IRIS_APP_NAME")
		If pVars("Namespace")=""
		{
			Set pVars("Namespace")="USER"
			Set pVars("UseUSERNamespace")=1
		}
		Else
		{
			Set pVars("UseUSERNamespace")=0
		}
		
		Set pVars("CSPAppName")=$ZConvert(pVars("Namespace"),"L")
		
		Set tSC = ..setup(.pVars, 2)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	/// This terminates this process with a exit value for the operating system so that
	/// Docker can know if everything worked fine or not.
	If $System.Status.IsError(tSC) 
	{ 
		Do $System.Status.DisplayError(tSC) // Show error message before exiting 
		Do $zu(4,$j,1)  // exit status 1
	} 
	Else 
	{ 
		Do $zu(4,$j,0) // exit status 0
	} 
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
     Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
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
		
		Set tSC = ##class(Ens.Config.Credentials).SetCredential("BankingCore", "SuperUser", "sys", 1)
		Quit:$System.Status.IsError(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
	Quit tSC 
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
	</Namespace>
</Manifest>
}
}