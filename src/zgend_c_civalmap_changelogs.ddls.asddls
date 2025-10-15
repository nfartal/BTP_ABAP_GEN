@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZGEND_C_CIVALMAP_CHANGELOGS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZGEND_I_CIVALMAP_CHANGELOGS
{
  key Sendersystem,
  key Receiversystem,
  key Inputdataobject,
  key Dataobject,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
