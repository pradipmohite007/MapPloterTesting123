/********** 
   Class   : MPCity 
   Author  : Shilpa Kamble 
   Date    : 09/12/2015 
   History : v1.6 
   Details : 
***********/
global with sharing class MPCity implements Comparable
{
    public string CityName
    {get;set;}

    public string CityKey
    {get;set;}

    //////////////////
    // Constructor
    //////////////////
    global MPCity() 
    {
        
    }

    global MPCity(String nameCity,String cityKey) 
    {
        CityName = nameCity;
        this.CityKey = cityKey;
    }


    //////////////////////////////////////
    //Public Methods
    //////////////////////////////////////

    // Used to sort list if SIMCoutries.
    global Integer compareTo(Object objectToCompareTo)
    {
        MPCity cityToCompare = (MPCity) objectToCompareTo;
        return CityName.compareTo(cityToCompare.CityName);
    }
}