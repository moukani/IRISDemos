Class IRISDemo.Production Extends Ens.Production
{

ClassMethod OnConfigChange(pProduction As Ens.Config.Production, pItem As Ens.Config.Item)
{
	/// We index the Business Services on the production every time there is a change on the production.
	/// This is used by the DispatchTo() method on class IRISDemo.BS.REST.Service base class to find out 
	/// what is the config item name of the business service class name. 
  	Do ##class(IRISDemo.Utils).IndexProductionItems()
}

ClassMethod Start() As %Status
{
	Set tSC = ##super()
	Quit:$System.Status.IsError(tSC) tSC

	/// We index the Business Services on the production every time the production starts. 
	/// This is used by the DispatchTo() method on class IRISDemo.BS.REST.Service base class to find out 
	/// what is the config item name of the business service class name. 
	/// If the production is started with ##class(Ens.Director).StartProduction() this method is not called. 
	/// But that is not a problem since every time we need to resolve the business config name, we verify if our
	/// index temporary global exists (see method GetBusinessServiceConfigItemName() on IRISDemo.Utils class).
	/// If the temporary global indsex does not exist on the first time we call GetBusinessServiceConfigItemName()
	/// we will index the production once on a temporary global. 
	Quit ##class(IRISDemo.Utils).IndexProductionItems()
}

ClassMethod OnStop(pTimeStarted As %String, pForced As %Boolean)
{
	/// This is the temporary global GetBusinessServiceConfigItemName() uses. We want to kill it 
	/// when the production stops.
	Kill ^IRIS.Temp.IRISDemoIndex
}

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
