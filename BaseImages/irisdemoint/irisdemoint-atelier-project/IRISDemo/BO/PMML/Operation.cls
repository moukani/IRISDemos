Include %PMML

Class IRISDemo.BO.PMML.Operation Extends Ens.BusinessOperation
{

	Parameter INVOCATION = "Queue";
	
	/// This setting is required only if you are using the simple Execute() method. 
	Property PMML As %String(MAXLEN = "") [ InitialExpression = "[Based on Request]" ];
	
	Parameter SETTINGS = "PMML::selector?context={IRISDemo.Util.ContextSearch/PMMLModels?targets=1&productionName=@productionId}";

	Method Execute(pInput As IRISDemo.BO.PMML.ExecuteModelReq, Output pOutput As IRISDemo.BO.PMML.ExecuteModelResp) As %Status
	{
		#Dim oModel As %DeepSee.PMML.Model.AbstractModel
		
		Set tSC = $System.Status.OK()
		Try
		{
			If ..PMML="[Based on Request]"
			{
				Set tSC = $System.Status.DisplayError(5001, "Specify the PMML parameter or use ExecuteParamModelReq instead of ExecuteModelReq.")
				Quit
			}
			
			// Obtain an instance of the requested model
			Set tSC = ..GetModelInstance(pInput.ModelName, .oModel)
			Quit:$$$ISERR(tSC)
			
			// Provide ModelData as an array
			Kill aModelData
			Set tKey = ""
			While 1 {
				Set tValue = pInput.ModelData.GetNext(.tKey)
				Quit:tKey=""
				Set aModelData(tKey) = tValue
			}
			
			// Now, let's execute the model...
			Set tSC = oModel.%ExecuteModel(.aModelData, .oModelDataOutput)
			Quit:$System.Status.IsError(tSC)
			
			
			//Now we have to convert the data output into an array so we can then copy the values into pOutput.ModelOutput
			//Unfortunately, the DataOutput model has no %GetAsArray to help us with. 
			
			Set pOutput = ##class(IRISDemo.BO.PMML.ExecuteModelResp).%New()
			
			Do oModelDataOutput.%GetFields(.aFields)
			set tFieldName = ""
			For 
			{
				Set tFieldName = $order(aFields(tFieldName))
				Quit:tFieldName=""
				
				Set tPropName = $$$PROPERTYNAME(tFieldName)
				
				Do pOutput.ModelOutput.SetAt($property(oModelDataOutput, tPropName), tPropName)
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}

	Method ExecuteParam(pInput As IRISDemo.BO.PMML.ExecuteParamModelReq, Output pOutput As IRISDemo.BO.PMML.ExecuteModelResp) As %Status
	{
		Set ..PMML = pInput.ModelClassName
		Quit ..Execute(pInput, .pOutput)
	}
	
	
	/// Internal array of model instances to (re)use
	Property ModelInstances as array of %DeepSee.PMML.Model.AbstractModel [ Private, Internal ];
	
	Method GetModelInstance(pModelName As %String = "", pModel As %DeepSee.PMML.Model.AbstractModel) As %Status [ Private ]
	{
		set pModel = ..ModelInstances.GetAt(pModelName)
		quit:$isobject(pModel) $$$OK
		
		// if the model hadn't been cached yet, create a fresh instance
		set tSC = $classmethod(..PMML, "%GetModelInstance", pModelName, .pModel)
		quit:$$$ISERR(tSC) tSC
		do ..ModelInstances.SetAt(pModel, pModelName)
		quit $$$OK
	}
	
	/// Override Set method to ensure model instances are cleaned up
	Method PMMLSet(pPMML As %String) As %Status [ ServerOnly = 1, Internal ]
	{
		set i%PMML = pPMML
		do ..ModelInstances.Clear()
		quit $$$OK
	}


	XData MessageMap
	{
	<MapItems>
		<MapItem MessageType="IRISDemo.BO.PMML.ExecuteParamModelReq">
			<Method>ExecuteParam</Method>
		</MapItem>
		<MapItem MessageType="IRISDemo.BO.PMML.ExecuteModelReq">
			<Method>Execute</Method>
		</MapItem>
	</MapItems>
	}

}
