@isTest(SeeAllData = false)
public with sharing class TestClassFilterReport
{ 
    
    public static void INSERTcustomSettingRecords()
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
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DecryptionCryptoKey', Value__c = 'TestKey'));
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'GoogleCryptoKey', Value__c = 'TestKey'));
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DefaultAPIcappingLIMIT', Value__c = '100')); 
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'isEmailNotificationSend ', Value__c = 'False'));
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKeysBank01', Value__c = 'TestKey1,TestKey2'));
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKeysBank02', Value__c = 'TestKey1,TestKey2'));
        listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = 'IsRated', Value__c='False'));  
        INSERT listSettingRecords;
    }  
    
    public static TestMethod void testfilters_GetObjectMetaData()
    {
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping2 = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping2;
        }
        Test.startTest();
        String testObjectMetaData = Ctrl_MapPlotter.GetObjectMetaData(customMapping2.Entity__c);
        String testOperators  = Ctrl_MapPlotter.GetOperators();  
        Test.stopTest();  
        System.assertNotEquals(testObjectMetaData,null);   
        System.assertNotEquals(testOperators,null);
    }
    public static TestMethod void testfilters_EditFilter()
    {
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping;
        }
        
        MP_MapFilter__c Filter =  new MP_MapFilter__c();
        Filter.Name = 'TestFilter';
        Filter.Expression__c = '(1 OR 2)';
        Filter.Expression1__c = '(3)';
        Filter.Type__c='colored';
        Filter.isCustomExpression__c=false;
        Filter.Description__c = 'Test Filter For Test Class';
        Filter.Filter_Criteria__c ='[{"operVal":"=","index":1,"ftype":"colored","fldValue":"india","fldName":"mailingcountry","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"=","index":2,"ftype":"colored","fldValue":"usa","fldName":"mailingcountry","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"=","index":3,"ftype":"normal","fldValue":"true","fldName":"formula__c","fldDataType":"BOOLEAN","color":null}]';
        Filter.MP_CustomMapping__c = customMapping.id;
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
            insert Filter;
        }
        String FilterVal;
        Test.StartTest();
        FilterVal = ctrl_Mapplotter.editFilter(Filter.id);
        Test.StopTest();
        System.assertNotEquals(FilterVal ,null);   
    }
    public static TestMethod void testfilters_GetFilterLegend()
    {
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping;
        }
        
        MP_MapFilter__c Filter =  new MP_MapFilter__c();
        Filter.Name = 'TestFilter';
        Filter.Expression__c = '(1 OR 2)';
        Filter.Expression1__c = '(3)';
        Filter.Type__c='colored';
        Filter.isCustomExpression__c=false;
        Filter.Description__c = 'Test Filter For Test Class';
        Filter.Filter_Criteria__c ='[{"operVal":"=","index":1,"ftype":"colored","fldValue":"india","fldName":"mailingcountry","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"=","index":2,"ftype":"colored","fldValue":"usa","fldName":"mailingcountry","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"=","index":3,"ftype":"normal","fldValue":"true","fldName":"formula__c","fldDataType":"BOOLEAN","color":null}]';
        Filter.MP_CustomMapping__c = customMapping.id;
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
            insert Filter;
        }
        String FilterVal;
        Test.StartTest();
        FilterVal = ctrl_Mapplotter.GetFilterLegend(Filter.id);
        Test.StopTest();
        System.assertNotEquals(Filter.id,null);
    }
    public static TestMethod void testfilters_GetSFReportList()
    {
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping;
        }
        
        MP_MapFilter__c Filter =  new MP_MapFilter__c();
        Filter.Name = 'TestFilter';
        Filter.Expression__c = '(1 OR 2)';
        Filter.Expression1__c = '(3)';
        Filter.Type__c='colored';
        Filter.isCustomExpression__c=false;
        Filter.Description__c = 'Test Filter For Test Class';
        Filter.Filter_Criteria__c ='[{"operVal":"=","index":1,"ftype":"colored","fldValue":"india","fldName":"mailingcountry","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"=","index":2,"ftype":"colored","fldValue":"usa","fldName":"mailingcountry","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"=","index":3,"ftype":"normal","fldValue":"true","fldName":"formula__c","fldDataType":"BOOLEAN","color":null}]';
        Filter.MP_CustomMapping__c = customMapping.id;
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
            insert Filter;
        }
        String lstFilter;
        Test.StartTest();
        lstFilter = ctrl_Mapplotter.GetSFReportList();
        Test.StopTest();
        System.assertNotEquals(lstFilter,null);
    }
    public static TestMethod void testfilters_deleteFilter()
    {
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable()){
            insert customMapping;
        }
        
        MP_MapFilter__c Filter =  new MP_MapFilter__c();
        Filter.Name = 'TestFilter';
        Filter.Expression__c = '(1 OR 2)';
        Filter.Expression1__c = '(3)';
        Filter.Type__c='colored';
        Filter.isCustomExpression__c=false;
        Filter.Description__c = 'Test Filter For Test Class';
        Filter.Filter_Criteria__c ='[{"operVal":"=","index":1,"ftype":"colored","fldValue":"india","fldName":"mailingcountry","fldDataType":"STRING","color":"#40FF1F"},{"operVal":"=","index":2,"ftype":"colored","fldValue":"usa","fldName":"mailingcountry","fldDataType":"STRING","color":"#FF38FC"},{"operVal":"=","index":3,"ftype":"normal","fldValue":"true","fldName":"formula__c","fldDataType":"BOOLEAN","color":null}]';
        Filter.MP_CustomMapping__c = customMapping.id;
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable()){
            insert Filter;
        }
        Boolean FilterVal;
        Test.StartTest();
        FilterVal = ctrl_Mapplotter.deleteFilter(Filter.id);
        Test.StopTest();
        System.assertEquals(FilterVal ,true);   
    }
    public static TestMethod void testfilters_saveAndRunFilter()
    {
        MP_CustomMapping__c customMapping2 = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable())
        {
            insert customMapping2;
        }    
        
        MP_MapFilter__c mapFilter = new MP_MapFilter__c(
            name ='contact1',
            MP_CustomMapping__c=customMapping2.id,
            isCustomExpression__c=true,
            Description__c='contact1', 
            Filter_Criteria__c='[{"index":1,"filterValue":"Mr.","filterOperator":"=","filterLogic":null,"filterField":"salutation","dataType":"PICKLIST"},{"index":2,"filterValue":"Test","filterOperator":"=","filterLogic":null,"filterField":"firstname","dataType":"STRING"}]');
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable())
        {
            insert mapFilter;
        }
        List<MP_MapFilter__c> lstMapFilter = [Select id From MP_MapFilter__c limit 100];
        
        Ctrl_MapPlotter ctrlObj = new Ctrl_MapPlotter();
        ctrlObj.filterMapPoint();
        ctrlObj.selectedObject = 'Contact';
        ctrlObj.describeSelectedobject();
        
        ctrlObj.selectedObject = '--None--';
        ctrlObj.describeSelectedobject();
        ctrlObj.selectedField='ID';
        ctrlObj.selectedField='salutation';
        ctrlObj.selectedIndex ='1';
        ctrlObj.getOperator();  
        
        ctrlObj.addNewRow();
        ctrlObj.removeRow();
        
        ctrlObj.selectedFilter = mapFilter.id;  
        ctrlObj.editFilter();
        Test.startTest();
        ctrlObj.saveAndRunFilter();
        Ctrl_MapPlotter.GetTotalMapPointsforObject('Account');
        Ctrl_MapPlotter.DeleteDataPoint('Account', False);
        Ctrl_MapPlotter.DeleteDataPointNew('Account');
        Ctrl_MapPlotter.GetSFReportList();
        ctrlObj.deleteFilter();
        ctrlObj.getpicklistval();
        ctrlObj.newFilter= mapFilter;
        ctrlObj.saveAndRunFilter();
        Helper_SOQL.GetMapPointsforObject('Account');
        Helper_SOQL.GetTriggerDeleteMapPoints(null);
        Helper_SOQL.GetTriggerDeleteMapPoints(new set<id>());
        Test.stopTest();  
        System.assertEquals(lstMapFilter.size(),1);        
    }
    
    public static TestMethod void testgetSFReportData_NoData(){
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping2 = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable())
        {
            insert customMapping2;  
        }
        
        MP_MapFilter__c mapFilter = new MP_MapFilter__c(
            name ='contact1',
            MP_CustomMapping__c=customMapping2.id,
            expression__c='1 AND 2',
            isCustomExpression__c=true,
            Description__c='contact1', 
            Filter_Criteria__c='[{"index":1,"filterValue":"Mr.","filterOperator":"=","filterLogic":null,"filterField":"salutation","dataType":"PICKLIST"},{"index":2,"filterValue":"Test","filterOperator":"=","filterLogic":null,"filterField":"firstname","dataType":"STRING"}]');
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable())
        {
            insert mapFilter;  
        }
        
        Ctrl_MapPlotter ctrlObj = new Ctrl_MapPlotter();
        
        Test.startTest();
        ctrlObj.selectedFilter = mapFilter.id;
        String result = Ctrl_MapPlotter.getSFReportData(mapFilter.id,null);    
        Test.stopTest();
        Ctrl_MapPlotter.ErrorMessage mappoits = (Ctrl_MapPlotter.ErrorMessage)JSON.deserialize(result, Ctrl_MapPlotter.ErrorMessage.class); 
        Ctrl_MapPlotter.GeocodedReport geocodeStatusResport = (Ctrl_MapPlotter.GeocodedReport )JSON.deserialize(result, Ctrl_MapPlotter.GeocodedReport.class);     
        System.assertEquals((mappoits.lstMPPoint),null);
        System.assertEquals(mappoits.message,'No records matching query condition'); 
    }
    
    public static TestMethod void testgetSFReportData_NOgeocoded(){
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping2 = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable())
        {
            insert customMapping2;  
        }
        
        
        Contact contact1 = new Contact(Salutation='Mr.', LastName = 'test1', MailingStreet = 'test, test1',
                                       MailingCity = 'test');
        if(Schema.sObjectType.Contact.isCreateable())
        {
            insert contact1;      
        }
        
        
        MP_Map_Point__c testMapPoint = new MP_Map_Point__c(Latitude__c = null, Longitude__c = null, RecordId__C = contact1.id, Label__c = 'test1',Country__c = '',State__c = 'CA', City__c= 'Sacramento',Street__c = 'California Division of Tourism,PO Box 1499,Dept TIA',Postal_Code__c = '', Status__c = 'Failed',Entity__c ='Contact');    
        if(Schema.sObjectType.MP_Map_Point__c.isCreateable())
        {
            insert testMapPoint;  
        }
        
        MP_MapFilter__c mapFilter = new MP_MapFilter__c(
            name ='contact1',
            MP_CustomMapping__c=customMapping2.id,
            expression__c='1 AND 2',
            isCustomExpression__c=true,
            Description__c='contact1', 
            Filter_Criteria__c='[{"index":1,"filterValue":"Mr.","filterOperator":"=","filterLogic":null,"filterField":"salutation","dataType":"PICKLIST"},{"index":2,"filterValue":"test1","filterOperator":"=","filterLogic":null,"filterField":"lastname","dataType":"STRING"}]');
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable())
        {
            insert mapFilter;  
        }
        
        Ctrl_MapPlotter ctrlObj = new Ctrl_MapPlotter();
        
        Test.startTest();
        ctrlObj.selectedFilter = mapFilter.id;
        String result = Ctrl_MapPlotter.getSFReportData(mapFilter.id,null);    
        Test.stopTest();
        
        Ctrl_MapPlotter.ErrorMessage mappoits = (Ctrl_MapPlotter.ErrorMessage)JSON.deserialize(result, Ctrl_MapPlotter.ErrorMessage.class); 
        Ctrl_MapPlotter.GeocodedReport geocodeStatusResport = (Ctrl_MapPlotter.GeocodedReport )JSON.deserialize(result, Ctrl_MapPlotter.GeocodedReport.class);     
        System.assertEquals(mappoits.lstMPPoint,null);
        System.assertEquals(mappoits.message,'No records matching query condition'); 
        
    }
    public static TestMethod void testgetSFReportData(){
        INSERTcustomSettingRecords();
        MP_CustomMapping__c customMapping2 = new MP_CustomMapping__c(Entity__c = 'Contact',Label__c = 'LastName',Country__c = 'MailingCountry',State__c = 'MailingState', City__c = 'MailingCity',Street__c = 'MailingStreet',Postal_Code__c = 'MailingPostalCode');
        if(Schema.sObjectType.MP_CustomMapping__c.isCreateable())
        {
            insert customMapping2;  
        } 
        
        
        Contact contact1 = new Contact(Salutation='Mr.', LastName = 'test1', MailingStreet = '9595 Six Pines Dr., Suite 8210The Woodlands',
                                       MailingCity = 'Houston');
        if(Schema.sObjectType.Contact.isCreateable())
        {
            insert contact1; 
        }
        
        
        MP_Map_Point__c testMapPoint = new MP_Map_Point__c(Latitude__c = 42.305936, Longitude__c = -71.523546, RecordId__C = contact1.id, Label__c = 'test1',Country__c = '',State__c = 'CA', City__c= 'Sacramento',Street__c = 'California Division of Tourism,PO Box 1499,Dept TIA',Postal_Code__c = '', Status__c = 'Success',Entity__c ='Contact');    
        if(Schema.sObjectType.MP_Map_Point__c.isCreateable())
        {
            insert testMapPoint;   
        }
        
        
        
        MP_MapFilter__c mapFilter = new MP_MapFilter__c(
            name ='contact1',
            MP_CustomMapping__c=customMapping2.id,
            expression__c='1 AND 2',
            isCustomExpression__c=true,
            Description__c='contact1', 
            Filter_Criteria__c='[{"index":1,"filterValue":"Mr.","filterOperator":"=","filterLogic":null,"filterField":"salutation","dataType":"PICKLIST"},{"index":2,"filterValue":"test1","filterOperator":"=","filterLogic":null,"filterField":"lastname","dataType":"STRING"}]');
        if(Schema.sObjectType.MP_MapFilter__c.isCreateable())
        {
            insert mapFilter;  
        }
        
        Ctrl_MapPlotter ctrlObj = new Ctrl_MapPlotter();
        
        Test.startTest();
        String result = Ctrl_MapPlotter.getSFReportData(mapFilter.id,null);
        Test.stopTest();
        Ctrl_MapPlotter.ErrorMessage mappoits = (Ctrl_MapPlotter.ErrorMessage)JSON.deserialize(result, Ctrl_MapPlotter.ErrorMessage.class); 
        Ctrl_MapPlotter.GeocodedReport geocodeStatusResport = (Ctrl_MapPlotter.GeocodedReport )JSON.deserialize(result, Ctrl_MapPlotter.GeocodedReport.class);     
        System.assertEquals(mappoits.message,'No records matching query condition');      
    }
}