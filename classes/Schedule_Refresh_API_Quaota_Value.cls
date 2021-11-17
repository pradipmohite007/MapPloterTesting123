/********** 
   Class   : Schedule_Refresh_API_Quota_Value
   Author  : Sandesh Ganjare 
   Date    : 25/05/2016
   History : v1.25 
   Details : This Scheduler schedule on installtion and runs everyday at 12AM (Pacific Day Time). The scheduler reset the daily API qouta
             to Zero at 12 AM(PDT). If any new key active at that time it changes the Daily Quota limit accordingly. 
***********/
global  with sharing class Schedule_Refresh_API_Quaota_Value implements Schedulable 
{
    global void execute(SchedulableContext SC) 
    {
        try
        {
            Integer API_Count=0;
            String orgID;
            // To detete the scheduled apex jobs when the package expired.
            List<PackageLicense> lstPackageLicense = [SELECT AllowedLicenses,Status, ExpirationDate FROM PackageLicense WHERE NamespacePrefix = : Helper_MPConstants.orgNamespace];
            if(lstPackageLicense != null && lstPackageLicense.size() >0){
               if(lstPackageLicense[0].ExpirationDate <= System.today()){ 
                List<CronTrigger> listCronTriggerAllScheduledJobs = [SELECT CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name= 'Schedule job to populate Map Points records' OR CronJobDetail.Name= 'Refresh Daily API Quota Value' limit 2];
                if(listCronTriggerAllScheduledJobs != null && listCronTriggerAllScheduledJobs.size() >0){
                for(CronTrigger CronTriggerAllScheduledJobs : listCronTriggerAllScheduledJobs)
                {
                    if((CronTriggerAllScheduledJobs.CronJobDetail.Name).equalsIgnoreCase('Schedule job to populate Map Points records') ||
                       (CronTriggerAllScheduledJobs.CronJobDetail.Name).equalsIgnoreCase('Refresh Daily API Quota Value'))
                    {                     
                        //False Positive// this job is executed in admin context
                        // Delete the Scheduled Job
                        System.abortJob(CronTriggerAllScheduledJobs.id);
                    }        
                }                
              } 
             }
            }
            MapPlotterPremiumSettings__c dailyQuotaValue = MapPlotterPremiumSettings__c.getValues('APIDailyQuotaValue');
            dailyQuotaValue.Value__c = String.valueOf(API_Count);
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE dailyQuotaValue;
           
            MapPlotterPremiumSettings__c isEmailSend = MapPlotterPremiumSettings__c.getValues('isEmailNotificationSend');
            isEmailSend.Value__c = 'false';
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE isEmailSend;

            MapPlotterPremiumSettings__c defaultAPIcappingLIMIT = MapPlotterPremiumSettings__c.getValues('DefaultAPIcappingLIMIT');
            MapPlotterPremiumSettings__c APICappingValue = MapPlotterPremiumSettings__c.getValues('APICappingValue');
            APICappingValue.Value__c = String.valueOf(defaultAPIcappingLIMIT.Value__c);
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
             UPDATE APICappingValue;
        }
        catch(Exception e)
        {
            system.debug('MPV2 exception occurred==>'+e.getMessage());
            MapPlotterPremiumSettings__c dailyQuotaValue = MapPlotterPremiumSettings__c.getValues('APIDailyQuotaValue');
            dailyQuotaValue.Value__c = String.valueOf(0);
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE dailyQuotaValue;
        }
    }
}