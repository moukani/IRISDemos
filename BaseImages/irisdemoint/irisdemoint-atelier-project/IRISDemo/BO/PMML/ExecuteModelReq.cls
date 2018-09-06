Class IRISDemo.BO.PMML.ExecuteModelReq Extends (%Persistent,Ens.Request)
{

	Property ModelData As %DeepSee.PMML.Data;

Storage Default
{
<Data name="ExecuteModelReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelData</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.B117E.ExecuteModeBDD2D</DataLocation>
<DefaultData>ExecuteModelReqDefaultData</DefaultData>
<IdLocation>^IRISDemo.B117E.ExecuteModeBDD2D</IdLocation>
<IndexLocation>^IRISDemo.B117E.ExecuteModeBDD2I</IndexLocation>
<StreamLocation>^IRISDemo.B117E.ExecuteModeBDD2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}