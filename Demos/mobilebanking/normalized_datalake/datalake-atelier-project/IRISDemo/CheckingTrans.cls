Include DEMOMACROS

/// I am using SqlTableName and SqlFieldName to give the impression that this model is
/// totally different from the Banking Core system. This only afects the SQL engine. 
/// As we will be feeding/reading data through JDBC/Spark, this effect will be achieved
/// without having to change a lot of the code we had already written for the banking core.
/// The "BC_" prefix stands for "Banking Core"
Class IRISDemo.CheckingTrans Extends %Persistent [ SqlTableName = "BC_TRANSACTIONS" ]
{
	Property TransactionNumber As %Integer [ SqlFieldName = "BC_TRANS_NUM", Required ];
	
	Property TransDateTime as %TimeStamp [ SqlFieldName = "BC_TRANS_DATE" ];
	
	Property TransType As %Library.String(VALUELIST=",PAYMENT,REFUND,CASH_IN,CASH_OUT,TRANSFER") [ SqlFieldName = "BC_TRANS_TYPE" ];
	
	Property Amount As %Library.Double [ SqlFieldName = "BC_TRANS_AMOUNT" ];
	
	/// Customer/Merchant who started the transaction
	Property FromAccount As Account [ SqlFieldName = "BC_TRANS_SRC_ACC" ];
	
	/// Must declare this as a Foreign Key so that our data dictionary
	/// will report it
	ForeignKey FromAccountFK(FromAccount) References IRISDemo.Account();
	
	/// Initial balance before the transaction
	Property FromAccountOldBalance As %Library.Double [ SqlFieldName = "BC_TRANS_SRC_ACC_OLD_BAL" ];
	
	/// new balance after the transaction
	Property FromAccountNewBalance As %Library.Double [ SqlFieldName = "BC_TRANS_SRC_ACC_NEW_BAL" ];

	/// customer who is the recipient of the transaction
	Property ToAccount As Account [ SqlFieldName = "BC_TRANS_DEST_ACC" ];
	
	ForeignKey ToAccountFK(ToAccount) References IRISDemo.Account();
	
	/// Initial balance recipient before the transaction. Note that there is not information for customers that start with M (Merchants).
	Property ToAccountOldBalance As %Library.Double [ SqlFieldName = "BC_TRANS_DEST_ACC_OLD_BAL" ];
	
	/// new balance recipient after the transaction. Note that there is not information for customers that start with M (Merchants).
	Property ToAccountNewBalance As %Library.Double [ SqlFieldName = "BC_TRANS_DEST_ACC_NEW_BAL" ];
	
	Property WhiteListedBy As IRISDemo.WhiteListRequest [ SqlFieldName = "BC_TRANS_WHITELISTED_BY" ];
	
	/// This flag marks a transaction that is reported as fraudulent. There will be no WhiteList for it.
	Property IsFraud As %Boolean [ SqlFieldName = "BC_TRANS_IS_FRAUD" ];
	
	Index FromAccountBitMapIndex On (FromAccount) [ Type = BitMap ];

	Index TransTypeBitMapIndex On (FromAccount) [ Type = BitMap ];
	
	Index AmountBitSliceIndex On Amount [ Type = bitslice ];
	
	Index IsFraudBitMapIndex On (IsFraud) [ Type = BitMap ];
	
	Index TransactionNumberIndex On TransactionNumber [ Unique ];
	
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
<Value name="12">
<Value>WhiteListedBy</Value>
</Value>
<Value name="13">
<Value>TransactionNumber</Value>
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