Class IRISDemo.Data.Utils
{
classmethod LoadIndexData(fileName as %String)
{
	do ##class(IRISDemo.Data.SNOMED2ICD).%KillExtent()
	do ##class(IRISDemo.Data.ComorbidityIndex).%KillExtent()

	/*
	set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	if objRs.Execute(fileName) {
		while objRs.Next() {
			set objMapping = ##class(IRISDemo.Data.SNOMED2ICD).%New()
			set objMapping.SNOMEDCode = objRs.Get("SNOMED")
			set objMapping.ICDCode = objRs.Get("ICD")
			do objMapping.%Save()
		}
	}
	*/
	
	write !!,"Loading index data from: ",fileName,!
	set objFile = ##class(%Library.File).%New(fileName)
	do objFile.Open("R")
	set header = objFile.ReadLine()
	set length = $length(header,",")
	for i = 1:1:length set header(i) = $piece(header,",",i)
	set count = 0
	while 'objFile.AtEnd {
		set line = objFile.ReadLine()
		for i = 1:1:length set value(header(i)) = $piece(line,",",i)
		
		set objMapping = ##class(IRISDemo.Data.SNOMED2ICD).%New()
		set objMapping.SNOMEDCode = value("SNOMEDCode")
		set objMapping.ICDCode = value("ICDCode")
		do objMapping.%Save()
		
		set objIndex = ##class(IRISDemo.Data.ComorbidityIndex).%New()
		set objIndex.ICDCode = value("ICDCode")
		set objIndex.Index = value("CharlsonComorbidityIndex")
		do objIndex.%Save()
		
		set count = count + 1
		write $justify(count,10)
	}
	do objFile.Close()
}

}