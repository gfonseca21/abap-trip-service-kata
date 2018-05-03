*"* use this source file for your ABAP unit test classes
CLASS ltc_user_test DEFINITION FINAL RISK LEVEL HARMLESS FOR TESTING FRIENDS zcl_gfo_trip_service.

  PUBLIC SECTION.

    METHODS:
      test_inform_usr_are_not_friend FOR TESTING,
      test_inform_usr_are_friend     FOR TESTING.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA: mo_bob  TYPE REF TO zcl_gfo_user VALUE IS INITIAL,
          mo_paul TYPE REF TO zcl_gfo_user VALUE IS INITIAL.

    METHODS: setup,
             teardown.

ENDCLASS.

CLASS ltc_user_test IMPLEMENTATION.

  METHOD setup.

    mo_bob  = NEW zcl_gfo_user( ).
    mo_paul = NEW zcl_gfo_user( ).

  ENDMETHOD.

  METHOD test_inform_usr_are_not_friend.

    DATA(lo_user) = zcl_gfo_user_builder=>a_user(
    )->friends_with( mo_bob
    )->build(
    ).

    DATA(lv_usrs_are_friends) = lo_user->is_friend_with( mo_paul ).

    cl_abap_unit_assert=>assert_equals(
    act = lv_usrs_are_friends
    exp = abap_false
    msg  = |Users are not friends| ).

  ENDMETHOD.

  METHOD: teardown.

    CLEAR: mo_bob, mo_paul.

  ENDMETHOD.

  METHOD test_inform_usr_are_friend.

    DATA(lo_user) = zcl_gfo_user_builder=>a_user(
      )->friends_with( mo_bob
      )->friends_with( mo_paul
      )->build(
      ).

    DATA(lv_usrs_are_friends) = lo_user->is_friend_with( mo_paul ).

    cl_abap_unit_assert=>assert_equals(
    act = lv_usrs_are_friends
    exp = abap_true
    msg  = |These users are friends| ).

  ENDMETHOD.

ENDCLASS.
