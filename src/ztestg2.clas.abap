CLASS ztestg2 DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.
  PRIVATE SECTION.
    DATA : out TYPE REF TO if_oo_adt_classrun_out.
    METHODS : get_data.
ENDCLASS.



CLASS ZTESTG2 IMPLEMENTATION.


  METHOD get_data.
*    SELECT * FROM i_country INTO TABLE @DATA(lt_data).

    DATA lv_limit TYPE zdoa_amt_to.
    CALL FUNCTION 'Z_PTRF_GET_DOA_EPPM_APP_LIMIT'
      EXPORTING
        iv_doa_band       = '011'
        iv_company_code   = '1000'
        iv_job_title      = 'SENIOR DIRECTOR, BRANCH 24'
        iv_portfolio      = 'P'
        iv_bucket         = 'P-AA-NA'
      IMPORTING
        ev_approval_limit = lv_limit.

    IF sy-subrc EQ 0.
      out->write( lv_limit ).
    ENDIF.

*    DATA es_limit TYPE zptrsdoa_rules.
*
*    CALL FUNCTION 'Z_PTRF_GET_DOA_RULES_DATA'
*      EXPORTING
*        iv_doa_band       = '007'
*        iv_company_code   = '3000'
*        iv_job_title      = ''
**        'ANALYST, BRANCH 84'
*      IMPORTING
*        es_doa_rules_data = es_limit.
*
*
*    IF sy-subrc EQ 0.
*      out->write( es_limit ).
*    ENDIF.

*    DATA: limit1 TYPE zdoaamount,
*          limit2 TYPE zdoaamount,
*          limit3 TYPE zdoaamount.
*
*    CALL FUNCTION 'Z_PTRF_GET_DOA_RULES_LIMIT'
*      EXPORTING
*        iv_doa_band        = '007'
*        iv_company_code    = '3000'
**       iv_job_title       =
*      IMPORTING
*        ev_approval_limit1 = limit1
*        ev_approval_limit2 = limit2
*        ev_approval_limit3 = limit3.
*
*    IF sy-subrc EQ 0.
*      out->write( limit1 ).
*    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    me->out = out.
    get_data( ).
  ENDMETHOD.
ENDCLASS.
