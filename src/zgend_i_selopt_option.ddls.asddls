@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Selection option value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGEND_I_SELOPT_OPTION
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZIM_SELOPT_OPTION')
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
      @Semantics.language: true
  key language,
      @EndUserText.label: 'Selection Option'
      value_low as CompOption,
      @Semantics.text: true
      @EndUserText.label: 'Description'
      text      as OptionDescription
}
