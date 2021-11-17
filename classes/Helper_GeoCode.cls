/********** 
   Class   : Helper_GeoCode 
   Author  : Shilpa Kamble 
   Date    : 09/12/2015 
   History : v1.6 
   Details : For Address Geocoding.
***********/
Global with sharing class Helper_GeoCode 
{
    
  
    //Method to call the geocode address 
    
    Global static MapPointInfo GeoCodeAddressForRecord1(List<MP_Map_Point__c> mapPointObj)
    {
      try {
          MapPointInfo mapPointInfoObj = GeoCodeAddress(mapPointObj[0].Street__c,mapPointObj[0].City__c,mapPointObj[0].State__c,mapPointObj[0].Postal_Code__c,mapPointObj[0].Country__c);
          
          if(mapPointInfoObj != null)
          {
              return mapPointInfoObj;
          }
          else
          {
              return null;
          }
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
        return null;
      }
    }

    // Geocode the address based on choice of the geocodeing type
    Global static MapPointInfo GeoCodeAddress(String street, String city,String state,String postalCode,String country)
    {
     try {
          String address;
          MapPointInfo mapPointInfoObj = new mapPointInfo();
          
          if((String.isNotEmpty(street)) || (String.isNotEmpty(city)) || (String.isNotEmpty(country)) ||(String.isNotEmpty(postalCode)) || (String.isNotEmpty(state)))  //if(street != null && city!=null)
          {
              if(String.isEmpty(street))
              {
                  street = ' ';
              }
              if(String.isEmpty(city))
              {
                  city = ' ';
              }
              if(String.isEmpty(country))
              {
                  country = ' ';
              }
              if(String.isEmpty(postalCode))
              {
                  postalCode = ' ';
              }
              if(String.isEmpty(state))
              {
                  state = ' ';
              }
              address = street+','+city+','+state+','+country+','+postalCode;
              Helper_GoogleAPI GeocodeObj = new Helper_GoogleAPI();
              mapPointInfoObj = GeocodeObj.MapAddress(address);
          }
          else
          {
              mapPointInfoObj.Status = Helper_MPConstants.GEOCODE_FAILED;
              return mapPointInfoObj;
          }
          return mapPointInfoObj;
      }
      catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());
        return null;
      }
    }

    //Method to handle the trigger oprations
    // @Future(callout=true) 
    Global static void TriggerHandler(List<sobject> lstRecords,String strTriggerEvent)
    {
    try {
         String Query;
         Set<Id> setidsRecords = new Set<Id>();
         for(Sobject record :lstRecords)
          {   
              Id recordId = (String)record.get('id');
              setidsRecords.add(recordId);
          }
            
          set<Id> setContactId = new set<Id>();
          String objectName = (String)LstRecords[0].getsObjectType().getDescribe().getName();
          Map<Id,String> mapIdAndCombinationKey = new Map<Id,String>(); 
          List<MP_CustomMapping__c> lstObject = Helper_SOQL.GetMappedObject(objectName);
     
          Set<Id> setIdsToInsert = new Set<Id>();
          Set<Id> setRecordIds =  new Set<Id>();
          set<Id> setLeadIds = new set<Id>();
          Set<Id> setRecIdsToDelete = new set<Id>();
          List<sobject> objLst = new List<sobject>();          
          if(Util.getReadAccessCheck(lstObject[0].Entity__c, new List<string>{lstObject[0].Label__c, lstObject[0].Country__c, lstObject[0].State__c, lstObject[0].City__c, lstObject[0].Street__C, lstObject[0].Postal_code__C})){
            if(lstObject[0].entity__c == 'Lead')
            {
             Query = 'Select id, IsConverted, '+ lstObject[0].label__C +','+lstObject[0].country__c+','+lstObject[0].state__c+','+lstObject[0].city__c+','+lstObject[0].street__c+','+lstObject[0].postal_code__c+' From '+lstObject[0].entity__c+' where id IN :setidsRecords';         
            }
            else{
             Query = 'Select id,'+ lstObject[0].label__C +','+lstObject[0].country__c+','+lstObject[0].state__c+','+lstObject[0].city__c+','+lstObject[0].street__c+','+lstObject[0].postal_code__c+' From '+lstObject[0].entity__c+' where id IN :setidsRecords';         
            }
            objLst = Database.Query(string.escapeSingleQuotes(Query));
          }
         
          // copying Column names in string
          Id customMappingId = lstObject[0].Id;
          String strName = lstObject[0].Label__c;
          String strCountry = lstObject[0].Country__c;
          String strState = lstObject[0].State__c;
          String strCity = lstObject[0].City__c;
          String strStreet = lstObject[0].Street__c;
          String strPostalCode = lstObject[0].Postal_Code__c;
          
          for(Sobject record :objLst)
          {
            try {   
                Id recordId = (String)record.get('id');
                if(strTriggerEvent == Helper_MPConstants.EVENT_UNDELETE)
                {
                    setRecordIds.add(recordId);
                }
                
                if(strTriggerEvent == Helper_MPConstants.EVENT_UPDATE || strTriggerEvent == Helper_MPConstants.EVENT_INSERT || strTriggerEvent == Helper_MPConstants.EVENT_DELETE )
                {                  
                    //Lookup////
                    List<String> lstAddressInfo = Helper_Geocode.GetAddressvalues(record, lstObject[0].Label__c, lstObject[0].Country__c, lstObject[0].State__c, lstObject[0].City__c, lstObject[0].Street__c, lstObject[0].Postal_Code__c);
                    //record, Name/label, Country, State, City, Street, PostalCode
                    String newRecName;
                    String newRecCountry;
                    String newRecState;
                    String newRecCity;
                    String newRecStreet;
                    String newRecZipCode;
                    
                    if(lstAddressInfo != null && lstAddressInfo.size() > 0) {
                  
                      newRecName = lstAddressInfo[0];
                      newRecCountry = lstAddressInfo[1];
                      newRecState = lstAddressInfo[2];
                      newRecCity = lstAddressInfo[3];
                      newRecStreet = lstAddressInfo[4];
                      newRecZipCode = lstAddressInfo[5];
                    }
    
                   
                    //Delete the white spaces from updated String
                    if(newRecName != null)
                    {
                        newRecName =newRecName.trim();
                    }
                    if(newRecCountry != null)
                    {
                         newRecCountry =newRecCountry.trim();
                    }
    
                    if(newRecState != null)
                    {
                         newRecState =newRecState.trim();
                    }
                    if(newRecCity != null)
                    {
                         newRecCity =newRecCity.trim();
                    }
                    if(newRecStreet != null)
                    {   
                         newRecStreet =newRecStreet.trim();
                    }
                    if(newRecZipCode != null)
                    {
                         newRecZipCode =newRecZipCode.trim();
                    }
    
                    if(newRecCountry != null || newRecState != null || newRecCity != null || newRecStreet != null || newRecZipCode != null)
                    {
                        setIdsToInsert.add(recordId);
                    }
    
                    
                    if(strTriggerEvent == Helper_MPConstants.EVENT_UPDATE || strTriggerEvent == Helper_MPConstants.EVENT_DELETE)
                    {
                        sObject oldRecord = Trigger.oldMap.get(recordId);                      
                                             
                        if(strTriggerEvent == Helper_MPConstants.EVENT_DELETE )
                        {
                             Id oldrecordId = (String)oldRecord.get('id');
                             setRecIdsToDelete.add(oldrecordId);
                        }  
    
                        List<String> lstAddress = Helper_Geocode.GetAddressvalues(oldRecord, lstObject[0].Label__c, lstObject[0].Country__c, lstObject[0].State__c, lstObject[0].City__c, lstObject[0].Street__c, lstObject[0].Postal_Code__c);
                         //record, Name/label, Country, State, City, Street, PostalCode
                         
                         String oldRecName;
                         String oldRecCountry;
                         String oldRecState;
                         String oldRecCity;
                         String oldRecStreet;
                         String oldRecZipCode;
                         
                         if(lstAddressInfo != null && lstAddressInfo.size() > 0) {
                            oldRecName = lstAddress[0];
                          oldRecCountry = lstAddress[1];
                          oldRecState = lstAddress[2];
                          oldRecCity = lstAddress[3];
                          oldRecStreet = lstAddress[4];
                          oldRecZipCode = lstAddress[5];
                         }
                        //Delete the white spaces from Old String
                        if(oldRecName != null)
                        {   
                            oldRecName =oldRecName.trim();
                        }
                        if(oldRecCountry != null)
                        {
                            oldRecCountry =oldRecCountry.trim();
                        }
                        if(oldRecState != null)
                        {
                            oldRecState = oldRecState.trim();
                        }
                        if(oldRecCity != null)
                        {
                            oldRecCity = oldRecCity.trim();
                        }
                        if(oldRecStreet != null)
                        {
                            oldRecStreet = oldRecStreet.trim();
                        }
                        if(oldRecZipCode != null)
                        {
                            oldRecZipCode = oldRecZipCode.trim();
                        }
                      
                        if(newRecCountry != oldRecCountry || newRecState != oldRecState || newRecCity != oldRecCity || newRecStreet != oldRecStreet || newRecZipCode != oldRecZipCode )
                        {
                            String strCombinationKey = Helper_GeoCode.GetCombinationKey(oldRecCountry,oldRecState,oldRecCity); 
                            mapIdAndCombinationKey.put(recordId,strCombinationKey);
                       
                        }
                        else if(newRecName != oldRecName)
                        {
                            setContactId.add(recordId);
                        }
                    
                        if(objectName.equalsIgnoreCase('Lead'))
                        {
                           Boolean resIsconverted = (Boolean)record.get('isConverted');
                           
                            if(resIsconverted)
                            {
                                setLeadIds.add(recordId);
                            }
                        }
                    }
                }
            }
            catch(Exception e) {
              system.debug('MPV2 exception occurred==>'+e.getMessage());
              record.addError('Please check all values');
            }
            
          } //For Ends here
  
          if(strTriggerEvent == Helper_MPConstants.EVENT_UPDATE)
          {
              if(!setContactId.isEmpty())
              {
         
                  Helper_GeoCode.HandleRecordUpdate(setContactId,objectName);

              }
              if(!mapIdAndCombinationKey.isEmpty())
              {
             
                  GeoCodeAddressFutureForObjectRecordUpdated(mapIdAndCombinationKey,objectName);
              }
          }
          
          if(strTriggerEvent == Helper_MPConstants.EVENT_INSERT)
          {
              if(setIdsToInsert.size() > 0)
              {
             
                  GeoCodeAddressFutureForObjectRecord(setIdsToInsert,objectName);
              }
          }
  
          if(strTriggerEvent == Helper_MPConstants.EVENT_DELETE)
          {             
              if(setRecIdsToDelete != null && setRecIdsToDelete.size() >0)
              {
                    DeleteMapPointsAndAddressKeyData(setRecIdsToDelete); 
              }
          }
  
          if(strTriggerEvent == Helper_MPConstants.EVENT_UNDELETE)
          {
              if(setRecordIds != null && setRecordIds.size() > 0)
              {
                  GeoCodeAddressFutureForObjectRecord(setRecordIds,objectName);
              }
          }
          if(setLeadIds != null && setLeadIds.size() > 0)
          {
              List<MP_Map_Point__c> lstDeleteRelatedMapPoints = Helper_SOQL.GetTriggerDeleteMapPoints(setLeadIds);
              if(MP_Map_Point__c.sObjectType.getDescribe().isDeletable() && lstDeleteRelatedMapPoints != null)
              {
                  DELETE lstDeleteRelatedMapPoints;
              }
          }
      }
        catch(Exception e) {
          system.debug('MPV2 exception occurred==>'+e.getMessage());
        }
    }


   //Trigger code to handle if the record is Updated
   @future 
    Global static void HandleRecordUpdate(Set<Id> setIds, String ObjectType)
    {
      try {
          List<MP_CustomMapping__c> lstMappingObj = Helper_SOQL.GetMappedObject(ObjectType);
       
          Set<Id> setRecordIds = new Set<Id>();
          Boolean recordInserted = false;
          String queryString;
      
          Map<id,MP_Map_Point__c> mapRecordsMPMapPoint = new Map<id,MP_Map_Point__c>();
          List<MP_Map_Point__c> lstToUpdateMapPoint = new List<MP_Map_Point__c>();
          List<MP_Map_Point__c> lstToInsertMapPoint = new List<MP_Map_Point__c>();
          if(Util.getReadAccessCheck(lstMappingObj[0].Entity__c, new List<string>{lstMappingObj[0].Label__c, lstMappingObj[0].Country__c, lstMappingObj[0].State__c, lstMappingObj[0].City__c, lstMappingObj[0].Street__C, lstMappingObj[0].Postal_code__C})){
              queryString = 'Select id,'+lstMappingObj[0].Label__c+','+lstMappingObj[0].Country__c+','+lstMappingObj[0].State__c+','+lstMappingObj[0].City__c+','+lstMappingObj[0].Street__C+','+lstMappingObj[0].Postal_code__C+' FROM '+lstMappingObj[0].Entity__c+' where id IN : setIds';
          }
          if(String.isNotBlank(queryString)){ 
          List<sObject> sobjRecordLst = Database.query(string.escapeSingleQuotes(queryString));        
          List<MP_Map_Point__c> lstObjectRecordsRelatedMPMapPoint = Helper_SOQL.GetTriggerUpdateMapPoints(setIds);
          for(sObject record : sobjRecordLst)
          {
              for(MP_Map_Point__c mapPoint : lstObjectRecordsRelatedMPMapPoint)
              {
                  if(record.id == mapPoint.RecordID__c)
                  {
                      mapRecordsMPMapPoint.put(record.id,mapPoint);
                  }
              }
          }
          
          for(sObject record : sobjRecordLst)
          {
              MP_Map_Point__c updateMapPoint = mapRecordsMPMapPoint.get(record.id);
              if(updateMapPoint != null)
              {
                  String labelName = String.valueOf(record.get(lstMappingObj[0].Label__C));
                  if(labelName != null)
                  {
                      updateMapPoint.Label__c = labelName;
                      updateMapPoint.isInsert__c = 'FALSE';
                      lstToUpdateMapPoint.add(updateMapPoint);
                  }
              }
          }
          // Check if the user has update access on the MP_Map_Point__c.Name field
          if (Util.getUpdateAccessCheck('MP_Map_Point__c', new List<string>{'Label__c','isInsert__c'}))
          {
              UPDATE lstToUpdateMapPoint;
          } 
        }
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
    }
    
    // if record is updated Geocode the address of record 
  @Future(callout = true) 
    Global static void GeoCodeAddressFutureForObjectRecordUpdated(Map<Id,String> mapIdAndOldCombinationKey ,String ObjectName)
    {     
      try {  
          Boolean isAPIKeyQueryLimitExceded = false;
          Set<Id> setRecordIds = new set<Id>();
          setRecordIds = mapIdAndOldCombinationKey.keySet();
  
          MapPlotterPremiumSettings__c API_QUOTA_LIMIT = MapPlotterPremiumSettings__c.getValues('APIDailyQuotaValue');
          MapPlotterPremiumSettings__c APICappingValue = MapPlotterPremiumSettings__c.getValues('APICappingValue');
          Integer API_Count = integer.valueOf(API_QUOTA_LIMIT.Value__c); 
          boolean notifiedLimit = false;
         
       
          Ctrl_MapPlotter ctrlObject = new Ctrl_MapPlotter();
    
  
          MapPlotterPremiumSettings__c iskeyLimitExceededSetting = MapPlotterPremiumSettings__c.getValues('IsGoogleAPIQueryLimitExceeded');
          if(iskeyLimitExceededSetting.Value__c == 'Yes')
          {
              isAPIKeyQueryLimitExceded = true;
          }
      
          Set<String> SetOldCombinationKeys = new set<String>();
          For(Id recordId : mapIdAndOldCombinationKey.keySet())
          {
              SetOldCombinationKeys.add(String.escapeSingleQuotes(mapIdAndOldCombinationKey.get(recordId)));
          }
         
  
          Boolean recordInserted = false;
          String queryString;
          Map<id,MP_Map_Point__c> mapSobjectMPMapPoint = new Map<id,MP_Map_Point__c>();
          List<MP_Map_Point__c> lstToUpdateMapPoint = new List<MP_Map_Point__c>();
          List<MP_Map_Point__c> lstToInsertMapPoint = new List<MP_Map_Point__c>();
        
          List<MP_CustomMapping__c> lstMapping = Helper_SOQL.GetMappedObject(ObjectName);
         // MP_CustomMapping__c lstMapping= new MP_CustomMapping__c();
          //If object is contact get account ID of conatct in Query
          if(Util.getReadAccessCheck(lstMapping[0].Entity__c, new List<string>{lstMapping[0].Label__c, lstMapping[0].Country__c, lstMapping[0].State__c, lstMapping[0].City__c, lstMapping[0].Street__C, lstMapping[0].Postal_code__C})){
            queryString = 'select id,'+lstMapping[0].Label__c+','+lstMapping[0].Country__c+','+lstMapping[0].State__c+','+lstMapping[0].City__c+','+lstMapping[0].Street__c+','+lstMapping[0].Postal_Code__c+' from '+lstMapping[0].Entity__c+' where id IN : setRecordIds';
           }
          if(String.isNotBlank(queryString)){
          List<sObject> sobjRecordLst =  Database.query(string.escapeSingleQuotes(queryString));
               
          List<MP_Map_Point__c> lstLeadRelatedMPMapPoint = Helper_SOQL.GetTriggerUpdateMapPoints(setRecordIds);
     
          for(sObject record : sobjRecordLst)
          {
              for(MP_Map_Point__c mapPoint : lstLeadRelatedMPMapPoint)
              {
                  if(record.id == mapPoint.RecordID__c)
                  {
                      mapSobjectMPMapPoint.put(record.id,mapPoint);
                  }
              }    
          }
          
          //Set<String> setCombinationKeys = new Set<String>();
          Set<String> setCommbinationKeys = new Set<String>();
      
             for(sObject record : sobjRecordLst)
              {
  
                  List<String> lstAddressInfo =Helper_GeoCode.GetAddressvalues(record, lstMapping[0].Label__c, lstMapping[0].Country__c, lstMapping[0].State__c, lstMapping[0].City__c, lstMapping[0].Street__c, lstMapping[0].Postal_Code__c);            
                  //record, Name/label, Country, State, City, Street, PostalCode
                  String strLable;
                  String strCountry;
                  String strState;
                  String strCity;
                  String strStreet;
                  String strPostalCode;
                  if(lstAddressInfo!= null && lstAddressInfo.size()>0){
                     strLable = lstAddressInfo[0];
                     strCountry = lstAddressInfo[1];
                     strState = lstAddressInfo[2];
                     strCity = lstAddressInfo[3];
                     strStreet = lstAddressInfo[4];
                     strPostalCode = lstAddressInfo[5];
                  }    
                  MP_Map_Point__c updateMapPoint = mapSobjectMPMapPoint.get(record.id);
  
                  if(updateMapPoint != null)
                  {
                      updateMapPoint.Label__c = strLable;
                      updateMapPoint.Country__c = strCountry;
                      updateMapPoint.State__c = strState;
                      updateMapPoint.City__c = strCity;
                      updateMapPoint.Street__c = strStreet;
                      updateMapPoint.Postal_Code__c = strPostalCode;
                      updateMapPoint.Entity__c = ObjectName;
                      updateMapPoint.RecordID__c = record.id;
                  }
                  String strCombinationKey;                         
                  //Call to geocode the address
                  if(setRecordIds.size() <= Helper_MPConstants.INTEGER_CONSTANT_TEN)
                  {
                 
                      MapPointInfo mapPointInfo = GeoCodeAddress(strStreet,strCity,strState, strPostalCode, strCountry);
                     
                      if(mapPointInfo != null)
                      {        
                          if(mapPointInfo.Status == Helper_MPConstants.GEOCODE_SUCCESS)
                          {
                              isAPIKeyQueryLimitExceded = false;
                              if(updateMapPoint != null)
                              {
                                  updateMapPoint.Latitude__c = mapPointInfo.Latitude;
                                  updateMapPoint.Longitude__c = mapPointInfo.Longitude; 
                                  updateMapPoint.GeoCode_Precision__c = mapPointInfo.Geocode_Precision; 
                                  updateMapPoint.Status__c = Helper_MPConstants.GEOCODE_SUCCESS;
                                  if(updateMapPoint.isInsert__c == null){
                                            updateMapPoint.isInsert__c = 'TRUE';   
                                        } else{
                                            updateMapPoint.isInsert__c = 'FALSE';    
                                        }
                                  lstToUpdateMapPoint.add(updateMapPoint);
                              }
                              else
                              {
                                  recordInserted = true;
                                  MP_Map_Point__c toInsertRecord = new  MP_Map_Point__c(
                                              Latitude__c = mapPointInfo.Latitude, Longitude__c = mapPointInfo.Longitude,
                                          Label__c = strLable,Country__c = strCountry,State__c = strState,City__c = strCity,Street__c = strStreet,Postal_Code__c = strPostalCode,
                                          Entity__c = ObjectName,RecordID__c = record.id,
                                          Status__c = Helper_MPConstants.GEOCODE_SUCCESS,
                                          isInsert__c = 'TRUE',
                                          GeoCode_Precision__c = mapPointInfo.Geocode_Precision);
                                  lstToInsertMapPoint.add(toInsertRecord);
                              }
                              strCombinationKey= GetCombinationKey(strCountry,strState,strCity);
                              setCommbinationKeys.add(strCombinationKey);
                          }
                          else if((mapPointInfo.status).equalsIgnoreCase(Helper_MPConstants.GEOCODE_PENDING))
                          {
                              isAPIKeyQueryLimitExceded = true;
                              updateMapPoint.Latitude__c = null;
                              updateMapPoint.Longitude__c = null; 
                              updateMapPoint.GeoCode_Precision__c = null;
                              updateMapPoint.AddressKey__c=null; 
                              updateMapPoint.isInsert__c = null;
                              updateMapPoint.Status__c = Helper_MPConstants.GEOCODE_PENDING;
                              lstToUpdateMapPoint.add(updateMapPoint);
  
                          }
                          else if((mapPointInfo.status).equalsIgnoreCase(Helper_MPConstants.GEOCODE_FAILED))
                          {
                              updateMapPoint.Latitude__c = null;
                              updateMapPoint.Longitude__c = null; 
                              updateMapPoint.GeoCode_Precision__c = null;
                              updateMapPoint.AddressKey__c=null; 
                              updateMapPoint.isInsert__c = null;
                              updateMapPoint.Status__c = Helper_MPConstants.GEOCODE_FAILED;
                              lstToUpdateMapPoint.add(updateMapPoint);
                          }
                      }
                      else if(updateMapPoint != null)
                      {
                            lstToUpdateMapPoint.add(updateMapPoint);
                      }   
                  }
                  else
                  {
                     
                      updateMapPoint.Latitude__c = null;
                      updateMapPoint.Longitude__c = null; 
                      updateMapPoint.GeoCode_Precision__c = null;
                      updateMapPoint.AddressKey__c=null; 
                      updateMapPoint.isInsert__c = null;
                      updateMapPoint.Status__c = Helper_MPConstants.GEOCODE_PENDING;
                      strCombinationKey = GetCombinationKey(updateMapPoint.country__c,updateMapPoint.state__c,updateMapPoint.City__c);
                      SetOldCombinationKeys.add(String.escapeSingleQuotes(strCombinationKey));
                     // DeleteAddressInfo(SetOldCombinationKeys);
                      lstToUpdateMapPoint.add(updateMapPoint);
                  }
              }    
          
          if(setRecordIds.size() <= Helper_MPConstants.INTEGER_CONSTANT_TEN)
          {
               // Check if the user has update access on the MP_Map_Point__c.Name field
              if (Util.getUpdateAccessCheck('MP_Map_Point__c', new List<string>{'Latitude__c','Longitude__c','GeoCode_Precision__c','Status__c','isInsert__c','AddressKey__c','country__c','state__c','City__c'}))
              {
                  UPDATE lstToUpdateMapPoint;
                  Set<Id> setMapPointIds = (new Map<Id,MP_Map_Point__c>(lstToUpdateMapPoint)).keySet();
                  if(setCommbinationKeys!= null && setCommbinationKeys.size()>0){
                  InsertNewEntryOfCombinationKey(setCommbinationKeys);
                  AssignCombinationKeytoMapPoints(setMapPointIds,setCommbinationKeys);
                     }
                  DeleteAddressInfo(SetOldCombinationKeys);
              }
              
              if(isAPIKeyQueryLimitExceded)
              {
                  iskeyLimitExceededSetting.Value__c = 'Yes'; 
              }
              else
              {
                  iskeyLimitExceededSetting.Value__c = 'No'; 
  
              }
                  //False Positive
                    //FLS update check is not added because we are updating Protected custom setting.
                  UPDATE iskeyLimitExceededSetting;     
          }
          else
          {
              if (Util.getUpdateAccessCheck('MP_Map_Point__c', new List<string>{'Latitude__c','Longitude__c','GeoCode_Precision__c','Status__c','isInsert__c','AddressKey__c','country__c','state__c','City__c'}))
              {
                  UPDATE lstToUpdateMapPoint;
                  Set<Id> setMapPointIds = (new Map<Id,MP_Map_Point__c>(lstToUpdateMapPoint)).keySet();
                  DeleteAddressInfo(SetOldCombinationKeys);
              } 
          }
         
          if(recordInserted)
          {
              // Check if the user has create access on the MP_Map_Point__c.Name field
              if (Util.getCreateAccessCheck('MP_Map_Point__c', new List<string>{'Latitude__c','Longitude__c','Label__c','Country__c' ,'State__c','City__c','Street__c','Postal_Code__c','Entity__c','RecordID__c','Status__c','isInsert__c','GeoCode_Precision__c'}))
              {
                  INSERT lstToInsertMapPoint;
                  Set<Id> setMapPointIds = (new Map<Id,MP_Map_Point__c>(lstToInsertMapPoint)).keySet();
                  InsertNewEntryOfCombinationKey(setCommbinationKeys);
                  AssignCombinationKeytoMapPoints(setMapPointIds,setCommbinationKeys);
                  DeleteAddressInfo(SetOldCombinationKeys);
              }
          }
      
     
       }
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
        ///////////////////////////////////////////////////////
}
    
    //Delete the Map Points with addressInfo records
   @future 
    Global static Void DeleteMapPointsAndAddressKeyData(Set<ID> serRecordIds)
    {
      try {
          List<MP_Map_Point__c> lstMapPointsToDelete = new List<MP_Map_Point__c>();
          Set<String> setCombinationKeys = new Set<String>();
          if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Country__c','State__c','City__c'})) {
              lstMapPointsToDelete = [SELECT id,country__c ,state__c,City__c from MP_Map_Point__c where RecordID__c IN : serRecordIds];
          }         
      
          if(lstMapPointsToDelete.size()>0)
          {
              For(MP_Map_Point__c mapPoint :lstMapPointsToDelete)
              {
                  String strCombinationKey = GetCombinationKey(mapPoint.Country__c,mapPoint.State__c,mapPoint.City__c);
                  setCombinationKeys.add(String.escapeSingleQuotes(strCombinationKey));
              }
            
             if (MP_Map_Point__c.sObjectType.getDescribe().isDeletable()) {
              DELETE lstMapPointsToDelete;
          }
          }
          if(setCombinationKeys != null)
          {
              DeleteAddressInfo(setCombinationKeys); 
          }
    }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
    }
    
    //when the record is created Geocode the record address & create the new MP_Map_point and associated addressInfo Record
    @Future(callout=true)
    Global static void GeoCodeAddressFutureForObjectRecord(set<Id> setRecordIds,String ObjectName)
    {
      try {
          String queryString;
          List<MP_Map_Point__c> lstToInsertMapPoint = new List<MP_Map_Point__c>();
          List<sObject> sobjRecordLst = new List<sObject>();
          List<MP_CustomMapping__c> lstMapping = Helper_SOQL.GetMappedObject(ObjectName);
          MapPlotterPremiumSettings__c API_QUOTA_LIMIT = MapPlotterPremiumSettings__c.getValues('APIDailyQuotaValue');
          MapPlotterPremiumSettings__c APICappingValue = MapPlotterPremiumSettings__c.getValues('APICappingValue');
          Integer API_Count = integer.valueOf(API_QUOTA_LIMIT.Value__c); 
          boolean notifiedLimit = false;
    
          if(lstMapping.size() >0)
          {
              if(Util.getReadAccessCheck(lstMapping[0].Entity__c, new List<string>{lstMapping[0].Label__c, lstMapping[0].Country__c, lstMapping[0].State__c, lstMapping[0].City__c, lstMapping[0].Street__C, lstMapping[0].Postal_code__C})){
               queryString = 'select id,'+lstMapping[0].Label__c+','+lstMapping[0].Country__c+','+lstMapping[0].State__c+','+lstMapping[0].City__c+','+lstMapping[0].Street__c+','+lstMapping[0].Postal_Code__c+' from '+lstMapping[0].Entity__c+' where id IN : setRecordIds';
               sobjRecordLst = Database.query(string.escapeSingleQuotes(queryString));
                
              }
              
          }
          
          Set<String> setCommbinationKeys = new Set<String>();
          Boolean isAPIKeyQueryLimitExceded = false;
          MapPlotterPremiumSettings__c iskeyLimitExceededSetting = MapPlotterPremiumSettings__c.getValues('IsGoogleAPIQueryLimitExceeded');
          if(iskeyLimitExceededSetting.Value__c == 'Yes')
          {
              isAPIKeyQueryLimitExceded = true;
          }
         
          if(sobjRecordLst.size() > 0)
          {
      

            
             for(sObject record : sobjRecordLst)
            {
              
              List<String> lstAddressInfo = GetAddressvalues(record, lstMapping[0].Label__c, lstMapping[0].Country__c, lstMapping[0].State__c, lstMapping[0].City__c, lstMapping[0].Street__c, lstMapping[0].Postal_Code__c);            
  
              String strLable;
              String strCountry;
              String strState;
              String strCity;
              String strStreet;
              String strPostalCode;
              if(lstAddressInfo != null && lstAddressInfo.size() > 0) {
                strLable = lstAddressInfo[0];
                strCountry = lstAddressInfo[1];
                strState = lstAddressInfo[2];
                strCity = lstAddressInfo[3];
                strStreet = lstAddressInfo[4];
                strPostalCode = lstAddressInfo[5];
              }
  
              MP_Map_Point__c toInsertMapPoint = new MP_Map_Point__c();
  
              toInsertMapPoint.Label__C  = strLable;
              toInsertMapPoint.Country__c = strCountry;
              toInsertMapPoint.State__c = strState;
              toInsertMapPoint.City__c = strCity;
              toInsertMapPoint.Street__c = strStreet;
              toInsertMapPoint.Postal_Code__c = strPostalCode;
              toInsertMapPoint.RecordID__c = record.Id;
              toInsertMapPoint.Entity__c = ObjectName;
  
              if(setRecordIds.size() <=  Helper_MPConstants.INTEGER_CONSTANT_TEN)
              {
                  MapPointInfo mapPointInfo = GeoCodeAddress(strStreet,strCity,strState, strPostalCode, strCountry);
                  
                  if(mapPointInfo != null)
                  { 
                      toInsertMapPoint.Latitude__c = mapPointInfo.Latitude;
                      toInsertMapPoint.Longitude__c = mapPointInfo.Longitude;
                      toInsertMapPoint.GeoCode_Precision__c = mapPointInfo.Geocode_Precision;
                      toInsertMapPoint.Status__c = mapPointInfo.Status;
                      if(toInsertMapPoint.Status__c == Helper_MPConstants.GEOCODE_SUCCESS)
                      {
                          toInsertMapPoint.isInsert__c = 'TRUE';
                          String strCombinationKey = GetCombinationKey(strCountry,strState,strCity);
                          setCommbinationKeys.add(strCombinationKey);
                          isAPIKeyQueryLimitExceded = false;
                      }
                      if(toInsertMapPoint.Status__c == Helper_MPConstants.GEOCODE_PENDING)
                      {
                          isAPIKeyQueryLimitExceded = true;
                          toInsertMapPoint.isInsert__c = null;
                      }
                  }    
                  else
                  {
  
                      toInsertMapPoint.Status__C = Helper_MPConstants.GEOCODE_FAILED;
                      toInsertMapPoint.isInsert__c = null;
                  }
              }
              else
              {
                  toInsertMapPoint.Status__c = Helper_MPConstants.GEOCODE_PENDING;
                  toInsertMapPoint.isInsert__c = null;
              }
              lstToInsertMapPoint.add(toInsertMapPoint); 
          }
          
         
             API_QUOTA_LIMIT.Value__c = String.valueOf(API_Count);
             //False Positive
             //FLS update check is not added because we are updating Protected custom setting.
             UPDATE API_QUOTA_LIMIT; 

          }
          if(lstToInsertMapPoint != null)
          {

              if (Util.getCreateAccessCheck('MP_Map_Point__c', new List<string>{'Latitude__c','Longitude__c','Label__c','Country__c' ,'State__c','City__c','Street__c','Postal_Code__c','Entity__c','RecordID__c','Status__c','isInsert__c','GeoCode_Precision__c'}))
              {
                  Database.Insert(lstToInsertMapPoint,false);
              }
              if(isAPIKeyQueryLimitExceded)
              {
                  iskeyLimitExceededSetting.Value__c = 'Yes'; 
              }
              else
              {
                  iskeyLimitExceededSetting.Value__c = 'No'; 
              }
  
             //False Positive
             //FLS update check is not added because we are updating Protected custom setting.
                  UPDATE iskeyLimitExceededSetting;
             
              Set<Id> setMapPointIds =new set<Id>();
              for(MP_Map_Point__c mappoint : lstToInsertMapPoint)
              {
                  setMapPointIds.add(mappoint.id);
              }
          
              InsertNewEntryOfCombinationKey(setCommbinationKeys);
              AssignCombinationKeytoMapPoints(setMapPointIds,setCommbinationKeys);
          }
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
    } 

  //Insert Combination keys in addressInfo
    Global static void InsertNewEntryOfCombinationKey(Set<String> setCombinationKey)
    {
      try
        {
          List<MP_AddressInfo__c> lstAddressInfo = new List<MP_AddressInfo__c>();
          For(String combinationKey : setCombinationKey)
          {
              MP_AddressInfo__c addrInfo = new MP_AddressInfo__c();
              String[] address = combinationKey.split('_');
              addrInfo.CountryName__c = address[0];
              addrInfo.StateName__c = address[1];
              addrInfo.CityName__c = address[2];
              addrInfo.CombinationKey__c = combinationKey.toUpperCase();
              lstAddressInfo.add(addrInfo);
          }
          
            if (Util.getCreateAccessCheck('MP_AddressInfo__c', new List<string>{'CountryName__c','StateName__c','CityName__c','CombinationKey__c'})){
              Database.insert(lstAddressInfo,false);      
          }                 
        }
        catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());                       
        }   
    }

    //Generate the combination key from country,State and city
    Global static String GetCombinationKey(String strCountry,String strState,String strCity)
    {
      try {
          if(strCountry == null || strCountry == '')
          {
              strCountry = 'Undefined Country';
          }
          if(strState == null || strState == '')
          {
              strState = 'Undefined State';
          }
          if(strCity == null || strCity=='')
          {
              strCity = 'Undefined City';
          }
          String strCombinationKey = String.escapeSingleQuotes(strCountry)+'_'+String.escapeSingleQuotes(strState)+'_'+String.escapeSingleQuotes(strCity);
          return  strCombinationKey.toUpperCase();
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());
        return null;
      }
    }

    //Assign the combination Key to Map Points
    Global static void AssignCombinationKeytoMapPoints(Set<Id> setIds,Set<String> setCombinationKeys)
    {
        try{
        Map<String,String> mapCombinationKeyAndName = new Map<String,string>();
        List<MP_Map_point__c> lstMapPointsToUpdate = new List<MP_Map_Point__c>();
        List<MP_AddressInfo__c> lstAddressInfo = new List<MP_AddressInfo__c>();
        if(Util.getReadAccessCheck('MP_AddressInfo__c', new List<string>{'name','Combinationkey__c'})){
          lstAddressInfo = [SELECT id,name,CombinationKey__c from MP_AddressInfo__c WHERE CombinationKey__c IN :setCombinationKeys];
        }
        if(lstAddressInfo.size() >0 ){
        for(MP_AddressInfo__c addr :lstAddressInfo)
        {
            string strCombinationKey = addr.CombinationKey__c;
            mapCombinationKeyAndName.put(strCombinationKey, addr.Name);
        }
        }
        List<MP_Map_Point__c> lstMapPoints = new List<MP_Map_Point__c>();
        if(Util.getReadAccessCheck('MP_Map_Point__c', new List<string>{'Country__c','State__c','City__c','AddressKey__c'})) {            
         lstMapPoints = [SELECT id,Country__c,State__c,City__c,AddressKey__c from MP_Map_Point__c WHERE Id IN : setIds and status__c ='success'];
        }
        if(lstMapPoints.size() > 0)
        {
            for(MP_Map_Point__c mapPoint : lstMapPoints)
            {
                string strCombinationKey = GetCombinationKey(mapPoint.Country__c,mapPoint.State__c,mapPoint.City__c);
                String strAddressKey  = mapCombinationKeyAndName.get(strCombinationKey);
                mapPoint.AddressKey__c = strAddressKey;
                lstMapPointsToUpdate.add(mapPoint);
            }
            if(lstMapPointsToUpdate != null)
            {
                if(Util.getUpdateAccessCheck('MP_Map_Point__c', new List<string>{'AddressKey__c','country__c','state__c','City__c'})){
                    Database.update(lstMapPointsToUpdate,false);
                }
            }
        } 
        }
        Catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
        
    }

    //Delete combination keys which is not present in any map point 
  //  @future (callout=true)
    Global Static void DeleteAddressInfo(Set<String> setOldCombinationKeys)
    {     
        try{
        List<AggregateResult> lstMapPoints = new List<AggregateResult>();
        Set<String> setAddressKeysForAddressInfo = new Set<String>();
        Set<String> setaddressKeysForOldCombinationKeys = new set<String>();
        Map<String,MP_AddressInfo__c> mapKeyAndRecord = new Map<String,MP_AddressInfo__c>();
        List<MP_AddressInfo__c> lstAddressInfo = new List<MP_AddressInfo__c>();
        if(Util.getReadAccessCheck('MP_AddressInfo__c', new List<string>{'name','Combinationkey__c'})){
                lstAddressInfo = [select id,name,Combinationkey__c from MP_AddressInfo__c where CombinationKey__c IN : setOldCombinationKeys];  
        }

        if(lstAddressInfo.size() > 0)
        {
            For(MP_AddressInfo__c addr : lstAddressInfo)
            {
                mapKeyAndRecord.put(string.escapeSingleQuotes(addr.name), addr); 
            }
        }
        setaddressKeysForOldCombinationKeys = mapKeyAndRecord.keySet();
        if(Util.getReadAccessCheck('MP_Map_Point__C', new List<string>{'addressKey__c'})){
         lstMapPoints = [SELECT addressKey__c,Count(ID) FROM MP_Map_Point__C where addressKey__c IN :setaddressKeysForOldCombinationKeys  Group By addressKey__c limit 2000];
        }
        
      
        if(lstMapPoints.size() > 0)
        {
            Set<String> setAddressKeysNotToDelete = new Set<String>();
            For(AggregateResult mapPoint : lstMapPoints)
            {
                
                String key;
                key = (String)mapPoint.get(Helper_MPConstants.org_namespaceprefix +'addressKey__c');    
              
               mapKeyAndRecord.remove(key);
            }
        }   
        

        if(mapKeyAndRecord != null)
        {
            Set<String> setKeysToDelete = mapKeyAndRecord.keySet();
         
         List<MP_AddressInfo__c> lstAddressInfotoDelete = new List<MP_AddressInfo__c>();
         if(Util.getReadAccessCheck('MP_AddressInfo__c', new List<string>{'name'})){
            lstAddressInfotoDelete = [SELECT name from MP_AddressInfo__c where name IN : setKeysToDelete];
         }         
         
            if(lstAddressInfotoDelete.size() > 0)
            {
                if(MP_AddressInfo__c.sObjectType.getDescribe().isDeletable()) {
                    DELETE lstAddressInfotoDelete;                
                 }
            }
        } 
      }
      Catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
    }

    //// Method for accessing the values of the fileds of records

    public Static List<String> GetAddressvalues(SObject record,String strName, String strCountry, String strState, String strCity, String strStreet, String strPostalCode) 
    { 
     try{
          List<String> lstAddressfileds = new List<String>();
          String stateName, recordName, countryName, cityName, streetName, postalCodeNo;
          String objectName = (String)record.getsObjectType().getDescribe().getName();
          map<string,schema.sobjecttype> describe = schema.getglobaldescribe();
          map<string,schema.sobjectfield> fieldmap = describe.get(objectName).getdescribe().fields.getmap();
          
          Set<String> setRelName = new Set<String>();
            for (String fieldName: fieldmap.keySet()) {
                  Schema.DescribeFieldResult fieldDescribe = fieldmap.get(fieldName).getDescribe();
                  String type = string.valueOf(fieldDescribe.getRelationshipName());
                   if(type != null){
                          setRelName.add(type);
                      } 
              }
    
          String[] arrStringName = strName.split('\\.');
          if(!setRelName.contains(arrStringName[0])){
                recordName = String.ValueOf(record.get(strName));
              }
              else{
                   Sobject obj = record.getSobject(arrStringName[0]);
                     if(obj != null){
                       recordName = String.ValueOf(obj.get(arrStringName[1]));
                     }
                     else{
                       recordName ='';
                     }
                  }
              lstAddressfileds.add(recordName);
          
          String[] arrStringCountry = strCountry.split('\\.');        
            if(!setRelName.contains(arrStringCountry[0])){
                     countryName = String.ValueOf(record.get(strCountry));
             }
            else{
                  Sobject obj = record.getSobject(arrStringCountry[0]);
                    if(obj != null){
                        countryName = String.ValueOf(obj.get(arrStringCountry[1]));
                    }
                    else{
                         countryName ='';
                       }
                  }
            lstAddressfileds.add(countryName);

          String[] arrStringState = strState.split('\\.');
          if(!setRelName.contains(arrStringState[0])){
                       stateName = String.ValueOf(record.get(strState));
              }
              else{
                      Sobject obj = record.getSobject(arrStringState[0]);
                      if(obj != null){
                          stateName = String.ValueOf(obj.get(arrStringState[1]));
                      }
                      else{
                          stateName ='';
                      }                     
              }        
              lstAddressfileds.add(stateName);
                  
          String[] arrStringCity = strCity.split('\\.');        
          if(!setRelName.contains(arrStringCity[0])){
                      cityName = String.ValueOf(record.get(strCity));
              }
              else{
                    Sobject obj = record.getSobject(arrStringCity[0]);
                        if(obj != null){
                              cityName = String.ValueOf(obj.get(arrStringCity[1]));
                             }
                         else{
                           cityName ='';
                         }
                  }
          lstAddressfileds.add(cityName);
                  
          String[] arrStringStreet = strStreet.split('\\.');        
          if(!setRelName.contains(arrStringStreet[0])){
                      streetName = String.ValueOf(record.get(strStreet));
              }
              else{
                   Sobject obj = record.getSobject(arrStringStreet[0]);
                        if(obj != null){
                              streetName = String.ValueOf(obj.get(arrStringStreet[1]));
                          }
                         else{
                           streetName ='';
                         }
                  } 
              lstAddressfileds.add(streetName);
                  
              String[] arrStringPostalCode = strPostalCode.split('\\.');    
              if(!setRelName.contains(arrStringPostalCode[0])){
                       postalCodeNo = String.ValueOf(record.get(strPostalCode));
                  }
                  else{   
                        
                        Sobject obj = record.getSobject(arrStringPostalCode[0]);
                        if(obj != null){
                              postalCodeNo = String.ValueOf(obj.get(arrStringPostalCode[1]));
                             }
                         else{
                           postalCodeNo ='';
                         }
                  }
          lstAddressfileds.add(postalCodeNo);              
          return lstAddressfileds;
        }
     catch(Exception e){
          system.debug('MPV2 exception occurred==>'+e.getMessage());
         return null;
     }      
   }
}