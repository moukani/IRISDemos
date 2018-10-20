Class BI.Accounts Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.Account, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Accounts" displayName="Accounts" disabled="false" abstract="false" sourceClass="IRISDemo.Account" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="AccountAge" disabled="false" hasAll="false" allCaption="All AccountAge" allDisplayName="AccountAge" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AccountAge" disabled="false" sourceProperty="AccountAge" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="City" disabled="false" hasAll="false" allCaption="All City" allDisplayName="City" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="City" disabled="false" sourceProperty="City" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Balance" disabled="false" sourceProperty="Balance" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}