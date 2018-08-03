/// 
Class BankingSrv.BP.Transaction.Process Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BankingSrv.BS.Transaction.NewTransactionReq' response='BankingSrv.BS.Transaction.NewTransactionResp' height='2000' width='2000' >
<context>
<property name='TransactionType' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='TransactionAmount' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='TransactionAboveLimit' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='TransactionAboveLimitReason' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='WhiteListFound' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='WhiteListRequestDate' type='%TimeStamp' instantiate='0' />
<property name='TransactionAllowed' type='%Boolean' initialexpression='1' instantiate='0' />
</context>
<sequence xend='200' yend='1800' >
<assign name="Get Transaction Type" property="context.TransactionType" value="request.TransType" action="set" xpos='200' ypos='250' />
<assign name="Get Amount" property="context.TransactionAmount" value="request.Amount" action="set" xpos='200' ypos='350' />
<rule name='Above Limit Rule' rule='BankingSrv.Rule.LimitsRule'  resultLocation='context.TransactionAboveLimit' reasonLocation='context.TransactionAboveLimitReason' ruleContext='context' xpos='200' ypos='450' >
</rule>
<if name='Is Above Limit?' condition='context.TransactionAboveLimit=1' xpos='200' ypos='550' xend='200' yend='1250' >
<true>
<call name='Query White List' target='White List Operation' async='0' xpos='335' ypos='700' >
<request type='WhiteList.BO.QueryWhiteListReq' >
<assign property="callrequest.FromAccountNumber" value="request.FromAccountNumber" action="set" />
</request>
<response type='WhiteList.BO.QueryWhiteListResp' >
<assign property="context.WhiteListFound" value="callresponse.WhiteListRequestFound" action="set" />
<assign property="context.WhiteListRequestDate" value="callresponse.RequestDate" action="set" />
</response>
</call>
<if name='White listed?' condition='context.WhiteListFound' xpos='335' ypos='800' xend='335' yend='1150' >
<true>
<trace name='Trace Above Limit Allowed' value='"Above limited allowed by white list registered on"_context.WhiteListRequestDate' xpos='335' ypos='950' />
</true>
<false>
<trace name='Trace above limit NOT allowed' value='"Above limited NOT allowed. No white list found."' xpos='605' ypos='950' />
<assign name="Above Limit not allowed!" property="context.TransactionAllowed" value="0" action="set" xpos='605' ypos='1050' />
</false>
</if>
</true>
</if>
<if name='Allowed?' condition='context.TransactionAllowed' xpos='200' ypos='1350' xend='200' yend='1700' >
<true>
<call name='Call Core Banking' target='Banking Core Transaction Operation' async='0' xpos='470' ypos='1500' >
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
<assign name="Transaction Approved!" property="response.TransactionApproved" value="1" action="set" xpos='470' ypos='1600' />
</true>
<false>
<assign name="Transaction declined!" property="response.TransactionApproved" value="0" action="set" xpos='200' ypos='1500' />
</false>
</if>
</sequence>
</process>
}

}
