Class IRISDemo.Data.Utils
{
classmethod LoadIndexData(fileName as %String) as %Status
{
	do ##class(IRISDemo.Data.SNOMED2ICD).%KillExtent()
	do ##class(IRISDemo.Data.ComorbidityIndex).%KillExtent()

	write !!,"Loading index data from: ",fileName,!
	set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	if objRs.Execute(fileName) {
		set count = 0
		while objRs.Next() {
			// Mapping from SNOMED to ICD
			set objMapping = ##class(IRISDemo.Data.SNOMED2ICD).%New()
			set objMapping.SNOMEDCode = objRs.Get("SNOMEDCode")
			set objMapping.ICDCode = objRs.Get("ICDCode")
			do objMapping.%Save()
			
			// Setup comorbidity index values for ICD codes
			set objIndex = ##class(IRISDemo.Data.ComorbidityIndex).%New()
			set objIndex.ICDCode = objRs.Get("ICDCode")
			set objIndex.Index = objRs.Get("CharlsonComorbidityIndex")
			do objIndex.%Save()
			
			set count = count + 1
			write $justify(count,10)
		}
	}
	quit $$$OK
}

}