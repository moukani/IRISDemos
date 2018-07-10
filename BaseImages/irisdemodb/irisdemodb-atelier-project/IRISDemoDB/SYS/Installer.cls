Include %occInclude

Class IRISDemoDB.SYS.Installer
{

ClassMethod AuthAllowed()
{
	Quit $$$AutheUnauthenticated+$$$AutheCache+$$$AutheDelegated
}

ClassMethod AuthForCSP()
{
	Quit $$$AutheCache+$$$AutheDelegated
}

ClassMethod AuthForInt()
{
	Quit $$$AutheUnauthenticated
}

/// This method is called by a RUN instruction inside your Dockerfile. It will
/// use environment variables defined on your Dockerfile to further parameterize
/// this setup.
ClassMethod Install()
{
	Try
	{
		Set pVars("InstallDir")=$System.Util.GetEnviron("ISC_PACKAGE_INSTALLDIR")
		
		Set tSourceDir=$System.Util.GetEnviron("IRIS_APP_SOURCEDIR")
		If tSourceDir'="" Set pVars("SourceDir")=tSourceDir
		
		Set pVars("Namespace")=$System.Util.GetEnviron("IRIS_APP_NAME")
		If pVars("Namespace")=""
		{
			Set tSC = $System.Status.Error(5001,"IRIS_APP_NAME environment variable is not set")
			Quit
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

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	
	<Log Text="Configuring namespace ${Namespace}..." Level="0"/>
	
	<Resource Name="%DB_APP" Description="Resource used to protect the application"/>
	<Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_APP:RW,%DB_IRISSYS:R" />
	
	<Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="0" Data="${Namespace}">
		<Configuration>
				<Database Name="${Namespace}" Dir="${MGRDIR}${Namespace}" Create="yes" MountRequired="1" Resource="%DB_APP}"/>
		</Configuration>
	</Namespace>
	
	<Log Text="Creating CSP Applications for ${Namespace}..." Level="0"/>
	<Namespace Name="${Namespace}" Create="no">
		<CSPApplication Url="/csp/${CSPAppName}" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISDemoDB.SYS.Installer).AuthForCSP()}" IsNamespaceDefault="true" Grant="AppRole" CookiePath="/csp/${CSPAppName}" Recurse="true" />
		<CSPApplication Url="/csp/${CSPAppName}/services" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISDemoDB.SYS.Installer).AuthForCSP()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}" Recurse="true"/>
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>
	</Namespace>

</Manifest>
}
}