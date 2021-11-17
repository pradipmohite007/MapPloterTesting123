/********** 
Class   : Batch_PopulateOldMapPoints
Author  : Shilpa Kamble 
Date    : 09/12/2015
History : v1.6 
Details : Populates the the points into the Map Point object
***********/

global with sharing class Batch_PopulateOldMapPoint implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful
{
    // Public Variables
    Public String ObjectType;
    
    
    global Batch_PopulateOldMapPoint() 
    {   }
    // Constructor
    global Batch_PopulateOldMapPoint(String objName) 
    {
        try{
            
            ObjectType = String.escapeSingleQuotes(objName);
            
        }
        Catch(Exception e){
            System.debug('MPV2 exception occurred==>'+e.getMessage());
        }
    }
    
    // Start Method
 global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        try{
            String Query;        
            Ctrl_MapPlotter ctrlObject = new Ctrl_MapPlotter();
            List<MP_CustomMapping__c> lstobjMapping = Helper_Soql.GetMappedObject(ObjectType);
             //False Positive
             //Access is not checked because we have to process all records of object for latitude and longitude calculations
            if(lstobjMapping.size() > 0)
            {
                //Gkadam //Added for the converted Lead to exclude from geocoding
                if(lstobjMapping[0].entity__c.equalsIgnoreCase('Lead'))
                    Query = 'Select id,'+ lstobjMapping[0].label__C +','+lstobjMapping[0].country__c+','+lstobjMapping[0].state__c+','+lstobjMapping[0].city__c+','+lstobjMapping[0].street__c+','+lstobjMapping[0].postal_code__c+' From '+lstobjMapping[0].entity__c +' where isconverted = false';                     
                //GKadam Ends
                else
                    Query = 'Select id,'+ lstobjMapping[0].label__C +','+lstobjMapping[0].country__c+','+lstobjMapping[0].state__c+','+lstobjMapping[0].city__c+','+lstobjMapping[0].street__c+','+lstobjMapping[0].postal_code__c+' From '+lstobjMapping[0].entity__c;       
            }
            return Database.getQueryLocator(Query); 
        }
        Catch(Exception e){
            System.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
        }
        
    }    
   // Execute Method
    global void execute(Database.BatchableContext BC, List<SObject> LstRecords) 
    { 
        try{
            List<MP_Map_Point__c> LstMapPoints = new List<MP_Map_Point__c>();
            if(LstRecords != null ){
                String objectName = (String)LstRecords[0].getSObjectType().getDescribe().getName();
                List<MP_CustomMapping__c> lstObject = Helper_SOQL.GetMappedObject(objectName);
                // copying Column names in string
                Id customMappingId = lstObject[0].Id;
                String strName = String.valueOf(lstObject[0].Label__c);
                String strCountry = String.valueOf(lstObject[0].Country__c);
                String strState = String.valueOf(lstObject[0].State__c);
                String strCity = String.valueOf(lstObject[0].City__c);
                String strStreet = String.valueOf(lstObject[0].Street__c);
                String strPostalCode = String.valueOf(lstObject[0].Postal_Code__c);
                
                // Check if the user has create record access on the MP_Map_Point__c object  
                if(Schema.sObjectType.MP_Map_Point__c.isCreateable())
                {
                    for(SObject record : LstRecords)
                    { 
                        Id recordId = (String)record.get('id');
                        
                        //getting the values of columns
                        List<String> lstAddressInfo =Helper_GeoCode.GetAddressvalues(record, strName,strCountry, strState, strCity, strStreet, strPostalCode);            
                        //record, Name/label, Country, State, City, Street, PostalCode
                        String recordName;
                        String countryName;
                        String stateName;
                        String cityName;
                        String streetName;
                        String postalCodeNo;
                        if(lstAddressInfo != null && lstAddressInfo.size() > 0) {
                            recordName = lstAddressInfo[0];
                            countryName = lstAddressInfo[1];
                            stateName = lstAddressInfo[2];
                            cityName = lstAddressInfo[3];
                            streetName = lstAddressInfo[4];
                            postalCodeNo = lstAddressInfo[5];
                        }
                        
                      MP_Map_Point__c mapPoint = new MP_Map_Point__c(Entity__c = objectName, RecordId__c = recordId, Label__c = recordName,Country__c = countryName,State__c = stateName,City__c = cityName,isInsert__c = null,
                      Street__c = streetName,Postal_Code__c = postalCodeNo,Status__c = Helper_MPConstants.GEOCODE_PENDING); //AddressKey__c = strAddressKey
                        LstMapPoints.add(mapPoint);
                    }  
                    
                    if(LstMapPoints.size() > 0)
                    {
                        if(Util.getCreateAccessCheck('MP_Map_Point__c', new List<string>{'Latitude__c','Longitude__c','Label__c','Country__c' ,'State__c','City__c','Street__c','Postal_Code__c','Entity__c','RecordID__c','Status__c','isInsert__c','GeoCode_Precision__c'}))
                        {
                            Database.insert(LstMapPoints, false);
                        }
                    }
                }
            } 
        }
        Catch(Exception e){
            System.debug('MPV2 exception occurred==>'+e.getMessage());
        }
    }
    // Finish Method
    global void finish(Database.BatchableContext BC) 
    {
        try{
            Batch_PopulateNewMapPoints batchObjectForAccount = new Batch_PopulateNewMapPoints();
            Database.executeBatch(batchObjectForAccount,Helper_MPConstants.INTEGER_CONSTANT_TEN);
        
                  }
        Catch(Exception e){
            System.debug('MPV2 exception occurred==>'+e.getMessage());
        }
        
    }
    
}