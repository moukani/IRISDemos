/// 
Class IRISDemo.BP.ReadmissionRisk.Process Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='RRLACESrv.BO.DischargeRequest' response='Ens.Response' height='2000' width='2000' >
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
<property name='PatientID' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='DischargeLocation' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='AlertMessage' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1700' >
<call name='Discharge patient' target='LACE SOAP Operation' async='0' xpos='200' ypos='250' >
<request type='RRLACESrv.BO.DischargeRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='RRLACESrv.BO.DischargeResponse' >
<assign property="context.DischargeResponse" value="callresponse.DischargeResult" action="set" />
</response>
</call>
<if name='Discharge OK?' condition='context.DischargeResponse=1' xpos='200' ypos='350' xend='200' yend='1600' >
<true>
<call name='Calculate Risk' target='LACE SOAP Operation' async='0' xpos='335' ypos='500' >
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
<if name='Risk Alert?' condition='context.RiskScore&gt;4' xpos='335' ypos='600' xend='335' yend='1500' >
<true>
<assign name="Compose Alert Message" property="context.AlertMessage" value="&quot;Patient '&quot;_request.PatientID_&quot;' has just been discharged to '&quot;_request.DischargeLocation_&quot;' and has a &quot;_$select(context.RiskScore&gt;9:&quot;high&quot;,1:&quot;moderate&quot;)_&quot; risk of readmission&quot;_$char(13,10)_&quot;The scores are as follows:&quot;_$char(13,10)_&quot;Risk Score: &quot;_context.RiskScore_$char(13,10)_&quot;'L' Score (Length of stay): &quot;_context.LScore_$char(13,10)_&quot;'A' Score (Acuity): &quot;_context.AScore_$char(13,10)_&quot;'C' Score (Comorbidity): &quot;_context.CScore_$char(13,10)_&quot;'E' Score (Emergency department visits): &quot;_context.EScore" action="set" xpos='470' ypos='750' />
<call name='Add Patient to Risk Program' target='Care Team' async='1' xpos='470' ypos='850' >
<request type='EnsLib.Workflow.TaskRequest' >
<assign property="callrequest.%Message" value="context.AlertMessage" action="set" />
<assign property="callrequest.%Subject" value="&quot;Patient at Risk of Readmission&quot;" action="set" />
<assign property="callrequest.%Actions" value="&quot;Visisted the Patient,Called the Patient&quot;" action="set" />
<assign property="callrequest.%FormFields" value="&quot;PatientID,DischargeLocation,RiskScore&quot;" action="set" />
<assign property="callrequest.%FormValues" value="request.PatientID_&quot;,&quot;_request.DischargeLocation_&quot;,&quot;_context.RiskScore" action="set" />
</request>
<response type='EnsLib.Workflow.TaskResponse' />
</call>
<call name='Alert Care Team' target='Risk Alert Email Operation' async='0' xpos='470' ypos='950' >
<request type='IRISDemo.BO.Email.EmailMessage' >
<assign property="callrequest.From" value="&quot;IRISDemo&quot;" action="set" />
<assign property="callrequest.Subject" value="&quot;LACE readmission alert&quot;" action="set" />
<assign property="callrequest.To" value="&quot;readmission.alert@healthcare.med&quot;" action="set" />
<assign property="callrequest.MessageText" value="context.AlertMessage" action="set" />
</request>
</call>
<sync name='Follow up SLA 2 days' calls='Add Patient to Risk Program' timeout='172800' type='all' xpos='470' ypos='1050' >
<annotation><![CDATA[Is the patient following the care plan?]]></annotation>
</sync>
<if name='No follow up?' condition='synctimedout' xpos='470' ypos='1150' xend='470' yend='1400' >
<true>
<alert value='"Follow up of patient id "_request.PatientID_" pending."' xpos='605' ypos='1300' />
</true>
</if>
</true>
</if>
</true>
</if>
</sequence>
</process>
}

/// BPL Definition
Storage Default
{
<Description>
<![CDATA[BPL Definition]]></Description>
<Type>%Storage.Persistent</Type>
}

}
