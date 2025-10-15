@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test'
define root view entity ZTESTGG1
  as select from zgenci_valuemap
{
  key sendersystem          as Sendersystem,
  key receiversystem        as Receiversystem,
  key dataobject            as Dataobject,
  key civaluemappingid      as Civaluemappingid,
      interfaceid           as Interfaceid,
      inputfield1           as Inputfield1,
      inputfield1length     as Inputfield1length,
      inputfield2           as Inputfield2,
      inputfield2length     as Inputfield2length,
      inputfield3           as Inputfield3,
      inputfield3length     as Inputfield3length,
      inputfield4           as Inputfield4,
      inputfield4length     as Inputfield4length,
      outputfield           as Outputfield,
      outputfieldlength     as Outputfieldlength,
      comments              as Comments,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt
}
