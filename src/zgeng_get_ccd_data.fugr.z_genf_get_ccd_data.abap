FUNCTION z_genf_get_ccd_data.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_NAME) TYPE  ZGENT_CNAME_RANGE
*"     VALUE(IV_COOP1) TYPE  ZGSDC_COOP OPTIONAL
*"     VALUE(IV_COOP2) TYPE  ZGSDC_COOP OPTIONAL
*"     VALUE(IV_COOP3) TYPE  ZGSDC_COOP OPTIONAL
*"     VALUE(IV_COOP4) TYPE  ZGSDC_COOP OPTIONAL
*"     VALUE(IV_COOP5) TYPE  ZGSDC_COOP OPTIONAL
*"  EXPORTING
*"     VALUE(ET_CCD_DATA) TYPE  ZGENTCCD_ITM
*"----------------------------------------------------------------------
*--Fetch CCD constant details from database
  SELECT
  FROM zgend_i_constantitem
  FIELDS *
  WHERE ConstantName IN @it_name
    AND DeletionIndicator = @space
   INTO TABLE @DATA(lt_ccd_data).

  IF sy-subrc EQ 0.

    IF iv_coop1 IS NOT INITIAL.
      DELETE lt_ccd_data WHERE ComparisonOperator1 NE iv_coop1.
    ENDIF. "IF im_coop1 IS NOT INITIAL.

    IF iv_coop2 IS NOT INITIAL.
      DELETE lt_ccd_data WHERE ComparisonOperator2 NE iv_coop2.
    ENDIF. "IF im_coop2 IS NOT INITIAL.

    IF iv_coop3 IS NOT INITIAL.
      DELETE lt_ccd_data WHERE ComparisonOperator3 NE iv_coop3.
    ENDIF. "IF im_coop3 IS NOT INITIAL.

    IF iv_coop4 IS NOT INITIAL.
      DELETE lt_ccd_data WHERE ComparisonOperator4 NE iv_coop4.
    ENDIF. "IF im_coop4 IS NOT INITIAL

    IF iv_coop5 IS NOT INITIAL.
      DELETE lt_ccd_data WHERE ComparisonOperator5 NE iv_coop5.
    ENDIF. "IF im_coop5 IS NOT INITIAL.

    et_ccd_data = VALUE #( FOR ls_ccd_data IN lt_ccd_data
                         ( name  = ls_ccd_data-ConstantName
                           sequence = ls_ccd_data-ItemKey
                           sign = ls_ccd_data-Sign
                           opti = ls_ccd_data-CompOption
                           coop1 = ls_ccd_data-ComparisonOperator1
                           coop2 = ls_ccd_data-ComparisonOperator2
                           coop3 = ls_ccd_data-ComparisonOperator3
                           coop4 = ls_ccd_data-ComparisonOperator4
                           coop5 = ls_ccd_data-ComparisonOperator5
                           low = ls_ccd_data-LowValue
                           high = ls_ccd_data-HighValue  ) ) .

  ELSE.
   CLEAR et_ccd_data.
  ENDIF.

ENDFUNCTION.
