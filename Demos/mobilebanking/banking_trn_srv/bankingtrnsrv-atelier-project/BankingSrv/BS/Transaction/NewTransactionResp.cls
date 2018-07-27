Class BankingSrv.BS.Transaction.NewTransactionResp  Extends %Persistent
{
	Property TransactionId As %String;
	
	Property Exception As IRISDemo.Exception;
	
	Method AsDynamicObject()
	{
		Set o={}
		Set o.TransactionId=..TransactionId
		If (..Exception'="") && (..Exception.Name'="")
		{
			Set o.Exception=..Exception.AsDynamicObject().Exception
		}
		Quit o		
	}
	
Storage Default
{
<Data name="NewTransactionRespDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransactionId</Value>
</Value>
<Value name="3">
<Value>Exception</Value>
</Value>
</Data>
<DataLocation>^BankingSrvB430.NewTransactA597D</DataLocation>
<DefaultData>NewTransactionRespDefaultData</DefaultData>
<IdLocation>^BankingSrvB430.NewTransactA597D</IdLocation>
<IndexLocation>^BankingSrvB430.NewTransactA597I</IndexLocation>
<StreamLocation>^BankingSrvB430.NewTransactA597S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}