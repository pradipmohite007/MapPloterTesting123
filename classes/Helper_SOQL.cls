/*******************************************
   Class   : Helper_SOQL
   Author  : Shilpa Kamble 
   Date    : 09/12/2015 
   History : v1.6 
   Details : For fetching the records using SOQL and SOSL quarries.
**********************************************************************/
global with sharing class Helper_SOQL 
{
    //Constructure
    Public Helper_SOQL()
    {

    }
    
    public class deleteDataWrapper{
    public Integer totalCount;
    public Integer dataponitSize;
    }
    //Return list of apex jobs
    global static List<AsyncApexJob> GetApexJobs()
    {
      try {
        //False Positive
            //Accessibility is not added because we have to check if job exist in system. we are not showing data to user. this is only for logic purpose
           List<AsyncApexJob> lstapexJob= [select id,apexclass.name,status, completedDate,TotaljobItems,jobItemsProcessed from asyncapexjob where Apexclass.Name = 'Batch_PopulateNewMapPoints' 
                                           AND JobItemsProcessed >0 
                                           AND Status ='Completed' 
                                           order by createdDate desc limit 1 ];
            return lstapexJob;
      }
      catch(Exception e) {
            system.debug('MPV2 exception occurred==>'+e.getMessage());
        return null;
      }
    }

    //Returns data of map points
    global static List<MP_Map_Point__c> GetDeltaOfMapPoints(Long lastSyncTime,Id offsetId,DateTime lastSyncDateTime,String strEvent)
    {
        try {
          List<MP_Map_Point__c> lstMapPoints = new List<MP_Map_Point__c>();
         if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__C', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c'})){
          if(strEvent == Helper_MPConstants.EVENT_INSERT)
          {
              if(offsetId == null)
              {
                  lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                                              FROM MP_Map_Point__c 
                                                              WHERE Status__c = : Helper_MPConstants.GEOCODE_SUCCESS 
                                                              AND isInsert__c = 'TRUE'
                                                              AND LastModifiedDate >: lastSyncDateTime
                                                              ORDER BY ID ASC 
                                                              LIMIT 10000];                                                        
  
              }
              else
              {
                  lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                                              FROM MP_Map_Point__c 
                                                              WHERE Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                                              AND isInsert__c = 'TRUE'
                                                              AND LastModifiedDate >: lastSyncDateTime
                                                              AND Id >= : offsetId 
                                                              ORDER BY ID ASC 
                                                              LIMIT 10000];
              }
              return lstMapPoints;
          }
          else if(strEvent == Helper_MPConstants.EVENT_UPDATE)
          {
               if(offsetId == null)
              {
                  lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                                              FROM MP_Map_Point__c 
                                                              WHERE Status__c =: Helper_MPConstants.GEOCODE_SUCCESS 
                                                              AND LastModifiedDate >: lastSyncDateTime
                                                              AND isInsert__c = 'FALSE'
                                                              ORDER BY ID ASC 
                                                              LIMIT 10000]; 
              }
              else
              {
                  lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                                              FROM MP_Map_Point__c 
                                                              WHERE Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                                              AND LastModifiedDate >: lastSyncDateTime
                                                              AND isInsert__c = 'FALSE'
                                                              AND Id >= :offsetId 
                                                              ORDER BY ID ASC 
                                                              LIMIT 10000];
              }
               return lstMapPoints;
          }
          else if(strEvent == Helper_MPConstants.EVENT_DELETE)
          {
  
              if(offsetId == null)
              {   
                  lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                          FROM MP_Map_Point__c 
                                          WHERE LastModifiedDate >: lastSyncDateTime
                                          AND Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                          AND IsDeleted = true  
                                          ORDER BY ID ASC 
                                          LIMIT 10000
                                          ALL ROWS]; 
              }
              else
              {
                  lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                          FROM MP_Map_Point__c 
                                          WHERE LastModifiedDate >: lastSyncDateTime
                                          AND Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                          AND IsDeleted = true 
                                          ORDER BY ID ASC 
                                          LIMIT 10000
                                          ALL ROWS];
              }
                return lstMapPoints;
          }
        }
          return null;
        }
        catch(Exception e) {
            system.debug('MPV2 exception occurred==>'+e.getMessage());
          return null;
        }
    }
  
    //Returns data of map points
   global static List<MP_Map_Point__c> GetDeltaOfMapPoints(DateTime lastSyncDateTime,Id offsetId,String strEvent)
    {
     try {
       List<MP_Map_Point__c> lstMapPoints = new List<MP_Map_Point__c>();
       if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__C', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c'})){
       if(strEvent == Helper_MPConstants.EVENT_INSERT)
        {
            if(offsetId == null)
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                                            Street__c, Postal_Code__c,CreatedDate
                                                            FROM MP_Map_Point__c 
                                                            WHERE Status__c = : Helper_MPConstants.GEOCODE_SUCCESS 
                                                            AND isInsert__c = 'TRUE'
                                                            AND LastModifiedDate >: lastSyncDateTime
                                                            ORDER BY ID ASC 
                                                            LIMIT :Helper_MPConstants.OFFSET_VALUE];//5000                                                        

            }
            else
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                                            Street__c, Postal_Code__c,CreatedDate
                                                            FROM MP_Map_Point__c 
                                                            WHERE Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                                            AND isInsert__c = 'TRUE'
                                                            AND LastModifiedDate >: lastSyncDateTime
                                                            AND Id >= : offsetId 
                                                            ORDER BY ID ASC 
                                                            LIMIT :Helper_MPConstants.OFFSET_VALUE]; //5000
            }
            return lstMapPoints;
        }
        else if(strEvent == Helper_MPConstants.EVENT_UPDATE) 
        {
             if(offsetId == null)
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                                            Street__c, Postal_Code__c,CreatedDate
                                                            FROM MP_Map_Point__c 
                                                            WHERE (Status__c =: Helper_MPConstants.GEOCODE_SUCCESS)
                                                            AND LastModifiedDate >: lastSyncDateTime
                                                            AND (isInsert__c = 'FALSE')
                                                            ORDER BY ID ASC 
                                                            LIMIT :Helper_MPConstants.OFFSET_VALUE]; //5000 
            }
            else
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                                            Street__c, Postal_Code__c,CreatedDate
                                                            FROM MP_Map_Point__c 
                                                            WHERE (Status__c =: Helper_MPConstants.GEOCODE_SUCCESS)
                                                            AND LastModifiedDate >: lastSyncDateTime
                                                            AND (isInsert__c = 'FALSE')
                                                            AND Id >= :offsetId 
                                                            ORDER BY ID ASC 
                                                            LIMIT :Helper_MPConstants.OFFSET_VALUE]; //5000
            }
             return lstMapPoints;
        }
      ////EVENT_UPDATE_FAILED////Success to failed or success to pending 
        else if(strEvent == Helper_MPConstants.EVENT_UPDATE_FAILED)
        {
             if(offsetId == null)
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                                            Street__c, Postal_Code__c,CreatedDate
                                                            FROM MP_Map_Point__c 
                                                            WHERE (Status__c =: Helper_MPConstants.GEOCODE_FAILED OR Status__c =:Helper_MPConstants.GEOCODE_PENDING)
                                                            AND LastModifiedDate >: lastSyncDateTime
                                                            AND (isInsert__c != null)
                                                            ORDER BY ID ASC 
                                                            LIMIT :Helper_MPConstants.OFFSET_VALUE];  //5000 
            }
            else
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                                            Street__c, Postal_Code__c,CreatedDate
                                                            FROM MP_Map_Point__c 
                                                            WHERE (Status__c =: Helper_MPConstants.GEOCODE_FAILED OR Status__c =:Helper_MPConstants.GEOCODE_PENDING)
                                                            AND LastModifiedDate >: lastSyncDateTime
                                                            AND (isInsert__c != null)
                                                            AND Id >= :offsetId 
                                                            ORDER BY ID ASC 
                                                            LIMIT :Helper_MPConstants.OFFSET_VALUE]; //5000
            }
             return lstMapPoints;
        }
        else if(strEvent == Helper_MPConstants.EVENT_DELETE)
        {

            if(offsetId == null)
            {   
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                        Street__c, Postal_Code__c,CreatedDate
                                        FROM MP_Map_Point__c 
                                        WHERE LastModifiedDate >: lastSyncDateTime
                                        AND Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                        AND IsDeleted = true  
                                        ORDER BY ID ASC 
                                        LIMIT :Helper_MPConstants.OFFSET_VALUE  //5000
                                        ALL ROWS]; 
            }
            else
            {
                lstMapPoints = [SELECT Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c,                        Street__c, Postal_Code__c,CreatedDate
                                        FROM MP_Map_Point__c 
                                        WHERE LastModifiedDate >: lastSyncDateTime
                                        AND Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                        AND IsDeleted = true
                                        AND Id >= :offsetId 
                                        ORDER BY ID ASC 
                                        LIMIT :Helper_MPConstants.OFFSET_VALUE //5000
                                        ALL ROWS];
            }
              return lstMapPoints;
        }
      }
        return null;
     }
        catch(Exception e) {
            system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
        }
    }
     
    global static Integer DeleteDataPoint(String objectName,Boolean isDataPointDeleted)
    {
      try {
          List<MP_CustomMapping__c> lstmappedObj = new List<MP_CustomMapping__c>();
          List<MP_Map_Point__c> lstMapPointsToDelete = new List<MP_Map_Point__c>();
        
          if(!isDataPointDeleted)
          {
              if(Util.getReadAccessCheck('MP_CustomMapping__c', new List<string>{'entity__c'})){
                 lstmappedObj = [select id,entity__c from MP_CustomMapping__c where entity__c =: String.escapeSingleQuotes(objectName) limit 1];
              }           
              /*String strObjectName = objectName;
              ////////////////// Deleting the Trigger ////////////////////
              if(strObjectName.endsWith('__c'))
              {
                 strObjectName = strObjectName.removeEnd('__c');
              }
              strObjectName= strObjectName.replace('__','_');
              String TriggerName = 'TriggerMPGeocode'+strObjectName;             
            //False +ve 
            //Read access is not checked because need to delete trigger irrespective of user access.
            List<ApexTrigger> triggerObj = [SELECT Id,Name FROM ApexTrigger where name = :String.escapeSingleQuotes(TriggerName) LIMIT 1];
            if(triggerObj != null && triggerObj.size() >0 ){
                   HttpRequest req = new HttpRequest();
                   req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
                   req.setHeader('Content-Type', 'application/json');
                   req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v36.0/tooling/sobjects/ApexTrigger/'+triggerObj[0].Id+'');
                   req.setMethod('DELETE');
                   Http h = new Http();
                   HttpResponse res = h.send(req); 
                   } */            
          }        
         if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__C', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'Status__c','City__c'})){
            lstMapPointsToDelete = [SELECT id,AddressKey__c,Country__c,State__c,City__c,Status__c 
                                          FROM MP_Map_Point__c 
                                          WHERE Entity__c =: String.escapeSingleQuotes(objectName) 
                                          LIMIT 2000];
         }
         
          if(lstMapPointsToDelete.size() > 0)
          {
              //set of addressKeys from the point which are going to delete
             
              Set<String> setCombinationKeystoDeleteMPPoints = new Set<String>();
              for(MP_Map_Point__c mpPoint : lstMapPointsToDelete)
              {
                  if(mpPoint.Status__c == Helper_MPConstants.GEOCODE_SUCCESS)
                  {
                      String strCombinationKey = Helper_GeoCode.GetCombinationKey(mpPoint.Country__c,mpPoint.State__c, mpPoint.City__c);
                      setCombinationKeystoDeleteMPPoints.add(strCombinationKey);
                  }
              }           
  
              //set of record Ids of map Point which are going to delete
              Set<Id> setMapPointIdsToDelete = (new Map<Id,MP_Map_Point__c>(lstMapPointsToDelete)).keySet();
            if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Id'})){
                List<MP_Map_Point__c> lstMapPointstoDlt = [SELECT id from MP_Map_Point__c where id IN : setMapPointIdsToDelete];
                
                if(lstMapPointstoDlt.size() > 0){
                    if(MP_Map_Point__c.sObjectType.getDescribe().isDeletable()){
                      DELETE lstMapPointstoDlt;
              }else{
                return -1;
                    }
                }
            }
              if(setCombinationKeystoDeleteMPPoints.size() > 0)
              {                
                if(MP_AddressInfo__c.sObjectType.getDescribe().isDeletable()) {
                    Helper_GeoCode.DeleteAddressInfo(setCombinationKeystoDeleteMPPoints);                
                 }else{
                  return -1;
              }
          }
           }
          if(lstmappedObj.size() > 0)
          {
              if(MP_CustomMapping__c.sObjectType.getDescribe().isDeletable()){
                 DELETE lstmappedObj;
               }else{
                 return -1;
              }
          }       
          return lstMapPointsToDelete.size();
       }
        catch(Exception e) {
            system.debug('MPV2 exception occurred==>'+e.getMessage());
          return 0;
        }   
    }
    
  global static String DeleteDataPoint(String objectName)
{
  Savepoint sp;
  try{
      List<MP_CustomMapping__c> lstmappedObj = new List<MP_CustomMapping__c>();
      List<MP_Map_Point__c> lstMapPointsToDelete = new List<MP_Map_Point__c>();
      //Take a count for the total records for showing on the records 
      Integer TotalRecords = 0;
      deleteDataWrapper deleteData = new deleteDataWrapper();
      if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'id'})){ 
            for (AggregateResult result : [SELECT count(id) FROM MP_Map_Point__c WHERE Entity__c =: String.escapeSingleQuotes(objectName)]
            ) TotalRecords += (Integer)result.get('expr0');
          
     }
     deleteData.totalCount=TotalRecords;
     if(!MP_CustomMapping__c.sObjectType.getDescribe().isDeletable()){
        Database.rollback(sp);
        deleteData.dataponitSize= -1;
        return JSON.serialize(deleteData);//return -1;  
      }
      // Get a record of custom Mapping for obj name       
      if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__C', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'Status__c','City__c'})){
      lstMapPointsToDelete = [SELECT id,AddressKey__c,Country__c,State__c,City__c,Status__c 
                                    FROM MP_Map_Point__c 
                                    WHERE Entity__c =: String.escapeSingleQuotes(objectName)
                                    LIMIT 2000];
     }       
        if(lstMapPointsToDelete.size() > 0)
        {
            //set of addressKeys from the point which are going to delete           
            Set<String> setCombinationKeystoDeleteMPPoints = new Set<String>();
            for(MP_Map_Point__c mpPoint : lstMapPointsToDelete)
            {
                if(mpPoint.Status__c == Helper_MPConstants.GEOCODE_SUCCESS)
                {
                    String strCombinationKey = Helper_GeoCode.GetCombinationKey(mpPoint.Country__c,mpPoint.State__c, mpPoint.City__c);
                    setCombinationKeystoDeleteMPPoints.add(strCombinationKey);
                }
            }           
            //set of record Ids of map Point which are going to delete
            Set<Id> setMapPointIdsToDelete = (new Map<Id,MP_Map_Point__c>(lstMapPointsToDelete)).keySet();
            if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Id'})){
            List<MP_Map_Point__c> lstMapPointstoDlt = [SELECT id from MP_Map_Point__c where id IN : setMapPointIdsToDelete];            
            if(lstMapPointstoDlt.size() > 0){
            
             if(MP_Map_Point__c.sObjectType.getDescribe().isDeletable()){
                DELETE lstMapPointstoDlt;
                
              }else{
                Database.rollback(sp);
                deleteData.dataponitSize= -1;
                return JSON.serialize(deleteData);//return -1;
              }   
             }
           }         
            if(setCombinationKeystoDeleteMPPoints.size() > 0)
            {
                if(MP_AddressInfo__c.sObjectType.getDescribe().isDeletable()) {
                    Helper_GeoCode.DeleteAddressInfo(setCombinationKeystoDeleteMPPoints);                
                 }else{
                  Database.rollback(sp);
                  deleteData.dataponitSize= -1;
                  return JSON.serialize(deleteData); //return -1;
                 }
            }
        } 
       
        else if(lstMapPointsToDelete.size() == 0){
            //Delete the mapping and the trigger after you delete all the datapoints.
            if(Util.getReadAccessCheck('MP_CustomMapping__c', new List<string>{'entity__c'})){
               lstmappedObj = [select id,entity__c from MP_CustomMapping__c where entity__c =: String.escapeSingleQuotes(objectName) LIMIT 1];
            }           
            String strObjectName = objectName;
            ////////////////// Deleting the Trigger ////////////////////
            if(strObjectName.endsWith('__c'))
            {
               strObjectName = strObjectName.removeEnd('__c');
            }
            strObjectName= strObjectName.replace('__','_');
            String TriggerName = 'TriggerMPGeocode'+strObjectName;
            //False +ve 
            //Read access is not checked because need to delete trigger irrespective of user access.
            List<ApexTrigger> triggerObj = [SELECT Id,Name FROM ApexTrigger where name = :String.escapeSingleQuotes(TriggerName) LIMIT 1];
              if(!test.isRunningTest()){
              if(triggerObj != null && triggerObj.size() >0 ){
                  HttpRequest req = new HttpRequest();
                 req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
                 req.setHeader('Content-Type', 'application/json');
                 req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v36.0/tooling/sobjects/ApexTrigger/'+triggerObj[0].Id+'');
                 req.setMethod('DELETE');
                 Http h = new Http();
                 HttpResponse res = h.send(req);
              }
             }
            String objname = objectName.contains('__') ? objectName.subString(14) : objectName;
            if(lstmappedObj.size() > 0)
            {
                for(CronTrigger ct : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger Where CronJobDetail.Name LIKE 'Schedule job to populate Map Points records%' AND  CronJobDetail.Name LIKE :'%'+String.escapeSingleQuotes(objname)]) 
                {
                    System.abortJob(ct.Id);
                }
              if(MP_CustomMapping__c.sObjectType.getDescribe().isDeletable()){              
               DELETE lstmappedObj;
               
               }else{
                  deleteData.dataponitSize= -1;
                  return JSON.serialize(deleteData); //return -1;
               }
            }
        }
       
        deleteData.dataponitSize= lstMapPointsToDelete.size();
        return JSON.serialize(deleteData); //return lstMapPointsToDelete.size();        
    }
    catch(Exception e) {
        Database.rollback(sp);
        system.debug('MPV2 exception occurred==>'+e.getMessage());
        return null; //return lstMapPointsToDelete.size(); return 0;
    }
}   
    // Return the one mapped object detail
    global static List<MP_CustomMapping__c> GetMappedObject(String ObjectType)
    {
        try
        {
            List<MP_CustomMapping__c> lstmappingofObject = new List<MP_CustomMapping__c>();
            if(string.isnotempty(ObjectType) && Util.getReadAccessCheck('MP_CustomMapping__c', new List<string>{'entity__c','label__C','country__c','state__c','city__c','street__c','postal_code__c','Pin_No__c','IsGeocode__c'})){
              lstmappingofObject = [select id,entity__c,label__C,country__c,state__c,city__c,street__c,postal_code__c,Pin_No__c,IsGeocode__c from MP_CustomMapping__c where entity__c = :String.escapeSingleQuotes(ObjectType) limit 1];
            }
            return lstmappingofObject;                  
        }
        catch(Exception e)
        {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
          return null;
        }
    }

    //Return list map points for perticular object
   
    global static List<MP_Map_Point__c> GetMapPointsforObject(String ObjectType)
    {
        List<MP_Map_Point__c> lstmappoints = new List<MP_Map_Point__c>();
        try {
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__C', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c'})){
              lstmappoints = [select Id,Label__c,Country__c,State__c,City__c,Street__c,Postal_code__c,Entity__c,RecordId__c,Latitude__c,Longitude__c,Status__c,GeoCode_Precision__c from MP_Map_Point__c where entity__c = :String.escapeSingleQuotes(ObjectType) limit 50000]; 
          }
          return lstmappoints;
        }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
        }
          
    }
 
    //Return list map points for perticular object with id as a offset
    
    global static List<MP_Map_Point__c> GetMapPointsforObject(String ObjectType ,Id offsetId)
    {
        List<MP_Map_Point__c> lstmappoints = new List<MP_Map_Point__c>();
        try {
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Status__c', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c'})){
          if(offsetId == null)
          {
              lstmappoints = [select Id,Label__c,Country__c,State__c,City__c,Street__c,Postal_code__c,Entity__c,RecordId__c,Latitude__c,Longitude__c,Status__c,GeoCode_Precision__c 
                                      FROM MP_Map_Point__c 
                                      WHERE entity__c = :String.escapeSingleQuotes(ObjectType)
                                      ORDER BY Id ASC
                                      LIMIT 5000]; 
                                      //LIMIT 5000]; 
          }
          else
          {
              lstmappoints = [select Id,Label__c,Country__c,State__c,City__c,Street__c,Postal_code__c,Entity__c,RecordId__c,Latitude__c,Longitude__c,Status__c,GeoCode_Precision__c 
                                      FROM MP_Map_Point__c 
                                      WHERE entity__c = :String.escapeSingleQuotes(ObjectType)
                                      AND id > :offsetId
                                      ORDER BY Id ASC 
                                      LIMIT 5000];  
                                      //LIMIT 5000]; 
          }
          if(lstmappoints != null)
          {
                return lstmappoints;
          }
        }
        return lstmappoints;
        }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
        }
    }

    // Return list of custom Mapping ie mapped objects
 
    global static List<MP_CustomMapping__c> GetCustomMappingObjects()
    {
        List<MP_CustomMapping__c> lstCustomMapping =new  List<MP_CustomMapping__c>();
        try {
          if(Util.getReadAccessCheck('MP_CustomMapping__c', new List<string>{'entity__c','label__c','country__c','state__c','city__c','street__c','postal_code__c','Pin_No__c','IsGeocode__c'})){
            lstCustomMapping =[select id,Label__c,Entity__c,Country__c,State__c,City__c,Street__C ,Postal_Code__c,Pin_No__c, IsGeocode__c from MP_CustomMapping__c ORDER BY Entity__c ASC limit 500];          
          }
           return lstCustomMapping;
        }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
            return lstCustomMapping;
        }
    } 

    // Return list of successfully geocoded MapPoints For specific Ids


    global static List<MP_Map_Point__c> GetMapPointsForRecordsIds(Set<Id> setRecordIds)
    {
        List<MP_Map_Point__c> lstMapPointForIds = new List<MP_Map_Point__c>();
        try {
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Status__c', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c','AddressKey__c','IsInsert__C','GeoCode_Precision__c'})){
           lstMapPointForIds = [select id,label__c,country__c,state__c,city__c,street__c,Postal_code__c,entity__c,recordId__c,AddressKey__c ,Latitude__c,Longitude__c,Status__c,GeoCode_Precision__c,CreatedDate,IsInsert__C from MP_Map_Point__c where recordId__C IN : setRecordIds AND status__c =: Helper_MPConstants.GEOCODE_SUCCESS limit 5000];
          }
          return lstMapPointForIds;
        }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
            return lstMapPointForIds;
        }        
    }
    
      //Added by Smita Pawar on 22-10-2019 starts here
    //Get map points for selected map point ids
    global static List<MP_Map_Point__c> GetMapPoints(Set<Id> setRecordIds)
    {
        List<MP_Map_Point__c> lstMapPointForIds = new List<MP_Map_Point__c>();
        try {
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Status__c', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c','AddressKey__c','IsInsert__C','GeoCode_Precision__c'})){
           lstMapPointForIds = [select id,label__c,country__c,state__c,city__c,street__c,Postal_code__c,entity__c,recordId__c,AddressKey__c ,Latitude__c,Longitude__c,Status__c,GeoCode_Precision__c,CreatedDate,IsInsert__C from MP_Map_Point__c where Id IN : setRecordIds AND status__c =: Helper_MPConstants.GEOCODE_SUCCESS limit 5000];
          }
          return lstMapPointForIds;
        }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
            return lstMapPointForIds;
        }        
    }
    //Added by Smita Pawar on 22-10-2019 ends here

    // Return map of Countries and related States, Cities for given object.
    global static Map<string,Map<string,List<MPCity>>> GetLocationFilter()
    {
        Map<string,Map<string,List<MPCity>>> countryMap = new Map<string,Map<string,List<MPCity>>>();
        Map<string,List<MPCity>> stateMap = new Map<string,List<MPCity>>();
        List<MPCity> lstCities = new List<MPCity>();
    try {
          List<MP_AddressInfo__c> lstaddressObj = new List<MP_AddressInfo__c>();
          if(Util.getReadAccessCheck('MP_AddressInfo__c', new List<string>{'name','StateName__c','CountryName__C','CityName__C'})){
            lstaddressObj =[SELECT Name,CountryName__C , StateName__c , CityName__C FROM MP_AddressInfo__c limit 50000];
          }
         
          if(lstaddressObj.size() > 0)
          {
              for(MP_AddressInfo__c addressObj : lstaddressObj)
              {
                  
                  String countryName = addressObj.CountryName__c;
                  String stateName = addressObj.StateName__c;
                  String cityName = addressObj.CityName__c;
                  String CityKey = addressObj.Name;
              
                  countryName = String.escapeSingleQuotes(countryName);   
                  if(countryName.length() <= 3)
                  {
                      countryName = countryName.toUpperCase();
                  }
                  else
                  {
                      countryName = countryName.toLowerCase();
                      countryName = countryName.capitalize();
                  }
  
                  stateName = String.escapeSingleQuotes(stateName);
                  if(stateName.length() <= 3)
                  {
                      stateName = stateName.toUpperCase();
                  }
                  else
                  {
                      stateName = stateName.toLowerCase();   
                      stateName = stateName.capitalize();
                  }
  
    
                  if(cityName != null ||  !String.isEmpty(cityName))
                  {
                      cityName = String.escapeSingleQuotes(cityName);
                      if(cityName.length() <= 3)
                      {
                          cityName = cityName.toUpperCase();
                      }
                      else
                      {
                          cityName = cityName.toLowerCase();
                          cityName = cityName.capitalize();
                      }
                  }
              
                  MPCity city = new MPCity(cityName,CityKey);
  
                  if(countryMap.containsKey(countryName))
                  {
                      stateMap = countryMap.get(countryName);
                      if(stateMap.containsKey(stateName)) 
                      {
                          lstCities = stateMap.get(stateName);
                          lstCities.add(city);
                      }
                      else 
                      {
                          lstCities = new List<MPCity>();
                          lstCities.add(city);
                          stateMap.put(stateName,lstCities);
                      }
                  }
                  else 
                  {
                      stateMap = new Map<String,List<MPCity>>();
                      lstCities = new List<MPCity>();
                      lstCities.add(City);
                      stateMap.put(stateName,lstCities);
                      countryMap.put(countryName,stateMap);
                  }
              
              }
              return countryMap;
          }
          return null;
    }
    catch(Exception e) {
      system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
    }
    }

    //Return the data for selected country,State and city
  

    global static List<MP_Map_Point__c> OnClickFetchMapPointsForLocationFilter(Set<String> setCityKey,ID offsetId) 
    {
        List<MP_Map_Point__c> lstMPMapPoints = new List<MP_Map_Point__c>();
        try {
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Status__c', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c'})){
            if(offsetId == null)
            {   
                lstMPMapPoints = [SELECT  Id,AddressKey__C,Entity__c,Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                                FROM MP_Map_Point__c 
                                WHERE status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                                AND AddressKey__C IN : setCityKey
                                ORDER BY ID ASC 
                                LIMIT 5000];        
            }
            else
            {
                
               lstMPMapPoints = [SELECT  ID,AddressKey__C,Entity__c, Latitude__c, Longitude__c, RecordId__c, Label__c, Country__c, State__c, City__c, Street__c, Postal_Code__c,CreatedDate
                    FROM MP_Map_Point__c 
                    WHERE Status__c =: Helper_MPConstants.GEOCODE_SUCCESS
                    AND AddressKey__C =: setCityKey
                    AND Id > : offsetId 
                    ORDER BY Id ASC 
                    LIMIT 5000]; 
            }
            return lstMPMapPoints;
        }
        return lstMPMapPoints;
        }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
        }
      
    }

   
    // Returns List of MP Sobject Result for supplied text and supported objects using SOSL query.  
 
    global static List<MP_Map_Point__c> GetSearchResult(String suppliedSearchText, Set<String> setSelectedObjects,Id offsetId)
    {
      try {
          string queryString,conditionString;
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__C', 'Entity__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c', 'CreatedDate','City__c','Name','Status__c','GeoCode_Precision__c'})){
          String[] types = new String[]{'MP_Map_Point__c'};
          conditionString  ='(';
          queryString = 'select id,Name,AddressKey__c,Label__c, Entity__c,City__c, State__c, Street__c, Postal_Code__c, Country__c,RecordID__c,Status__c,Latitude__c,Longitude__c,GeoCode_Precision__c,CreatedDate from MP_Map_Point__c WHERE Status__c = \''+Helper_MPConstants.GEOCODE_SUCCESS+'\' AND Entity__c IN : setselectedObjects and ';        
          Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);        
          for(Schema.DescribeSobjectResult res : results) {
              for(Schema.SObjectField sfield : res.fields.getMap().Values())
              {
                  schema.describefieldresult dfield = sfield.getDescribe();
                  if(dfield.getType() == Schema.DisplayType.String  || dfield.getType() == Schema.DisplayType.Email || dfield.getType() == Schema.DisplayType.Picklist || dfield.getType() == Schema.DisplayType.Phone) {
                      if(conditionString != '(')
                                          conditionString += ' or ';
                      conditionString += ' '+dfield.getname() +' like \'%'+String.escapeSingleQuotes(suppliedSearchText)+'%\'';
                  }
              }    
          }
         
          if(offsetId == null)
          {
           conditionString += ' ) order by ID ASC LIMIT 2000';
          }
          else
          {
           conditionString += ' ) AND (ID > : offsetId  ) order by ID ASC LIMIT 2000';
          }        
          List<MP_Map_Point__c> lstMpMapPoints = (List<MP_Map_Point__c>) Database.query(queryString+conditionString);        
          return lstMpMapPoints;
       }
      return null;
          
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
      }
    }

   //Return list of All (Success/Pending/Failed) MapPoints For specific Ids to update through trigger
    global static List<MP_Map_Point__c> GetTriggerUpdateMapPoints(Set<Id> setRecordIds)
    { 
      try {
        if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Entity__c','GeoCode_Precision__c', 'Latitude__c', 'Longitude__c', 'RecordId__c', 'Label__c', 'Country__c', 'State__c', 'Street__c', 'Postal_Code__c','City__c'})){
            List<MP_Map_Point__c> listMPMapPoints = ([
                    SELECT id,Entity__c, Label__c,RecordID__c,IsInsert__c, Latitude__c,Longitude__c, GeoCode_Precision__c,Country__c,State__c,City__c,Street__c,Postal_Code__c,Status__c
                    FROM MP_Map_Point__c
                    WHERE RecordID__c IN : setRecordIds
            ]);
            return listMPMapPoints;
        }
        return null;
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
      }
    }

    //Return list of All (Success/Pending/Failed) MapPoints For specific Ids to Delete through trigger
       global static List<MP_Map_Point__c> GetTriggerDeleteMapPoints(Set<ID> serRecordIds)
    {
      try {
        //False +ve 
        // read access is not check because records are retrive for delete purpose and delete access is checked in the method where involked.
          List<MP_Map_Point__c> listDeleteMapPoints = ([
                  SELECT id
                  FROM MP_Map_Point__c 
                  WHERE RecordID__c IN : serRecordIds limit 50000
          ]);
          return listDeleteMapPoints;
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
            return null;
      }
    }
}