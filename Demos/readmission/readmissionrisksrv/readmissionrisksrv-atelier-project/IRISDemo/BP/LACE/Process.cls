/// 
Class IRISDemo.BP.LACE.Process Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='RRLACESrv.BO.DischargeRequest' response='RRLACESrv.BO.RiskResponse' height='2000' width='2000' >
<context>
<property name='DischargeResponse' type='%Library.Status' initialexpression='1' instantiate='0' />
<property name='EmailTo' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='EmailSubject' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='EmailText' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='RiskScore' type='%Integer' instantiate='0' />
<property name='LScore' type='%Integer' instantiate='0' />
<property name='AScore' type='%Integer' instantiate='0' />
<property name='CScore' type='%Integer' instantiate='0' />
<property name='EScore' type='%Integer' instantiate='0' />
</context>
<sequence xend='200' yend='1050' >
<call name='Discharge patient' target='RRLACESrv.BO.LACESoap' async='0' xpos='200' ypos='250' >
<request type='RRLACESrv.BO.DischargeRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='RRLACESrv.BO.DischargeResponse' >
<assign property="context.DischargeResponse" value="callresponse.DischargeResult" action="set" />
</response>
</call>
<if name='Discharge OK?' condition='context.DischargeResponse=1' xpos='200' ypos='350' xend='200' yend='950' >
<true>
<call name='Calculate Risk' target='RRLACESrv.BO.LACESoap' async='0' xpos='335' ypos='500' >
<request type='RRLACESrv.BO.RiskRequest' >
<assign property="callrequest.PatientID" value="request.PatientID" action="set" />
<assign property="callrequest.EncounterNumber" value="request.EncounterNumber" action="set" />
</request>
<response type='RRLACESrv.BO.RiskResponse' >
<assign property="response" value="callresponse" action="set" />
<assign property="context.RiskScore" value="callresponse.RiskScore" action="set" />
<assign property="context.LScore" value="callresponse.LScore" action="set" />
<assign property="context.AScore" value="callresponse.AScore" action="set" />
<assign property="context.CScore" value="callresponse.CScore" action="set" />
<assign property="context.EScore" value="callresponse.EScore" action="set" />
</response>
</call>
<if name='Risk Alert?' condition='context.RiskScore&gt;4' xpos='335' ypos='600' xend='335' yend='850' >
<true>
<call name='Send Email' target='RRLACESrv.BO.LACESoap' async='0' xpos='470' ypos='750' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
</true>
</if>
</true>
</if>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
