/// <p>This Reader is to be used with %ResultSet. It will allow you to scan a CSV file, record by record.
/// There are three queries available for reading:</p>
/// <ol>
/// <li>CSV - comma separated
/// <li>CSV2 - semicolon separated
/// <li>TSV - tab separated
/// </ol>
/// <p>Use the query accordingly to your file type! The reader expects to find a header on the first line with the name of the fields.
/// This will be used to name the columns when you use the method Get().</p>
/// <p>The reader can deal with fields quoted and unquoted automatically.</p>  
///
///	<p>This assumes that your CSV file has a header line.
/// This custom query supports Comman Separated Values (CSV), Semicolumn Separated Values (CSV2)
/// and Tab Separated Values (TSV).</p>	
///
/// <EXAMPLE>
///
///			; Comma Separated Values
///			;Set oCSVFileRS=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV")
///			;
///			; Semicolon Separated Values
///			;Set oCSVFileRS=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV2")
///			;
///			; Tab Separated Values
///			Set oCSVFileRS=##class(%ResultSet).%New("IRISDemo.Util.FileReader:TSV")
///			
///			Set tSC = oCSVFileRS.Execute(pFileName)
///			Quit:$System.Status.IsError(tSC)
///			
///			While oCSVFileRS.Next()
///			{
///				Set tDataField1 = oCSVFileRS.Get("Column Name 1")
///				Set tDataField2 = oCSVFileRS.Get("Column Name 2")
///				Set tDataField4 = oCSVFileRS.GetData(3)
///				
///				// Your code goes here			
///			}
///	</EXAMPLE>					
///
Class IRISDemo.Util.FileReader Extends %RegisteredObject
{

	/// Use this Query with %ResultSet class to read comma (,) separated files.
	Query CSV(pFileName As %String, pFileEncoding As %String = "UTF8") As %Query
	{
	}
	
	/// Use this Query with %ResultSet class to read semicolon (;) separated files.
	Query CSV2(pFileName As %String, pFileEncoding As %String = "UTF8") As %Query
	{
	}
	
	/// Use this Query with %ResultSet class to read tab separated files.
	Query TSV(pFileName As %String, pFileEncoding As %String = "UTF8") As %Query
	{
	}
	
	/// Index a header from a CSV file so we can later get every row of the file
	/// and read every column by it's name. This method supports fields quoted, double 
	/// quoted or not quoted or a mix of the three. The only thing that is required for this to work
	/// is that the correct field separator is specified (Comma, Semicolon or Tab).
	ClassMethod IndexHeader(pHeader As %String, pSeparator As %String = ",", Output pHeaderIndex)
	{
		//How many columns?
		Set pHeaderIndex=$Length(pHeader,pSeparator)
		
		Set tRegexSeparator=pSeparator
		
		If tRegexSeparator=$Char(9)
		{
			Set tRegexSeparator="\x09"
		}
		
		//Let's build a regular expression to read all the data without the quotes...
		Set pHeaderIndex("Regex")=""
		For i=1:1:pHeaderIndex
		{
			Set $Piece(pHeaderIndex("Regex"),tRegexSeparator,i)="\""?'?(.*?)\""?'?"
		}
		Set pHeaderIndex("Regex")="^"_pHeaderIndex("Regex")
		
		//Let's use this regular expression to index the column names...
		Set oMatcher = ##class(%Regex.Matcher).%New(pHeaderIndex("Regex"))
		Do oMatcher.Match(pHeader)
		
		//Now let's index the colum names
		For i=1:1:oMatcher.GroupCount
		{
			Set pHeaderIndex("Columns",i)=$ZStrip(oMatcher.Group(i),"<>W")
		}
	}

	ClassMethod IndexRow(pRow As %String, ByRef pHeaderIndex As %String, Output pIndexedRow As %String)
	{
		Set oMatcher = ##class(%Regex.Matcher).%New(pHeaderIndex("Regex"))
		Do oMatcher.Match(pRow)
		
		//Now let's index the colum names
		For i=1:1:oMatcher.GroupCount
		{
			Set $List(pIndexedRow,i)=oMatcher.Group(i)
		}
	}



	ClassMethod CSVGetInfo(colinfo As %List, parminfo As %List, idinfo As %List, qHandle As %Binary, extoption As %Integer = 0, extinfo As %List) As %Status
	{
			Quit ..FileGetInfo(.colinfo, .parminfo, .idinfo, .qHandle, .extoption, .extinfo)
	}
	
	ClassMethod CSV2GetInfo(colinfo As %List, parminfo As %List, idinfo As %List, qHandle As %Binary, extoption As %Integer = 0, extinfo As %List) As %Status
	{
			Quit ..FileGetInfo(.colinfo, .parminfo, .idinfo, .qHandle, .extoption, .extinfo)
	}
	
	ClassMethod TSVGetInfo(colinfo As %List, parminfo As %List, idinfo As %List, qHandle As %Binary, extoption As %Integer = 0, extinfo As %List) As %Status
	{
			Quit ..FileGetInfo(.colinfo, .parminfo, .idinfo, .qHandle, .extoption, .extinfo)
	}
	
	ClassMethod FileGetInfo(colinfo As %List, parminfo As %List, idinfo As %List, qHandle As %Binary, extoption As %Integer = 0, extinfo As %List) As %Status
	{
		Merge tHeaderIndex = qHandle("HeaderIndex")
		Set colinfo = ""
		For i=1:1:tHeaderIndex
		{
			Set tColName = tHeaderIndex("Columns",i)
			Set colinfo=colinfo_$LB($LB(tColName))	
		}
		
		Set parminfo=$ListBuild("pFileName","pFileEncoding")
		Set extinfo=""
		Set idinfo=""
		Quit $$$OK
	}

	ClassMethod CSVExecute(ByRef qHandle As %Binary, pFileName As %String, pFileEncoding As %String = "UTF8") As %Status
	{
		Set qHandle("Separator")=","
		Quit ..FileExecute(.qHandle, pFileName, pFileEncoding)
	}

	ClassMethod CSV2Execute(ByRef qHandle As %Binary, pFileName As %String, pFileEncoding As %String = "UTF8") As %Status
	{
		Set qHandle("Separator")=";"
		Quit ..FileExecute(.qHandle, pFileName, pFileEncoding)
	}

	ClassMethod TSVExecute(ByRef qHandle As %Binary, pFileName As %String, pFileEncoding As %String = "UTF8") As %Status
	{
		Set qHandle("Separator")=$Char(9)
		Quit ..FileExecute(.qHandle, pFileName, pFileEncoding)
	}

	ClassMethod FileExecute(ByRef qHandle As %Binary, pFileName As %String, pFileEncoding As %String = "UTF8") As %Status
	{
		Set tSC = $System.Status.OK()
		Try
		{
			Set oFile = ##class(%Stream.FileCharacter).%New()
			If pFileEncoding'="" Set oFile.TranslateTable=pFileEncoding
			Set oFile.Filename=pFileName
			
			Set tHeader=oFile.ReadLine()
			Do ..IndexHeader(tHeader, qHandle("Separator"), .tHeaderIndex)
			
			Merge qHandle("HeaderIndex")=tHeaderIndex
			Set qHandle("File")=oFile
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}

	ClassMethod CSVClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FileExecute ]
	{
		Quit ..FileClose(.qHandle)
	}

	ClassMethod CSV2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FileExecute ]
	{
		Quit ..FileClose(.qHandle)
	}

	ClassMethod TSVClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FileExecute ]
	{
		Quit ..FileClose(.qHandle)
	}

	ClassMethod FileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FileExecute ]
	{
		#Dim oFile As %Library.FileCharacterStream
		Set tSC = $System.Status.OK()
		Try
		{
			Kill qHandle("File")
			Kill qHandle("HeaderIndex")
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}

	ClassMethod CSVFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FileExecute ]
	{
		Quit ..FileFetch(.qHandle, .Row, .AtEnd)
	}

	ClassMethod CSV2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FileExecute ]
	{
		Quit ..FileFetch(.qHandle, .Row, .AtEnd)
	}

	ClassMethod TSVFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FileExecute ]
	{
		Quit ..FileFetch(.qHandle, .Row, .AtEnd)
	}

	ClassMethod FileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FileExecute ]
	{
		Set tSC = $System.Status.OK()
		Try
		{
			Set Row = ""
			
			Set oFile = qHandle("File")
			If oFile.AtEnd
			{
				Set AtEnd=1
				Quit
			}
	
			Merge tHeaderIndex=qHandle("HeaderIndex")
			
			While 'oFile.AtEnd
			{
				Set tRow=oFile.ReadLine()
				Continue:tRow=""
				Quit
			}
					
			Do ..IndexRow(tRow, .tHeaderIndex, .Row)
			
			
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
	}
}
