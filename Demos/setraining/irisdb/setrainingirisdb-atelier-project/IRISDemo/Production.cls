Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <!-- We don't need these for now / Item Name="PMML File Loader" Category="" ClassName="IRISDemo.BS.PMML.File.PMMLLoader" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/common_shared/pmml/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.pmml</Setting>
  </Item>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item-->
  <Item Name="Readmission Risk HL7 Service" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">readmissionrisksrv</Setting>
    <Setting Target="Adapter" Name="Port">9999</Setting>
  </Item>
  <Item Name="Application Trigger Service" Category="" ClassName="IRISDemo.BS.AppTrigger.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Application HL7 Trigger Process" Category="" ClassName="IRISDemo.BP.HL7AppTrigger.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
