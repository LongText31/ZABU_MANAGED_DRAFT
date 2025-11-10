@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Projection View for Draft Scen'
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_TRAVEL_a_d
  provider contract transactional_query
  as projection on zr_travel_d
{
  key TravelUUID,
      @Search.defaultSearchElement: true
      TravelID,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element:['AgencyName']
      AgencyID,
      _Agency.Name       as AgencyName,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['CustomerName']
      CustomerID,
      _Customer.LastName as CustomerName,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      CurrencyCode,
      Description,
      OverallStatus,
      LocalLastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child zc_booking_a_d,
      _Currency,
      _Customer
}
