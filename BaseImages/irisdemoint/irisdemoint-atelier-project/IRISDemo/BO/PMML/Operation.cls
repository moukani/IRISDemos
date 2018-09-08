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
			//Oddily enough, %GetModelInstance will give me not an instance of the model
			//but the type of model (i.e: TreeModel)
			Set tSC = $classmethod(..PMML, "%GetModelInstance", .tModelType)
			
			Set tModelClass = ..PMML_"."_tModelType
			
			//Now we can create that model
			Set oModel = $classmethod(tModelClass, "%New")
			
			//Let's take the name of the class used as input data...
			Set tDataClassName = oModel.%GetDataClassName()
			
			//Let's create the input data instance...
			Set oModelInputData = $classmethod(tDataClassName, "%New")
			
			//Assuming that every key on pInput.ModelData represents the name of an 
			//existing property on the input data model, let's set all the properties
			//on the model with the received pInput values: 
			Set tKey=""
			For
			{
				Set tKey = pInput.ModelData.Next(tKey)
				Quit:tKey=""
				
				Set tValue = pInput.ModelData.GetAt(tKey)
				
				$$$TRACE("Setting oModelInputData."_tKey_"="_tValue)
				Set $property(oModelInputData, tKey) = tValue
			}
			
			//Now, let's execute the model...
			Set tSC = oModel.%ExecuteModel(oModelInputData, .oModelDataOutput)
			Quit:$System.Status.IsError(tSC)
			
			
			//Now we have to convert the data output into an array so we can then copy the values into pOutput.ModelOutput
			//Unfortunately, the DataOutput model has no %GetAsArray to help us with. We will have to use class
			//dictionary for that:
			
			Set tOutputModelClass=oModelDataOutput.%ClassName(1)
			Set oOutputModelClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(tOutputModelClass)
			
			Set pOutput = ##class(IRISDemo.BO.PMML.ExecuteModelResp).%New()
			
			For iProp=1:1:oOutputModelClassDef.Properties.Count()
			{
				Set tPropName = oOutputModelClassDef.Properties.GetAt(iProp).Name
				
				Do pOutput.ModelOutput.SetAt($property(oModelDataOutput, tPropName), tPropName)
			}
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