Class RRLACESrv.WSClient.LACESoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://RRLACESrv:52773/csp/appint/soap/IRISDemo.SOAP.LACE.Service.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "LACE";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Overrides default handling of string arguments.
Parameter XMLIGNORENULL = 1;

Method Admit(PatientID As %String, EncounterNumber As %String, EncounterType As %String, StartDate As %Date, StartTime As %Time, AdmissionSource As %String) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Admit").Invoke($this,"http://tempuri.org/IRISDemo.SOAP.LACE.Service.Admit",.PatientID,.EncounterNumber,.EncounterType,.StartDate,.StartTime,.AdmissionSource)
}

Method Discharge(PatientID As %String, EncounterNumber As %String, EncounterType As %String, AdmissionSource As %String, StartDate As %Date, StartTime As %Time, EndDate As %Date, EndTime As %Time, DischargeLocation As %String) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Discharge").Invoke($this,"http://tempuri.org/IRISDemo.SOAP.LACE.Service.Discharge",.PatientID,.EncounterNumber,.EncounterType,.AdmissionSource,.StartDate,.StartTime,.EndDate,.EndTime,.DischargeLocation)
}

Method Risk(PatientID As %String, EncounterNumber As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	quit ..WebMethod("Risk").Invoke($this,"http://tempuri.org/IRISDemo.SOAP.LACE.Service.Risk",.PatientID,.EncounterNumber)
}

}
