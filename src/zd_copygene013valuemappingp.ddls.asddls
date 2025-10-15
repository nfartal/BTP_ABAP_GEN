@EndUserText.label: 'Copy GEN-E-013 :  Value Mapping for SAP BTP-C'
define abstract entity ZD_CopyGenE013ValueMappingP
{
  @EndUserText.label: 'New Sendersystem'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Sendersystem' )
  Sendersystem    : zsystem;
  @EndUserText.label: 'New Receiversystem'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Receiversystem' )
  Receiversystem  : zsystem;
  @EndUserText.label: 'New Dataobject'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Dataobject' )
  Dataobject      : zobject;
  @EndUserText.label: 'New Inputdataobject'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Inputdataobject' )
  Inputdataobject : zobject;
}
