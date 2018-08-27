Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{
		
	XData Install [ XMLNamespace = INSTALLER ]
	{
	<Manifest>
		
		<If Condition="${UseUSERNamespace}">
			<Namespace Name="USER" Create="no">
				<IfDef Var="SourceDir">
		            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
		            <Import File="${SourceDir}" Recurse="true"/>
		        </IfDef>
			</Namespace>
		</If>
		<If Condition="'${UseUSERNamespace}">
			<Log Text="Configuring roles for ${Namespace}..." Level="0"/>
			<Resource Name="%DB_APP" Description="Resource used to protect the application"/>
			<Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_APP:RW,%DB_IRISSYS:R" />
			
			<Log Text="Configuring namespace ${Namespace}..." Level="0"/>
			<Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="0" Data="${Namespace}">
				<Configuration>
						<Database Name="${Namespace}" Dir="${MGRDIR}${Namespace}" Create="yes" MountRequired="1" Resource="%DB_APP}"/>
				</Configuration>
			</Namespace>
			
			<Log Text="Creating CSP Applications for ${Namespace}..." Level="0"/>
			<Namespace Name="${Namespace}" Create="no">
				<CSPApplication Url="/csp/${CSPAppName}" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForCSP()}" IsNamespaceDefault="true" Grant="AppRole" CookiePath="/csp/${CSPAppName}" Recurse="true" />
				
				<CSPApplication Url="/csp/${CSPAppName}/soap"     Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForSOAP()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}/soap" Recurse="true"  AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="true" GroupById="${CSPAppName}" PermittedClasses='1""IRISDemo.SOAP."".E'/>
				<IfDef Var="SourceDir">
		            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
		            <Import File="${SourceDir}" Recurse="true"/>
		        </IfDef>
		        
		        <CSPApplication Url="/csp/${CSPAppName}/rest" Directory="${CSPDIR}${CSPAppName}" AuthenticationMethods="#{##class(IRISConfig.Installer).AuthForREST()}" IsNamespaceDefault="false" Grant="AppRole" CookiePath="/csp/${CSPAppName}/rest" Recurse="true"  AutoCompile="false" CSPZENEnabled="true" InboundWebServicesEnabled="false" GroupById="${CSPAppName}" DispatchClass="IRISDemo.REST.Dispatcher"  UseSessionCookie="1" PermittedClasses='1""IRISDemo.REST."".E'/>
			</Namespace>
			
			<Log Text="Applying additional configurations to the new REST CSP Application..." Level="0"/>
			<Invoke Class="IRISConfig.Installer" Method="CSPAppConfigureAsREST" CheckStatus="true">
				<Arg name="pCSPAppName" Value="/csp/${CSPAppName}/rest"/>
			</Invoke>
		</If>
	</Manifest>
	}
}