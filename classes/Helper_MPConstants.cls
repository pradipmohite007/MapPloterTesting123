/********** 
   Class   : Helper_MPConstants
   Author  : Shilpa Kamble 
   Date    : 09/12/2015
   History : v1.6 
   Details : For declaring all the conatant strings.
***********/
global with sharing class Helper_MPConstants
{
    ///////////////////////////////
    // Properties/Constants
    ///////////////////////////////
    public static string URL_GoogleMapAPI = 'https://maps.googleapis.com/maps/api/geocode/json';
    public static string URL_MapQuestAPI = 'http://www.mapquestapi.com/geocoding/v1/address';
    public static string orgNamespace = System.Label.orgNamespace ;
    public static string org_namespaceprefix = orgNamespace+'__';
   

    public static string URL_GoogleNewsAPI = 'https://news.google.com/news/feeds?q=';
   

    public static string API_SPECIAL_CHARACTERS = '[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"|.,|,.|\n|\\n|\r\n|\t]';
    
    public static string GEOCODE_FAILED = 'Failed';
    public static string GEOCODE_SUCCESS = 'Success';
    public static string GEOCODE_PENDING = 'Pending';
    public static string GOOGLE_API_GEOCODEING = 'Google API';
   
    public static string ACCOUNT_API_NAME = 'Account';
    public static string CONTACT_API_NAME = 'Contact';
    public static string LEAD_API_NAME = 'Lead';
    public static string MAP_POINT_API_NAME = 'MP_Map_Point__c';
    public static string SCHEDULER_NAME = 'Schedule job to populate Map Points records';
    public static string REFRESH_DAILY_QUOTA_SCHEDULER_NAME = 'Refresh Daily API Quota Value';

    //Constants used to handle trigger
    global static String EVENT_INSERT = 'Insert';    
    global static String EVENT_UPDATE = 'Update';   
    global static String EVENT_DELETE = 'Delete';   
    global static String EVENT_UNDELETE = 'Undelete';
    global static String EVENT_UPDATE_FAILED = 'Update_failed';   

    public static integer INTEGER_CONSTANT_TEN = 10; 
    public static integer INTEGER_CONSTANT_FIFTY = 50;
    public static integer OFFSET_VALUE = 2000;
    public static string COLORED_FILTER = 'colored';
   
}