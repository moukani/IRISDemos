Include DEMOMACROS

Class IRISDemo.CheckingTrans Extends %Persistent
{
	Property TransDateTime as %TimeStamp;
	
	Property TransType As %Library.String(VALUELIST=",PAYMENT,REFUND,CASH_IN,CASH_OUT,TRANSFER") [ SqlColumnNumber = 3 ];
	
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

/// Throws exceptions!
/// If successful, returns new transaction ID
/// This method is called by a SOAP service on class IRISDemo.Services.TransactionServices  
/// It will be called by the BankingServices service.
ClassMethod CreateTransaction(pTransDateTime As %TimeStamp, pTransType As %String, pAmount As %Double, pFromAccountNumber As %String, pToAccountNumber As %String, pIgnoreLackOfFounds As %Boolean = 0) As %String 
{
	#Dim oTrans As IRISDemo.MobileTransaction
	Set tSC = $$$OK
	
	Set tTransactionId=""
	Set oTrans = ..%New()
	
	Set oTrans.FromAccount = ##class(Account).AccountNumberIndexOpen(pFromAccountNumber,,.tSC)
	$$$ThrowStatusExceptionIfError(tSC, "SourceAccountNumberNotFoundException")

	Set oTrans.ToAccount = ##class(Account).AccountNumberIndexOpen(pToAccountNumber,,.tSC)
	$$$ThrowStatusExceptionIfError(tSC, "DestinationAccountNumberNotFoundException")

	Set oTrans.Amount=pAmount
	Set oTrans.TransDateTime=pTransDateTime
	Set oTrans.TransType=pTransType
	
	Set oTrans.FromAccountOldBalance=oTrans.FromAccount.Balance
	Set oTrans.ToAccountOldBalance=oTrans.ToAccount.Balance
	
	Set oTrans.ToAccount.Balance=oTrans.ToAccount.Balance+oTrans.Amount
	Set oTrans.FromAccount.Balance=oTrans.FromAccount.Balance-oTrans.Amount

	Do oTrans.ValidateTransaction(pIgnoreLackOfFounds)
			
	Set oTrans.FromAccountNewBalance=oTrans.FromAccount.Balance
	Set oTrans.ToAccountNewBalance=oTrans.ToAccount.Balance
	
	Set tSC = oTrans.%Save(1)
	$$$ThrowStatusExceptionIfError(tSC, "SaveTransactionException")
	
	Set tTransactionId=oTrans.%Id()
		
	Quit tTransactionId
}

/// Throws exception if validation fails!
Method ValidateTransaction(pIgnoreLackOfFounds As %Boolean = 0) [ Private ] 
{
	#Dim oTrans As IRISDemo.MobileTransaction
	Set tRet=1

	If (..TransType="PAYMENT")
	{
		If ..FromAccount.%ClassName()'="CustomerAccount"
		{
			$$$ThrowException("InvalidSourceAccountNumberException", "Source account type should be Customer")
		}

		If ..ToAccount.%ClassName()'="MerchantAccount"
		{
			$$$ThrowException("InvalidDestinationAccountNumberException", "Destination account type should be Merchant")
		}				
	}
	Else
	{
		Throw ##class(%Exception.General).%New("InvalidTypeOfTransactionException", ..TransType)
	}
			
	If 'pIgnoreLackOfFounds && (..FromAccount.Balance<0)
	{
		$$$ThrowException("InsufficientFundsOnSourceException", "Source account has insufficient funds.")
	} 

}

ClassMethod LoadDataFromCSVFile(pFileName As %String) As %Status
{
	#Dim oTrans As IRISDemo.Trans
	
	Set tSC = $$$OK
	Try
	{
		Set iLine=0 //Header is consumed
		
		Set oRSTransactions=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV")
		Set tSC = oRSTransactions.Execute(pFileName)
		Quit:$System.Status.IsError(tSC)
		
		Set tSC = ..%DeleteExtent(0)
		Quit:$System.Status.IsError(tSC)

		Set tSC = ##class(Account).%DeleteExtent(0)
		Quit:$System.Status.IsError(tSC)
		
		Do ..ClearErrors()
		
		Set tBaseDate=$ZDateH("2018-01-01",3)
		
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
			Set oTrans.IsFraud=+oRSTransactions.Get("fraud")
			
			Set tSC = ##class(Account).OpenOrCreateByNumber(oRSTransactions.Get("merchant"), .oToAccount)
			Quit:$System.Status.IsError(tSC)
			
			Set oTrans.ToAccount=oToAccount
			If oTrans.ToAccount.%Id()=""
			{
				Set tCategoryCode=$Piece(oRSTransactions.Get("category"),"_",2)
				Set tSC=##class(MerchantCategory).OpenOrCreateByCode(tCategoryCode, .oCategory)
				$$$ThrowStatusExceptionIfError(tSC, "CreateCategoryException")
				
				Set oCategory.Description=$ZConvert(tCategoryCode, "S")
				
				Set oTrans.ToAccount.Category=oCategory
			}
			
			Set tSC = ##class(Account).OpenOrCreateByNumber(oRSTransactions.Get("customer"), .oFromAccount)
			Quit:$System.Status.IsError(tSC)
			
			Set oTrans.FromAccount=oFromAccount
			If oTrans.FromAccount.%Id()=""
			{
				Set oTrans.FromAccount.Gender=oRSTransactions.Get("gender")
				If oTrans.FromAccount.Gender="E" Set oTrans.FromAccount.Gender="U" //This should not happen!
				Set oTrans.FromAccount.DateOfBirth=..DateOfBirthForAgeGroup(oRSTransactions.Get("age"))
			}
			
			Set oTrans.TransType="PAYMENT"
			
			Set oTrans.FromAccountOldBalance=oTrans.FromAccount.Balance
			Set oTrans.ToAccountOldBalance=oTrans.ToAccount.Balance
			
			Set oTrans.ToAccount.Balance=oTrans.ToAccount.Balance+oTrans.Amount
			Set oTrans.FromAccount.Balance=oTrans.FromAccount.Balance-oTrans.Amount
			
			Do oTrans.ValidateTransaction(1)
			
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

ClassMethod DateOfBirthForAgeGroup(pAgeGroup As %Integer) As %Date
{
	If pAgeGroup=0
	{
		Set iAgeMin=15
		Set iAgeMax=18 
	}
	ElseIf pAgeGroup=1
	{
		Set iAgeMin=19
		Set iAgeMax=25 
	}
	ElseIf pAgeGroup=2
	{
		Set iAgeMin=26
		Set iAgeMax=35 
	}
	ElseIf pAgeGroup=3
	{
		Set iAgeMin=36
		Set iAgeMax=45 
	}
	ElseIf pAgeGroup=4
	{
		Set iAgeMin=46
		Set iAgeMax=55 
	}
	ElseIf pAgeGroup=5
	{
		Set iAgeMin=56
		Set iAgeMax=65 
	}
	Else
	{
		Set iAgeMin=$Random(60)+18
		Set iAgeMax=iAgeMin+1
	}

	Set iDateMax=$H-(iAgeMin*365)
	Set iDateMin=$H-(iAgeMax*365)
	
	Set iDateDelta=$Random(iDateMax-iDateMin)
	
	Quit iDateMin+iDateDelta	
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
<Data name="CheckingTransDefaultData">
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
<DataLocation>^IRISDemo.CheckingTransD</DataLocation>
<DefaultData>CheckingTransDefaultData</DefaultData>
<IdLocation>^IRISDemo.CheckingTransD</IdLocation>
<IndexLocation>^IRISDemo.CheckingTransI</IndexLocation>
<StreamLocation>^IRISDemo.CheckingTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}