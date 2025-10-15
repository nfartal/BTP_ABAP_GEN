CLASS lhc_rap_tdat_cts DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      get
        RETURNING
          VALUE(result) TYPE REF TO if_mbc_cp_rap_tdat_cts.

ENDCLASS.

CLASS lhc_rap_tdat_cts IMPLEMENTATION.
  METHOD get.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZGENCCDOBJ'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'ConstantHeader' table = 'ZGENCCD_HDR' )
                                         ( entity = 'ConstantItem' table = 'ZGENCCD_ITM' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_zgend_i_constantheader_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR ConstantHeaderAll
        RESULT    result,
      selectcustomizingtransptreq FOR MODIFY
        IMPORTING
                  keys   FOR ACTION ConstantHeaderAll~SelectCustomizingTransptReq
        RESULT    result,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ConstantHeaderAll
        RESULT result.
ENDCLASS.

CLASS lhc_zgend_i_constantheader_s IMPLEMENTATION.

  METHOD get_instance_features.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ELSE.
      edit_flag = if_abap_behv=>fc-o-enabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF zgend_i_constantheader_s IN LOCAL MODE
    ENTITY ConstantHeaderAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%is_draft = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %tky = all[ 1 ]-%tky
               %action-edit = edit_flag
               %assoc-_ConstantHeader = edit_flag
               %action-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.

  METHOD selectcustomizingtransptreq.
    MODIFY ENTITIES OF zgend_i_constantheader_s IN LOCAL MODE
      ENTITY ConstantHeaderAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %tky               = key-%tky
                          TransportRequestID = key-%param-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF zgend_i_constantheader_s IN LOCAL MODE
      ENTITY ConstantHeaderAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %tky   = entity-%tky
                          %param = entity ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.

    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZGEND_I_CONSTANTHEADER' ID 'ACTVT' FIELD '03'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = is_authorized.
    result-%action-Edit = is_authorized.
    result-%action-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zgend_i_constantheader_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      save_modified REDEFINITION,
      cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zgend_i_constantheader_s IMPLEMENTATION.

  METHOD save_modified.
    READ TABLE update-ConstantHeaderAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize ##NEEDED.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zgend_i_constantheader DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR ConstantHeader
        RESULT result,
      copyconstantheader FOR MODIFY
        IMPORTING
          keys FOR ACTION ConstantHeader~CopyConstantHeader,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ConstantHeader
        RESULT result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR ConstantHeader
        RESULT    result,
      validatetransportrequest FOR VALIDATE ON SAVE
        IMPORTING
          keys_constantheader FOR ConstantHeader~ValidateTransportRequest
          keys_constantitem   FOR ConstantItem~ValidateTransportRequest,
      earlynumbering_cba_Constantite FOR NUMBERING
        IMPORTING entities FOR CREATE ConstantHeader\_Constantitem.
ENDCLASS.

CLASS lhc_zgend_i_constantheader IMPLEMENTATION.

  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
    result-%assoc-_ConstantItem = edit_flag.
  ENDMETHOD.

  METHOD copyconstantheader.

    DATA new_ConstantHeader TYPE TABLE FOR CREATE zgend_i_constantheader_s\_ConstantHeader.
    DATA new_ConstantItem TYPE TABLE FOR CREATE zgend_i_constantheader_s\\ConstantHeader\_ConstantItem.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-ConstantHeader = VALUE #( FOR fkey IN keys ( %tky = fkey-%tky ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF zgend_i_constantheader_s IN LOCAL MODE
      ENTITY ConstantHeader
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_ConstantHeader)
        FAILED DATA(read_failed).

    READ ENTITIES OF zgend_i_constantheader_s IN LOCAL MODE
      ENTITY ConstantHeader BY \_ConstantItem
        ALL FIELDS WITH CORRESPONDING #( ref_ConstantHeader )
        RESULT DATA(ref_ConstantItem).

    IF ref_ConstantHeader IS NOT INITIAL.
      ASSIGN ref_ConstantHeader[ 1 ] TO FIELD-SYMBOL(<ref_ConstantHeader>).

      DATA(key) = keys[ KEY draft %tky = <ref_ConstantHeader>-%tky ].
      DATA(key_cid) = key-%cid.

      APPEND VALUE #(
        %tky-SingletonID = 1
        %is_draft = <ref_ConstantHeader>-%is_draft
        %target = VALUE #( (
          %cid = key_cid
          %is_draft = <ref_ConstantHeader>-%is_draft
          %data = CORRESPONDING #( <ref_ConstantHeader> EXCEPT
          SingletonID
          CreatedBy
          CreatedAt
          ChangedBy
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_ConstantHeader ASSIGNING FIELD-SYMBOL(<new_ConstantHeader>).
      <new_ConstantHeader>-%target[ 1 ]-ConstantName = key-%param-Name.

      FIELD-SYMBOLS: <new_ConstantItem> LIKE LINE OF new_ConstantItem.

      UNASSIGN <new_ConstantItem>.
      LOOP AT ref_ConstantItem ASSIGNING FIELD-SYMBOL(<ref_ConstantItem>).

        DATA(cid_ref_ConstantItem) = key_cid.
        IF <new_ConstantItem> IS NOT ASSIGNED.
          INSERT VALUE #( %cid_ref  = cid_ref_ConstantItem
                          %is_draft = key-%is_draft ) INTO TABLE new_ConstantItem ASSIGNING <new_ConstantItem>.
        ENDIF.
        INSERT VALUE #( %is_draft = key-%is_draft
                        %data = CORRESPONDING #( <ref_ConstantItem> EXCEPT
                                                 SingletonID
        ) ) INTO TABLE <new_ConstantItem>-%target ASSIGNING FIELD-SYMBOL(<target_ConstantItem>).
        <target_ConstantItem>-%key-ConstantName = key-%param-Name.
        <target_ConstantItem>-%cid = 'ConstantItem'
          && |#{ <ref_ConstantItem>-%key-ConstantName }|
          && |#{ <ref_ConstantItem>-%key-ItemKey }|.
      ENDLOOP.

      MODIFY ENTITIES OF zgend_i_constantheader_s IN LOCAL MODE
        ENTITY ConstantHeaderAll CREATE BY \_ConstantHeader
        FIELDS (
                 ConstantName
                 Description
                 Comments
               ) WITH new_ConstantHeader
        ENTITY ConstantHeader CREATE BY \_ConstantItem
        FIELDS (
                 ConstantName
                 ItemKey
                 Sign
                 CompOption
                 ComparisonOperator1
                 ComparisonOperator2
                 ComparisonOperator3
                 ComparisonOperator4
                 ComparisonOperator5
                 LowValue
                 HighValue
                 DeletionIndicator
               ) WITH new_ConstantItem
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-ConstantHeader = mapped_create-ConstantHeader.
    ENDIF.

    INSERT LINES OF read_failed-ConstantHeader INTO TABLE failed-ConstantHeader.

    IF failed-ConstantHeader IS INITIAL.
      reported-ConstantHeader = VALUE #( FOR created IN mapped-ConstantHeader (
                                                 %cid = created-%cid
                                                 %action-CopyConstantHeader = if_abap_behv=>mk-on
                                                 %msg = mbc_cp_api=>message( )->get_item_copied( )
                                                 %path-ConstantHeaderAll-%is_draft = created-%is_draft
                                                 %path-ConstantHeaderAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.

  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZGEND_I_CONSTANTHEADER' ID 'ACTVT' FIELD '03'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%action-CopyConstantHeader = is_authorized.
  ENDMETHOD.

  METHOD get_instance_features.
    result = VALUE #( FOR row IN keys ( %tky = row-%tky
                                        %action-CopyConstantHeader = COND #( WHEN row-%is_draft = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.

  METHOD validatetransportrequest.

    DATA change TYPE REQUEST FOR CHANGE zgend_i_constantheader_s.
    IF keys_ConstantHeader IS NOT INITIAL.
      DATA(is_draft) = keys_ConstantHeader[ 1 ]-%is_draft.
    ELSEIF keys_ConstantItem IS NOT INITIAL.
      is_draft = keys_ConstantItem[ 1 ]-%is_draft.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE zgend_i_constantheader_s
    FROM VALUE #( ( %is_draft = is_draft
                    SingletonID = 1
                    %control-TransportRequestID = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    IF lines( transport_from_singleton ) = 1.
      DATA(transport_request) = transport_from_singleton[ 1 ]-TransportRequestID.
    ENDIF.
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = transport_request
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZGENCCD_HDR' keys = REF #( keys_ConstantHeader ) )
                                                          ( table = 'ZGENCCD_ITM' keys = REF #( keys_ConstantItem ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.

  METHOD earlynumbering_cba_Constantite.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).

      SELECT FROM zgen_ccd_itm_d " ZGEND_I_ConstantItem - Draft
         FIELDS MAX( itemkey )
         WHERE constantname = @<ls_entity>-ConstantName
         INTO @DATA(lv_item).
      IF sy-subrc <> 0.
        lv_item = 1.
      ENDIF. " IF sy-subrc <> 0

      LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_item_create>).
        lv_item += 1.
        INSERT VALUE #( %cid = <ls_item_create>-%cid
                        %is_draft = <ls_entity>-%is_draft
                        constantname = <ls_entity>-ConstantName
                        itemkey = COND #( WHEN <ls_item_create>-ItemKey IS INITIAL THEN lv_item
                                          ELSE <ls_item_create>-ItemKey ) ) INTO TABLE mapped-constantitem.

      ENDLOOP. " LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_item_create>)

    ENDLOOP. " LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>)

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zgend_i_constantitem DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    CONSTANTS: c_def_sign   TYPE sychar01 VALUE 'I',    " CHAR01 data element for SYST
               c_def_option TYPE c LENGTH 2 VALUE 'EQ', " Def_option of type Character
               c_msgid      TYPE symsgid VALUE 'ZGEN'.  " Message Class

  PRIVATE SECTION.
    METHODS:
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR ConstantItem
        RESULT result.

    METHODS SetDefaultSignOption FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ConstantItem~SetDefaultSignOption.
    METHODS ValidateNotes FOR VALIDATE ON SAVE
      IMPORTING keys FOR ConstantItem~ValidateNotes.

ENDCLASS.

CLASS lhc_zgend_i_constantitem IMPLEMENTATION.

  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.

  METHOD SetDefaultSignOption.

    READ ENTITIES OF ZGEND_I_ConstantHeader_S IN LOCAL MODE
       ENTITY ConstantItem
       FIELDS ( sign compoption )
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_constantitem).

    MODIFY ENTITIES OF ZGEND_I_ConstantHeader_S IN LOCAL MODE
        ENTITY ConstantItem
        UPDATE SET FIELDS WITH VALUE #( FOR ls_item IN lt_constantitem
                                        ( %key = ls_item-%key
                                          %is_draft = ls_item-%is_draft
                                          sign = c_def_sign
                                          CompOption = c_def_option
                                          %control = VALUE #( sign = if_abap_behv=>mk-on
                                                              compoption = if_abap_behv=>mk-on ) )
                                           ) REPORTED DATA(ls_modifyReported).

    reported = CORRESPONDING #( DEEP ls_modifyReported ) .

  ENDMETHOD.

  METHOD ValidateNotes.

*--Validate if notes is updated
*Fetch latest notes for changed CCD header records from BO
    READ ENTITIES OF ZGEND_I_ConstantHeader_S IN LOCAL MODE
       ENTITY ConstantHeader
       FIELDS ( constantname comments )
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_notes_new).

*Fetch old notes from constant header table
    SELECT FROM zgenccd_hdr AS a
      INNER JOIN @keys AS b
      ON a~name = b~ConstantName
      FIELDS  a~name AS ConstantName,
              a~comments " CCD Comments
      ORDER BY ConstantName
      INTO TABLE @DATA(lt_notes_old).
    IF sy-subrc = 0.
      DELETE ADJACENT DUPLICATES FROM lt_notes_old COMPARING constantname.
    ENDIF. " IF sy-subrc <> 0

*Check if notes has been updated for changed entities
    LOOP AT lt_notes_new ASSIGNING FIELD-SYMBOL(<ls_notes_new>).
      ASSIGN lt_notes_old[ constantname = <ls_notes_new>-ConstantName ] TO FIELD-SYMBOL(<ls_notes_old>).
      IF sy-subrc = 0.
        IF <ls_notes_new>-comments = <ls_notes_old>-comments.
          APPEND VALUE #( constantname = <ls_notes_new>-constantname ) TO failed-constantheader.
          APPEND VALUE #( constantname = <ls_notes_new>-constantname
                          %msg = new_message( severity = if_abap_behv_message=>severity-error
                                           id = c_msgid
                                           number = 000
                                           v1 = 'Constant'(001)
                                           v2 = <ls_notes_new>-constantname
                                           v3 = 'changed. Please update notes'(002) ) ) TO reported-constantheader.
        ENDIF. " IF <ls_notes_new>-comments = <ls_notes_old>-comments
      ELSE.
*--During initial save
        IF <ls_notes_new>-comments IS INITIAL.
          APPEND VALUE #( constantname = <ls_notes_new>-constantname ) TO failed-constantheader.
          APPEND VALUE #( constantname = <ls_notes_new>-constantname
                          %msg = new_message( severity = if_abap_behv_message=>severity-error
                                           id = c_msgid
                                           number = 000
                                           v1 = 'Constant'(001)
                                           v2 = <ls_notes_new>-constantname
                                           v3 = 'created. Please enter notes'(002) ) ) TO reported-constantheader.
        ENDIF.
      ENDIF. " IF sy-subrc = 0
    ENDLOOP. " LOOP AT lt_notes_new ASSIGNING FIELD-SYMBOL(<ls_notes_new>)

  ENDMETHOD.

ENDCLASS.
