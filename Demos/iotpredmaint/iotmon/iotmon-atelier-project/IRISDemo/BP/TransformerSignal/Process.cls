/// 
Class IRISDemo.BP.TransformerSignal.Process Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='IRISDemo.RM.TransformerSignal.Record' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='VibrationLevel' type='%Integer' initialexpression='1' instantiate='0' />
<property name='Threat' type='%Integer' initialexpression='0' instantiate='0' />
<property name='Vibration' type='%Decimal' instantiate='0' />
<property name='ModelClassName' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
<property name='WFResponse' type='EnsLib.Workflow.TaskResponse' instantiate='0' />
</context>
<sequence xend='200' yend='1300' >
<assign name="Store Vibration on Context" property="context.Vibration" value="request.Vibration" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[To be used on Business Rule...]]></annotation>
</assign>
<rule name='Determine Vibration Level' rule='IRISDemo.BR.TransformerSignal.VibrationLevelRule'  ruleContext='context' xpos='200' ypos='350' >
</rule>
<assign name="Defining ML to Call" property="context.ModelClassName" value="&quot;IRISDemo.ImportedModel.DTTransformer&quot;_request.TransformerCode" action="set" xpos='200' ypos='450' >
<annotation><![CDATA[Each Transformer has a specific ML model.]]></annotation>
</assign>
<call name='Call ML Model ' target='Anomaly Detection ML Operation' async='0' xpos='200' ypos='550' >
<annotation><![CDATA[To determine if there is an anomaly]]></annotation>
<request type='IRISDemo.BO.PMML.ExecuteParamModelReq' >
<assign property="callrequest.ModelData" value="context.Vibration" action="set" key="&quot;Vibration&quot;" />
<assign property="callrequest.ModelClassName" value="context.ModelClassName" action="set" />
<assign property="callrequest.ModelData" value="context.VibrationLevel" action="set" key="&quot;VibrationLevel&quot;" />
<assign property="callrequest.ModelData" value="request.TransformerLoad" action="set" key="&quot;TransformerLoad&quot;" />
<assign property="callrequest.ModelData" value="request.TopOilTemperature" action="set" key="&quot;TopOilTemperature&quot;" />
<assign property="callrequest.ModelData" value="request.BottomOilTemperature" action="set" key="&quot;BottomOilTemperature&quot;" />
<assign property="callrequest.ModelData" value="request.OilVolume" action="set" key="&quot;OilVolume&quot;" />
<assign property="callrequest.ModelData" value="request.MoistureInOil" action="set" key="&quot;MoistureInOil&quot;" />
</request>
<response type='IRISDemo.BO.PMML.ExecuteModelResp' >
<assign property="context.Threat" value="callresponse.ModelOutput.GetAt(&quot;pmmlprediction&quot;)" action="set" />
</response>
</call>
<if name='Threat&gt;0' condition='context.Threat&gt;0' xpos='200' ypos='650' xend='200' yend='1200' >
<annotation><![CDATA[If there is a threat]]></annotation>
<true>
<alert value='"Transformer "_request.TransformerCode_" is on threat level "_context.Threat_"!"' xpos='335' ypos='800' />
<call name='Call Maintenance Team' target='Maintenance Team' async='0' xpos='335' ypos='900' >
<request type='EnsLib.Workflow.TaskRequest' >
<assign property="callrequest.%Subject" value="&quot;Transformer &quot;_request.TransformerCode_&quot; is on threat level &quot;_context.Threat" action="set" />
<assign property="callrequest.%Message" value="&quot;Transformer &quot;_request.TransformerCode_&quot; has a threat level &quot;_context.Threat_&quot;. Please, initiate maitenance protocol and report.&quot;" action="set" />
<assign property="callrequest.%FormFields" value="&quot;Field Report&quot;" action="set" />
<assign property="callrequest.%Title" value="&quot;Threat level &quot;_context.Threat" action="set" />
<assign property="callrequest.%Actions" value="&quot;Problem Fixed,Needs Replacement&quot;" action="set" />
</request>
<response type='EnsLib.Workflow.TaskResponse' >
<assign property="context.WFResponse" value="callresponse" action="set" />
</response>
</call>
<sync name='Wait for Report' calls='Call Maintenance Team' type='all' xpos='335' ypos='1000' />
<call name='Archive Signal with Report' target='Archive Signal Operation' async='1' xpos='335' ypos='1100' >
<request type='ArchiveDB.BO.ArchiveTransformerSignal.Request' >
<assign property="callrequest.TransformerCode" value="request.TransformerCode" action="set" />
<assign property="callrequest.TimeOfMeasurement" value="request.TimeOfMeasurement" action="set" />
<assign property="callrequest.TransformerLoad" value="request.TransformerLoad" action="set" />
<assign property="callrequest.TopOilTemperature" value="request.TopOilTemperature" action="set" />
<assign property="callrequest.BottomOilTemperature" value="request.BottomOilTemperature" action="set" />
<assign property="callrequest.OilVolume" value="request.OilVolume" action="set" />
<assign property="callrequest.MoistureInOil" value="request.MoistureInOil" action="set" />
<assign property="callrequest.Vibration" value="request.Vibration" action="set" />
<assign property="callrequest.VibrationLevel" value="context.VibrationLevel" action="set" />
<assign property="callrequest.Threat" value="context.Threat" action="set" />
<assign property="callrequest.ActionTaken" value="context.WFResponse.%Action" action="set" />
<assign property="callrequest.FieldReport" value="context.WFResponse.%FormValues.GetAt(&quot;Field Report&quot;)" action="set" />
<assign property="callrequest.MaitenanceTeamMember" value="context.WFResponse.%UserName" action="set" />
</request>
<response type='Ens.Response' />
</call>
</true>
</if>
</sequence>
</process>
}

}
