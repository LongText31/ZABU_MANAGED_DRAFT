@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppl Proj View for Draft Scen'
@Metadata.allowExtensions: true
@Search.searchable: true


define view entity ZC_BookingSupplement_A_D
  as projection on zr_bookingsuppliment_D
{
  key BookSupplUUID,

      TravelUUID,

      BookingUUID,

      @Search.defaultSearchElement: true
      BookingSupplementID,

      @ObjectModel.text.element: ['SupplementDescription']
      @Consumption.valueHelpDefinition: [ 
          {  entity: {name: '/DMO/I_Supplement', element: 'SupplementID' },
             additionalBinding: [ { localElement: 'BookSupplPrice',  element: 'Price',        usage: #RESULT },
                                  { localElement: 'CurrencyCode',    element: 'CurrencyCode', usage: #RESULT }]
              }
        ]
      SupplementID,
      _SupplimentText.Description as SupplementDescription: localized,

      BookSupplPrice,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      CurrencyCode,

      LocalLastChangedAt,

      /* Associations */
      _Booking : redirected to parent ZC_Booking_A_D,
      _Product,
      _Travel  : redirected to ZC_TRAVEL_A_D
}
