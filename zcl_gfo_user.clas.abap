CLASS zcl_gfo_user DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_user TYPE STANDARD TABLE OF REF TO zcl_gfo_user WITH EMPTY KEY .

    METHODS add_friend
      IMPORTING
        !iv_user TYPE REF TO zcl_gfo_user .
    METHODS add_trip
      IMPORTING
        !iv_trip TYPE REF TO zcl_gfo_trip .
    METHODS get_friends
      RETURNING
        VALUE(rt_users) TYPE tt_user .
    METHODS trips
      RETURNING
        VALUE(rt_trips) TYPE zcl_gfo_trip=>tt_trip .
    METHODS is_friend_with
      IMPORTING io_another_user   TYPE REF TO zcl_gfo_user
      RETURNING
        VALUE(rv_friends) TYPE boolean.

  PRIVATE SECTION.
    DATA:
      mt_trips   TYPE zcl_gfo_trip=>tt_trip,
      mt_friends TYPE tt_user.

ENDCLASS.

CLASS zcl_gfo_user IMPLEMENTATION.

  METHOD add_friend.
    APPEND iv_user TO mt_friends.
  ENDMETHOD.

  METHOD add_trip.
    APPEND iv_trip TO mt_trips.
  ENDMETHOD.

  METHOD get_friends.
    rt_users = mt_friends.
  ENDMETHOD.

  METHOD trips.
    rt_trips = mt_trips.
  ENDMETHOD.

  METHOD is_friend_with.

    IF line_exists( mt_friends[ table_line = io_another_user ] ).
      rv_friends = abap_true. "Users are friends
    ELSE.
      rv_friends = abap_false. "Users are not Friends
    ENDIF.

  ENDMETHOD.

ENDCLASS.
