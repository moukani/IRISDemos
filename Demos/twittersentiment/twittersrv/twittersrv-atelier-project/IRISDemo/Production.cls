Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Twitter Streaming Service" Category="" ClassName="Twitter.BS.Streaming.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="TwitterAPIFollowString"></Setting>
    <Setting Target="Adapter" Name="TwitterAccessTokenCredentials">TwitterAppUserTokenCredentials</Setting>
    <Setting Target="Adapter" Name="TwitterAppConsumerCredentials">TwitterAppConsumerCredentials</Setting>
    <Setting Target="Adapter" Name="TwitterAPITrackString">#irisdemo</Setting>
    <Setting Target="Host" Name="TargetConfigName">Evaluate Tweet Process</Setting>
  </Item>
  <Item Name="Evaluate Tweet Process" Category="" ClassName="IRISDemo.BP.EvaluateTweet.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
