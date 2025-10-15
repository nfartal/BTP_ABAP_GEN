CLASS ztests DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.
  PRIVATE SECTION.
    DATA : out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS ZTESTS IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.
    DATA es_limit TYPE ZDOA_AMT_TO.

    CALL FUNCTION 'Z_PTRF_GET_DOA_EPPM_APP_LIMIT'
      EXPORTING
        iv_doa_band       = '006'
        iv_company_code   = '1000'
        iv_job_title      = 'Senior Vice President, Br'
        IV_PORTFOLIO = 'P'
        IV_BUCKET = 'P-AA-NA'
      IMPORTING
        EV_APPROVAL_LIMIT = es_limit.

        out->write( es_limit ).
        endmethod.
ENDCLASS.
