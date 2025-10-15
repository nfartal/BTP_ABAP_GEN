@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZGEND_I_CIVALMAP_CHANGELOGS
  as select from zgen_vmchangelog
{
  key sendersystem as Sendersystem,
  key receiversystem as Receiversystem,
  key inputdataobject as Inputdataobject,
  key dataobject as Dataobject,
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
