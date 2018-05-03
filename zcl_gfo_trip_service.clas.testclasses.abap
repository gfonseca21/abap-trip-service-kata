*"* use this source file for your ABAP unit test classes

CLASS ltc_gfo_trip_service DEFINITION DEFERRED.

CLASS lcl_gfo_trip_dao_mock DEFINITION INHERITING FROM zcl_gfo_trip_dao.

  PUBLIC SECTION.
    METHODS: tripsby REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_gfo_trip_dao_mock IMPLEMENTATION.


  METHOD tripsby.
    rt_trips = io_user->trips( ).
  ENDMETHOD.

ENDCLASS.

CLASS ltc_gfo_trip_service DEFINITION FOR TESTING
  FINAL
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM zcl_gfo_trip_service
.

  PUBLIC SECTION.
    METHODS: test_user_not_logged_in        FOR TESTING. "Should throw an Exception when user is not logged in.
    METHODS: test_no_trips_usrs_not_friends FOR TESTING. "Should not return any trips when users are not friends.
    METHODS: test_return_trips_usrs_friends FOR TESTING. "Should return trips when users are friends.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS: setup.
    METHODS: teardown.

    DATA: mo_trip_service      TYPE REF TO zcl_gfo_trip_service,
          mo_user_builder      TYPE REF TO zcl_gfo_user_builder,
          mo_guest             TYPE REF TO zcl_gfo_user VALUE IS INITIAL, "User not logged in
          mo_registered_user   TYPE REF TO zcl_gfo_user VALUE IS INITIAL, "User is logged in
          mo_unused_user       TYPE REF TO zcl_gfo_user VALUE IS INITIAL,
          mo_another_user      TYPE REF TO zcl_gfo_user VALUE IS INITIAL,
          mo_friend            TYPE REF TO zcl_gfo_user VALUE IS INITIAL,
          mo_to_brazil         TYPE REF TO zcl_gfo_trip VALUE IS INITIAL,
          mo_real_trip_service TYPE REF TO zcl_gfo_trip_service VALUE IS INITIAL,
          mo_trip_dao_mock     TYPE REF TO zcl_gfo_trip_dao.

ENDCLASS.       "ztc_gfo_Trip_Service

CLASS ltc_gfo_trip_service IMPLEMENTATION.

  METHOD setup.

    mo_user_builder      = NEW zcl_gfo_user_builder( ).
    mo_registered_user   = NEW zcl_gfo_user( ).
    mo_friend            = NEW zcl_gfo_user( ).
    mo_another_user      = NEW zcl_gfo_user( ).
    mo_to_brazil         = NEW zcl_gfo_trip( ).
    mo_to_brazil         = NEW zcl_gfo_trip( ).
    mo_real_trip_service = NEW zcl_gfo_trip_service( ).

  ENDMETHOD.

  METHOD test_user_not_logged_in.

    mo_trip_service = NEW #( ).

    TRY.
        mo_trip_service->get_friends_trips( io_friend        = mo_unused_user
                                            io_loggedin_user = mo_guest ).
        cl_abap_unit_assert=>fail(
            msg = |Ausnahme zcx_gfo_user_not_logged_in wurde nicht geworfen.| " Description
        ).
      CATCH zcx_gfo_user_not_logged_in INTO DATA(lo_not_logged_in).
    ENDTRY.

  ENDMETHOD.

  METHOD test_no_trips_usrs_not_friends.

    mo_trip_service = NEW #( ).

    mo_trip_dao_mock = NEW zcl_gfo_trip_dao( ).
    mo_trip_service  = NEW zcl_gfo_trip_service( mo_trip_dao_mock ).

    mo_friend = mo_user_builder->a_user(
    )->friends_with( mo_another_user
    )->with_trips( mo_to_brazil
    )->build(
    ).

    TRY.
        DATA(lt_friend_trips) = mo_trip_service->get_friends_trips( io_friend        = mo_friend
                                                                    io_loggedin_user = mo_registered_user ).
        cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act              = lines( lt_friend_trips )                               " Data Object which should adhere to constraint EXP
            exp              = 0                                                      " Constraint to which ACT needs to adhere
            msg              = |Ich erwarte kein trip, weil die benutzer Fruend sind| " Description
        ).
      CATCH zcx_gfo_user_not_logged_in INTO DATA(lo_not_logged_in).
    ENDTRY.

  ENDMETHOD.

  METHOD test_return_trips_usrs_friends.

    mo_trip_dao_mock = NEW lcl_gfo_trip_dao_mock( ).
    mo_trip_service  = NEW #( io_trip_dao = mo_trip_dao_mock ).

    mo_friend = mo_user_builder->a_user(
    )->friends_with( mo_another_user
    )->friends_with( mo_registered_user
    )->with_trips( mo_to_brazil
    )->with_trips( mo_to_brazil
    )->build(
    ).

    TRY.
        DATA(lt_friend_trips) = mo_trip_service->get_friends_trips( io_friend        = mo_friend
                                                                    io_loggedin_user = mo_registered_user ).
        cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act              = lines( lt_friend_trips )                                  " Data Object which should adhere to constraint EXP
            exp              = 2                                                         " Constraint to which ACT needs to adhere
            msg              = |Ich erwarte 2 Trips, weil die benutzer kein Fruend sind| " Description
        ).
      CATCH zcx_gfo_user_not_logged_in INTO DATA(lo_not_logged_in).
    ENDTRY.

  ENDMETHOD.

  METHOD teardown.

    CLEAR: mo_trip_service.

    "Comment

  ENDMETHOD.

ENDCLASS..
