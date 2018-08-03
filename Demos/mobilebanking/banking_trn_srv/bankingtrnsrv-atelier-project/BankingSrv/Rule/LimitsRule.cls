/// 
Class BankingSrv.Rule.LimitsRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="LimitsRule" context="BankingSrv.BP.Transaction.Process.Context" production="">
<ruleSet name="Above Limit Rules" effectiveBegin="" effectiveEnd="">
<rule name="Cash Out" disabled="false">
<when condition="(TransactionType=&quot;CASH_OUT&quot;)&amp;&amp;(TransactionAmount&gt;100000)">
<return>1</return>
</when>
</rule>
<rule name="Transfers" disabled="false">
<when condition="(TransactionType=&quot;TRANSFER&quot;)&amp;&amp;(TransactionAmount&gt;10000)">
<return>1</return>
</when>
</rule>
<return>0</return>
</ruleSet>
</ruleDefinition>
}

}
