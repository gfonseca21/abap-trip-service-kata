*"* use this source file for your ABAP unit test classes
CLASS ltc_trip_dao_test DEFINITION FINAL RISK LEVEL HARMLESS FOR TESTING.

  PRIVATE SECTION.
    DATA: mo_trip_dao TYPE REF TO zcl_gfo_trip_dao,
          mo_user     TYPE REF TO zcl_gfo_user.
    METHODS: setup.

    METHODS: error_when_ret_user_trips FOR TESTING.

ENDCLASS.

CLASS ltc_trip_dao_test IMPLEMENTATION.

  METHOD setup.
    mo_trip_dao = NEW #( ).
    mo_user     = NEW #( ).
  ENDMETHOD.

  METHOD error_when_ret_user_trips.
    TRY.
        mo_trip_dao->find_trips_by_user( mo_user ).
      CATCH cx_root.
        DATA(lv_error) = abap_true.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
