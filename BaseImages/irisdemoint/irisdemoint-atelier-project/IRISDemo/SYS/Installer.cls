Include %occInclude

Class IRISDemo.SYS.Installer
{

ClassMethod AuthAllowed()
{
	Quit $$$AutheUnauthenticated+$$$AutheCache+$$$AutheDelegated
}

ClassMethod AuthForSMP() As %Integer
{
	Quit $$$AutheNormal
}

ClassMethod AuthForREST()
{
	Quit $$$AutheLoginToken+$$$AutheCache
}

ClassMethod AuthForSOAP()
{
	Quit $$$AutheUnauthenticated
}

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

ClassMethod ConfigureAutoStart(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		
		Set tSC = ##class(Ens.Director).SetAutoStart("IRISDemo.Production", 0)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC 
}

ClassMethod ConfigureAsRESTCSPApp(pCSPAppName) As %Status
{
	Set tSC = $System.Status.OK()
	Try
	{
		Set oCSPApp = ##class(Security.Applications).%OpenId(pCSPAppName, , .tSC)

		Set oCSPApp.DispatchClass="IRISDemo.REST.Dispatcher"
		Set oCSPApp.UseCookies=1
		Set tSC = oCSPApp.%Save()
		Quit:$System.Status.IsError(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}

	Quit tSC
}

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	
	<Log Text="Configuring roles for ${Namespace}..." Level="0"/>
	<Resource Name="%DB_APP" Description="Resource used to protect the application"/>
	<Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_APP:RW,%DB_IRISSYS:R" />
	
	<Log Text="Configuring namespace ${Namespace}..." Level="0"/>
	<Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="1" Data="${Namespace}">
		<Configuration>
				<Database Name="${Namespace}" Dir="${MGRDIR}${Namespace}" Create="yes" MountRequired="1" Resource="%DB_APP}"/>
		</Configuration>
	</Namespace>
	
	<Log Text="Creating CSP Applications for ${Namespace}..." Level="0"/>
	<Namespace Name="${Namespace}" Create="no">
		<CSPApplication Url="/csp/${CSPAppName}" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISDemo.SYS.Installer).AuthForSMP()}" IsNamespaceDefault="true" CookiePath="/csp/${CSPAppName}" AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="%ISCMgtPortal" Resource="%Ens_Portal"/>
		<CSPApplication Url="/csp/${CSPAppName}/soap" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISDemo.SYS.Installer).AuthForSOAP()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}/soap" Recurse="true"  AutoCompile="false" CSPZENEnabled="false" InboundWebServicesEnabled="true" GroupById="${CSPAppName}"/>
		
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>

		<CSPApplication Url="/csp/${CSPAppName}/rest" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISDemo.SYS.Installer).AuthForREST()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}/rest" Recurse="true"  AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="${CSPAppName}" DispatchClass="IRISDemo.REST.Dispatcher"  UseSessionCookie="1" PermittedClasses='1""IRISDemo.REST."".E'/>
	</Namespace>
	
	<Log Text="Applying additional configurations to the new REST CSP Application..." Level="0"/>
	<Invoke Class="IRISDemo.SYS.Installer" Method="ConfigureAsRESTCSPApp" CheckStatus="true">
		<Arg name="pCSPAppName" Value="/csp/${CSPAppName}/rest"/>
	</Invoke>

	<Log Text="Configuring production IRISDemo.Production to auto-start." Level="0"/>
	<Invoke Class="IRISDemo.SYS.Installer" Method="ConfigureAutoStart" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
</Manifest>
}
}