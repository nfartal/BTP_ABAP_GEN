@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Get CI Mapping data'
define root view entity ZGEND_I_GET_CIVALUEMAPPING
  as select from zgenci_valuemap as OriginalValueMapping
  association [0..1] to zgen_vmchangelog as Changelog on  $projection.Sendersystem    = Changelog.sendersystem
                                                      and $projection.Receiversystem  = Changelog.receiversystem
                                                      and $projection.Inputdataobject = Changelog.inputdataobject
                                                      and $projection.Dataobject      = Changelog.dataobject
{
  key OriginalValueMapping.sendersystem    as Sendersystem,
  key OriginalValueMapping.receiversystem  as Receiversystem,
  key OriginalValueMapping.inputdataobject as Inputdataobject,
  key OriginalValueMapping.dataobject      as Dataobject,
      civaluemappingid                     as Civaluemappingid,
      interfaceid                          as Interfaceid,
      inputfield1                          as Inputfield1,
      inputfield1length                    as Inputfield1length,
      inputfield2                          as Inputfield2,
      inputfield2length                    as Inputfield2length,
      inputfield3                          as Inputfield3,
      inputfield3length                    as Inputfield3length,
      inputfield4                          as Inputfield4,
      inputfield4length                    as Inputfield4length,
      outputfield                          as Outputfield,
      outputfieldlength                    as Outputfieldlength,
      comments                             as Comments,
      created_by                           as CreatedBy,
      created_at                           as CreatedAt,
      Changelog.last_changed_by            as LastChangedBy,
      Changelog.last_changed_at            as LastChangedAt
}
