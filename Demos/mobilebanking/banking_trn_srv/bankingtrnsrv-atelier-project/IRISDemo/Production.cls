Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Banking Core Transaction Operation" Category="Banking Core" ClassName="BankingCore.Transaction.TransactionServicesSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">BankingCore</Setting>
  </Item>
  <Item Name="Banking Transaction Service" Category="" ClassName="BankingSrv.BS.Transaction.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Transaction Process" Category="Banking Core" ClassName="BankingSrv.BP.Transaction.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RuleLogging">a</Setting>
  </Item>
  <Item Name="White List Service" Category="White List" ClassName="WhiteList.BS.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="White List Operation" Category="White List" ClassName="WhiteList.BO.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
