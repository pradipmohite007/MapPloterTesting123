/*****************************************
   Class   : Helper_Search
   Author  : Shilpa Kamble 
   Date    : 09/12/2015
   History : v1.6 
   Details : 
********************************************/
global with sharing class Helper_Search 
{
   //Return country hierarchy from AddressInfo Object
   
    global static Map<string,Map<string,List<MPCity>>> GetLocationFilter()
    {
        Map<string,Map<string,List<MPCity>>> mapObjectFilter = Helper_SOQL.GetLocationFilter();  
        return mapObjectFilter;   
    }
}