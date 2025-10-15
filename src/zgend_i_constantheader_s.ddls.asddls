@EndUserText.label: 'CCD Header Data Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZGEND_I_CONSTANTHEADER_S
  as select from I_Language
    left outer join ZGENCCD_HDR on 0 = 0
  composition [0..*] of ZGEND_I_CONSTANTHEADER as _ConstantHeader
{
  key 1 as SingletonID,
  _ConstantHeader,
  max( ZGENCCD_HDR.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
