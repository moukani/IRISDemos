/// 
Class BankingSrv.BP.Transaction.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BankingSrv.BS.Transaction.NewTransactionReq' response='BankingSrv.BS.Transaction.NewTransactionResp' height='2150' width='2000' >
<context>
<property name='Request' type='BankingSrv.BS.Transaction.NewTransactionReq' instantiate='0' />
<property name='TransactionAboveLimit' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='TransactionAboveLimitReason' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='QueryWhiteListResp' type='WhiteList.BO.QueryWhiteListResp' instantiate='0' />
<property name='TransactionAllowed' type='%Boolean' initialexpression='1' instantiate='0' />
<property name='DatalakeReq' type='Datalake.BO.Transaction.NewTransactionReq' instantiate='0' />
<property name='TransactionResp' type='BankingCore.Transaction.WSProxy.s0.CreateTransactionResp' instantiate='0' />
</context>
<sequence xend='200' yend='1800' >
<assign name="Save Request into Context" property="context.Request" value="request" action="set" xpos='200' ypos='250' />
<rule name='Above Limit Rule' rule='BankingSrv.Rule.LimitsRule'  resultLocation='context.TransactionAboveLimit' reasonLocation='context.TransactionAboveLimitReason' ruleContext='context' xpos='200' ypos='350' >
</rule>
<if name='Is Above Limit?' condition='context.TransactionAboveLimit=1' xpos='200' ypos='450' xend='200' yend='1150' >
<true>
<call name='Query White List' target='White List Operation' async='0' xpos='335' ypos='600' >
<request type='WhiteList.BO.QueryWhiteListReq' >
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
</request>
<response type='WhiteList.BO.QueryWhiteListResp' >
<assign property="context.QueryWhiteListResp" value="callresponse" action="set" />
</response>
</call>
<if name='White listed?' condition='context.QueryWhiteListResp.WhiteListRequestFound' xpos='335' ypos='700' xend='335' yend='1050' >
<true>
<trace name='Trace Above Limit Allowed' value='"Above limited allowed by white list registered on"_context.QueryWhiteListResp.RequestDate' xpos='335' ypos='850' />
</true>
<false>
<trace name='Trace above limit NOT allowed' value='"Above limited NOT allowed. No white list found."' xpos='605' ypos='850' />
<assign name="Above Limit not allowed!" property="context.TransactionAllowed" value="0" action="set" xpos='605' ypos='950' />
</false>
</if>
</true>
</if>
<if name='Allowed?' condition='context.TransactionAllowed' xpos='200' ypos='1250' xend='200' yend='1700' >
<true>
<assign name="Transaction Approved!" property="response.TransactionApproved" value="1" action="set" xpos='470' ypos='1400' />
<call name='Call Core Banking' target='Banking Core Transaction Operation' async='0' xpos='470' ypos='1500' >
<request type='BankingCore.Transaction.CreateTransactionRequest' >
<assign property="callrequest.pTransDateTime" value="request.TransDateTime" action="set" />
<assign property="callrequest.pTransType" value="request.TransType" action="set" />
<assign property="callrequest.pAmount" value="request.Amount" action="set" />
<assign property="callrequest.pFromAccountNumber" value="request.FromAccountNumber" action="set" />
<assign property="callrequest.pToAccountNumber" value="request.ToAccountNumber" action="set" />
</request>
<response type='BankingCore.Transaction.CreateTransactionResponse' >
<assign property="response.TransactionId" value="callresponse.CreateTransactionResult.TransactionId" action="set" />
<assign property="context.TransactionResp" value="callresponse.CreateTransactionResult" action="set" />
</response>
</call>
<call name='Populate the data lake' target='Datalake Transaction Operations' async='1' xpos='470' ypos='1600' >
<annotation><![CDATA[Asynchronous]]></annotation>
<request type='Datalake.BO.Transaction.NewTransactionReq' >
<assign property="callrequest.TransDateTime" value="request.TransDateTime" action="set" />
<assign property="callrequest.TransactionNumber" value="context.TransactionResp.TransactionId" action="set" />
<assign property="callrequest.FromAccountOldBalance" value="context.TransactionResp.FromAccountOldBalance" action="set" />
<assign property="callrequest.FromAccountNewBalance" value="context.TransactionResp.FromAccountNewBalance" action="set" />
<assign property="callrequest.ToAccountOldBalance" value="context.TransactionResp.ToAccountOldBalance" action="set" />
<assign property="callrequest.ToAccountNewBalance" value="context.TransactionResp.ToAccountNewBalance" action="set" />
<assign property="callrequest.TransType" value="request.TransType" action="set" />
<assign property="callrequest.Amount" value="request.Amount" action="set" />
<assign property="callrequest.WhiteListRequestId" value="context.QueryWhiteListResp.WhiteListRequestId" action="set" />
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
<assign property="callrequest.ToAccountNumber" value="request.ToAccountNumber" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
<false>
<assign name="Transaction declined!" property="response.TransactionApproved" value="0" action="set" xpos='200' ypos='1400' />
</false>
</if>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
