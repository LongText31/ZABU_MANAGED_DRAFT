class lhc_zr_bookingsuppliment_d definition inheriting from cl_abap_behavior_handler.

  private section.

    methods setbookingsupnum for determine on save
      importing keys for zr_bookingsuppliment_d~setbookingsupnum.
    methods calcbooksupprice for determine on modify
      importing keys for zr_bookingsuppliment_d~calcbooksupprice.

endclass.

class lhc_zr_bookingsuppliment_d implementation.

  method setbookingsupnum.

    data lt_booking_sup_updt type table for update zr_travel_d\\zr_bookingsuppliment_d.

    read entities of zr_travel_d in local mode
    entity zr_bookingsuppliment_d by \_booking
    fields ( bookingid )
    with corresponding #( keys )
    result data(lt_booking).

    loop at lt_booking into data(ls_booking).

      read entities of zr_travel_d in local mode
      entity zr_booking_d by \_bookingsuppliment
      fields ( bookingsupplementid )
      with value #( ( %tky = ls_booking-%tky ) )
      result data(lt_bookingsup).
    endloop.

    data(lv_max_book_sup) = '00'.

    loop at lt_bookingsup into data(ls_bookingsup).
      if lv_max_book_sup < ls_bookingsup-bookingsupplementid.
        lv_max_book_sup = ls_bookingsup-bookingsupplementid.
      endif.
    endloop.

    loop at lt_bookingsup into ls_bookingsup where bookingsupplementid is initial.
      lv_max_book_sup += 1.
      append value #( %tky = ls_bookingsup-%tky
                      bookingsupplementid = lv_max_book_sup  ) to lt_booking_sup_updt.
    endloop.

    modify entities of zr_travel_d in local mode
    entity zr_bookingsuppliment_d
    update fields ( bookingsupplementid )
    with lt_booking_sup_updt.

  endmethod.

  method calcbooksupprice.
    read entities of zr_travel_d in local mode
    entity zr_bookingsuppliment_d by \_travel
    fields ( traveluuid )
    with corresponding #( keys )
    result data(lt_travel).

    modify entities of zr_travel_d in local mode
    entity zr_travel_d
    execute recalctotalprice
    from corresponding #( lt_travel ).

  endmethod.

endclass.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
