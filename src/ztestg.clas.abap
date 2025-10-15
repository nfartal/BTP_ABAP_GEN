CLASS ztestg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZTESTG IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA es_limit TYPE zptrsdoa_rules.

    CALL FUNCTION 'Z_PTRF_GET_DOA_RULES_DATA'
      EXPORTING
        iv_doa_band       = '007'
        iv_company_code   = '3000'
        iv_job_title      = 'ANALYST, BRANCH 84'
      IMPORTING
        es_doa_rules_data = es_limit.

*    DATA lv_limit TYPE zdoa_amt_to.
*    CALL FUNCTION 'Z_PTRF_GET_DOA_EPPM_APP_LIMIT'
*      EXPORTING
*        iv_doa_band       = '003'
*        iv_company_code   = '1000'
*        iv_job_title      = 'Director, Branch 24'
*        iv_portfolio      = ' '
**       iv_bucket         =
*      IMPORTING
*        ev_approval_limit = lv_limit.

*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA it_logs TYPE STANDARD TABLE OF zgen_vmchangelog.
*
*    it_logs = VALUE #( ( sendersystem    = 'AMEX'
*                         receiversystem  = 'S4HANA'
*                         inputdataobject = 'GLACCOUNT'
*                         dataobject      = 'VCARD'
*                         created_by      = 'GAURAV'
*                         created_at      = '20250127111159.000000 '
*                         last_changed_by = ' '
*                         last_changed_at = ' ' ) ).
*
*    MODIFY zgen_vmchangelog FROM TABLE @it_logs.
*    COMMIT WORK.


  ENDMETHOD.
ENDCLASS.
