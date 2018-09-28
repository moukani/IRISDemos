Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	
	<Log Text="Configuring roles for ${Namespace}..." Level="0"/>
	<Resource Name="%DB_APPINT" Description="Resource used to protect the application"/>
	<Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_APPINT:RW,%DB_IRISSYS:R,%Ens_Portal:U" />
	
	<Log Text="Giving CSPSystem access to our database so the OPTIONS request from HTTP CORS calls will work." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="AddRoleToUser" CheckStatus="true">
		<Arg name="pUsername" Value="CSPSystem"/>
		<Arg name="pRole" Value="%DB_APPINT"/>
	</Invoke>
	
	<Log Text="Configuring namespace ${Namespace}..." Level="0"/>
	<Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="1" Data="${Namespace}">
		<Configuration>
				<Database Name="${Namespace}" Dir="${MGRDIR}${Namespace}" Create="yes" MountRequired="1" Resource="%DB_APPINT"/>
		</Configuration>
	</Namespace>
	
	<Log Text="Creating CSP Applications for ${Namespace}..." Level="0"/>
	<Namespace Name="${Namespace}" Create="no">
		<CSPApplication Url="/csp/${CSPAppName}" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForSMP()}" IsNamespaceDefault="true" CookiePath="/csp/${CSPAppName}" AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="%ISCMgtPortal" Resource="%Ens_Portal"/>
		<CSPApplication Url="/csp/${CSPAppName}/soap" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForSOAP()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}/soap" Recurse="true"  AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="true" GroupById="${CSPAppName}"/>
		
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>

		<CSPApplication Url="/csp/${CSPAppName}/rest" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForREST()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}/rest" Recurse="true"  AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="${CSPAppName}" DispatchClass="IRISDemo.REST.Dispatcher"  UseSessionCookie="1"/>
	</Namespace>
	
	<Log Text="Applying additional configurations to the new REST CSP Application..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="CSPAppConfigureAsREST" CheckStatus="true">
		<Arg name="pCSPAppName" Value="/csp/${CSPAppName}/rest"/>
	</Invoke>

	<Log Text="Enabling Analytics on main CSP application so we can import PMML and see production statistics." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="CSPAppEnableAnalytics" CheckStatus="true">
		<Arg name="pCSPAppName" Value="/csp/${CSPAppName}"/>
	</Invoke>

	<Log Text="Configuring production IRISDemo.Production to auto-start." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="ConfigureAutoStart" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
</Manifest>
}
}