@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection View for Draft Scen'

@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_booking_a_d
  as projection on zr_booking_d
{
  key BookingUUID,

      TravelUUID,

      @Search.defaultSearchElement: true
      BookingID,

      BookingDate,

      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer',element: 'CustomerID' } }]
      CustomerID,
      _Customer.LastName as CustomerName,

      @ObjectModel.text.element: ['CarrierName']
      //      @Consumption.valueHelpDefinition: [
      //          { entity: {name: '/DMO/I_Flight_StdVH', element: 'AirlineID'},
      //            additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT   },
      //                                 { localElement: 'ConnectionID', element: 'ConnectionID', usage: #RESULT},
      //                                 { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT},
      //                                 { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
      //            useForValidation: true }
      //        ]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Flight', element: 'AirlineID' },
                                           additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',usage: #RESULT },
                                                                { localElement: 'AirlineID',    element: 'AirlineID',usage: #RESULT },
                                                                { localElement: 'FlightPrice',  element: 'Price', usage: #RESULT},
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ]
      AirlineID,
      _Carrier.Name      as CarrierName,

      //      @Consumption.valueHelpDefinition: [
      //          { entity: {name: '/DMO/I_Flight_StdVH', element: 'ConnectionID'},
      //            additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT},
      //                                 { localElement: 'AirlineID',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
      //                                 { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT},
      //                                 { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
      //            useForValidation: true }
      //        ]
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                           additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate'},
                                                { localElement: 'AirlineID',    element: 'AirlineID'},
                                                { localElement: 'FlightPrice',  element: 'Price', usage: #RESULT},
                                                { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ]
      ConnectionID,


      //      @Consumption.valueHelpDefinition: [
      //          { entity: {name: '/DMO/I_Flight_StdVH', element: 'FlightDate'},
      //            additionalBinding: [ { localElement: 'AirlineID',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
      //                                 { localElement: 'ConnectionID', element: 'ConnectionID', usage: #FILTER_AND_RESULT},
      //                                 { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT},
      //                                 { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
      //            useForValidation: true }
      //        ]
      FlightDate,

      //      @Consumption.valueHelpDefinition: [
      //          { entity: {name: '/DMO/I_Flight_StdVH', element: 'Price'},
      //            additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',   usage: #FILTER_AND_RESULT},
      //                                 { localElement: 'AirlineID',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
      //                                 { localElement: 'ConnectionID', element: 'ConnectionID', usage: #FILTER_AND_RESULT},
      //                                 { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
      //            useForValidation: true }
      //        ]
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                      additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate'},
                                           { localElement: 'AirlineID',    element: 'AirlineID'},
                                           { localElement: 'FlightPrice',  element: 'Price', usage: #RESULT },
                                           { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ]
      FlightPrice,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      CurrencyCode,

      BookingStatus,

      LocalLastChangedAt,

      /* Associations */
      _Bookingsuppliment : redirected to composition child ZC_BookingSupplement_A_D,
      //      _BookingStatus,
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent ZC_TRAVEL_a_d
}
