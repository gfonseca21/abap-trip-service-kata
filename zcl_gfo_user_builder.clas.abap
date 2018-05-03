CLASS zcl_gfo_user_builder DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS: a_user
      RETURNING VALUE(ro_user) TYPE REF TO zcl_gfo_user_builder.

    METHODS: friends_with
      IMPORTING
                io_user                TYPE REF TO zcl_gfo_user
      RETURNING VALUE(ro_user_friends) TYPE REF TO zcl_gfo_user_builder.

    METHODS: with_trips
      IMPORTING
                io_trips             TYPE REF TO zcl_gfo_trip
      RETURNING VALUE(ro_user_trips) TYPE REF TO zcl_gfo_user_builder.

    METHODS: build
      RETURNING VALUE(ro_user) TYPE REF TO zcl_gfo_user.

  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS: add_friends_to
      IMPORTING
        io_user TYPE REF TO zcl_gfo_user.

    METHODS: add_trips_to
      IMPORTING
        io_user TYPE REF TO zcl_gfo_user.

    DATA: mt_friends TYPE STANDARD TABLE OF REF TO zcl_gfo_user,
          mt_trips   TYPE STANDARD TABLE OF REF TO zcl_gfo_trip.

ENDCLASS.

CLASS ZCL_GFO_USER_BUILDER IMPLEMENTATION.

  METHOD a_user.

    ro_user = NEW zcl_gfo_user_builder( ).

  ENDMETHOD.

  METHOD friends_with.

    APPEND io_user TO me->mt_friends.

    ro_user_friends = me.

  ENDMETHOD.

  METHOD with_trips.

    APPEND io_trips TO me->mt_trips.

    ro_user_trips = me.

  ENDMETHOD.

  METHOD build.

    ro_user = NEW zcl_gfo_user( ).

    me->add_trips_to( ro_user ).
    me->add_friends_to( ro_user ).

  ENDMETHOD.

  METHOD add_friends_to.

    LOOP AT me->mt_friends ASSIGNING FIELD-SYMBOL(<fs_friends>).
      io_user->add_friend( <fs_friends> ).
    ENDLOOP.

  ENDMETHOD.

  METHOD add_trips_to.

    LOOP AT me->mt_trips ASSIGNING FIELD-SYMBOL(<fs_trips>).
      io_user->add_trip( <fs_trips> ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
