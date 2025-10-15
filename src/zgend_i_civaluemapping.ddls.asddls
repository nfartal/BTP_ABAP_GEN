@EndUserText.label: 'GEN-E-013 :  Value Mapping for SAP BTP-C'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GenE013ValueMappAll'
  }
}
define root view entity ZGEND_I_CIValueMapping
  as select from I_Language
    left outer join zgenci_valuemap on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZGEND_I_VALUEMAPPINGALL as _GenE013ValueMapping
{
  @UI.facet: [ {
    id: 'ZI_GenE013ValueMapping', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'GEN-E-013 :  Value Mapping for SAP BTP-C', 
    position: 1 , 
    targetElement: '_GenE013ValueMapping'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GenE013ValueMapping,
  @UI.hidden: true
  max( zgenci_valuemap.last_changed_at ) as LastChangedAtMax,
  @ObjectModel.text.association: '_I_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as sxco_transport) as TransportRequestID,
  _I_ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
