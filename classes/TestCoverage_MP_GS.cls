/*************************************************
Class   : TestCoverage_MP_GS.cls
Author  : Priyanka Modani
Date    : 07/10/2018
History : v1.0 
Details : Test class for the Controllers.
***********************************************/
@isTest(SeeAllData = false)
public class TestCoverage_MP_GS {  
    
    private static void INSERTcustomSettingRecords()
    {
        try{
            List<MapPlotterPremiumSettings__c> listSettingRecords = new List<MapPlotterPremiumSettings__c>();
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleAPIKey', Value__c = 'TestKey'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKey', Value__c = 'TestKey'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsGoogleKeyValid', Value__c = 'Yes'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'SetGeocodingRefreshInterval', Value__c = '15'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleMapUrl', Value__c = 'https://test.test.com/test/api/test/json'));
            //Brahmaiah Starts: // These are removed custom settings
            
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsGoogleAPIQueryLimitExceeded', Value__c = 'No'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'APIDailyQuotaValue', Value__c = '97'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'APICappingValue', Value__c = '100'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DecryptionCryptoKey', Value__c = 'testkey'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleCryptoKey', Value__c = 'testkey'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DefaultAPIcappingLIMIT', Value__c = '100'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'isEmailNotificationSend', Value__c = 'false'));
            listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DisableEmailNotification', Value__c = 'false'));
            
            //Brahmaiah  //Ends
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
        catch(Exception e){
            System.debug('GS_MP exception occured==>'+e.getMessage());
        }
    }
    
    //INSERT Custom Mapping Records
    private static void INSERTCustomMappingRecords()
    {
        try{
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
        catch(Exception e){
            System.debug('GS_MP exception occured==>'+e.getMessage());
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
                return null;
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
    
    public static TestMethod void testExportFilteredData(){
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
        
        Contact testContact = new Contact(LastName = 'Test Contact', MailingStreet = 'Kalyani Nagar', MailingCity = 'Pune', MailingState = 'MH', MailingCountry = 'India', MailingPostalCode = '411006',LeadSource ='Web');
                                
        insert testContact;
        Test.startTest();
        Map<Id,Map<String,Object>> value = Ctrl_MapPlotter.ExportFilteredData(Filter.id,'Contact',null,null);
        Test.stopTest();
        system.assertNotEquals(value.size(),0);
    }
    public static TestMethod void testExportFilteredData1(){
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
        Contact testContact = new Contact(LastName = 'Test Contact', MailingStreet = 'Kalyani Nagar', MailingCity = 'Pune', MailingState = 'MH', MailingCountry = 'India', MailingPostalCode = '411006',LeadSource ='Web');
                                
        insert testContact;
        
        MP_Map_Point__c mpPoints = new MP_Map_Point__c();
        mpPoints.Name = 'a051R00000tmPC7';
        mpPoints.status__c = 'Success';
        mpPoints.RecordID__c= testContact.Id;
        insert mpPoints;
        MP_Map_Point__c mpPoints1 = new MP_Map_Point__c();
        mpPoints1.Name = 'a051R00000tmaa1';
        insert mpPoints1;
        String ids = '['+mpPoints.Id+','+mpPoints1.Id+']';
         
        Test.startTest();
        Map<Id,Map<String,Object>> value = Ctrl_MapPlotter.ExportFilteredData(null,'Contact',null,ids);
        Test.stopTest();
        System.assertNotEquals(value.size(), 0);
    }
    
    public static TestMethod void testGetFieldSetsValueOnRecordDetail(){
        Account acc = new Account();
        acc.name ='test';
        insert acc; 
        
        Test.startTest();
        Map<String, String> value = Ctrl_MapPlotter.GetFieldSetsValueOnRecordDetail(acc.id,'Account'); 
        Test.stopTest();
        System.assertNotEquals(value.size(), 0);
    }  
    public static TestMethod void testMassUpdate(){       
        list<Contact> lstContact = new list<Contact>();
        list<MP_Map_Point__c> lstMapPoint = new list<MP_Map_Point__c>();
        Contact contact1;
        
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping;
        }
        if(Schema.sObjectType.Contact.isCreateable())
        {
            contact1 = TestCreateContact('test1', 'Kalyani Nagar','Pune','MH', 'India','411006');    
            contact1.LeadSource = 'Web';
            Update contact1;
            
            for(integer i=0;i<20;i++)
            {
            Contact testContact = new Contact(LastName = 'Test Contact'+i, MailingStreet = 'Kalyani Nagar', MailingCity = 'Pune', MailingState = 'MH', MailingCountry = 'India', 
                                                  MailingPostalCode = '411006',LeadSource ='Web');
            lstContact.add(testContact);
            }
            INSERT lstContact;
        }
        
        if(Schema.sObjectType.MP_Map_Point__c.isCreateable())
        {
        MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.Name,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');
                
        string country='India';
        string state = 'MH';
        string city = 'Pune';
        Decimal latitude =42.305936;
        Decimal longitude = -71.523546;
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
        
        for(integer i=0;i<lstContact.size();i++)
        {
            MP_Map_Point__c testMapPoint = new MP_Map_Point__c(Latitude__c = latitude, Longitude__c = longitude, RecordId__C = lstContact[i].Id, Label__c = 'Test Contact'+i,Country__c = country,State__c = state,City__c = city,Street__c = 'Kalyani Nagar',Postal_Code__c = '411006', Status__c = 'Success',Entity__c = 'Contact',GeoCode_Precision__c = 'ROOFTOP',AddressKey__c = strAddrKey);    
            lstMapPoint.add(testMapPoint);
        }
        INSERT lstMapPoint;
        }
        
        List<MP_MapFilter__c> listToInsert = new List<MP_MapFilter__c>();     
        MP_MapFilter__c Filter =  new MP_MapFilter__c();
        Filter.Name = 'TestFilter';
        Filter.Expression__c = '(1 OR 2)';
        Filter.Expression1__c = '(3)';
        Filter.Type__c='Normal';
        Filter.isCustomExpression__c=false;
        Filter.Description__c = 'Test Filter For Test Class';
        Filter.Filter_Criteria__c ='[{"operVal":"Equals to","index":1,"ftype":"Normal","fldValue":"Pune","fldName":"mailingcity","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"Equals to","index":2,"ftype":"colored","fldValue":"Mumbai","fldName":"mailingcity","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"Equals to","index":3,"ftype":"normal","fldValue":"India","fldName":"MailingCountry","fldDataType":"STRING","color":null}]';
        Filter.MP_CustomMapping__c = customMapping.id;
        listToInsert.add(Filter);
        
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
            insert listToInsert;
        }
        
        String value;  
        Test.startTest();
        Ctrl_MapPlotter.fieldsForMassUpdate('Contact');
        value = Ctrl_MapPlotter.MassUpdatesObject(Filter.id,'Contact','LeadSource','Phone Inquiry','String',null); 
        Test.stopTest();        
        System.assertEquals(value, null);
    }
    public static TestMethod void testMassUpdate1(){       
        list<Contact> lstContact = new list<Contact>();
        list<MP_Map_Point__c> lstMapPoint = new list<MP_Map_Point__c>();
        Contact contact1;
        
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping;
        }
        if(Schema.sObjectType.Contact.isCreateable())
        {
            contact1 = TestCreateContact('test1', 'Kalyani Nagar','Pune','MH', 'India','411006');    
            contact1.LeadSource = 'Web';
            Update contact1;
            
            for(integer i=0;i<20;i++)
            {
            Contact testContact = new Contact(LastName = 'Test Contact'+i, MailingStreet = 'Kalyani Nagar', MailingCity = 'Pune', MailingState = 'MH', MailingCountry = 'India', 
                                                  MailingPostalCode = '411006',LeadSource ='Web');
            lstContact.add(testContact);
            }
            INSERT lstContact;
        }
        
        if(Schema.sObjectType.MP_Map_Point__c.isCreateable())
        {
        MP_Map_Point__c mapPointContact1 = TestCreateMPMapPoint(42.305936,-71.523546, contact1.id,contact1.Name,contact1.MailingCountry,contact1.MailingState,contact1.MailingCity,contact1.MailingStreet,contact1.MailingPostalCode,'Success','Contact','ROOFTOP');
                
        string country='India';
        string state = 'MH';
        string city = 'Pune';
        Decimal latitude =42.305936;
        Decimal longitude = -71.523546;
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
        
        for(integer i=0;i<lstContact.size();i++)
        {
            MP_Map_Point__c testMapPoint = new MP_Map_Point__c(Latitude__c = latitude, Longitude__c = longitude, RecordId__C = lstContact[i].Id, Label__c = 'Test Contact'+i,Country__c = country,State__c = state,City__c = city,Street__c = 'Kalyani Nagar',Postal_Code__c = '411006', Status__c = 'Success',Entity__c = 'Contact',GeoCode_Precision__c = 'ROOFTOP',AddressKey__c = strAddrKey);    
            lstMapPoint.add(testMapPoint);
        }
        INSERT lstMapPoint;
        }
        
        List<MP_MapFilter__c> listToInsert = new List<MP_MapFilter__c>();     
        MP_MapFilter__c Filter =  new MP_MapFilter__c();
        Filter.Name = 'TestFilter';
        Filter.Expression__c = '(1 OR 2)';
        Filter.Expression1__c = '(3)';
        Filter.Type__c='Normal';
        Filter.isCustomExpression__c=false;
        Filter.Description__c = 'Test Filter For Test Class';
        Filter.Filter_Criteria__c ='[{"operVal":"Equals to","index":1,"ftype":"Normal","fldValue":"Pune","fldName":"mailingcity","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"Equals to","index":2,"ftype":"colored","fldValue":"Mumbai","fldName":"mailingcity","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"Equals to","index":3,"ftype":"normal","fldValue":"India","fldName":"MailingCountry","fldDataType":"STRING","color":null}]';
        Filter.MP_CustomMapping__c = customMapping.id;
        listToInsert.add(Filter);
        
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
            insert listToInsert;
        }
        Contact testContact = new Contact(LastName = 'Test Contact', MailingStreet = 'Kalyani Nagar', MailingCity = 'Pune', MailingState = 'MH', MailingCountry = 'India', MailingPostalCode = '411006',LeadSource ='Web');
                                
        insert testContact;
        Contact testContact1 = new Contact(LastName = 'Test Contact1', MailingStreet = 'Kalyani Nagar', MailingCity = 'Pune', MailingState = 'MH', MailingCountry = 'India', MailingPostalCode = '411006',LeadSource ='Web');
                                
        insert testContact1;
        MP_Map_Point__c mpPoints = new MP_Map_Point__c();
        mpPoints.RecordID__c= testContact.Id;
        insert mpPoints;
        mpPoints.Name = mpPoints.Id; 
        update mpPoints;
        MP_Map_Point__c mpPoints1 = new MP_Map_Point__c();
        mpPoints.RecordID__c= testContact1.Id;
        insert mpPoints1;
        mpPoints1.Name = mpPoints1.Id;
        update mpPoints1;
        String ids = '['+mpPoints.Id+','+mpPoints1.Id+']';
        
        Test.startTest();
        Ctrl_MapPlotter.fieldsForMassUpdate('Contact');
        String value = Ctrl_MapPlotter.MassUpdatesObject(null,'Contact','LeadSource','Phone Inquiry','String',ids);
        System.assertNotEquals(value, null);
        Test.stopTest();        
    }
    public static Testmethod void testChkUsrAllowedFrExportMU(){
        Export_MUEnabler__c profileNameSetting = new Export_MUEnabler__c();
        profileNameSetting.ProfileList__c = 'System Administrator';
        profileNameSetting.Name = 'test';
        insert profileNameSetting;
        
        Test.startTest();
        String value = Ctrl_MapPlotter.ChkUsrAllowedFrExportMU();
        System.assertNotEquals(value, null);
        Test.stopTest();
    }
    public static Testmethod void testChkUsrAllowedFrExportMUElse(){
        Export_MUEnabler__c profileNameSetting = new Export_MUEnabler__c();
        profileNameSetting.ProfileList__c = 'Standard User';
        profileNameSetting.Name = 'test';
        insert profileNameSetting;
        
        Test.startTest();
        String value = Ctrl_MapPlotter.ChkUsrAllowedFrExportMU();
        System.assertNotEquals(value, null);
        Test.stopTest();
    }
}