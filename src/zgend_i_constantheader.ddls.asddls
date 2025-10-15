@EndUserText.label: 'Constant Header Data'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZGEND_I_CONSTANTHEADER
  as select from zgenccd_hdr
  association to parent ZGEND_I_CONSTANTHEADER_S as _ConstantHeaderAll on $projection.SingletonID = _ConstantHeaderAll.SingletonID
  composition [0..*] of ZGEND_I_CONSTANTITEM     as _ConstantItem
{
  key name                  as ConstantName,
      @Semantics.user.createdBy: true
      eruser                as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      aeuser                as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Consumption.hidden: true
      local_last_changed_at as LocalLastChangedAt,
      description           as Description,
      comments              as Comments,
      @Consumption.hidden: true
      1                     as SingletonID,
      _ConstantHeaderAll,
      _ConstantItem 

}
