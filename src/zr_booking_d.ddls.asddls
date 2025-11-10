@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Entity for Draft Scen'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zr_booking_d
  as select from /dmo/a_booking_d

  association        to parent zr_travel_d     as _Travel     on $projection.TravelUUID = _Travel.TravelUUID
  composition [0..*] of zr_bookingsuppliment_D as _Bookingsuppliment

  association [1..1] to /DMO/I_Customer        as _Customer   on $projection.CustomerID = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier         as _Carrier    on $projection.AirlineID = _Carrier.AirlineID
  association [1..*] to /DMO/I_Connection      as _Connection on $projection.ConnectionID = _Connection.ConnectionID

{
  key booking_uuid          as BookingUUID,
      parent_uuid           as TravelUUID,
      booking_id            as BookingID,
      booking_date          as BookingDate,
      customer_id           as CustomerID,
      carrier_id            as AirlineID,
      connection_id         as ConnectionID,
      flight_date           as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price          as FlightPrice,
      currency_code         as CurrencyCode,
      booking_status        as BookingStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      //Associations
      _Travel,
      _Customer,
      _Carrier,
      _Connection,
      _Bookingsuppliment
}
