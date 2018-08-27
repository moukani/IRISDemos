Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Banking Core Transaction Operation" Category="Banking Core" ClassName="BankingCore.Transaction.TransactionServicesSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">BankingCore</Setting>
    <Setting Target="Host" Name="SendSuperSession">0</Setting>
  </Item>
  <Item Name="Banking Transaction Service" Category="Banking Tran. Srv." ClassName="BankingSrv.BS.Transaction.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Transaction Process" Category="Banking Core,Banking Tran. Srv." ClassName="BankingSrv.BP.Transaction.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RuleLogging">a</Setting>
  </Item>
  <Item Name="White List Service" Category="White List" ClassName="WhiteList.BS.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="White List Operation" Category="White List" ClassName="WhiteList.BO.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Datalake Transaction Operations" Category="Datalake" ClassName="Datalake.BO.Transaction.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">Datalake</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:IRIS://datalake:51773/APP</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.intersystems.jdbc.IRISDriver</Setting>
    <Setting Target="Adapter" Name="JGService">Java Gateway Service</Setting>
  </Item>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Create White List Process" Category="White List" ClassName="WhiteList.BP.CreateWLReq.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Datalake White List Operation" Category="Datalake,White List" ClassName="Datalake.BO.WhiteList.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">Java Gateway Service</Setting>
    <Setting Target="Adapter" Name="Credentials">Datalake</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:IRIS://datalake:51773/APP</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.intersystems.jdbc.IRISDriver</Setting>
  </Item>
</Production>
}

}
