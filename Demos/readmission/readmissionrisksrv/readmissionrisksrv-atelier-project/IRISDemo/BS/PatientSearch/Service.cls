Class IRISDemo.BS.PatientSearch.Service Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %CSP.Request, Output pOutput As %Stream.GlobalCharacter) As %Status
{
	set objRequest = ##class(IRISDemo.Message.PatientSearch.Request).%New()
	set objRequest.PatientID = $get(pInput.Data("PatientID",1))
	set objRequest.Lastname = $get(pInput.Data("Lastname",1))
	set objRequest.Firstname = $get(pInput.Data("Firstname",1))
	
	set tSC = ..SendRequestSync("RRLACESrv.BO.LACESoap",objRequest,.pOutput)
	Quit tSC
}

}