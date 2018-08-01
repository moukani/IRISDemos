/// 
Class BankingSrv.BP.Transaction.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BankingSrv.BS.Transaction.NewTransactionReq' response='BankingSrv.BS.Transaction.NewTransactionResp' height='2000' width='2000' >
<sequence xend='199' yend='343' >
	<call name='Call Core Banking' target='Banking Core Transaction Operation' async='0' xpos='199' ypos='253' >
		<request type='BankingCore.Transaction.CreateTransactionRequest' >
			<assign property="callrequest.pTransDateTime" value="request.TransDateTime" action="set" />
			<assign property="callrequest.pTransType" value="request.TransType" action="set" />
			<assign property="callrequest.pAmount" value="request.Amount" action="set" />
			<assign property="callrequest.pFromAccountNumber" value="request.FromAccountNumber" action="set" />
			<assign property="callrequest.pToAccountNumber" value="request.ToAccountNumber" action="set" />
		</request>
		<response type='BankingCore.Transaction.CreateTransactionResponse' >
			<assign property="response.TransactionId" value="callresponse.CreateTransactionResult" action="set" />
		</response>
	</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
