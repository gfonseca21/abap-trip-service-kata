CLASS zcl_gfo_trip_dao DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS find_trips_by_user
      IMPORTING
        !io_user        TYPE REF TO zcl_gfo_user
      RETURNING
        VALUE(rt_trips) TYPE zcl_gfo_trip=>tt_trip .

    METHODS:
      tripsby
        IMPORTING io_user         TYPE REF TO zcl_gfo_user
        RETURNING VALUE(rt_trips) TYPE zcl_gfo_trip=>tt_trip.

  PRIVATE SECTION.
    DATA: mo_trip_dao TYPE REF TO zcl_gfo_trip_dao.

ENDCLASS.


CLASS zcl_gfo_trip_dao IMPLEMENTATION.


  METHOD find_trips_by_user.
    RAISE EXCEPTION TYPE zcx_gfo_collaborator_call
      EXPORTING
        iv_text = |zcl_gfo_trip_dao should not be invoked during unit test|.
  ENDMETHOD.


  METHOD tripsby.
    rt_trips = zcl_gfo_trip_dao=>find_trips_by_user( io_user ).
  ENDMETHOD.

ENDCLASS.
