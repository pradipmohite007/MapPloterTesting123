/********** 
   Class   : MapPointInfo 
   Author  : Shilpa Kamble 
   Date    : 09/12/2015 
   History : v1.6 
   Details : Stores the Map Point information.
***********/
global with sharing class MapPointInfo implements Comparable
{
    ////////////////////////////////////
    // Properies
    ////////////////////////////////////
    public string EntityName
    {get;set;}

    public String DisplayName
    {get;set;}

    public String Address
    {get;set;}

    public ID RecordId 
    {get;set;}

    public Double Latitude 
    {get;set;}

    public Double Longitude 
    {get;set;}

    public string Status
    {get;set;}

    public Integer StatusCode
    {get;set;}

    public ID ObjectRecordId
    {get;set;}

    public String Geocode_Precision
    {get;set;}

    public Datetime RecCreationDate
    {get;set;}
    ////////////////////////////////////
    // Constructor
    ////////////////////////////////////
    //public MapPointInfo() 
    //{
    //  QueriedAsParent = false;
    //}

    ////////////////////////////////////
    // Static Methods
    ////////////////////////////////////
    global static string FormatAddress(String street, String city, String state, String country, String postalCode)
    {
        if(String.isBlank(street))
      {
            street = '';
      }
        if(String.isBlank(city))
      {
            city = '';
      }
        if(String.isBlank(state))
      {
            state = '';
      }
        if(String.isBlank(country))
      {
            country = '';
      }
        if(String.isBlank(postalCode))
      {
            postalCode = '';
      }
        
        return  street + ' ' + city + ' ' + state + ' ' + country + ' ' + postalCode;
    }

    ////////////////////////////////////
    // Public Methods
    ////////////////////////////////////
    global Integer compareTo(Object objectToCompareTo)
    {
        Integer returnResult = 0; 
        Try
        {
            MapPointInfo mapPointToCompare = (MapPointInfo) objectToCompareTo;
            returnResult = DisplayName.compareTo(mapPointToCompare.DisplayName);
        }
        Catch(Exception ex)
        {
            System.debug(logginglevel.info,'**Sort Exception='+ex);
        }
        return  returnResult;
    }
}