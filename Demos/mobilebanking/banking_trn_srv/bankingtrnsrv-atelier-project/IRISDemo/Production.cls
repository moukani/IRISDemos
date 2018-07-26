Class IRISDemo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Banking Core Transaction Operation" Category="Banking Core" ClassName="BankingCore.Transaction.TransactionServicesSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">BankingCore</Setting>
  </Item>
</Production>
}

}
