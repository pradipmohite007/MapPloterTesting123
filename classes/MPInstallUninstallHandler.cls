/********** 
   Class   : MPInstallUninstallHandler 
   Author  : Shilpa Kamble 
   Date    : 09/12/2015  
   History : v1.6 
   Details : Execute on installation and uninstalltion of application. 
***********/
global without sharing class MPInstallUninstallHandler implements InstallHandler,UninstallHandler 
{ 
   
    //Constructor
   
    public MPInstallUninstallHandler() 
    {
        
    }

    //Overrride methods
    // Execute on installation of application. 
    global void onInstall(InstallContext context)
    {       
        Ctrl_MapPlotter ctrlObject = new Ctrl_MapPlotter();
        
        Boolean checkOrgtype, trialPackage; // MPP Conversion to MPF Start - Removal of checkOrgtype & trialPackage condition - Hemant Keni
        try{
          
          //False Positive
            //Access is not check on CronTrigger because irrespective of user permission we have listofCronTrigger to abort the specific one.
          List<CronTrigger> listCronTriggerAllScheduledJobs = [SELECT CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name='Schedule job to populate Map Points records' limit 1];
              for(CronTrigger CronTriggerAllScheduledJobs : listCronTriggerAllScheduledJobs)
              {
                  if((CronTriggerAllScheduledJobs.CronJobDetail.Name).equalsIgnoreCase('Schedule job to populate Map Points records'))
                  {                     
                      // Abort the Scheduled Job
                      System.abortJob(CronTriggerAllScheduledJobs.id);
                      break;
                  }        
              }
          //False Positive
          //Access is not check on CronTrigger because irrespective of user permission we have listofCronTrigger to abort and reschedule the Job.
          // Check is our Scheduled Job exists
          List<CronTrigger> CronTriggerScheduledJobsList = [SELECT id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = 'Refresh Daily API Quota Value' LIMIT 1];
          // Delete the Scheduled Job
          if(CronTriggerScheduledJobsList.size() > 0)
          {
             System.abortJob(CronTriggerScheduledJobsList[0].id);      
          }
  
         List<MapPlotterPremiumSettings__c> listSettingRecord =  MapPlotterPremiumSettings__c.getall().values();
          if((listSettingRecord).isEmpty() || listSettingRecord.size() >= 20 )
          {
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'GoogleAPIKey'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKey'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'IsGoogleKeyValid'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'IsGoogleAPIQueryLimitExceeded'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'APIDailyQuotaValue', Value__c='0'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'GoogleCryptoKey', Value__c='-q8Km6XcpBWwXGkOkN0J0neO9UI='));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'DecryptionCryptoKey', Value__c='380db410e8b11fa9'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'DefaultAPIcappingLIMIT', Value__c='10000'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'GoogleMapUrl', Value__c='https://maps.googleapis.com/maps/api/geocode/json'));       
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'isEmailNotificationSend', Value__c = 'False'));       
               listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'DisableEmailNotification', Value__c='False'));
              listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'MPPSupportEmail', Value__c = 'MPPre.support@extentia.com'));
            listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKeysBank01', Value__c = '89a5dc29cc23d1003c128fb9e4451915,5aa0fea499bd8fd6a64a21c3ba429116,5bdd78e2801905019a4e49767b758fff,36205b258cd92f5420bb3c608a61fe6d,8cee5d909a43f8281c59f5b13f50175f,bb0cc76223e19542960334d4d8043d6b'));
            listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'DarkSkyForecastKeysBank02', Value__c = '4b8a9ebd98e5705a2f8f04131313f9bd,0acf69bf2eed761738e2df2791ae3648,0311b3f23ed5a917a54f2328512ac984,bd688513354747a219a3106446ed2da8,c25df637898b904d079d404370be5551,c73e9317c17979ca00d5f51720a5d4da'));
            listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'IsPageVisited', Value__c='No'));
            listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'PromotionAfterDays', Value__c='0'));
            listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'RemindAfterDays', Value__c='7'));
            listSettingRecord.add(new MapPlotterPremiumSettings__c(Name = 'IsRated', Value__c='False'));
            //False Positive
            //FLS insert check is not added because we are inserting Protected custom setting. 
            INSERT listSettingRecord;
        }
        else
        {
            SetSettingValue('GoogleAPIKey',listSettingRecord);
            SetSettingValue('DarkSkyForecastKey',listSettingRecord);
            SetSettingValue('IsGoogleKeyValid',listSettingRecord);
            SetSettingValue('IsGoogleAPIQueryLimitExceeded',listSettingRecord);
            SetSettingValue('APICappingValue',listSettingRecord);
            SetSettingValue('APIDailyQuotaValue',listSettingRecord);
            SetSettingValue('GoogleCryptoKey',listSettingRecord);
            SetSettingValue('DecryptionCryptoKey',listSettingRecord);
            SetSettingValue('DefaultAPIcappingLIMIT',listSettingRecord);
            SetSettingValue('GoogleMapUrl',listSettingRecord);
            SetSettingValue('isEmailNotificationSend',listSettingRecord);
            SetSettingValue('MPPSupportEmail',listSettingRecord);
            SetSettingValue('DisableEmailNotification',listSettingRecord);
            SetSettingValue('DarkSkyForecastKeysBank01',listSettingRecord);
            SetSettingValue('DarkSkyForecastKeysBank02',listSettingRecord);
            SetSettingValue('IsPageVisited',listSettingRecord);
            SetSettingValue('PromotionAfterDays',listSettingRecord);
            SetSettingValue('RemindAfterDays',listSettingRecord);
            SetSettingValue('IsRated',listSettingRecord);
              
      //False Positive
        //FLS insert and update check is not added because we are upserting Protected custom setting.
            UPSERT listSettingRecord;
        }  
        //Auto Creating Custom Mapping records for Account/Contact/Lead
         Ctrl_MapPlotter.createAutoMapping(); 
              }
          Catch(Exception e){
              system.debug('MPV2 exception occurred==>'+e.getMessage());
              sendFailureEmail('Installation',e);
                    }
        }    

    //Private Method
 
    // Remove settings value if exists. Add the setting if it does not exist.
  global void SetSettingValue(String settingName, List<MapPlotterPremiumSettings__c> listSettingRecords)
    {
        try{
          if(listSettingRecords.size() > 0)
          {
             //False Positive
             //Access is not check on MapPlotterPremiumSettings__c because irrespective of user permission we have save the custom Setting which are protected.
             List<MapPlotterPremiumSettings__c> lstSettingRecord =  [SELECT Id, Name, Value__c FROM MapPlotterPremiumSettings__c WHERE Name =: settingName LIMIT 1]; 
              if(lstSettingRecord.size() > 0)
              {
                      lstSettingRecord[0].Value__c = null;
                      //False Positive
                      //FLS update check is not added because we are updating Protected custom setting.
                      UPDATE lstSettingRecord;
              }
              else
              {
                  lstSettingRecord.add(new MapPlotterPremiumSettings__c(Name = settingName));
                  //False Positive
                  //FLS insert check is not added because we are inserting Protected custom setting.
                  INSERT lstSettingRecord;
              } 
           }
           else
           {
               listSettingRecords.add(new MapPlotterPremiumSettings__c(Name = settingName));
           }
       }
       Catch(Exception e){
           system.debug('MPV2 exception occurred==>'+e.getMessage());
           sendFailureEmail('Installation',e); 
       }
    }
    
    // Execute on uninstallation of application.
    global void onUninstall(UninstallContext context)
    {
       try 
          {
            //False Positive
            //Access is not check on CronTrigger because irrespective of user permission we have listofCronTrigger to abort Job that we are scheduled on uninstallation.
            // Check is our Scheduled Job exists
            List<CronTrigger> lstcronTrigger = Database.query('SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = \''+ Helper_MPConstants.SCHEDULER_NAME +'\' limit 1');
            List<CronTrigger> lstcronTrigger_daily = Database.query('SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = \''+ Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME +'\' limit 1');

            // Delete the Scheduled Job
            if(lstcronTrigger.size() > 0)
                {
                 System.abortJob(lstcronTrigger[0].id);           
           }
           if(lstcronTrigger_daily.size() > 0)
                {
                 System.abortJob(lstcronTrigger_daily[0].id);     
           }
         
        }
        Catch(Exception e)
        {
           system.debug('MPV2 exception occurred==>'+e.getMessage());
           sendFailureEmail('unInstallation',e);
        }
    }
    void sendFailureEmail(string context, Exception e) {       
          
          //False Positive
                //Access is not check on Organization because irrespective of user permission we want the organization id. 
             Organization orgDetail = [select Id, IsSandbox, InstanceName, Organizationtype from Organization LIMIT 1];
 
                String strError ;
                strError = e.getMessage();                
                List<String> toAddresses = new List<String>();
          //False Positive 
          //We using the hardcoded Email Id for sending the email alert when the package installtion got failed.
          toAddresses.add(string.valueOf('MPPre.support@extentia.com'));
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);

                mail.setReplyTo(UserInfo.getUserEmail());
                string orgId = '';
                  if(orgDetail != null)
                    orgId += orgDetail.Id;   
                mail.setSenderDisplayName('My Package Errors');                
                if(context == 'unInstallation') {                                 
                  mail.setSubject('Exception while unInstalling package for org: '+orgId);
                  mail.setPlainTextBody('Exception : '+strError);
                }
                else if(context == 'Installation') {
                  mail.setSubject('Post install script fail for org: '+orgId);
                  mail.setPlainTextBody('Exception : '+strError);
                }
                Messaging.sendEmail(new Messaging.Email[] { mail });
    }
}