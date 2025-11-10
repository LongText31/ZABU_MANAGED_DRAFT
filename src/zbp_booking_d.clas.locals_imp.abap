class lhc_zr_booking_d definition inheriting from cl_abap_behavior_handler.

  private section.

    methods setbookingid for determine on save
      importing keys for zr_booking_d~setbookingid.
    methods setbookingdate for determine on save
      importing keys for zr_booking_d~setbookingdate.
    methods calculatetotalprice for determine on modify
      importing keys for zr_booking_d~calculatetotalprice.
    methods validatecustomer for validate on save
      importing keys for zr_booking_d~validatecustomer.

endclass.

class lhc_zr_booking_d implementation.

  method setbookingid.

    data lt_booking_update type table for update zr_travel_d\\zr_booking_d.

    read entities of zr_travel_d in local mode
    entity zr_booking_d by \_travel
    fields ( traveluuid )
    with corresponding #( keys )
    result data(lt_travel).

    loop at lt_travel into data(ls_travel).

      read entities of zr_travel_d in local mode
      entity zr_travel_d by \_booking
      fields ( bookingid )
      with value #( ( %tky = ls_travel-%tky ) )
      result data(lt_booking).

      data(lv_max_bookid) = '0000'.

      loop at lt_booking into data(ls_booking).

        if ls_booking-bookingid > lv_max_bookid.
          lv_max_bookid = ls_booking-bookingid.
        endif.
      endloop.

      loop at lt_booking into ls_booking where bookingid is initial.
        lv_max_bookid += 1.
        append value #(  %tky = ls_booking-%tky
                         bookingid = lv_max_bookid ) to lt_booking_update.

      endloop.


    endloop.


    modify entities of zr_travel_d in local mode
    entity zr_booking_d
    update fields ( bookingid )
    with lt_booking_update.


  endmethod.

  method setbookingdate.

    read entities of zr_travel_d in local mode
    entity zr_booking_d
    fields ( bookingdate )
    with corresponding #( keys )
    result data(lt_result).

    delete lt_result where bookingdate is not initial.

    if lt_result is initial.
      return.
    endif.

    loop at lt_result assigning field-symbol(<fs_result>).
      <fs_result>-bookingdate = cl_abap_context_info=>get_system_date( ).
    endloop.

    modify entities of zr_travel_d in local mode
    entity zr_booking_d
    update fields ( bookingdate )
    with corresponding #( lt_result ).

  endmethod.

  method calculatetotalprice.

    read entities of zr_travel_d in local mode
    entity zr_booking_d by \_travel
    fields ( traveluuid )
    with corresponding #( keys )
    result data(lt_result).

    modify entities of zr_travel_d in local mode
    entity zr_travel_d
    execute recalctotalprice
    from corresponding #( lt_result ).
  endmethod.

  method validatecustomer.

    read entities of zr_travel_d in local mode
    entity zr_booking_d
    fields ( customerid )
    with corresponding #( keys )
    result data(lt_booking).

    read entities of zr_travel_d in local mode
    entity zr_booking_d by \_travel
    from corresponding #( lt_booking )
    link data(lt_travel_booking_link).

    data lt_customers type sorted table of /dmo/customer with unique key customer_id.

    lt_customers = corresponding #( lt_booking discarding duplicates mapping customer_id = customerid  except * ).

    delete lt_customers where customer_id is initial.

    if lt_customers is not initial.

      select from /dmo/customer
      fields customer_id
      for all entries in @lt_customers
      where customer_id = @lt_customers-customer_id
      into table @data(lv_valid_customers).
    endif.
    loop at lt_booking into data(booking).

      append value #( %tky = booking-%tky
                      %state_area = 'Validate Customer'
                       ) to reported-zr_booking_d.
      if booking-customerid is initial.
        append value #( %tky = booking-%tky ) to failed-zr_booking_d.

        append value #( %tky = booking-%tky
                        %state_area = 'VALIDATE_CUSTOMER'
                        %element-customerid = if_abap_behv=>mk-on  "This the field
                        %path = value #( zr_travel_d-%tky = lt_travel_booking_link[ key id
                                                                                    source-%tky = booking-%tky ]-target-%tky )
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Enter Customer ID' )
                         ) to reported-zr_booking_d.
      elseif booking-customerid is not initial and not line_exists( lv_valid_customers[ customer_id = booking-customerid ] ).
        append value #( %tky = booking-%tky ) to failed-zr_booking_d.

        append value #( %tky = booking-%tky
                         %state_area = 'VALIDATE_CUSTOMER'
                         %element-customerid = if_abap_behv=>mk-on
                         %path = value #( zr_travel_d-%tky = lt_travel_booking_link[ key id
                                                                                    source-%tky = booking-%tky ]-target-%tky )
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Customer is Unknown' )
                          ) to reported-zr_booking_d.
      endif.
    endloop.
  endmethod.

endclass.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
