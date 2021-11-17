global with sharing class Batch_PopulateNewMapPoints implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful
{
   // Constructor
    public Integer API_Count;
    MapPlotterPremiumSettings__c APICappingvalue;
    MapPlotterPremiumSettings__c APIDailyLimit; 
    boolean notifiedLimit;
    List<CronTrigger> CronTriggerScheduledJobs;
    global Batch_PopulateNewMapPoints(String objectT) 
    {
    }
    global Batch_PopulateNewMapPoints() 
    {
      try{
        notifiedLimit = false;
        APICappingvalue = MapPlotterPremiumSettings__c.getValues('APICappingValue');
       }
        Catch(Exception e){
        System.debug('MPV2 exception occurred==>'+e.getMessage());
      }
    }
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
       //False Positive
       //Access is not checked because we have to process all records from MP_Map_Point__c object for latitude and longitude calculations.
       return Database.getQueryLocator([SELECT id,Entity__c,Label__c,Country__c,State__C,City__c,Street__c,Postal_Code__c,Status__c FROM MP_Map_Point__c where Status__c =: Helper_MPConstants.GEOCODE_PENDING]);
    }
    // Execute Method
    global void execute(Database.BatchableContext BC, List<SObject> LstRecords) 
    {   
        try{
        List<MP_Map_Point__c> lstMapPoints = new List<MP_Map_Point__c>();
        List<MP_Map_Point__c> tempLstMapPoints = (List<MP_Map_Point__c>)LstRecords;
        
        Boolean iskeyLimitExceeded  = false;
        Set<String> setCombinationKeys = new Set<String>();

        for(MP_Map_Point__c mapPointObj : tempLstMapPoints)
        {
            MapPointInfo mapPoint = Helper_GeoCode.GeoCodeAddressForRecord1(new List<MP_Map_Point__c>{mapPointObj});
            if(mapPoint != null)
            {
                if( mapPoint.Status != null )
                {                
                    if((mapPoint.Status).equalsIgnoreCase(Helper_MPConstants.GEOCODE_SUCCESS))
                    {
                        mapPointObj.Latitude__c = mapPoint.Latitude;
                        mapPointObj.Longitude__c = mapPoint.Longitude;
                        mapPointObj.GeoCode_Precision__c = mapPoint.Geocode_Precision; 
                        mapPointObj.Status__c = Helper_MPConstants.GEOCODE_SUCCESS;
                        mapPointObj.isInsert__c = 'TRUE';
                        iskeyLimitExceeded = false;
                        String strCombinationKey = Helper_GeoCode.GetCombinationKey(mapPointObj.Country__c,mapPointObj.State__c,mapPointObj.City__c);
                        setCombinationKeys.add(strCombinationKey);
                    }
                    else if((mapPoint.Status).equalsIgnoreCase(Helper_MPConstants.GEOCODE_PENDING))
                    {
                        iskeyLimitExceeded = true;
            
                        mapPointObj.Status__c  = Helper_MPConstants.GEOCODE_PENDING;
                        break;
                    }
                    else if((mapPoint.Status).equalsIgnoreCase(Helper_MPConstants.GEOCODE_FAILED))
                    {
                        iskeyLimitExceeded = false;
                        mapPointObj.Status__c = Helper_MPConstants.GEOCODE_FAILED;
                    }
                    lstMapPoints.add(mapPointObj);
                }
                else
                {
                    mapPointObj.Status__c = Helper_MPConstants.GEOCODE_FAILED;
                    iskeyLimitExceeded = false;
                    lstMapPoints.add(mapPointObj);   
                }
            }
         }
        
                
        MapPlotterPremiumSettings__c iskeyLimitExceededSetting = MapPlotterPremiumSettings__c.getValues('IsGoogleAPIQueryLimitExceeded'); 
        if(iskeyLimitExceeded)
        {
            iskeyLimitExceededSetting.Value__c = 'Yes';
        }
        else
        {
            iskeyLimitExceededSetting.Value__c = 'No';
        }

        //False Positive
        //FLS update check is not added because we have to update Portected custom setting.
        UPDATE iskeyLimitExceededSetting; 
       
       if(lstMapPoints.size() > 0)
        {
          if(Util.getUpdateAccessCheck('MP_Map_Point__c', new List<string>{'Latitude__c','Longitude__c','GeoCode_Precision__c','Status__c','isInsert__c'})){
                 Database.update(lstMapPoints);
          }
        }

        Set<Id> setMapPointIds = (new Map<Id,MP_Map_Point__c>(LstMapPoints)).keySet();
       
        if(setCombinationKeys != null)
        {
            Helper_GeoCode.InsertNewEntryOfCombinationKey(setCombinationKeys);
            Helper_GeoCode.AssignCombinationKeytoMapPoints(setMapPointIds,setCombinationKeys);
        }
      }
      Catch(Exception e){
        system.debug('MPP exception occurred==>'+e.getMessage());
      }
    }  
    
   // Finish Method
    global void finish(Database.BatchableContext BC) 
    {
         
         try{
         if(API_Count == integer.valueof(APICappingValue.value__c)) 
         {
            sendLimitNotification.sendEmail(true);
         }
         
         //False Positive
         //Access is not check on CronTrigger because irrespective of user permission we have to schedule batch for daily limit reset.
         List<CronTrigger> CronTriggerScheduledJobs = [SELECT id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name =: Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME LIMIT 1];                 
         if(CronTriggerScheduledJobs.size() == 0) {
           Schedule_Refresh_API_Quaota_Value schedulerForRefresh_API_Quota_Value = new Schedule_Refresh_API_Quaota_Value();
          datetime dt = DateTime.newInstanceGMT(2015, 5, 31, 07, 0, 0);
          String cronExpression = '0 '+dt.minute()+' '+dt.hour()+' * * ?';
           system.schedule(Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME, cronExpression, schedulerForRefresh_API_Quota_Value);
         }
        }
        Catch(Exception e){
           system.debug('MPP exception occurred==>'+e.getMessage());
        }
    }
}