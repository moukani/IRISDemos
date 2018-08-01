Class IRISDemo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
</Production>
}

ClassMethod OnConfigChange(pProduction As Ens.Config.Production, pItem As Ens.Config.Item)
{
  Do ##class(IRISDemo.Utils).IndexProductionItems()  
}

ClassMethod Start() As %Status
{
	Set tSC = ##super()
  Quit:$$$System.Status.IsError(tSC) tSC

  Quit ##class(IRISDemo.Utils).IndexProductionItems()
}
}
