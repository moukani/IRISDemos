Include %sySystem

Class IRISDemo.SendSignalsToMonitorTask Extends (IRISDemo.Util.BaseTask, %SYS.Task.Definition)
{
	Parameter TaskName = "Send Signals to IOT Monitor Production";
	
	/// Where I find the files
	Property OverflowDir As %String [ InitialExpression = "/to_iotmon/" ];
	
	/// Where I should put the files for the IOT Monitor Production
	Property IOTMonitorDir As %String [ InitialExpression = "/common_shared/transformer_signals/" ];
	
	/// the minimun time granularity of a task is 1min. We will send 2 files every minute (1 every 30 seconds)
	Property FilesPerMinute As %Integer (MINVAL=1, MAXVAL=12) [ InitialExpression = 2];
	
	/// I am overriding this because I want Logging enabled by default for my task
	Property DebugLog As %Boolean [ InitialExpression = 1 ];
	
	Method OnTaskExecution() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			Set oFileListRS = ##class(%ResultSet).%New("%Library.File:FileSet")
			
			Set tSC = oFileListRS.Execute(..OverflowDir,"*.csv")
			Quit:$System.Status.IsError(tSC)
			
			
			Set iWaitTime=(60/..FilesPerMinute)-0.1
			
			For i=1:1:..FilesPerMinute
			{
				Quit:'oFileListRS.Next()
				
				Set tFileName = oFileListRS.Get("Name")
				Do ..Log("Sending file "_tFileName_" to IOT Monitor Production...")
				
				Set tNewFileName = ..IOTMonitorDir_$Piece(tFileName,"/",*)
				
				Do ##class(%File).CopyFile(tFileName,tNewFileName, .return)
				If ((return'=0) || (##class(%File).Exists(tNewFileName) = 0))
				{
					Set tSC = $System.Status.Error(5001,"Could not move file "_tFileName_" to "_tNewFileName_".")
					Quit
				}
				
				Do ..Log("Deleting file "_tFileName_"...")
				Do ##class(%File).Delete(tFileName, .return)
				If return'=0
				{
					Set tSC = $System.Status.Error(5001,"Could not delete file "_tFileName_".")
					Quit
				}
				
				Hang iWaitTime //Let's wait now before sending the next one.
			}

		}
		Catch(Exception)
		{
			Set tSC = Exception.AsStatus()
		}
		
        If $System.Status.IsError(tSC)
        {
             Do ..LogStatus(tSC, "OnTaskExecution")
        }

		Quit $$$OK // I don't want my task to stop because of an error that may be temporary
	}
}