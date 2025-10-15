CLASS lhc_rap_tdat_cts DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      get
        RETURNING
          VALUE(result) TYPE REF TO if_mbc_cp_rap_tdat_cts.

ENDCLASS.

CLASS lhc_rap_tdat_cts IMPLEMENTATION.
  METHOD get.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZGENE013_VALUEMAPPING'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'GenE013ValueMapping' table = 'ZGENCI_VALUEMAP' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zgend_i_civaluemapping DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR GenE013ValueMappAll
        RESULT    result,
      selectcustomizingtransptreq FOR MODIFY
        IMPORTING
                  keys   FOR ACTION GenE013ValueMappAll~SelectCustomizingTransptReq
        RESULT    result,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR GenE013ValueMappAll
        RESULT result.
ENDCLASS.

CLASS lhc_zgend_i_civaluemapping IMPLEMENTATION.
  METHOD get_instance_features.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    result = VALUE #( FOR key IN keys (
               %tky = key-%tky
               %action-edit = edit_flag
               %assoc-_GenE013ValueMapping = edit_flag
               %field-TransportRequestID = transport_feature
               %action-SelectCustomizingTransptReq = COND #( WHEN key-%is_draft = if_abap_behv=>mk-off
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE selecttransport_flag ) ) ).
  ENDMETHOD.
  METHOD selectcustomizingtransptreq.
    MODIFY ENTITIES OF ZGEND_I_CIValueMapping IN LOCAL MODE
      ENTITY GenE013ValueMappAll
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %tky               = key-%tky
                          TransportRequestID = key-%param-transportrequestid
                         ) ).

    READ ENTITIES OF ZGEND_I_CIValueMapping IN LOCAL MODE
      ENTITY GenE013ValueMappAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %tky   = entity-%tky
                          %param = entity ) ).
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZGEND_I_VALUEMAPPINGALL' ID 'ACTVT' FIELD '03'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = is_authorized.
    result-%action-Edit = is_authorized.
    result-%action-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS lsc_zgend_i_civaluemapping DEFINITION FINAL INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      save_modified REDEFINITION,
      cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zgend_i_civaluemapping IMPLEMENTATION.
  METHOD save_modified.
    DATA(transport_from_singleton) = VALUE #( update-GenE013ValueMappAll[ 1 ]-TransportRequestID OPTIONAL ).
    IF transport_from_singleton IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = transport_from_singleton
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD cleanup_finalize ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_gene013valuemapping DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR GenE013ValueMapping
        RESULT result,
      copygene013valuemapping FOR MODIFY
        IMPORTING
          keys FOR ACTION GenE013ValueMapping~CopyGenE013ValueMapping,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR GenE013ValueMapping
        RESULT result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR GenE013ValueMapping
        RESULT    result,
      validatetransportrequest FOR VALIDATE ON SAVE
        IMPORTING
          keys_gene013valuemappall FOR GenE013ValueMappAll~ValidateTransportRequest
          keys_gene013valuemapping FOR GenE013ValueMapping~ValidateTransportRequest.
ENDCLASS.

CLASS lhc_zi_gene013valuemapping IMPLEMENTATION.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.
  METHOD copygene013valuemapping.
    DATA new_GenE013ValueMapping TYPE TABLE FOR CREATE ZGEND_I_CIValueMapping\_GenE013ValueMapping.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-GenE013ValueMapping = VALUE #( FOR fkey IN keys ( %tky = fkey-%tky ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZGEND_I_CIValueMapping IN LOCAL MODE
      ENTITY GenE013ValueMapping
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_GenE013ValueMapping)
        FAILED DATA(read_failed).

    IF ref_GenE013ValueMapping IS NOT INITIAL.
      ASSIGN ref_GenE013ValueMapping[ 1 ] TO FIELD-SYMBOL(<ref_GenE013ValueMapping>).
      DATA(key) = keys[ KEY draft %tky = <ref_GenE013ValueMapping>-%tky ].
      DATA(key_cid) = key-%cid.
      APPEND VALUE #(
        %tky-SingletonID = 1
        %is_draft = <ref_GenE013ValueMapping>-%is_draft
        %target = VALUE #( (
          %cid = key_cid
          %is_draft = <ref_GenE013ValueMapping>-%is_draft
          %data = CORRESPONDING #( <ref_GenE013ValueMapping> EXCEPT
          SingletonID
          CreatedBy
          CreatedAt
          LocalLastChangedBy
          LocalLastChangedAt
          LastChangedAt
        ) ) )
      ) TO new_GenE013ValueMapping ASSIGNING FIELD-SYMBOL(<new_GenE013ValueMapping>).
      <new_GenE013ValueMapping>-%target[ 1 ]-Sendersystem = to_upper( key-%param-Sendersystem ).
      <new_GenE013ValueMapping>-%target[ 1 ]-Receiversystem = to_upper( key-%param-Receiversystem ).
      <new_GenE013ValueMapping>-%target[ 1 ]-Dataobject = to_upper( key-%param-Dataobject ).
      <new_GenE013ValueMapping>-%target[ 1 ]-Inputdataobject = to_upper( key-%param-Inputdataobject ).

      MODIFY ENTITIES OF ZGEND_I_CIValueMapping IN LOCAL MODE
        ENTITY GenE013ValueMappAll CREATE BY \_GenE013ValueMapping
        FIELDS (
                 Sendersystem
                 Receiversystem
                 Inputdataobject
                 Dataobject
                 Civaluemappingid
                 Interfaceid
                 Inputfield1
                 Inputfield1length
                 Inputfield2
                 Inputfield2length
                 Inputfield3
                 Inputfield3length
                 Inputfield4
                 Inputfield4length
                 Outputfield
                 Outputfieldlength
                 Comments
               ) WITH new_GenE013ValueMapping
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-GenE013ValueMapping = mapped_create-GenE013ValueMapping.
    ENDIF.

    INSERT LINES OF read_failed-GenE013ValueMapping INTO TABLE failed-GenE013ValueMapping.

    IF failed-GenE013ValueMapping IS INITIAL.
      reported-GenE013ValueMapping = VALUE #( FOR created IN mapped-GenE013ValueMapping (
                                                 %cid = created-%cid
                                                 %action-CopyGenE013ValueMapping = if_abap_behv=>mk-on
                                                 %msg = mbc_cp_api=>message( )->get_item_copied( )
                                                 %path-GenE013ValueMappAll-%is_draft = created-%is_draft
                                                 %path-GenE013ValueMappAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZGEND_I_VALUEMAPPINGALL' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%action-CopyGenE013ValueMapping = is_authorized.
  ENDMETHOD.
  METHOD get_instance_features.
    result = VALUE #( FOR row IN keys ( %tky = row-%tky
                                        %action-CopyGenE013ValueMapping = COND #( WHEN row-%is_draft = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
  METHOD validatetransportrequest.
    CHECK keys_GenE013ValueMapping IS NOT INITIAL.
    DATA change TYPE REQUEST FOR CHANGE ZGEND_I_CIValueMapping.
    READ ENTITY IN LOCAL MODE ZGEND_I_CIValueMapping
    FIELDS ( TransportRequestID ) WITH CORRESPONDING #( keys_GenE013ValueMappAll )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZGENCI_VALUEMAP' keys = REF #( keys_GenE013ValueMapping ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
