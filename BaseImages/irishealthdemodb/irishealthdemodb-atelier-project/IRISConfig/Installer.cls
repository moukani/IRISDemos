Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{
		
	XData Install [ XMLNamespace = INSTALLER ]
	{
	<Manifest>
		
		<Log Text="Configuring roles for ${Namespace}..." Level="0"/>
		<Resource Name="%DB_APP" Description="Resource used to protect the application"/>
		<Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_APP:RW,%DB_IRISSYS:R" />

		<Log Text="Giving CSPSystem access to our database so the OPTIONS request from HTTP CORS calls will work." Level="0"/>
		<Invoke Class="IRISConfig.Installer" Method="AddRoleToUser" CheckStatus="true">
			<Arg name="pUsername" Value="CSPSystem"/>
			<Arg name="pRole" Value="%DB_APP"/>
		</Invoke>

		<Log Text="Configuring namespace ${Namespace}..." Level="0"/>
		<Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="0" Data="${Namespace}">
			<Configuration>
					<Database Name="${Namespace}" Dir="${MGRDIR}${Namespace}" Create="yes" MountRequired="1" Resource="%DB_APP"/>
			</Configuration>
		</Namespace>
		
		<Log Text="Creating CSP Applications for ${Namespace}..." Level="0"/>
		<Namespace Name="${Namespace}" Create="no">
		
			<!-- 
			We want people to be able to create a CSP application that can call a REST service back into the database without 
			requiring to authenticate the REST call again. This is done by having the same session cookie path, CSP application group and 
			Login Cookie authentication method enabled.
			-->
			<CSPApplication Url="/csp/${CSPAppName}"      Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForCSP()}" Recurse="true" IsNamespaceDefault="true"  Grant="AppRole" CookiePath="/csp/${CSPAppName}" AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="${CSPAppName}" UseSessionCookie="1"/>
			
			<CSPApplication Url="/csp/${CSPAppName}/soap" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForSOAP()}" Recurse="true" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}" AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="true"  GroupById="${CSPAppName}" UseSessionCookie="1" PermittedClasses='1""IRISDemo.SOAP."".E'/>
	        
	        <CSPApplication Url="/csp/${CSPAppName}/rest" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForREST()}" Recurse="true" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}" AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="${CSPAppName}" UseSessionCookie="1" PermittedClasses='1""IRISDemo.REST."".E' DispatchClass="IRISDemo.REST.Dispatcher"/>
	        
			<IfDef Var="SourceDir">
	            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
	            <Import File="${SourceDir}" Recurse="true"/>
	        </IfDef>

		</Namespace>
		
		<Log Text="Enabling Analytics on main CSP application so we can import PMML and see dashboards." Level="0"/>
		<Invoke Class="IRISConfig.Installer" Method="CSPAppEnableAnalytics" CheckStatus="true">
			<Arg name="pCSPAppName" Value="/csp/${CSPAppName}"/>
		</Invoke>

		<Log Text="Applying additional configurations to the new REST CSP Application..." Level="0"/>
		<Invoke Class="IRISConfig.Installer" Method="CSPAppConfigureAsREST" CheckStatus="true">
			<Arg name="pCSPAppName" Value="/csp/${CSPAppName}/rest"/>
		</Invoke>
	</Manifest>
	}
}