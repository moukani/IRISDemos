Class BankingSrv.BP.Transaction.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

	XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
	{
		<process language="objectscript" request="BankingSrv.BS.Transaction.NewTransactionReq" response="BankingSrv.BS.Transaction.NewTransactionResp">
			<context>
			</context>
			<sequence>
			</sequence>
		</process>
	}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}