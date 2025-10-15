CLASS lhc_zgend_i_civalmap_changelog DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zgendicivalmapchangelogs
        RESULT result.
ENDCLASS.

CLASS lhc_zgend_i_civalmap_changelog IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.
