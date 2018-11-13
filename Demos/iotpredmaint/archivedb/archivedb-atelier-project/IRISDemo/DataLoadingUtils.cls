Include DEMOMACROS

Class IRISDemo.DataLoadingUtils
{	
	Parameter OVERFLOWDIR = "/to_iotmon/";
	
	/// This is called from IRISDemo.Installer to create the user merchants, 
	/// customer accounts and transactions between them
	ClassMethod LoadFullDataFromCSVFile(pFileName As %String, pImageBuildTS As %TimeStamp) As %Status
	{
		#Dim oRSInsert As %SQL.Statement
		#Dim oSignal As IRISDemo.TransformerSignal
		
		Set tSC = $$$OK
		Try
		{
			DO DISABLE^%NOJRN
			
			// Identifying transformer by file name. Calculating base time stamp. Leaving 2% for loading during the demo.
			Set tSC = ..PrepareDataLoad(pFileName, 0.2, pImageBuildTS, .oTransformer, .tBaseTimeStamp, .iMaxNumOfMeasurementsToRead, .tOverflowFileHeader)
			Quit:$System.Status.IsError(tSC)
			
			Set oRSSignal=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV")
			
			Set tSC = oRSSignal.Execute(pFileName)
			Quit:$System.Status.IsError(tSC)
			
			Set iCurrentMeasurement=0
				
			// Every record represents a measure taken every minute for a single transformer			
			While oRSSignal.Next()
			{
				Set iCurrentMeasurement=iCurrentMeasurement+1
				Set tTimeOfMeasurementTS = $System.SQL.DATEADD("s", iCurrentMeasurement, tBaseTimeStamp) 

				If iCurrentMeasurement<=iMaxNumOfMeasurementsToRead
				{
					Set oSignal = ##class(IRISDemo.TransformerSignal).%New()
					Set oSignal.Transformer = oTransformer
					Set oSignal.TimeOfMeasurement = tTimeOfMeasurementTS
					Set oSignal.BottomOilTemperature = oRSSignal.Get("bot")
					
					// Once this has been set to 1, it will be 1 for ever
					If oSignal.Transformer.IsThereBulging'=1
					{
						Set oSignal.Transformer.IsThereBulging = oRSSignal.Get("bulging")
					}
					Set oSignal.MoistureInOil = oRSSignal.Get("mio")
					Set oSignal.OilVolume = oRSSignal.Get("ov")
					Set oSignal.Threat = oRSSignal.Get("threat")
					Set oSignal.TopOilTemperature = oRSSignal.Get("tot")
					Set oSignal.TransformerLoad = oRSSignal.Get("load")
					Set oSignal.Vibration = oRSSignal.Get("vibration")
					Set oSignal.VibrationLevel = oRSSignal.Get("vib_level")-1
					
					Set tSC = oSignal.%Save()
					Quit:$System.Status.IsError(tSC)
				}
				Else
				{
					//Write to overflow file to be loaded later by iotmon
					Set tSC = ..WriteToOverflowFile(tTimeOfMeasurementTS, oTransformer.Code, oRSSignal, tOverflowFileHeader)
					Quit:$System.Status.IsError(tSC)
				}
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		DO ENABLE^%NOJRN
				
		Quit tSC
	}
	
	ClassMethod PrepareDataLoad(pFileName As %String, pPercLeftForDemo As %Float, pImageBuildTS As %String, Output pTransformer As Transformer, Output pBaseTimeStamp As %TimeStamp, Output pNumOfMeasurements As %Integer, Output pOverflowFileHeader As %String) As %Status
	{
		Set tSC = $$$OK
		Try
		{
			Set oFile = ##class(%Stream.FileCharacter).%New()
			Set oFile.TranslateTable="UTF8"
			Set oFile.Filename=pFileName
			
			Set iNumOfMeasurements=0
			
			// Header
			Set pOverflowFileHeader=oFile.ReadLine()
			
			While 'oFile.AtEnd
			{
				Set tRow=oFile.ReadLine()
				Continue:tRow=""
				
				Set iNumOfMeasurements=iNumOfMeasurements+1
			}
			
			Set pNumOfMeasurements = iNumOfMeasurements*(1-pPercLeftForDemo)

			// A measurement per minute
			Set iSecondsOfMeasurement = pNumOfMeasurements*60

			// When did we started measuring?
			Set pBaseTimeStamp = $System.SQL.DATEADD("s", -iSecondsOfMeasurement, pImageBuildTS)
			
			// This is always linux so that we can safely assume / as a separator
			Set tFileName=$Piece($Piece(pFileName,"/",*),".")
			
			Set tFileNameU=$ZConvert(tFileName,"U")
			
			Set tTransformerCode=$Piece(tFileNameU,"TRANSFORMER",2)
			
			Set pTransformer=##class(IRISDemo.Transformer).CodeIndexOpen(tTransformerCode,, .tSC)
			
			// We must always check the status code:
			If $System.Status.IsError(tSC)
			{
				// If the error is something different from "object does not exist", 
				// let's quit because something went really wrong...
				If $System.Status.GetErrorCodes(tSC)'["5770"
				{
					Quit
				}
				
				// If I am here, that is because the error is "object does not exist"
				// So let's reset it to Ok, because we are going to create this object...
				Set tSC = $$$OK
			}
			
			// If I found the object, we are done!
			Quit:$IsObject(pTransformer)
			
			Set pTransformer=##class(IRISDemo.Transformer).%New()
			Set pTransformer.Code=tTransformerCode
			Set pTransformer.Model = ..GetTransformerModel(tTransformerCode, .tSC)
			Quit:$System.Status.IsError(tSC)
			
			Set tSC = pTransformer.%Save()
			Quit:$System.Status.IsError(tSC)
			
			// I am doing this here instead of doing it on the dockerfile because I was having
			// permissions problems due to having a volume shared between two containers
			If '##class(%File).DirectoryExists(..#OVERFLOWDIR)
			{
				Do ##class(%File).CreateDirectory(..#OVERFLOWDIR, .return)
				If return'=0
				{
					Set tSC = $System.Status.DisplayError(5001, "Could not create directory "_..#OVERFLOWDIR)
				}
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}

ClassMethod GetTransformerModel(pTransformerCode As %String, Output pSC As %Status) As IRISDemo.TransformerModel
{
		Set pSC = $$$OK
		Set oTransformerModel=""
		Try
		{
			Set tCompanyList="Mitsubishi,Alstom,Siemens,Delta Star,VTC,ABB"
			Set iModelIdx=(pTransformerCode#3)+1
			Set tManufacturer=$Piece(tCompanyList,",",iModelIdx)
			Set iBase=$Ascii("A")
			Set tTransformerModelCode = tManufacturer_" "_(100*iModelIdx)_$Char(iBase+iModelIdx)
			
			Set oTransformerModel=##class(IRISDemo.TransformerModel).CodeIndexOpen(tTransformerModelCode,, .tSC)
			
			// We must always check the status code:
			If $System.Status.IsError(tSC)
			{
				// If the error is something different from "object does not exist", 
				// let's quit because something went really wrong...
				If $System.Status.GetErrorCodes(tSC)'["5770"
				{
					Quit
				}
				
				// If I am here, that is because the error is "object does not exist"
				// So let's reset it to Ok, because we are going to create this object...
				Set tSC = $$$OK
			}
			
			// If I found the object, we are done!
			Quit:$IsObject(oTransformerModel)
			
			Set oTransformerModel=##class(IRISDemo.TransformerModel).%New()
			Set oTransformerModel.Code=tTransformerModelCode
			Set oTransformerModel.Manufacturer=tManufacturer
			
			Set pSC = oTransformerModel.%Save()
		}
		Catch (oException)
		{
			Set pSC = oException.AsStatus()
		}
		
		Quit oTransformerModel
}

ClassMethod WriteToOverflowFile(pMeasurementDateTime As %TimeStamp, pTransformerCode As %String, pRSSignal As %ResultSet, pOverflowFileHeader As %String) As %Status
	{
		#Dim oOverflowFile As %File
		
		Set tSC = $$$OK
		Try
		{
			Set tOverflowFileName = ..#OVERFLOWDIR_$Translate(pMeasurementDateTime," :-")_".csv"
			
			Set oOverflowFile=##class(%File).%New(tOverflowFileName)
			Set tSC = oOverflowFile.Open("WA")
			If $System.Status.IsError(tSC)
			{
				Set tSC = oOverflowFile.Open("WN")
			}
			Quit:$System.Status.IsError(tSC)
			
			Set return=$ZF(-1, "chmod 666 "_tOverflowFileName)
			If return'=0
			{
				Set tSC = $System.Status.Error(5001, "Could not change overflow file umask to 666 (rw rw rw).")
				Quit
			}
			
			Set return=$ZF(-1, "chown irisusr:irisusr "_tOverflowFileName)
			If return'=0
			{
				Set tSC = $System.Status.Error(5001, "Could not assign overflow file to irisusr.")
				Quit
			}

			Set i=0
			For iField=1:1:$Length(pOverflowFileHeader,",")
			{
				Set tFieldName=$Piece(pOverflowFileHeader,",",iField)
				If ",threat,bulging,vib_level,"[(","_tFieldName_",") Continue
				
				Set i=i+1
				Set $Piece(tFinalHeader,",",i)=tFieldName
			}
			
			Set tData=pTransformerCode_","_pMeasurementDateTime
			For iField=1:1:$Length(tFinalHeader,",")
			{
				Set tFieldName=$Piece(tFinalHeader,",",iField)
				
				Set $Piece(tData,",",iField+2)=pRSSignal.Get(tFieldName) 
			}
			
			Set tSC = oOverflowFile.WriteLine(tData)
			Quit:$System.Status.IsError(tSC)

			Do oOverflowFile.Close()
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}
}