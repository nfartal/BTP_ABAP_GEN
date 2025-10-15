@EndUserText.label: 'GEN-E-013 :  Value Mapping for SAP BTP-C'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZGEND_I_VALUEMAPPINGALL
  as select from zgenci_valuemap
  association to parent ZGEND_I_CIValueMapping as _GenE013ValueMappAll on $projection.SingletonID = _GenE013ValueMappAll.SingletonID
{
  key sendersystem          as Sendersystem,
  key receiversystem        as Receiversystem,
  key inputdataobject       as Inputdataobject,
  key dataobject            as Dataobject,
      civaluemappingid      as Civaluemappingid,
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
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      @Consumption.hidden: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Consumption.hidden: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Consumption.hidden: true
      1                     as SingletonID,
      _GenE013ValueMappAll

}
