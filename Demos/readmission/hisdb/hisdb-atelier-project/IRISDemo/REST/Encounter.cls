Include DEMOMACROS

Class IRISDemo.REST.Encounter Extends %CSP.REST
{

	Parameter UseSession = 1;
	
	Parameter CONVERTINPUTSTREAM = 1;
	
	Parameter CHARSET = "utf-8";
	
	Parameter HandleCorsRequest = 1;

	XData UrlMap
	{
		<Routes>
		  <Route Url="/resetdemo/" Method="GET" Call="ResetDemo"/>
		  <Route Url="/discharge/" Method="POST" Call="Discharge"/>
		  <Route Url="/list/" Method="GET" Call="List"/>
		</Routes>
	}
	
	ClassMethod ResetDemo() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.requestResult={}

			Do ##class(IRISDemo.Data.Utils).ResetDemo()
			
			//
			// Everything worked out OK!
			//
			Set response.requestResult.status="OK"
		}
		Catch (oException)
		{
			//
			// Ops! Something went wrong!
			//
			Set response.requestResult.status="Error"
			Set response.requestResult.exception=$$$ExceptionAsJSON(oException)
		}
		
		// Whatever the response is, let's send it
		Write response.%ToJSON()
		
		Quit $$$OK
	}
	
	ClassMethod List(pMRN As %String = "", pFirstName As %String = "", pLastName As %String = "") As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.encounters=[]
			Set response.requestResult={}
			
			Set tSQL="select Patient->MRN, Patient->FirstName, Patient->LastName, Patient->Gender, Patient->DoB, "_
					 "EncounterNumber, EncounterType, StartDate, StartTime, EndDate, EndTime, EncounterStatus, DischargeDestination "_
					 " from IRISDemo_Data.Encounter"
			
			Set bHasWhereClause=0
			
			Set pMRN=$Translate(pMRN,"'","")
			If pMRN'=""
			{
				Set tSQL=tSQL_" where MRN='"_pMRN_"'"
				Set bHasWhereClause=1
			}

			Set pFirstName=$Translate(pFirstName,"'","")
			If pFirstName'=""
			{
				Set tSQL=tSQL_$Select(bHasWhereClause:" and ",1:" where ")_" FirstName %StartsWith '"_pFirstName_"'"
				Set bHasWhereClause=1
			}

			Set pLastName=$Translate(pLastName,"'","")
			If pLastName'=""
			{
				Set tSQL=tSQL_$Select(bHasWhereClause:" and ",1:" where ")_" FirstName %StartsWith '"_pLastName_"'"
			}
			
			Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL)
			
			Set oResultMetadata = oRS.%GetMetadata()
			
			While oRS.%Next()
			{
				Set encounter={}
				
				For iCol=1:1:oResultMetadata.columnCount
				{
					Set oColumn = oResultMetadata.columns.GetAt(iCol)
					Set $property(encounter, oColumn.colName)=oRS.%GetData(iCol)
				}
				
				Do response.encounters.%Push(encounter)
			}
			
			//
			// Everything worked out OK!
			//
			Set response.requestResult.status="OK"
		}
		Catch (oException)
		{
			//
			// Ops! Something went wrong!
			//
			Set response.requestResult.status="Error"
			Set response.requestResult.exception=$$$ExceptionAsJSON(oException)
		}
		
		// Whatever the response is, let's send it
		Write response.%ToJSON()
		
		Quit $$$OK
	}
	
	ClassMethod Discharge() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.requestResult={}
			
			// Transform the JSON string from the POST into a dynamic object
			Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set oEncounter = ##class(IRISDemo.Data.Encounter).%OpenId(request.encounterId)
			If '$IsObject(oEncounter) $$$ThrowException("EncounterNotFoundException", "encounterId: "_request.encounterId)
			
			Do oEncounter.Discharge()
			
			//
			// Everything worked out OK!
			//
			Set response.requestResult.status="OK"
		}
		Catch (oException)
		{
			//
			// Ops! Something went wrong!
			//
			Set response.requestResult.status="Error"
			Set response.requestResult.exception=$$$ExceptionAsJSON(oException)
		}
		
		// Whatever the response is, let's send it
		Write response.%ToJSON()
		
		Quit $$$OK
	}
}