Include DEMOMACROS

Class ArchiveDB.BO.ArchiveTransformerSignal.Operation extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method ArchiveTransformerSignal(pInput As ArchiveDB.BO.ArchiveTransformerSignal.Request, Output pOutput As Ens.Response) As %Status
{
	Set tSC = $$$OK
	Try
	{
		$$$TRACE("Set Auto Commit to OFF")
		Set tSC = ..Adapter.SetAutoCommit(0)
		Quit:$System.Status.IsError(tSC)
		
		$$$TRACE("Finding source account ID...")
		Set tTransformerId = ..FindOrCreateTransformer(pInput.TransformerCode)
		
		$$$TRACE("Inserting new transaction.")
		Set tSC = ..InsertTransaction(tTransformerId, pInput)
		Quit:$System.Status.IsError(tSC)
		
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	If $System.Status.IsError(tSC)
	{
		$$$TRACE("Rolling back the transaction.")
		Set tSC2 = ..Adapter.Rollback()
	}
	Else
	{
		$$$TRACE("Commiting the transaction")
		Set tSC2 = ..Adapter.Commit()
	}
	
	If $System.Status.IsError(tSC2)
	{
		Set tSC = $System.Status.AppendStatus(tSC, tSC2)
	}
	
	Quit tSC
}

Method FindOrCreateTransformer(pTransformerCode As %String) As %String
{
	Set pParams=1
	Set pParams(1)=pTransformerCode
	
	Set tSC = ..Adapter.ExecuteQueryParmArray(.oRS, "select ID from IRISDemo.Transformer where Code=?", .pParams)
	$$$ThrowStatusExceptionIfError(tSC, "FindTransformerException")
	
	If oRS.Next()
	{
		Return oRS.GetData(1)
	}

	Set tSC = ..Adapter.ExecuteQueryParmArray(.oRS, "insert into IRISDemo.Transformer (Code, IsThereBulging) values (?, 0)", .pParams)
	$$$ThrowStatusExceptionIfError(tSC, "CreateTransformerException")
	
	Set tSC = ..Adapter.ExecuteQueryParmArray(.oRS, "select ID from IRISDemo.Transformer where Code=?", .pParams)
	$$$ThrowStatusExceptionIfError(tSC, "FindTransformerException")
	
	If oRS.Next()
	{
		Return oRS.GetData(1)
	}
	
	$$$ThrowStatusExceptionIfError(tSC, "FindTransformerJustInsertedException")
}

Method InsertTransaction(pTransformerId As %Integer, pInput As ArchiveDB.BO.ArchiveTransformerSignal.Request) As %Status
{
	Set tSC = $$$OK
	Try
	{		
		Set tInsertSQL = "insert into IRISDemo.TransformerSignal "_
						 "(Transformer, TimeOfMeasurement, TransformerLoad, TopOilTemperature, BottomOilTemperature, OilVolume, MoistureInOil, Vibration, VibrationLevel, Threat) "_
						 "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		
		Set pInsertParams=10
		
		Set pInsertParams(1)=pTransformerId
		Set pInsertParams(2)=pInput.TimeOfMeasurement
		Set pInsertParams(3)=pInput.TransformerLoad
		Set pInsertParams(4)=pInput.TopOilTemperature
		Set pInsertParams(5)=pInput.BottomOilTemperature
		Set pInsertParams(6)=pInput.OilVolume 
		Set pInsertParams(7)=pInput.MoistureInOil
		Set pInsertParams(8)=pInput.Vibration
		Set pInsertParams(9)=pInput.VibrationLevel
		Set pInsertParams(10)=pInput.Threat
		
		Set tSC =  ..Adapter.ExecuteUpdateParmArray(.iNumRowsAffected, tInsertSQL, .pInsertParams)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	Quit tSC
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="ArchiveDB.BO.ArchiveTransformerSignal.Request">
        <Method>ArchiveTransformerSignal</Method>
    </MapItem>
</MapItems>
}

}