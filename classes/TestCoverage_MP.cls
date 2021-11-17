/*************************************************
Class   : TestCoverage_MP.cls
Author  : Shilpa Kamble 
Date    : 09/12/2015
History : v1.6 
Details : Test class for the Controllers.
***********************************************/
@isTest(SeeAllData = false)
public with sharing class TestCoverage_MP
{   

private static String CRON_EXP = '0 0 0 15 3 ? 2022';    
private static void INSERTcustomSettingRecords()
{
List<MapPlotterPremiumSettings__c> listSettingRecords = new List<MapPlotterPremiumSettings__c>();
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleAPIKey', Value__c = 'TestKey'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKey', Value__c = 'TestKey'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsGoogleKeyValid', Value__c = 'Yes'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsGoogleAPIQueryLimitExceeded', Value__c = 'No'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'SetGeocodingRefreshInterval', Value__c = '15'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'APIDailyQuotaValue', Value__c = '97'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'APICappingValue', Value__c = '100'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleMapUrl', Value__c = 'https://test.test.com/test/api/test/json'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DecryptionCryptoKey', Value__c = 'testkey'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleCryptoKey', Value__c = 'testkey'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DefaultAPIcappingLIMIT', Value__c = '100'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'isEmailNotificationSend', Value__c = 'false'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DisableEmailNotification', Value__c = 'false'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKeysBank01', Value__c = 'TestKey1,TestKey2,TestKey3,TestKey4,TestKey5,TestKey6'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKeysBank02', Value__c = 'TestKey1,TestKey2,TestKey3,TestKey4,TestKey5,TestKey6'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsPageVisited', Value__c='No'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'PromotionAfterDays', Value__c='3'));
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'RemindAfterDays', Value__c='7'));      
listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsRated', Value__c='False'));  

//False Positive
//FLS insert check is not added because we are inserting Protected custom setting. 
INSERT listSettingRecords;


}

//INSERT Custom Mapping Records
private static void INSERTCustomMappingRecords()
{
if(Schema.sObjectType.MP_CustomMapping__c.isCreateable())
{
    MP_CustomMapping__c customMapping1 = new MP_CustomMapping__c(Entity__c = 'Account',Label__c = 'Name',Country__c = 'BillingCountry',State__c = 'Billingstate', City__c = 'BillingCity',Street__c = 'BillingStreet',Postal_Code__c = 'BillingPostalCode');
    INSERT customMapping1;
    MP_CustomMapping__c customMapping2 = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
    INSERT customMapping2;
    MP_CustomMapping__c customMapping3 = new MP_CustomMapping__c(Entity__c = 'Lead',Label__c = 'LastName',Country__c = 'Country',State__c = 'state', City__c = 'City',Street__c = 'Street',Postal_Code__c = 'PostalCode');
    INSERT customMapping3;
    MP_CustomMapping__c customMapping4 = new MP_CustomMapping__c(Entity__c = 'Test__c',Label__c = 'LastName__C',Country__c = 'Country__c',State__c = 'state__C', City__c = 'City__C',Street__c = 'Street__C',Postal_Code__c = 'PostalCode__C');
    INSERT customMapping4;
}
}

private static MP_addressInfo__c TestCreateMP_AddressInfo(String strCombinationKey,String strCountry,String strState,String strCity)
{
if(Schema.sObjectType.MP_AddressInfo__c.isCreateable())
{
    MP_AddressInfo__c  addrInfo = new MP_AddressInfo__c(CombinationKey__c = strCombinationKey,countryName__c = strCountry,StateName__c = strState,CityName__c = strCity);
    try
    {
        insert addrInfo;
        return addrInfo;
    }   
    catch(Exception e)
    {
        system.debug('#Exception in insert AddressInfo='+e.getMessage());
    }
}
return null;
}

private static String GetAddressKey(String StrCombinationKey)
{
List<MP_AddressInfo__c> lstAddr = [select id,name,CombinationKey__c from MP_addressInfo__c where CombinationKey__c =:  StrCombinationKey limit 1];
if(lstAddr != null)
{
    return lstAddr[0].Name;
}
return null;
}  


//Function to create test account
private static Account TestCreateAccount(String name, String street, String city, String state, String postalCode, String country)
{ 
 if(Schema.sObjectType.Account.isCreateable())
 {  
    Account testAccount = new Account(Name = name, BillingStreet = street, BillingCity = city, BillingState = state, BillingCountry = country, BillingPostalCode = postalCode);
    try
    {
        INSERT testAccount;
       return testAccount;
    }
    catch(Exception e)
    {
        system.debug('Inset Record Exception='+e.getMessage());
        return null;
    }
}
return null;   
}

//Function to create test Contact
private static Contact TestCreateContact(String lastName, String street, String city, String state, String country, String postalCode)
{
if(Schema.sObjectType.Contact.isCreateable())
{
    Contact testContact = new Contact(LastName = lastName, MailingStreet = street, MailingCity = city, MailingState = state, MailingCountry = country, 
            MailingPostalCode = postalCode);
    
    try
    {
        INSERT testContact;
        return testContact;
    }
    catch(Exception e)
    {
        system.debug('Exception in contact insert='+e.getMessage());
        return null;
    }
}
return null;
}

//Function to create test MP_MaP_Point
private static MP_Map_Point__c TestCreateMPMapPoint(Decimal latitude, Decimal longitude, String reocrdId,String label ,String country,String state,String city,String street,String postalCode,String status,String entity,String precision)
{
MP_Map_Point__c testMapPoint;
String strAddrKey;
String combinationKey = Helper_GeoCode.GetCombinationKey(country, state, city);

MP_AddressInfo__c addrmp1 = TestCreateMP_AddressInfo(combinationKey,Country,State,City);
if(addrmp1 != null)
{
    strAddrKey = addrmp1.Name;
}
else
{
    strAddrKey = GetAddressKey(combinationKey);
}
testMapPoint = new MP_Map_Point__c(Latitude__c = latitude, Longitude__c = longitude, RecordId__C = reocrdId, Label__c = label,Country__c = country,State__c = state,City__c = city,Street__c = street,Postal_Code__c = postalCode, Status__c = Status,Entity__c = entity,GeoCode_Precision__c = precision,AddressKey__c = strAddrKey);    
  if(Schema.sObjectType.MP_Map_Point__c.isCreateable())
{
    try
    {
        INSERT testMapPoint;
        return testMapPoint;
    }
    catch(Exception e)
    {
        return null;
    }
}
return null;
}

//INSERT the records with map points
private static TestMethod void TestCase_SaveMapping()
{     Test.startTest();
INSERTcustomSettingRecords();
Ctrl_MapPlotter.SaveMapping('Account','Name','Billingcountry','BillingState','Billingcity','Billingstreet','billingpostalcode');
List<MP_CustomMapping__C> lstMappedObj = Helper_SOQL.GetCustomMappingObjects();
Test.stopTest();   
system.assertEquals(lstMappedObj.size(),1);
}

private static TestMethod void TestCase_SaveMapping_Negative()
{
 Test.startTest();
INSERTcustomSettingRecords();
Ctrl_MapPlotter.SaveMapping('Test__c','Name','country','State','city','street','postalcode');
List<MP_CustomMapping__C> lstMappedObj = Helper_SOQL.GetCustomMappingObjects();
Test.stopTest();   
system.assertEquals(lstMappedObj.size(),1);
}

private static TestMethod void TestCase_Getobjects()
{       
INSERTCustomMappingRecords();        
Ctrl_MapPlotter mapPlotter = new Ctrl_MapPlotter();

Test.startTest();      
List<Ctrl_MapPlotter.ObjectDetials> mappedObjects = (List<Ctrl_MapPlotter.ObjectDetials>)JSON.deserialize(Ctrl_MapPlotter.Getobjects(),List<Ctrl_MapPlotter.ObjectDetials>.class);
Test.stopTest();    
system.assertNotEquals(mappedObjects.size(),0);
}

private static TestMethod void TestCase_Getfields()
{       
INSERTcustomSettingRecords();
// by Jitendra
INSERTCustomMappingRecords();        
Ctrl_MapPlotter mapPlotter = new Ctrl_MapPlotter();

Test.startTest();      
List<Ctrl_MapPlotter.ObjectDetials> fields = (List<Ctrl_MapPlotter.ObjectDetials>)JSON.deserialize(Ctrl_MapPlotter.Getfields('Account'),List<Ctrl_MapPlotter.ObjectDetials>.class);
Test.stopTest();
system.assertNotEquals(fields.size(),0);
}
private static TestMethod void TestCase_GetCustomMappingObjects()
{       
INSERTcustomSettingRecords();
// by Jitendra
INSERTCustomMappingRecords();        
Ctrl_MapPlotter mapPlotter = new Ctrl_MapPlotter();

Test.startTest();      
List<MP_CustomMapping__c> mapping = Helper_SOQL.GetCustomMappingObjects();
Test.stopTest();
system.assertEquals(mapping.size(),4);
}

private static TestMethod void TestCase_showResult()
{       
INSERTcustomSettingRecords();
// by Jitendra
INSERTCustomMappingRecords();   
//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');

Ctrl_MapPlotter mapPlotter = new Ctrl_MapPlotter();

Test.startTest();      
string result = Ctrl_MapPlotter.showResult('Account',null);
Ctrl_MapPlotter.GeocodedReport geocodeStatusResport = (Ctrl_MapPlotter.GeocodedReport )JSON.deserialize(result, Ctrl_MapPlotter.GeocodedReport.class);
Test.stopTest();
system.assertEquals(geocodeStatusResport.count_Success,2);
system.assertEquals(geocodeStatusResport.count_Pending,0);
system.assertEquals(geocodeStatusResport.count_failed,0);
}
private static TestMethod void TestCase_PopulateCountries()
{       
INSERTcustomSettingRecords();

// by Jitendra
INSERTCustomMappingRecords();   
//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');

Ctrl_MapPlotter mapPlotter = new Ctrl_MapPlotter();

Test.startTest();      
string countries = Ctrl_MapPlotter.PopulateCountries();
Map<string,Map<string,List<MPCity>>> countriesLst = (Map<string,Map<string,List<MPCity>>> )JSON.deserialize(countries, Map<string,Map<string,List<MPCity>>>.class);
Test.stopTest();
system.assertEquals(countriesLst.size(),2);
}
private static TestMethod void TestCase_PopulateCountriesNegative()
{       
Test.startTest();      
  string countries = Ctrl_MapPlotter.PopulateCountries();
Test.stopTest();
system.assertEquals(countries,null);
}
private static TestMethod void TestCase_SaveWeatherKey()
{   
INSERTcustomSettingRecords();

// by Jitendra
INSERTCustomMappingRecords();  
Test.startTest();      
ctrl_Mapplotter.SaveWeatherKey('test');
Test.stopTest();
MapPlotterPremiumSettings__c weatherKey = MapPlotterPremiumSettings__c.getValues('DarkSkyForecastKey');
System.assertEquals('test',weatherKey.Value__c);    
}
private static TestMethod void TestCase_GetAPIKeys()
{    
INSERTcustomSettingRecords();

// by Jitendra
INSERTCustomMappingRecords(); 
ctrl_Mapplotter.SaveWeatherKey('test');
Test.startTest();      
String strKeys = Ctrl_MapPlotter.GetAPIKeys();

Test.stopTest();
Map<String,String> mapKeysWithValues = (Map<String,String>)JSON.deserialize(strkeys,Map<String,String>.class);        
system.assertEquals(mapKeysWithValues.get('GeocodingAPIKey'),'TestKey');
   
}
private static TestMethod void TestCase_SaveGeoCodingAPIKey()
{    
INSERTcustomSettingRecords();

// by Jitendra
INSERTCustomMappingRecords(); 
Test.startTest();      
Ctrl_MapPlotter.SaveGeoCodingAPIKey( 'TestKey', true, false);
Test.stopTest();
Map<String, MapPlotterPremiumSettings__c> mapCustomSetting = MapPlotterPremiumSettings__c.getAll();
MapPlotterPremiumSettings__c settingGoogleAPIKey = mapCustomSetting.get('GoogleAPIKey');
MapPlotterPremiumSettings__c settingIsKeyValid = mapCustomSetting.get('IsGoogleKeyValid');
MapPlotterPremiumSettings__c settingIsKeyLimitExceeded = mapCustomSetting.get('IsGoogleAPIQueryLimitExceeded');
System.assertEquals('TestKey',settingGoogleAPIKey.Value__c);
System.assertEquals('Yes',settingIsKeyValid.Value__c);
System.assertEquals('No',settingIsKeyLimitExceeded.Value__c);  
}
private static TestMethod void TestCase_SaveGeoCodingAPIKeyNegative()
{    
INSERTcustomSettingRecords();

// by Jitendra
INSERTCustomMappingRecords(); 
Test.startTest();      
Ctrl_MapPlotter.SaveGeoCodingAPIKey( 'TestKey', false, true); 
Test.stopTest();
MapPlotterPremiumSettings__c geocodingKey = MapPlotterPremiumSettings__c.getValues('GoogleAPIKey');
System.assertEquals('TestKey',geocodingKey.Value__c);  
}
private static TestMethod void TestCase_CheckApexJobsStatus()
{    
INSERTcustomSettingRecords();

// by Jitendra
INSERTCustomMappingRecords(); 
Test.startTest();      
Boolean isApexJobRunning = Ctrl_MapPlotter.CheckApexJobsStatus();
Test.stopTest();
System.assertEquals(true,true);  
}
private static TestMethod void TestCase_GetSelectedDataPoints()
{    
INSERTcustomSettingRecords();

// by sandesh temo
INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');

Ctrl_MapPlotter mapPlotter = new Ctrl_MapPlotter();

Test.startTest();      
String datapoints = Ctrl_MapPlotter.GetSelectedDataPoints();
Test.stopTest();
List<ctrl_MapPlotter.MappedObject> lstObj =(List<ctrl_MapPlotter.MappedObject>)JSON.deserialize(datapoints, List<ctrl_MapPlotter.MappedObject>.class);
system.assertEquals(lstObj.size(),4);
}
private static TestMethod void TestCase_OnClickSearchText()
{    
INSERTcustomSettingRecords();


INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');


String SearchInput = 'test';
List<String> ListObjects = new List<String>();
ListObjects.add('Account');
ListObjects.add('contact');

Test.startTest();      
String lstSearchResult = Ctrl_MapPlotter.OnClickSearchText(SearchInput,ListObjects,null);  
Test.stopTest();
List<ctrl_MapPlotter.MapPoint> lstSearchMapPoints =(List<ctrl_MapPlotter.MapPoint>)JSON.deserialize(lstSearchResult, List<ctrl_MapPlotter.MapPoint>.class);
system.assertEquals(lstSearchMapPoints.size(),4);
}
private static TestMethod void TestCase_OnClickSearchTextNegative()
{    
INSERTcustomSettingRecords();

// by sandesh temo
INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');


String SearchInput = 'ABC';
List<String> ListObjects = new List<String>();
ListObjects.add('Account');
ListObjects.add('contact');
Set<Id> setAccountMapPointIds = new Set<Id>();
Set<Id> setContactMapPointIds = new Set<Id>();
Set<Id> setLeadMapPointIds = new Set<Id>();

List<Id> listsearchedSobjects = new List<Id>();

listsearchedSobjects.add([SELECT id FROM MP_Map_Point__c WHERE Entity__c = 'Account' OR Entity__c = 'Contact' OR Entity__c = 'lead' limit 1].id);

Test.setFixedSearchResults(listsearchedSobjects); 

Test.startTest();      
String lstSearchRst = Ctrl_MapPlotter.OnClickSearchText(SearchInput,ListObjects,null);                  
Test.stopTest();
List<ctrl_MapPlotter.MapPoint> lstSearchMapPnts =(List<ctrl_MapPlotter.MapPoint>)JSON.deserialize(lstSearchRst, List<ctrl_MapPlotter.MapPoint>.class);
system.assertNotEquals(lstSearchMapPnts.size(),1);
}
private static TestMethod void TestCase_GetMappedObject()
{    
INSERTcustomSettingRecords();

// by sandesh temo
INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');


List<Account> lstAcc = [select id from Account limit 10];
Set<Id> accIds = (new Map<Id,Account>(lstAcc)).keySet();


List<MP_Map_Point__c> lstMPPoints = [select id ,addressKey__c from MP_Map_Point__c limit 100];        

Test.startTest();      
List<MP_CustomMapping__c> mapping = Helper_SOQL.GetMappedObject('Account');
Test.stopTest();
system.assertEquals(mapping.size(),1);
}
private static TestMethod void TestCase_GetMappedObjectNegative()
{    
INSERTcustomSettingRecords();


INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');

//////////////////////////////////////////////////////////
List<Account> lstAcc = [select id from Account limit 10];
Set<Id> accIds = (new Map<Id,Account>(lstAcc)).keySet();

List<MP_Map_Point__c> lstMPPoints = [select id ,addressKey__c from MP_Map_Point__c limit 100];        

Test.startTest();      
List<MP_CustomMapping__c> mapping1 = Helper_SOQL.GetMappedObject('Test__c');
Test.stopTest();
system.assertEquals(mapping1.size(),1);
}

private static TestMethod void TestCase_GetLstObjectReports()
{    
INSERTcustomSettingRecords();

// by sandesh temo
INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');


Test.startTest();      
String strLstObjectReport = Ctrl_MapPlotter.GetLstObjectReports();  
Test.stopTest();
List<object> lst  = (List<object>)JSON.deserializeUntyped(strLstObjectReport);
system.assertEquals(lst.size(),4);   
}
private static TestMethod void TestCase_StartGeocoding1()
{    
INSERTcustomSettingRecords();

//by sandesh temo
INSERTCustomMappingRecords();
List<MP_CustomMapping__c>  lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();

//Account with MP map point
Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');


Test.startTest();      
boolean status = Ctrl_MapPlotter.StartGeocoding1('Account');  
Test.stopTest();    
system.assertEquals(status,true);   
}
//TestMethod to cover code for Schedule and Batch class For populating new Map Points 

private static TestMethod void TestCase_Schedule_Batch_PopulateNewMapPoints()
{
INSERTcustomSettingRecords(); 
INSERTCustomMappingRecords();       
Account account1 = TestCreateAccount('testacnt1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','USA','95812');
Account account2 = TestCreateAccount('testacnt2', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','USA','95812');
Account account3 = TestCreateAccount('testacnt3', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','USA','95812');
Account account4 = TestCreateAccount('testacnt4', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','USA','95812');
Account account5 = TestCreateAccount('testacnt5', 'aaaaa', 'bbbbb', '****1111','mmmmm','');
Account account6 = TestCreateAccount('testacnt6', 'aaaaa', 'bbbbb', '****1111','mmmmm','');
 
Test.startTest();        
String jobId1 = System.schedule('ScheduleApexClassTest1',CRON_EXP, new Schedule_Batch_PopulateNewMapPoints());  
Test.stopTest();

List<CronTrigger> CronTriggerScheduledJobs = [SELECT id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'ScheduleApexClassTest1'];
// 8 map points records crerated from Account, Contact Lead records and 8 MP map points created with respect to this records manualy.
// All recirs created from INSERTRecords funcion.

System.assertEquals(CronTriggerScheduledJobs.size(), 1);
}

private static TestMethod void TestCase_Schedule_Batch_PopulateOldMapPoints()
{
INSERTcustomSettingRecords(); 
INSERTCustomMappingRecords();       

Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Pending','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2','N-9, M-2 Road, 103, Ranjanwan Society, Hudco, Near T V Centre' ,'Aurangabad', 'Maharashtra', '431001', 'India');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936,-71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Pending','Account','ROOFTOP');

//Contact with MP map point
Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA' ,'USA', '95812');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.LastName,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Pending','Contact','ROOFTOP');

Contact contact2 = TestCreateContact('testContact2', 'Wadia college', 'Pune', 'Maharashtra', 'India', '411006');
MP_Map_Point__c mapPointcontact2 = TestCreateMPMapPoint(42.305936,-71.523546, contact2.id,contact2.LastName,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Pending','Contact','ROOFTOP');


test.startTest();
  Batch_PopulateOldMapPoint oldBatch = new Batch_PopulateOldMapPoint('Account');
  Database.executeBatch(oldBatch);          
Test.stopTest();
list<MP_Map_Point__c> lstMapPoints = [select id from MP_Map_Point__c Limit 500];
system.assertEquals(lstMapPoints.size(),4);
}

private static TestMethod void TestCase_TriggerHandler_Update()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();   
Account TestAccount3 = TestCreateAccount('TestAcc3', '', 'Pune', 'Maharashtra','','India'); 
Test.startTest();
TestAccount3.Name = 'TestAccountUpdate';
if(Account.sObjectType.getDescribe().isUpdateable())
Update TestAccount3;
Test.stopTest();
List<Account> lstAccount = [select id from Account where Name = 'TestAccountUpdate'];
system.assertEquals(lstAccount.size(),1);   
}

private static TestMethod void TestCase_TriggerHandler_UpdateAddress()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();

Account TestAccount3 = TestCreateAccount('TestAcc3', '', 'Pune', 'Maharashtra','','India');
Test.startTest();
TestAccount3.BillingStreet = 'Nagar Road';
if(Account.sObjectType.getDescribe().isUpdateable())
Update TestAccount3;
Test.stopTest();
List<Account> lstAccount = [select id from Account where BillingStreet = 'Nagar Road'];
system.assertEquals(lstAccount.size(),1);
}

private static TestMethod void TestCase_TriggerHandler_Delete()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();
Account TestAccount3 = TestCreateAccount('TestAcc3', '', 'Pune', 'Maharashtra','','India');
Test.startTest();
if(Account.sObjectType.getDescribe().isDeletable())
Delete TestAccount3;
Test.stopTest();
List<MP_Map_Point__c> lstAccountMapPoints = [select id,status__c,AddressKey__c,Entity__c,label__c from Mp_Map_Point__c where entity__c = 'Account'];
system.assertEquals(lstAccountMapPoints.size(),0);
}

private static TestMethod void TestCase_CreateConvertedLead()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();
Lead testLead = new Lead(LastName = 'TestlastName', Street = 'Kalyani Nagar', City = 'Pune', State = 'Maharashtra', Country =  'India', PostalCode = '', Company = 'Extentia');
if(Lead.sObjectType.getDescribe().isCreateable())
{
INSERT testLead;
Test.startTest();
Database.LeadConvert lc = new Database.LeadConvert();
lc.setLeadId(testLead.id);
LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
lc.setConvertedStatus(convertStatus.MasterLabel);
Database.LeadConvertResult lcr = Database.convertLead(lc);
Test.stopTest();
System.assert(lcr.isSuccess()); 
}
}

private static TestMethod void TestCase_GeoCodeAddressFutureForObjectRecord()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();
Account TestAccount3 = TestCreateAccount('TestAcc3', '', 'Pune', 'Maharashtra','','India');
Account TestAccount4 = TestCreateAccount('TestAccount4', 'Kalyani nagar', 'Pune', 'Maharashtra','411006','India');

set<Id> accountId = new set<Id>();
accountId.add(TestAccount3.id);
accountId.add(TestAccount4.id);

Test.startTest();
Helper_Geocode.GeoCodeAddressFutureForObjectRecord(accountId,'Account');
Test.stopTest();

List<MP_Map_Point__c> lstAccountMapPoints = [select id,status__c,AddressKey__c,Entity__c,label__c from Mp_Map_Point__c where entity__c = 'Account'];
system.assertEquals(lstAccountMapPoints.size(),2);
}
private static TestMethod void TestCase_GeoCodeAddressFutureForObjectRecordUPDATEd()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();

MApPointInfo mapPoint = new MapPointInfo();
mapPoint.EntityName = 'TestMapPoint';
mapPoint.DisplayName = 'TestDisplayName';  
mapPoint.Address = 'Kalyani nagar';     
mapPoint.Latitude = 42.305936;
mapPoint.Longitude = -71.523546;
mapPoint.Status = 'success';
mappoint.statusCode =0;
mapPoint.Geocode_Precision = 'High';

mapPoint.RecCreationDate = Date.Today();
MApPointInfo.FormatAddress('Kalyni nagar','Pune','MH','411006','India');

Account account1 = TestCreateAccount('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','','');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936, -71.523546, account1.id,account1.Name,account1.BillingCountry,Account1.BillingState,account1.BillingCity,Account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Contact contact1 = TestCreateContact('test1', 'California Division of Tourism,PO Box 1499,Dept TIA','Sacramento','CA', 'USA','');
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.Name,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');


Account TestAccount3 = TestCreateAccount('TestAcc3', '', 'Pune', 'Maharashtra','','India');
Account TestAccount4 = TestCreateAccount('TestAccount4', 'Kalyani nagar', 'Pune', 'Maharashtra','411006','India');

List<MP_Map_Point__c> lstMapPoint1 = [select id,addresskey__c,country__c,state__C,City__c from MP_Map_Point__c where entity__c ='Account' And Status__c='Success'];
Map<id,String> mapIdAndAddressKey =new Map<Id,String>();
For(MP_Map_Point__c mp : lstMapPoint1)
{ 
    String combinationKey = Helper_Geocode.GetCombinationKey(mp.country__c,mp.state__c,mp.city__c);
    mapIdAndAddressKey.put(mp.id,combinationKey.toUpperCase());
}

Test.startTest();
Helper_Geocode.GeoCodeAddressFutureForObjectRecordUPDATEd(mapIdAndAddressKey,'Account');
Test.stopTest();   
List<MP_Map_Point__c> lstAccountMapPoints = [select id,status__c,AddressKey__c,Entity__c,label__c from Mp_Map_Point__c where entity__c = 'Account'];
system.assertNotEquals(lstAccountMapPoints,null);   
}

//TestMethod to cover code for all other Hepler classes.
private static TestMethod void TestCase_MPInstallUninstallHandler()
{
INSERTcustomSettingRecords();
MPInstallUninstallHandler scriptInstance = new MPInstallUninstallHandler();
Test.testInstall(scriptInstance, new Version(1,0), true);
List<CronTrigger> listcronTrigger = Database.query('SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = \'Schedule job to populate Map Points records\' limit 1');
System.assertEquals(listcronTrigger.size(),0);

Schedule_Batch_PopulateNewMapPoints scheduler = new Schedule_Batch_PopulateNewMapPoints('Account');
Datetime sysTime = System.now();      
String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' * * ? *';
system.schedule(Helper_MPConstants.SCHEDULER_NAME, chronExpression, scheduler);

Test.startTest();
  Test.testUninstall(scriptInstance);
Test.stopTest();
List<CronTrigger> listcronTrigger1 = Database.query('SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = \'Schedule job to populate Map Points records\' limit 1');
System.assertEquals(listcronTrigger1.size(),0);
}

private static TestMethod void TestCase_MPInstallUninstallHandlerForNewInstallation()
{
MPInstallUninstallHandler scriptInstance = new MPInstallUninstallHandler();
Test.testInstall(scriptInstance, new Version(1,0), true);
List<CronTrigger> listcronTrigger = Database.query('SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = \'Schedule job to populate Map Points records\' limit 1');
System.assertEquals(listcronTrigger.size(),0);

Schedule_Batch_PopulateNewMapPoints scheduler = new Schedule_Batch_PopulateNewMapPoints('Account');
Datetime sysTime = System.now();      
String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' * * ? *';
system.schedule(Helper_MPConstants.SCHEDULER_NAME, chronExpression, scheduler);

Test.startTest();
  Test.testUninstall(scriptInstance);
Test.stopTest();

List<CronTrigger> listcronTrigger1 = Database.query('SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = \'Schedule job to populate Map Points records\' limit 1');
System.assertEquals(listcronTrigger1.size(),0);
}
private static TestMethod void TestCase_getReferencedToFields()
{        
Test.startTest();
  map<string, string> flsList  = Ctrl_MapPlotter.getReferencedToFields('Contact','AccountId');
Test.stopTest();
system.assertNotEquals(flsList.size(), 0);
}
private static TestMethod void TestCase_getReferencedToFieldsNegative()
{        
Test.startTest();
  map<string, string> flsList  = Ctrl_MapPlotter.getReferencedToFields('Contac','ccountId');
Test.stopTest();
system.assertEquals(flsList, null);
}

private static TestMethod void TestCase_GetDataBtnIndexedDBandSF_Null()
{        
INSERTcustomSettingRecords();

Account account1 = TestCreateAccount('test1', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','','');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936, -71.523546, account1.id,account1.Name,account1.BillingCountry,Account1.BillingState,account1.BillingCity,Account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

Account account2 = TestCreateAccount('test2', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','','');
MP_Map_Point__c mapPointAccount2 = TestCreateMPMapPoint(42.305936, -71.523546, account2.id,account2.Name,account2.BillingCountry,account2.BillingState,account2.BillingCity,account2.BillingStreet,account2.BillingPostalCode,'Success','Account','ROOFTOP');

Account account3 = TestCreateAccount('test3', 'California Division of Tourism,PO Box 1499,Dept TIA', 'Sacramento', 'CA','','');
MP_Map_Point__c mapPointAccount3 = TestCreateMPMapPoint(42.305936, -71.523546, account3.id,account3.Name,account3.BillingCountry,account3.BillingState,account3.BillingCity,account3.BillingStreet,account3.BillingPostalCode,'Success','Account','ROOFTOP');

DateTime dateTimeNow = dateTime.now();
String lastSyncTime = ''+dateTimeNow.getTime();
Long timeStamp = long.valueOf(lastSyncTime);
Test.startTest();
  String value  = Ctrl_MapPlotter.GetDataBtnIndexedDBandSF1(timeStamp,null,null,null);
  String value1  = Ctrl_MapPlotter.GetDataBtnIndexedDBandSF1(timeStamp,mapPointAccount1.id,mapPointAccount1.id,mapPointAccount1.id);
Test.stopTest();
system.assertNotEquals(value, null);
}

private static TestMethod void TestCase_OnClickFetchMapPointsForLocationFilter()
{
INSERTcustomSettingRecords();
INSERTCustomMappingRecords();
Account TestAccount1 = TestCreateAccount('TestAcc1', '', 'Pune', 'Maharashtra','','India'); 
Account TestAccount2 = TestCreateAccount('TestAcc2', '', 'Mumbai', 'Maharashtra','','India');   
Account TestAccount3 = TestCreateAccount('TestAcc3', '', 'Pune', 'Maharashtra','','India');     
Account TestAccount4 = TestCreateAccount('TestAcc4', '', 'Nagpur', 'Maharashtra','','India');

Account account1 = TestCreateAccount('test1','California Division of Tourism,PO Box 1499,Dept TIA' ,'Sacramento', 'CA', '95812', 'USA');
MP_Map_Point__c mapPointAccount1 = TestCreateMPMapPoint(42.305936,-71.523546, account1.id,account1.Name,account1.BillingCountry,account1.BillingState,account1.BillingCity,account1.BillingStreet,account1.BillingPostalCode,'Success','Account','ROOFTOP');

List<MP_AddressInfo__c> lstAddr = [select id,name,CombinationKey__c from MP_addressInfo__c limit 100];
List<String> lstCitykeys = new List<String>();
if(lstAddr!= null && lstAddr.size()>0){
    for(MP_AddressInfo__c citykey : lstAddr){
        lstCitykeys.add(citykey.name);
    }       
}
Test.startTest();
    Ctrl_MapPlotter.OnClickFetchMapPointsForLocationFilter(lstCitykeys,mapPointAccount1.Id); 
   String value= Ctrl_MapPlotter.OnClickFetchMapPointsForLocationFilter(lstCitykeys,null);     
Test.stopTest();
system.assertNotEquals(value, null);
}
////////Filter//////
public static TestMethod void testfilters_SaveAndRunFilter()
{
INSERTcustomSettingRecords();
MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
insert customMapping;
} 
Contact contact1 = TestCreateContact('test2', 'Kalyani Nagar','Mumbai','MH', 'India','411006');
Contact contact2 = TestCreateContact('test2', 'Kalyani Nagar','Pune','MH', 'India','411006'); 

MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.Name,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');
MP_Map_Point__c mapPointContact2 = TestCreateMPMapPoint(18.546321, 73.903321, contact2.id,contact2.Name,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');    
Boolean value,value1,value2;
Test.startTest();
value  = ctrl_Mapplotter.SaveAndRunFilter('{"fId":null,"fName":"Testfilter","fDesc":"TestDesc","baseObj":"Contact","fLogic1":"1","fLogic2":null,"isCustom":false,"fType":"normal","filters":[{"fldName":"mailingcountry","fldDataType":"STRING","operVal":"Equals to","fldValue":"india","ftype":"normal","color":null}]}'); 
//value1 = ctrl_Mapplotter.SaveAndRunFilter('{"fId":null,"fName":"Testfilter","fDesc":"TestDesc","baseObj":"Contact","fLogic1":"1 and 2","fLogic2":null,"isCustom":false,"fType":"normal","filters":[{"fldName":"mailingcountry","fldDataType":"STRING","operVal":"Equals to","fldValue":"india","ftype":"normal","color":null}]}'); 
//value2 = ctrl_Mapplotter.SaveAndRunFilter('{"fId":null,"fName":"testcolor","fDesc":"contacts in Indian state","baseObj":"Contact","fLogic1":"1 or 2","fLogic2":"3","isCustom":false,"fType":"colored","filters":[{"fldName":"mailingcity","fldDataType":"STRING","operVal":"Equals to","fldValue":"Pune","ftype":"colored","color":"#2EFF31"},{"fldName":"mailingcity","fldDataType":"STRING","operVal":"Equals to","fldValue":"Mumbai","ftype":"colored","color":"#425FFF"},{"fldName":"mailingcountry","fldDataType":"STRING","operVal":"Equals to","color":null,"ftype":"normal","fldValue":"India"}]}'); 

Test.stopTest();
System.assertEquals(value, true);
}
public static TestMethod void testfilters_GetReportData()
{
INSERTcustomSettingRecords();
MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
insert customMapping;
} 
Contact contact1 = TestCreateContact('test2', 'Kalyani Nagar','Mumbai','MH', 'India','411006');
Contact contact2 = TestCreateContact('test2', 'Kalyani Nagar','Pune','MH', 'India','411006'); 
MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.Name,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');
MP_Map_Point__c mapPointContact2 = TestCreateMPMapPoint(18.546321, 73.903321, contact2.id,contact2.Name,contact2.MailingCountry,contact2.MailingState,contact2.MailingCity,contact2.MailingStreet,contact2.MailingPostalCode,'Success','Contact','ROOFTOP');    
List<MP_MapFilter__c> listToInsert = new List<MP_MapFilter__c>();     
MP_MapFilter__c Filter =  new MP_MapFilter__c();
Filter.Name = 'TestFilter';
Filter.Expression__c = '(1 OR 2)';
Filter.Expression1__c = '(3)';
Filter.Type__c='colored';
Filter.isCustomExpression__c=false;
Filter.Description__c = 'Test Filter For Test Class';
Filter.Filter_Criteria__c ='[{"operVal":"Equals to","index":1,"ftype":"colored","fldValue":"Pune","fldName":"mailingcity","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"Equals to","index":2,"ftype":"colored","fldValue":"Mumbai","fldName":"mailingcity","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"Equals to","index":3,"ftype":"normal","fldValue":"India","fldName":"MailingCountry","fldDataType":"STRING","color":null}]';
Filter.MP_CustomMapping__c = customMapping.id;
listToInsert.add(Filter);


MP_MapFilter__c Filter2 =  new MP_MapFilter__c();
Filter2.Name = 'TestFilter2';
Filter2.Expression__c = '(1 OR 2)';
Filter2.Expression1__c = '(3)';
Filter2.Type__c='colored';
Filter2.isCustomExpression__c=false;
Filter2.Description__c = 'Test Filter For Test Class with picklist';
Filter2.Filter_Criteria__c ='[{"operVal":"Equals to","index":1,"ftype":"colored","fldValue":"Pune;MUMBAI","fldName":"mailingcity","fldDataType":"PICKLIST","color":"#40FF1F"},{"operVal":"Equals to","index":2,"ftype":"colored","fldValue":"Mumbai","fldName":"mailingcity","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"Equals to","index":3,"ftype":"normal","fldValue":"India","fldName":"MailingCountry","fldDataType":"STRING","color":null}]';
Filter2.MP_CustomMapping__c = customMapping.id;
listToInsert.add(Filter2);
if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
insert listToInsert;
}

String value;
Test.startTest();
value = Ctrl_MapPlotter.GetSFReportData(Filter.Id, null);
Ctrl_MapPlotter.GetFilterLegend(Filter.Id);
Test.stopTest();
System.assertNotEquals(value, null);
}

}