class lhc_zr_travel_d definition inheriting from cl_abap_behavior_handler.
  private section.

    methods get_instance_authorizations for instance authorization
      importing keys request requested_authorizations for zr_travel_d result result.
    methods get_global_authorizations for global authorization
      importing request requested_authorizations for zr_travel_d result result.
    methods precheck_create for precheck
      importing entities for create zr_travel_d.

    methods precheck_update for precheck
      importing entities for update zr_travel_d.
    methods accepttravel for modify
      importing keys for action zr_travel_d~accepttravel result result.

    methods deductdiscount for modify
      importing keys for action zr_travel_d~deductdiscount result result.

    methods recalctotalprice for modify
      importing keys for action zr_travel_d~recalctotalprice.

    methods rejecttravel for modify
      importing keys for action zr_travel_d~rejecttravel result result.
    methods calctotprice for determine on modify
      importing keys for zr_travel_d~calctotprice.

    methods setstatusopen for determine on modify
      importing keys for zr_travel_d~setstatusopen.

    methods settravelid for determine on save
      importing keys for zr_travel_d~settravelid.
    methods validatecustomer for validate on save
      importing keys for zr_travel_d~validatecustomer.
    methods activate for modify
      importing keys for action zr_travel_d~activate.

    methods discard for modify
      importing keys for action zr_travel_d~discard.

    methods edit for modify
      importing keys for action zr_travel_d~edit.

    methods resume for modify
      importing keys for action zr_travel_d~resume.

endclass.

class lhc_zr_travel_d implementation.

  method get_instance_authorizations.
*    data: lv_uptade type if_abap_behv=>t_xflag,
*          lv_delete type if_abap_behv=>t_xflag.
*
*    read entities of zr_travel_d in local mode
*    entity zr_travel_d
*    fields ( agencyid )
*    with corresponding #( keys )
*    result data(lt_travels)
*    failed data(lt_failed).
*
*    check lt_travels is not initial.
*
*    select from /dmo/a_travel_d as a
*    inner join /dmo/agency as b
*    on a~agency_id = b~agency_id
*    fields a~travel_uuid,
*           a~agency_id,
*           b~country_code
*           for all entries in @lt_travels
*           where a~agency_id = @lt_travels-agencyid
*           into table @data(lt_age_ctry).
*
*    loop at lt_travels into data(ls_travels).
*
*      read table lt_age_ctry assigning field-symbol(<fs_age_ctry>) with key travel_uuid = ls_travels-traveluuid.
*      if sy-subrc is initial.
*        if requested_authorizations-%update = if_abap_behv=>mk-on.
*
*          authority-check object 'ZAUTH_OBJ'
*             id 'LAND1' field <fs_age_ctry>-country_code
*             id 'ACTVT' field '02'.
*
*          lv_uptade = cond #( when sy-subrc = 0 then if_abap_behv=>auth-allowed
*                              else if_abap_behv=>auth-unauthorized ).
*
*          append value #( %tky = ls_travels-%tky
*                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                        text = 'Not Authorizaed for Agency ID'  ) ) to reported-zr_travel_d.
*        endif.
**
*        if requested_authorizations-%delete = if_abap_behv=>mk-on.
*
*          authority-check object 'ZAUTH_OBJ'
*            id 'LAND1' field <fs_age_ctry>-country_code
*            id 'ACTVT' field '06'.
*
*          lv_delete = cond #( when sy-subrc = 0 then if_abap_behv=>auth-allowed
*                              else if_abap_behv=>auth-unauthorized ).
*
*          append value #( %tky = ls_travels-%tky
*                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                        text = 'Not Authorizaed for Agency ID'  ) ) to reported-zr_travel_d.
*          .
*
*        endif.
*      else.
*      endif.
*      append value #( traveluuid = ls_travels-traveluuid
*                      %update = lv_uptade
*                      %delete = lv_delete ) to result.
*    endloop.

  endmethod.

  method get_global_authorizations.
*    if requested_authorizations-%create = if_abap_behv=>mk-on.
*      authority-check object 'ZAUTH_OBJ'
*         id 'LAND1' dummy
*         id 'ACTVT' field '01'.
*      result-%create = cond #( when sy-subrc = 0 then if_abap_behv=>auth-allowed
*                               else if_abap_behv=>auth-unauthorized ).
*    endif.
*
*    if requested_authorizations-%update = if_abap_behv=>mk-on.
*
*      authority-check object 'ZAUTH_OBJ'
*           id 'LAND1' dummy
*           id 'ACTVT' field '02'.
*
*      result-%update = cond #( when sy-subrc = 0 then if_abap_behv=>auth-allowed
*                          else if_abap_behv=>auth-unauthorized ).
*
*    endif.
*
*    if requested_authorizations-%delete = if_abap_behv=>mk-on.
*
*      authority-check object 'ZAUTH_OBJ'
*           id 'LAND1' dummy
*           id 'ACTVT' field '06'.
*
*      result-%delete = cond #( when sy-subrc = 0 then if_abap_behv=>auth-allowed
*                               else if_abap_behv=>auth-unauthorized ).
*
*    endif.
  endmethod.

  method precheck_create.
  endmethod.

  method precheck_update.

    data lt_agency type sorted table of /dmo/agency with unique key agency_id.

    lt_agency = corresponding #( entities discarding duplicates mapping agency_id = agencyid except * ).

    check lt_agency is not initial.

    select from /dmo/agency
    fields agency_id, country_code
    for all entries in @lt_agency
    where agency_id = @lt_agency-agency_id
    into table @data(lt_ag_ct).

    if sy-subrc is initial.

      loop at entities into data(ls_entity).

        read table lt_ag_ct assigning field-symbol(<fs_ag_ct>) with key agency_id = ls_entity-agencyid.

        authority-check object 'ZAUTH_OBJ'
           id 'LAND1' field <fs_ag_ct>-country_code
           id 'ACTVT' field '02'.
        if sy-subrc is not initial.

          append value #( %tky = ls_entity-%tky ) to failed-zr_travel_d.

          append value #( %tky = ls_entity-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Not Authorizaed for Agency ID'  ) ) to reported-zr_travel_d.

        endif.
      endloop.
    endif.



  endmethod.

  method accepttravel.

    modify entities of zr_travel_d in local mode
    entity zr_travel_d
    update fields ( overallstatus )
    with value #( for ls_keys in keys ( %tky = ls_keys-%tky
                                        overallstatus = 'A' ) ).

    read entities of zr_travel_d in local mode
    entity zr_travel_d
    all fields with corresponding #( keys )
    result data(lt_result).

    result = value #( for ls_result in lt_result ( %tky = ls_result-%tky
                                                   %param  = ls_result ) ).

  endmethod.

  method deductdiscount.

    data(lt_keys) = keys.

    loop at lt_keys assigning field-symbol(<fs_keys>) where %param-discount is initial
                                                         or %param-discount gt 100
                                                         or %param-discount le 0  .

      append  value #( %tky = <fs_keys>-%tky ) to failed-zr_travel_d.
      append  value #( %tky = <fs_keys>-%tky
                       %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                     text     = 'Discount Invalide'  )
                       %element-bookingfee = if_abap_behv=>mk-on
                       %action-deductdiscount = if_abap_behv=>mk-on ) to reported-zr_travel_d.
      delete lt_keys.
    endloop.

    check lt_keys is not initial.

    read entities of zr_travel_d in local mode
    entity zr_travel_d
    fields ( bookingfee )
    with corresponding #( lt_keys )
    result data(lt_result).

    loop at lt_result assigning field-symbol(<fs_result>).
      data lt_result_new type table for update zr_travel_d.
      data lv_disc type decfloat16.
      data(lv_discount) = lt_keys[ key id %tky = <fs_result>-%tky ]-%param-discount.
      lv_disc = lv_discount / 100.
      data(lv_disc_book_fee) = <fs_result>-bookingfee - ( <fs_result>-bookingfee * lv_disc ).

      append value #( %tky       = <fs_result>-%tky
                      bookingfee = lv_disc_book_fee  ) to lt_result_new.

      modify entities of zr_travel_d in local mode
      entity zr_travel_d
      update fields ( bookingfee )
      with lt_result_new.

      read entities of zr_travel_d in local mode
      entity zr_travel_d
      all fields with corresponding #( lt_keys )
      result data(lt_modified_travel).


    endloop.

    result = value #( for ls_modified_travel in lt_modified_travel ( %tky = ls_modified_travel-%tky
                                                                     %param = ls_modified_travel ) ).

  endmethod.

  method recalctotalprice.

    types: begin of ty_total,
             price type /dmo/total_price,
             curr  type /dmo/currency_code,
           end of ty_total.

    data: lt_total      type table of ty_total,
          lv_conv_price type ty_total-price.


    read  entities of zr_travel_d in local mode
     entity zr_travel_d
     fields ( bookingfee currencycode )
     with corresponding #( keys )
     result data(lt_travel).

    delete lt_travel where currencycode is initial.

    read entities of zr_travel_d in local mode
    entity zr_travel_d by \_booking
    fields ( flightprice currencycode )
    with corresponding #( keys )
    result data(lt_booking).

    delete lt_booking where currencycode is initial.

    read entities of zr_travel_d in local mode
    entity zr_booking_d by \_bookingsuppliment
    fields ( booksupplprice currencycode )
    with corresponding #( lt_booking )
    result data(lt_bookingsupl).

    loop at lt_travel assigning field-symbol(<fs_travel>).

      lt_total =  value #( ( price = <fs_travel>-bookingfee
                             curr = <fs_travel>-currencycode ) ).

      loop at lt_booking assigning field-symbol(<fs_booking>) where currencycode is not initial.

        append value #( price = <fs_booking>-flightprice
                        curr  = <fs_booking>-currencycode ) to lt_total.

        loop at lt_bookingsupl assigning field-symbol(<fs_bookingsupl>) where currencycode is not initial.

          append value #( price = <fs_bookingsupl>-booksupplprice
                          curr  = <fs_bookingsupl>-currencycode ) to lt_total.


        endloop.
      endloop.
      loop at lt_total assigning field-symbol(<fs_total>).
        if <fs_total>-curr = <fs_travel>-currencycode.
          lv_conv_price = <fs_total>-price.
        else.

          /dmo/cl_flight_amdp=>convert_currency(
      exporting
        iv_amount               = <fs_total>-price
        iv_currency_code_source = <fs_total>-curr
        iv_currency_code_target = <fs_travel>-currencycode
        iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
    importing
      ev_amount               = lv_conv_price
    ).

        endif.
        <fs_travel>-totalprice = <fs_travel>-totalprice + lv_conv_price.
      endloop.

    endloop.
    modify entities of zr_travel_d in local mode
    entity zr_travel_d
    update fields ( totalprice )
    with corresponding #( lt_travel ).

  endmethod.

  method rejecttravel.

    modify entities of zr_travel_d  in local mode
    entity zr_travel_d
    update fields ( overallstatus )
    with value #( for ls_keys in keys ( %tky = ls_keys-%tky
                                        overallstatus = 'O' ) ).

    read entities of zr_travel_d in local mode
    entity zr_travel_d
    all fields with corresponding #( keys )
    result data(lt_result).

    result = value #( for ls_result in lt_result ( %tky = ls_result-%tky
                                                   %param = ls_result ) ).

  endmethod.

  method calctotprice.

    modify entities of zr_travel_d in local mode
    entity zr_travel_d
    execute recalctotalprice
    from corresponding #( keys ).


  endmethod.

  method setstatusopen.

    read entities of zr_travel_d in local mode
     entity zr_travel_d
     fields ( overallstatus )
     with corresponding #( keys )
     result data(lt_travel).

    delete lt_travel where overallstatus is not initial.

    check lt_travel is not initial.

    modify entities of zr_travel_d  in local mode
    entity zr_travel_d
    update fields ( overallstatus )
    with value #( for ls_travel in lt_travel ( %tky = ls_travel-%tky
                                               overallstatus = 'O' ) ).

  endmethod.

  method settravelid.

    read entities of zr_travel_d in local mode
    entity zr_travel_d
    fields ( travelid )
    with corresponding #( keys )
    result data(lt_travel).

    delete lt_travel where travelid is not initial.

    check lt_travel is not initial.

    select
    from /dmo/a_travel_d
    fields max( travel_id )
    into @data(lv_max_travel_id).

    modify entities of zr_travel_d  in local mode
    entity zr_travel_d
    update fields ( travelid )
    with value #( for ls_travel in lt_travel ( %tky = ls_travel-%tky
                                               travelid = lv_max_travel_id + 1 ) ).

  endmethod.

  method validatecustomer.

    read entities of zr_travel_d in local mode
    entity zr_travel_d
    fields ( customerid )
    with corresponding #( keys )
    result data(lt_travel).

    data lt_customers type sorted table of /dmo/customer with unique key customer_id.

    lt_customers = corresponding #( lt_travel discarding duplicates mapping customer_id = customerid  except * ).

    delete lt_customers where customer_id is initial.

    if lt_customers is not initial.

      select from /dmo/customer
      fields customer_id
      for all entries in @lt_customers
      where customer_id = @lt_customers-customer_id
      into table @data(lv_valid_customers).
    endif.
    loop at lt_travel into data(travel).

      append value #( %tky = travel-%tky
                      %state_area = 'Validate Customer'
                       ) to reported-zr_travel_d.
      if travel-customerid is initial.
        append value #( %tky = travel-%tky ) to failed-zr_travel_d.

        append value #( %tky = travel-%tky
                        %state_area = 'VALIDATE_CUSTOMER'
                        %element-customerid = if_abap_behv=>mk-on  "This the field
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Enter Customer ID' )  ) to reported-zr_travel_d.
      elseif travel-customerid is not initial and not line_exists( lv_valid_customers[ customer_id = travel-customerid ] ).
        append value #( %tky = travel-%tky ) to failed-zr_travel_d.

        append value #( %tky = travel-%tky
                         %state_area = 'VALIDATE_CUSTOMER'
                         %element-customerid = if_abap_behv=>mk-on
                         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text = 'Customer is Unknown' )  ) to reported-zr_travel_d.
      endif.
    endloop.

  endmethod.

  METHOD Activate.
  ENDMETHOD.

  METHOD Discard.
  ENDMETHOD.

  METHOD Edit.
  ENDMETHOD.

  METHOD Resume.
  ENDMETHOD.

endclass.
