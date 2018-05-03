CLASS ZCX_GFO_COLLABORATOR_CALL DEFINITION
  PUBLIC
  INHERITING FROM cx_dynamic_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_text TYPE string .

    METHODS if_message~get_text
         REDEFINITION .
  PRIVATE SECTION.
    DATA mv_text TYPE string.
ENDCLASS.



CLASS ZCX_GFO_COLLABORATOR_CALL IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).
    mv_text = iv_text.
  ENDMETHOD.


  METHOD if_message~get_text.
    result = mv_text.
  ENDMETHOD.
ENDCLASS.
