Class BankingCore.Transaction.CreateTransactionResponse Extends Ens.Response [ ProcedureBlock ]
{

Property CreateTransactionResult As %String;

Storage Default
{
<Data name="CreateTransactionResponseDefaultData">
<Subscript>"CreateTransactionResponse"</Subscript>
<Value name="1">
<Value>CreateTransactionResult</Value>
</Value>
</Data>
<DefaultData>CreateTransactionResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
