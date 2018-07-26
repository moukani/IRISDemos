/// See https://www.kaggle.com/ntnu-testimon/paysim1/home for more information
Class IRISDemo.MobileTransaction Extends %Persistent
{
	Property TransDateTime as %TimeStamp;
	
	 /// CASH_IN is the process of increasing the balance of account by paying in cash to a merchant.
	 /// CASH_OUT is the opposite process of CASH-IN, it means to withdraw cash from a merchant which decreases the balance of the account.
	 /// DEBIT is similar process than CASH-OUT and involves sending the money from the mobile money service to a bank account.
	 /// PAYMENT is the process of paying for goods or services to merchants which decreases the balance of the account and increases the balance of the receiver.
	 /// TRANSFER is the process of sending money to another user of the service through the mobile money platform.
	Property TransType As %Library.String(VALUELIST=",CASH_IN,CASH_OUT,DEBIT,PAYMENT,TRANSFER") [ SqlColumnNumber = 3 ];
	
	Property Amount As %Library.Double;
	
	/// Customer/Merchant who started the transaction
	Property FromAccount As Account;
	
	/// Initial balance before the transaction
	Property FromAccountOldBalance As %Library.Double;
	
	/// new balance after the transaction
	Property FromAccountNewBalance As %Library.Double;

	/// customer who is the recipient of the transaction
	Property ToAccount As Account;
	
	/// Initial balance recipient before the transaction. Note that there is not information for customers that start with M (Merchants).
	Property ToAccountOldBalance As %Library.Double;
	
	/// new balance recipient after the transaction. Note that there is not information for customers that start with M (Merchants).
	Property ToAccountNewBalance As %Library.Double;
	
	/// Customer called customer services and, after investigation, this transaction has been confirmed to be a fraud.
	Property IsFraud As %Boolean;

/// This method is called by a SOAP service on class IRISDemo.Services.TransactionServices  
/// It will be called by the BankingServices service.
ClassMethod CreateTransaction(pTransDateTime As %TimeStamp, pTransType As %String, pAmount As %Double, pFromAccountNumber As %String, pToAccountNumber As %String, pIgnoreLackOfFounds As %Boolean = 0, Output pTransactionId As %String) As %Status 
{
	#Dim oTrans As IRISDemo.MobileTransaction
	Set tSC = $$$OK
	Try
	{
		Set oTrans = ..%New()
		
		Set oTrans.FromAccount = ##class(Account).AccountNumberIndexOpen(pFromAccountNumber,,.tSC)
		Quit:$System.Status.IsError(tSC)

		Set oTrans.ToAccount = ##class(Account).AccountNumberIndexOpen(pToAccountNumber,,.tSC)
		Quit:$System.Status.IsError(tSC)
		
		Set oTrans.Amount=pAmount
		Set oTrans.TransDateTime=pTransDateTime
		Set oTrans.TransType=pTransType
		
		Set oTrans.FromAccountOldBalance=oTrans.FromAccount.Balance
		Set oTrans.ToAccountOldBalance=oTrans.ToAccount.Balance
		
		Set oTrans.ToAccount.Balance=oTrans.ToAccount.Balance+oTrans.Amount
		Set oTrans.FromAccount.Balance=oTrans.FromAccount.Balance-oTrans.Amount

		Set tSC = oTrans.ValidateTransaction(pIgnoreLackOfFounds)
		Quit:$System.Status.IsError(tSC)
				
		Set oTrans.FromAccountNewBalance=oTrans.FromAccount.Balance
		Set oTrans.ToAccountNewBalance=oTrans.ToAccount.Balance
		
		Set tSC = oTrans.%Save(1)
		Quit:$System.Status.IsError(tSC)
		
		Set pTransactionId=oTrans.%Id()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod ValidateTransaction(pTransaction As IRISDemo.MobileTransaction, pIgnoreLackOfFounds As %Boolean = 0) As %String [ Private ] 
{
	#Dim oTrans As IRISDemo.MobileTransaction
	Set tRet=1
	Set tSC = $$$OK
	Try
	{
		If pTransaction.TransType="CASH_IN"
		{
 //			Accordingly to the dataset documentation, this transaction should be between
 //			a customer and a merchant. But all of them on the dataset are between customers!
 //			If oTrans.FromAccount.AccountType'="M"
 //			{
 //				Do ..LogError(iLine, oTrans.TransType_": From Account must be a merchant")
 //				Continue
 //			}
 //
 //			If oTrans.ToAccount.AccountType'="C"
 //			{
 //				Do ..LogError(iLine, oTrans.TransType_": To Account must be a customer")
 //				Continue
 //			}				
		}
		ElseIf (pTransaction.TransType="CASH_OUT")
		{
 //			Accordingly to the dataset documentation, this transaction should be between
 //			a customer and a merchant. But all of them on the dataset are between customers!
 //			If oTrans.FromAccount.AccountType'="C"
 //			{
 //				Do ..LogError(iLine, oTrans.TransType_": From Account must be a customer")
 //				Continue
 //			}
 //
 //			If oTrans.ToAccount.AccountType'="M"
 //			{
 //				Do ..LogError(iLine, oTrans.TransType_": To Account must be a merchant")
 //				Continue
 //			}				
		}
		ElseIf (pTransaction.TransType="PAYMENT")
		{
			If pTransaction.FromAccount.AccountType'="C"
			{
				Set tSC = $System.Status.Error(5001,oTrans.TransType_": From Account must be a customer")
				Quit
			}

			If pTransaction.ToAccount.AccountType'="M"
			{
				Set tSC = $System.Status.Error(5001, oTrans.TransType_": To Account must be a merchant")
				Quit
			}				
		}
		ElseIf (pTransaction.TransType="DEBIT") || (pTransaction.TransType="TRANSFER")
		{
			//No validations
		}
		Else
		{
			Set tSC = $System.Status.Error(5001, "Invalid type of transaction ("_oTrans.TransType_")")
			Quit
		}
				
		If 'pIgnoreLackOfFounds && (pTransaction.FromAccount.Balance<0)
		{
			Set tSC = $System.Status.Error(5001, "Insufficient funds.")
			Quit
		} 
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod LoadDataFromCSVFile(pFileName As %String) As %Status
{
	#Dim oTrans As IRISDemo.Trans
	
	Set tSC = $$$OK
	Try
	{
		Set oRSTransactions=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		Set tSC = oRSTransactions.Execute(pFileName)
		Quit:$System.Status.IsError(tSC)
		
		Set tSC = ..%DeleteExtent(0)
		Quit:$System.Status.IsError(tSC)

		Set tSC = ##class(Account).%DeleteExtent(0)
		Quit:$System.Status.IsError(tSC)
		
		Do ..ClearErrors()
		
		Set tBaseDate=$ZDateH("2018-01-01",3)
		
		Set iLine=0 //Header is consumed
		
		While oRSTransactions.Next()
		{
			Set iLine=iLine+1
			
			Set oTrans = ..%New()
			
			// step must be transformed into TransDateTime. One step is 1 hour
			Set step=oRSTransactions.Get("step")
			Set hour=step#24
			Set day=step\24
			Set dateH=tBaseDate+day
			Set hourH=hour*60*60
			Set oTrans.TransDateTime=$ZDate(dateH,3)_" "_$ZTime(hourH)
			
			Set oTrans.Amount=+oRSTransactions.Get("amount")
			Set oTrans.IsFraud=+oRSTransactions.Get("isFraud")
			
			Set tSC = ##class(Account).OpenOrCreateByNumber(oRSTransactions.Get("nameDest"), .oToAccount)
			Quit:$System.Status.IsError(tSC)
			
			Set oTrans.ToAccount=oToAccount

			Set tSC = ##class(Account).OpenOrCreateByNumber(oRSTransactions.Get("nameOrig"), .oFromAccount)
			Quit:$System.Status.IsError(tSC)
			
			Set oTrans.FromAccount=oFromAccount
			
			Set oTrans.TransType=oRSTransactions.Get("type")
			
			Set oTrans.FromAccountOldBalance=oTrans.FromAccount.Balance
			Set oTrans.ToAccountOldBalance=oTrans.ToAccount.Balance
			
			Set oTrans.ToAccount.Balance=oTrans.ToAccount.Balance+oTrans.Amount
			Set oTrans.FromAccount.Balance=oTrans.FromAccount.Balance-oTrans.Amount
			
			Set tSC = ..ValidateTransaction(oTrans, 1)
			Quit:$System.Status.IsError(tSC)
			
			Set oTrans.FromAccountNewBalance=oTrans.FromAccount.Balance
			Set oTrans.ToAccountNewBalance=oTrans.ToAccount.Balance
			
			//This is a single transaction involving three objects!
			Set tSC = oTrans.%Save(1)
			Quit:$System.Status.IsError(tSC) //This is not really necessary. It's here for the habit of it.
		}
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	Set ^IRISDemo.TransL("Total")=iLine
	Do ..ShowResults(tSC)
	
	Quit tSC
}

ClassMethod ClearErrors() [ Private ]
{
	Kill ^IRISDemo.TransL
}

ClassMethod LogError(pLine As %Integer, pError As %String) [ Private ]
{
	Set i=$Increment(^IRISDemo.TransL("Errors"))
	Set ^IRISDemo.TransL("Errors",i)=$LB(pLine, pError)
}

ClassMethod ShowResults(pSC As %Status) [ Private ]
{
	Do $System.Status.DisplayError(pSC)
	
	Set iTotalLines=^IRISDemo.TransL("Total")
	Set iTotalErrors=$Get(^IRISDemo.TransL("Errors"),0)
	
	For i=1:1:iTotalErrors 
	{
		Set i=$Order(^IRISDemo.TransL("Errors",i))
		
		Set tErrorData = ^IRISDemo.TransL("Errors",i)
		
		Write !,$LG(tErrorData,1),$C(9),": ",$LG(tErrorData,2)
	}
	
	Write !,iTotalLines," lines processed.",!
	Write !,iTotalErrors," errors reported - "_(iTotalErrors/iTotalLines*100)_"% of the records.",!
	
	Kill ^IRISDemo.Trans
}

Storage Default
{
<Data name="MobileTransactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransDateTime</Value>
</Value>
<Value name="3">
<Value>TransType</Value>
</Value>
<Value name="4">
<Value>Amount</Value>
</Value>
<Value name="5">
<Value>FromAccount</Value>
</Value>
<Value name="6">
<Value>FromAccountOldBalance</Value>
</Value>
<Value name="7">
<Value>FromAccountNewBalance</Value>
</Value>
<Value name="8">
<Value>ToAccount</Value>
</Value>
<Value name="9">
<Value>ToAccountOldBalance</Value>
</Value>
<Value name="10">
<Value>ToAccountNewBalance</Value>
</Value>
<Value name="11">
<Value>IsFraud</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.MobileTransactionD</DataLocation>
<DefaultData>MobileTransactionDefaultData</DefaultData>
<IdLocation>^IRISDemo.MobileTransactionD</IdLocation>
<IndexLocation>^IRISDemo.MobileTransactionI</IndexLocation>
<StreamLocation>^IRISDemo.MobileTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

