CLASS zcl_gfo_trip_service DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS: constructor
      IMPORTING io_trip_dao TYPE REF TO zcl_gfo_trip_dao OPTIONAL.

    METHODS get_friends_trips
      IMPORTING
        !io_friend        TYPE REF TO zcl_gfo_user
        !io_loggedin_user TYPE REF TO zcl_gfo_user
      RETURNING
        VALUE(rt_trips)   TYPE zcl_gfo_trip=>tt_trip
      RAISING
        zcx_gfo_user_not_logged_in .

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS:
      no_trips
        RETURNING VALUE(rt_trips) TYPE zcl_gfo_trip=>tt_trip,
      check_loggedin_user_is_bound
        IMPORTING
          io_loggedin_user TYPE REF TO zcl_gfo_user
        RAISING
          zcx_gfo_user_not_logged_in.

    METHODS trips_by
      IMPORTING
        io_user             TYPE REF TO zcl_gfo_user
      RETURNING
        VALUE(rt_trip_list) TYPE zcl_gfo_trip=>tt_trip.

    DATA mo_trip_dao TYPE REF TO zcl_gfo_trip_dao.

ENDCLASS.

CLASS zcl_gfo_trip_service IMPLEMENTATION.


  METHOD check_loggedin_user_is_bound.

    IF io_loggedin_user IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_gfo_user_not_logged_in.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    IF io_trip_dao IS BOUND.
      mo_trip_dao = io_trip_dao.
    ELSE.
      mo_trip_dao = NEW #( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_friends_trips.

    check_loggedin_user_is_bound( io_loggedin_user ).

    IF io_friend->is_friend_with( io_loggedin_user ) = abap_true.
      rt_trips = me->trips_by( io_friend ).
    ELSE.
      rt_trips = me->no_trips( ).
    ENDIF.

  ENDMETHOD.

  METHOD no_trips.

    rt_trips = VALUE zcl_gfo_trip=>tt_trip( ).

  ENDMETHOD.


  METHOD trips_by.

    rt_trip_list = mo_trip_dao->tripsby( io_user ).

  ENDMETHOD.

ENDCLASS.
