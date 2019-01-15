Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Java Gateway Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIS HL7v2 File Feed" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HIS HL7v2 File Feed_Router</Setting>
    <Setting Target="Adapter" Name="FilePath">/hl7files/in/</Setting>
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
  </Item>
  <Item Name="HIS HL7v2 File Feed_Router" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">IRISDemo.HISHL7v2FileFeedRoutingRule</Setting>
  </Item>
  <Item Name="RRLACESrv.BO.LACESoap" Category="" ClassName="RRLACESrv.BO.LACESoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">RRLACESrv</Setting>
  </Item>
  <Item Name="IRISDemo.BP.LACE.Process" Category="" ClassName="IRISDemo.BP.LACE.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="IRISDemo.BO.Email.Operation" Category="" ClassName="IRISDemo.BO.Email.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIS HL7v2 TCP Feed" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9090</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HIS HL7v2 File Feed_Router</Setting>
  </Item>
</Production>
}

}
