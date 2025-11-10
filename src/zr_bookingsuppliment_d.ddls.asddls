@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppliment View for Draft Scen'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zr_bookingsuppliment_D
  as select from /dmo/a_bksuppl_d

  association        to parent zr_booking_d   as _Booking        on $projection.BookingUUID = _Booking.BookingUUID
  association [1..1] to zr_travel_d           as _Travel         on $projection.TravelUUID = _Travel.TravelUUID
  association [1..1] to /DMO/I_Supplement     as _Product        on $projection.SupplementId = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText as _SupplimentText on $projection.SupplementId = _SupplimentText.SupplementID

{
  key booksuppl_uuid        as BooksupplUuid,
      root_uuid             as TravelUUID,
      parent_uuid           as BookingUUID,
      booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as BookSupplPrice,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      //Association
      _Booking,
      _Travel,
      _Product,
      _SupplimentText

}
