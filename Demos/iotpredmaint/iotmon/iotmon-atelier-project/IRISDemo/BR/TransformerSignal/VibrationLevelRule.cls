/// 
Class IRISDemo.BR.TransformerSignal.VibrationLevelRule Extends Ens.Rule.Definition
{

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="IRISDemo.BP.TransformerSignal.Process.Context" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Vibration Level 0" disabled="false">
<when condition="Vibration&lt;3.3054140391">
<assign property="VibrationLevel" value="0"></assign>
</when>
</rule>
<rule name="Vibration Level 1" disabled="false">
<when condition="(Vibration&gt;=3.3054140391)&amp;&amp;(Vibration&lt;5.68043071494)">
<assign property="VibrationLevel" value="1"></assign>
</when>
</rule>
<rule name="Vibration Level 2" disabled="false">
<when condition="(Vibration&gt;=5.68043071494)&amp;&amp;(Vibration&lt;8.18428831676)">
<assign property="VibrationLevel" value="2"></assign>
</when>
</rule>
<rule name="Vibration Level 3" disabled="false">
<when condition="Vibration&gt;=8.18428831676">
<assign property="VibrationLevel" value="3"></assign>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
