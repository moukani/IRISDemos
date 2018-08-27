/// 
Class BankingSrv.Rule.LimitsRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="LimitsRule" context="BankingSrv.BP.Transaction.Process.Context" production="">
<ruleSet name="Above Limit Rules" effectiveBegin="" effectiveEnd="">
<rule name="Cash Out" disabled="false">
<when condition="(Request.TransType=&quot;CASH_OUT&quot;)&amp;&amp;(Request.Amount&gt;500)">
<return>1</return>
</when>
</rule>
<rule name="Transfers" disabled="false">
<when condition="(Request.TransType=&quot;TRANSFER&quot;)&amp;&amp;(Request.Amount&gt;1000)">
<return>1</return>
</when>
</rule>
<return>0</return>
</ruleSet>
</ruleDefinition>
}

}
