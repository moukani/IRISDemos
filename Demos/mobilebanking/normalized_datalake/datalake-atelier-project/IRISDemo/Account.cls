/// I am using SqlTableName and SqlFieldName to give the impression that this model is
/// totally different from the Banking Core system. This only afects the SQL engine. 
/// As we will be feeding/reading data through JDBC/Spark, this effect will be achieved
/// without having to change a lot of the code we had already written for the banking core.
/// The "BC_" prefix stands for "Banking Core"
Class IRISDemo.Account Extends %Persistent [ SqlTableName = BC_ACCOUNT ]
{
	Property AccountNumber As %String [ Required, SqlFieldName = "BC_ACC_NUMBER" ];
	
	Property Balance As %Library.Double [ InitialExpression = 0, Required, SqlFieldName = "BC_ACC_BALANCE" ];
	
	Index AccountNumberIndex On AccountNumber [ Unique ];
	
	ClassMethod OpenOrCreateByNumber(pAccountNumber As %String, Output pObject As %Persistent) As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// First, let's normalize the account number just to be safe
			// That is not strictly necessary to search the index. The autogenerated method
			// CodeIndexOpen will normalize it for us before searching. But removing spaces 
			// is not part of the normalization and keeping the code uniform helps to keep
			// things clean.
			Set tAccountNumber=$ZStrip(pAccountNumber, "<>W")
			
			// Let's try to find the object by it's code, using the index:
			Set pObject = ..AccountNumberIndexOpen(tAccountNumber,,.tSC)
			
			// We must always check the status code:
			If $System.Status.IsError(tSC)
			{
				// If the error is something different from "object does not exist", 
				// let's quit because something went really wrong...
				If $System.Status.GetErrorCodes(tSC)'["5770"
				{
					Quit
				}
				
				// If I am here, that is because the error is "object does not exist"
				// So let's reset it to Ok, because we are going to create this object...
				Set tSC = $$$OK
			}
			
			// If I found the object, we are done!
			Quit:$IsObject(pObject)
			
			// If not, let's create it:
			Set tAccountType=$Extract(tAccountNumber)
			If tAccountType="C"
			{
				Set pObject = ##class(IRISDemo.CustomerAccount).%New()
				Set pObject.Balance=6000 //Every customer will start with US$1000!
			}
			Else
			{
				Set pObject = ##class(IRISDemo.MerchantAccount).%New()
				Set pObject.Balance=-6000 //Every merchant will start with - US$6000!
			}
			Set pObject.AccountNumber=tAccountNumber
			
			// I will not call %Save on this. I will let it be called by the object that 
			// is pointing to this new object, as part of a single transaction.
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}
	
Storage Default
{
<Data name="AccountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccountNumber</Value>
</Value>
<Value name="3">
<Value>Balance</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.AccountD</DataLocation>
<DefaultData>AccountDefaultData</DefaultData>
<IdLocation>^IRISDemo.AccountD</IdLocation>
<IndexLocation>^IRISDemo.AccountI</IndexLocation>
<StreamLocation>^IRISDemo.AccountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}