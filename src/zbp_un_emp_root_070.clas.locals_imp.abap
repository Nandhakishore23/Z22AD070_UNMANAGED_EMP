**CLASS lhc_EMP DEFINITION INHERITING FROM cl_abap_behavior_handler.
**  PRIVATE SECTION.
**
**    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
**      IMPORTING keys REQUEST requested_authorizations FOR emp RESULT result.
**
**    METHODS create FOR MODIFY
**      IMPORTING entities FOR CREATE emp.
**
**    METHODS update FOR MODIFY
**      IMPORTING entities FOR UPDATE emp.
**
**    METHODS delete FOR MODIFY
**      IMPORTING keys FOR DELETE emp.
**
**    METHODS read FOR READ
**      IMPORTING keys FOR READ emp RESULT result.
**
**    METHODS lock FOR LOCK
**      IMPORTING keys FOR LOCK emp.
**
**ENDCLASS.
**
**CLASS lhc_EMP IMPLEMENTATION.
**
**  METHOD get_instance_authorizations.
**  ENDMETHOD.
**
**  METHOD create.
**  ENDMETHOD.
**
**  METHOD update.
**  ENDMETHOD.
**
**  METHOD delete.
**  ENDMETHOD.
**
**  METHOD read.
**  ENDMETHOD.
**
**  METHOD lock.
**  ENDMETHOD.
**
**ENDCLASS.
**
**CLASS lsc_ZUN_EMP_ROOT_070 DEFINITION INHERITING FROM cl_abap_behavior_saver.
**  PROTECTED SECTION.
**
**    METHODS finalize REDEFINITION.
**
**    METHODS check_before_save REDEFINITION.
**
**    METHODS adjust_numbers REDEFINITION.
**
**    METHODS save REDEFINITION.
**
**    METHODS cleanup REDEFINITION.
**
**    METHODS cleanup_finalize REDEFINITION.
**
**ENDCLASS.
**
**CLASS lsc_ZUN_EMP_ROOT_070 IMPLEMENTATION.
**
**  METHOD finalize.
**  ENDMETHOD.
**
**  METHOD check_before_save.
**  ENDMETHOD.
**
**  METHOD adjust_numbers.
**  ENDMETHOD.
**
**  METHOD save.
**  ENDMETHOD.
**
**  METHOD cleanup.
**  ENDMETHOD.
**
**  METHOD cleanup_finalize.
**  ENDMETHOD.
**
**ENDCLASS.
*
*
*
*
*
*" Buffer class to hold create/update/delete entries temporarily
*CLASS lcl_buffer DEFINITION CREATE PRIVATE.
*  PUBLIC SECTION.
*    TYPES: BEGIN OF ty_buffer,
*             flag TYPE c LENGTH 1,       " 'C' = Create, 'U' = Update, 'D' = Delete
*             lv_data TYPE zun_emp_tab,   " The structure that holds employee data
*           END OF ty_buffer.
*
*    CLASS-DATA mt_buffer TYPE STANDARD TABLE OF ty_buffer WITH EMPTY KEY.  " Table to store buffer entries
*
*    " Method to get an instance of the buffer class (Singleton pattern)
*    CLASS-METHODS get_instance
*      RETURNING VALUE(ro_instance) TYPE REF TO lcl_buffer.
*
*    " Method to add records to the buffer (Create, Update, or Delete)
*    METHODS add_to_buffer
*      IMPORTING
*        iv_flag TYPE c         " Flag to specify the type of operation (C/U/D)
*        is_employee TYPE zun_emp_tab.  " Employee data to be added to the buffer
*
*  PRIVATE SECTION.
*    CLASS-DATA go_instance TYPE REF TO lcl_buffer.  " Holds the single instance of the class
*ENDCLASS.
*
*CLASS lcl_buffer IMPLEMENTATION.
*
*  METHOD get_instance.
*    IF go_instance IS NOT BOUND.
*      go_instance = NEW #( ).
*    ENDIF.
*    ro_instance = go_instance.
*  ENDMETHOD.
*
*  METHOD add_to_buffer.
*    INSERT VALUE #( flag = iv_flag lv_data = is_employee ) INTO TABLE mt_buffer.
*  ENDMETHOD.
*
*ENDCLASS.
*
*" Custom Exception Class
*CLASS zcx_my_exception DEFINITION INHERITING FROM cx_static_check.
*  PUBLIC SECTION.
*    INTERFACES if_t100_message.  " This interface is used for handling messages.
*    METHODS constructor IMPORTING
*                          textid LIKE if_t100_message=>t100key OPTIONAL.  " Constructor to initialize exception with a message
*ENDCLASS.
*
*CLASS zcx_my_exception IMPLEMENTATION.
*  METHOD constructor.
*    CALL METHOD super->constructor
*      EXPORTING
*        previous = previous.   " Calling the parent class constructor
*    me->if_t100_message~t100key = textid.  " Set the error message key
*  ENDMETHOD.
*ENDCLASS.
*
*" Behavior Handler Class for EMP entity
*CLASS lhc_EMP DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*    " Method to check instance authorization for each operation
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR emp RESULT result.
*
*    " Methods for CRUD operations
*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE emp.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE emp.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE emp.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ emp RESULT result.
*
*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK emp.
*ENDCLASS.
*
*CLASS lhc_EMP IMPLEMENTATION.
*
*  METHOD create.
*    DATA(lo_buffer) = lcl_buffer=>get_instance( ).
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
*      DATA ls_employee TYPE zun_emp_tab.
*
*      " Map entity fields to employee structure
*      ls_employee-emp_id        = <ls_entity>-EmpId.
*      ls_employee-first_name    = <ls_entity>-FirstName.
*      ls_employee-last_name     = <ls_entity>-LastName.
*      ls_employee-date_of_birth = <ls_entity>-DateOfBirth.
*      ls_employee-email         = <ls_entity>-Email.
*      ls_employee-hire_date     = <ls_entity>-HireDate.
*      ls_employee-salary        = <ls_entity>-Salary.
*      ls_employee-curry         = <ls_entity>-Curry.
*
*      " Add to buffer as create
*      lo_buffer->add_to_buffer( iv_flag = 'C' is_employee = ls_employee ).
*
*      " Return mapped keys (required by RAP)
*      INSERT VALUE #( %cid = <ls_entity>-%cid empID = ls_employee-emp_id ) INTO TABLE mapped-emp.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD update.
*    DATA(lo_buffer) = lcl_buffer=>get_instance( ).
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
*      " Fetch existing employee from DB to buffer with flag U
*      DATA ls_db TYPE zun_emp_tab.
*      SELECT SINGLE * FROM zun_emp_tab WHERE emp_id = @<ls_entity>-EmpId INTO _db.
*      " Overwrite fields if updated in <ls_entity>
*      IF <ls_entity>-FirstName IS NOT INITIAL.
*        ls_db-first_name = <ls_entity>-FirstName.
*      ENDIF.
*      IF <ls_entity>-LastName IS NOT INITIAL.
*        ls_db-last_name = <ls_entity>-LastName.
*      ENDIF.
*      IF <ls_entity>-DateOfBirth IS NOT INITIAL.
*        ls_db-date_of_birth = <ls_entity>-DateOfBirth.
*      ENDIF.
*      IF <ls_entity>-email IS NOT INITIAL.
*        ls_db-email = <ls_entity>-email.
*      ENDIF.
*      IF <ls_entity>-HireDate IS NOT INITIAL.
*        ls_db-hire_date = <ls_entity>-HireDate.
*      ENDIF.
*      IF <ls_entity>-salary IS NOT INITIAL.
*        ls_db-salary = <ls_entity>-salary.
*      ENDIF.
*      IF <ls_entity>-curry IS NOT INITIAL.
*        ls_db-curry = <ls_entity>-curry.
*      ENDIF.
*
*      " Add updated employee to buffer with flag 'U'
*      lo_buffer->add_to_buffer( iv_flag = 'U' is_employee = ls_db ).
*
*      " Return mapped keys
*      INSERT VALUE #( %cid = <ls_entity>-%cid_ref empID = ls_db-emp_id ) INTO TABLE mapped-emp.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD delete.
*    DATA(lo_buffer) = lcl_buffer=>get_instance( ).
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
*      " Create minimal structure for deletion
*      DATA ls_employee TYPE zun_emp_tab.
*      ls_employee-emp_id = <ls_key>-EmpId.
*
*      " Add to buffer with flag 'D'
*      lo_buffer->add_to_buffer( iv_flag = 'D' is_employee = ls_employee ).
*
*      " Return mapped keys
*      INSERT VALUE #( %cid = <ls_key>-%cid_ref empID = <ls_key>-EmpId ) INTO TABLE mapped-emp.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD read.
*    " Implement read logic here if required
*  ENDMETHOD.
*
*  METHOD lock.
*    " Implement lock logic if required
*  ENDMETHOD.
*
*ENDCLASS.
*
*" Saver class to persist data with validation and proper error handling
*CLASS lsc_ZUN_EMP_ROOT_070 IMPLEMENTATION.
*
*  METHOD save.
*    DATA(lo_buffer) = lcl_buffer=>get_instance( ).
*    LOOP AT lo_buffer->mt_buffer ASSIGNING FIELD-SYMBOL(<ls_buf>).
*      CASE <ls_buf>-flag.
*        WHEN 'C'.  " If the flag is 'C', perform Insert operation
*          INSERT zun_emp_tab FROM <ls_buf>-lv_data.
*        WHEN 'U'.  " If the flag is 'U', perform Update operation
*          UPDATE zun_emp_tab FROM <ls_buf>-lv_data.
*        WHEN 'D'.  " If the flag is 'D', perform Delete operation
*          DELETE FROM zun_emp_tab WHERE emp_id = <ls_buf>-lv_data-emp_id.
*      ENDCASE.
*    ENDLOOP.
*    CLEAR lo_buffer->mt_buffer.  " Clear the buffer after saving changes
*  ENDMETHOD.
*
*  METHOD finalize.
*    " Optional post-save logic
*  ENDMETHOD.
*
*  METHOD check_before_save.
*    " Optional pre-save validations
*  ENDMETHOD.
*
*  METHOD adjust_numbers.
*  ENDMETHOD.
*
*  METHOD cleanup.
*    " Optional cleanup logic
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*    " Optional final cleanup
*  ENDMETHOD.
*
*ENDCLASS.


CLASS lcl_buffer DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.

    " Structure stored in buffer
    TYPES: BEGIN OF ty_buffer,
             flag    TYPE c LENGTH 1,        " C = Create, U = Update, D = Delete
             lv_data TYPE zun_emp_tab_070,       " Employee table structure
           END OF ty_buffer.

    " Static internal table buffer
    CLASS-DATA mt_buffer TYPE STANDARD TABLE OF ty_buffer WITH EMPTY KEY.

    " Singleton instance getter
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO lcl_buffer.

    " Add entry to buffer
    METHODS add_to_buffer
      IMPORTING
        iv_flag     TYPE c
        is_employee TYPE zun_emp_tab_070.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO lcl_buffer.

ENDCLASS.



CLASS lcl_buffer IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.


  METHOD add_to_buffer.
    INSERT VALUE ty_buffer(
            flag    = iv_flag
            lv_data = is_employee )
      INTO TABLE mt_buffer.
  ENDMETHOD.

ENDCLASS.








CLASS lhc_EMP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR emp RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE emp.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE emp.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE emp.

    METHODS read FOR READ
      IMPORTING keys FOR READ emp RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK emp.

ENDCLASS.



CLASS lhc_EMP IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD create.
    DATA(lo_buffer) = lcl_buffer=>get_instance( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).

      DATA ls_employee TYPE zun_emp_tab_070.

      ls_employee-emp_id        = <ls_entity>-EmpId.
      ls_employee-first_name    = <ls_entity>-FirstName.
      ls_employee-last_name     = <ls_entity>-LastName.
      ls_employee-date_of_birth = <ls_entity>-DateOfBirth.
      ls_employee-email         = <ls_entity>-Email.
      ls_employee-hire_date     = <ls_entity>-HireDate.
      ls_employee-salary        = <ls_entity>-Salary.
      ls_employee-curry      = <ls_entity>-Curry.

      lo_buffer->add_to_buffer(
        iv_flag     = 'C'
        is_employee = ls_employee ).

      INSERT VALUE #(
        %cid  = <ls_entity>-%cid
        EmpId = ls_employee-emp_id )
        INTO TABLE mapped-emp.

    ENDLOOP.
  ENDMETHOD.


  METHOD update.
    DATA(lo_buffer) = lcl_buffer=>get_instance( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).

      DATA ls_db TYPE zun_emp_tab_070.

      SELECT SINGLE *
        FROM zun_emp_tab_070
        WHERE emp_id = @<ls_entity>-EmpId
        INTO @ls_db.

      IF <ls_entity>-FirstName IS NOT INITIAL.
        ls_db-first_name = <ls_entity>-FirstName.
      ENDIF.

      IF <ls_entity>-LastName IS NOT INITIAL.
        ls_db-last_name = <ls_entity>-LastName.
      ENDIF.

      IF <ls_entity>-DateOfBirth IS NOT INITIAL.
        ls_db-date_of_birth = <ls_entity>-DateOfBirth.
      ENDIF.

      IF <ls_entity>-Email IS NOT INITIAL.
        ls_db-email = <ls_entity>-Email.
      ENDIF.

      IF <ls_entity>-HireDate IS NOT INITIAL.
        ls_db-hire_date = <ls_entity>-HireDate.
      ENDIF.

      IF <ls_entity>-Salary IS NOT INITIAL.
        ls_db-salary = <ls_entity>-Salary.
      ENDIF.

      IF <ls_entity>-Curry IS NOT INITIAL.
        ls_db-curry = <ls_entity>-Curry.
      ENDIF.

      lo_buffer->add_to_buffer(
        iv_flag     = 'U'
        is_employee = ls_db ).

      INSERT VALUE #(
        %cid  = <ls_entity>-%pid
        EmpId = ls_db-emp_id )
        INTO TABLE mapped-emp.

    ENDLOOP.
  ENDMETHOD.


  METHOD delete.
    DATA(lo_buffer) = lcl_buffer=>get_instance( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).

      DATA ls_employee TYPE zun_emp_tab_070.
      ls_employee-emp_id = <ls_key>-EmpId.

      lo_buffer->add_to_buffer(
        iv_flag     = 'D'
        is_employee = ls_employee ).

      INSERT VALUE #(
        %cid  = <ls_key>-%pid
        EmpId = <ls_key>-EmpId )
        INTO TABLE mapped-emp.

    ENDLOOP.
  ENDMETHOD.


  METHOD read.
    SELECT *
      FROM zun_emp_tab_070
      FOR ALL ENTRIES IN @keys
      WHERE emp_id = @keys-EmpId
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.


  METHOD lock.
  ENDMETHOD.

ENDCLASS.



CLASS lsc_ZUN_EMP_ROOT_070 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS adjust_numbers REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.



CLASS lsc_ZUN_EMP_ROOT_070 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
  ENDMETHOD.

  METHOD save.

    LOOP AT lcl_buffer=>mt_buffer ASSIGNING FIELD-SYMBOL(<ls_buf>).

      CASE <ls_buf>-flag.

        WHEN 'C'.
          INSERT zun_emp_tab_070 FROM @<ls_buf>-lv_data.

        WHEN 'U'.
          UPDATE zun_emp_tab_070 FROM @<ls_buf>-lv_data.

        WHEN 'D'.
          DELETE FROM zun_emp_tab_070
            WHERE emp_id = @<ls_buf>-lv_data-emp_id.

      ENDCASE.

    ENDLOOP.

    CLEAR lcl_buffer=>mt_buffer.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
