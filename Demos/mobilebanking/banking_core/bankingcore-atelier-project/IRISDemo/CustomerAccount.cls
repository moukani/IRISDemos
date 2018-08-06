Class IRISDemo.CustomerAccount Extends Account
{
	Property Gender As %String (VALUELIST=",M,F,U", DISPLAYLIST=",Male,Female,Unknown") [ Required ];
	
	Property DateOfBirth As %Date;
	
	Property Age As %Integer [ SqlComputed, SqlComputeCode = { Set {*}=($H-{DateOfBirth})/365 }, Transient ];
	

}