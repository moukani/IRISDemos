Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Transformer Signals In" Category="" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">Transformer Signal Process</Setting>
    <Setting Target="Host" Name="RecordMap">IRISDemo.RM.TransformerSignal</Setting>
    <Setting Target="Adapter" Name="FilePath">/common_shared/transformer_signals/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
  </Item>
  <Item Name="Transformer Signal Process" Category="" ClassName="IRISDemo.BP.TransformerSignal.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="Archive Signal Operation" Category="" ClassName="ArchiveDB.BO.ArchiveTransformerSignal.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">Java Gateway Service</Setting>
    <Setting Target="Adapter" Name="Credentials">ArchiveDB</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:IRIS://archivedb:51773/APP</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.intersystems.jdbc.IRISDriver</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
    <Setting Target="Host" Name="RetryInterval">30</Setting>
    <Setting Target="Adapter" Name="StayConnected">10</Setting>
  </Item>
  <Item Name="PMML File Loader" Category="" ClassName="IRISDemo.BS.PMML.File.PMMLLoader" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/common_shared/pmml/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.pmml</Setting>
    <Setting Target="Adapter" Name="ConfirmComplete">1</Setting>
  </Item>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Anomaly Detection ML Operation" Category="" ClassName="IRISDemo.BO.PMML.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Maintenance Team" Category="" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
