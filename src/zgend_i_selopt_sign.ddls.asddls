@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Selection option sign value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGEND_I_SELOPT_SIGN
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZIM_SELOPT_SIGN')
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
      @Semantics.language: true
  key language,
      @EndUserText.label: 'Selection Sign'
      value_low as Sign,
      @Semantics.text: true
      @EndUserText.label: 'Description'
      text      as SignDescription
}
