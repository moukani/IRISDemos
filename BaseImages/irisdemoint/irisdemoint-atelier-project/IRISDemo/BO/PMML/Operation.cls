Class IRISDemo.BO.PMML.Operation extends Ens.BusinessOperation {

	Parameter INVOCATION = "Queue";

	Property PMML As %String(MAXLEN="");
	
	Parameter SETTINGS = "PMML::selector?multiSelect=0&context={IRISDemo.Util.ContextSearch/PMMLModels?targets=1&productionName=@productionId}";

	Method Execute(pInput As IRISDemo.BO.PMML.ExecuteModelReq, Output pOutput As IRISDemo.BO.PMML.ExecuteModelResp) As %Status
	{
		#Dim oModel As %DeepSee.PMML.Model.AbstractModel
		
		Set tSC = $System.Status.OK()
		Try
		{
			Set oModel = $classmethod(..PMML, "%New")
			Set tSC = oModel.%ExecuteModel(pInput.ModelData, .oModelOutput)
			Quit:$System.Status.IsError(tSC)
			
			Set pOutput.ModelOutput=oModelOutput
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}
	
	XData MessageMap 
	{
		<MapItems>
		    <MapItem MessageType="IRISDemo.BO.PMML.ExecuteModelReq">
		        <Method>Execute</Method>
		    </MapItem>
		</MapItems>
	}

}