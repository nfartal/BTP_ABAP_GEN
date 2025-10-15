@EndUserText.label: 'Constant Item Data'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZGEND_I_CONSTANTITEM
  as select from zgenccd_itm
  association [1..1] to ZGEND_I_CONSTANTHEADER_S      as _ConstantHeaderAll on $projection.SingletonID = _ConstantHeaderAll.SingletonID
  association        to parent ZGEND_I_CONSTANTHEADER as _ConstantHeader    on $projection.ConstantName = _ConstantHeader.ConstantName
{
  key name     as ConstantName,
  key sequence as ItemKey,
      sign     as Sign,
      opti     as CompOption,
      coop1    as ComparisonOperator1,
      coop2    as ComparisonOperator2,
      coop3    as ComparisonOperator3,
      coop4    as ComparisonOperator4,
      coop5    as ComparisonOperator5,
      low      as LowValue,
      high     as HighValue,
      loekz    as DeletionIndicator,
      @Consumption.hidden: true
      1        as SingletonID,
      _ConstantHeaderAll,
      _ConstantHeader

}
