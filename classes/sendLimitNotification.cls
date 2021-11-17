/********** 
   Class   : sendLimitNotification
   Author  : Sandesh Ganjare 
   Date    : 25/05/2016
   History : v1.25 
   Details : Send the email notification to current when Daily API quota reaches to 95% and when we exhausted the Daily API quota limit.
***********/
public with sharing class sendLimitNotification {
    public static void sendEmail(boolean limitExceed)
    {
        try{
        MapPlotterPremiumSettings__c isEmailSend = MapPlotterPremiumSettings__c.getValues('isEmailNotificationSend');
        MapPlotterPremiumSettings__c APICapping = MapPlotterPremiumSettings__c.getValues('APICappingValue');
        MapPlotterPremiumSettings__c APIDailyQuota = MapPlotterPremiumSettings__c.getValues('APIDailyQuotaValue');
        MapPlotterPremiumSettings__c disableEmail = MapPlotterPremiumSettings__c.getValues('DisableEmailNotification');

        if((isEmailSend.value__c).equalsIgnoreCase('false') && (disableEmail.value__c).equalsIgnoreCase('false')){
            //False Positive
            //Accessibility check is not added because we require the email of current user for sending some messages.
            // We are not showing data to user. this is only for logic purpose.
            user currentUser = [select id, firstName, email from user where id =: userInfo.getUserId()];
            List<Messaging.SingleEmailMessage> lstAllMessages = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(limitExceed == true)
                {
                  mail.setPlainTextBody('Hi '+currentUser.firstName+',\n\n Your daily geocode limit of \"'+APICapping.value__c+'\" has been exceeded. In case you want to increase your daily limit, please send an email to MPP.GeocodingUsage@extentia.com.\n\n Regards,\n Team Map Plotter'); 
                  mail.setSubject('Map Plotter -- daily geocode limit exceeded');
            }
            else
                {
                  mail.setPlainTextBody('Hi '+currentUser.firstName+',\n\n Based on your usage of Map Plotter Premium, you are currently at 95% of your daily geocode limit. If you would like to increase your daily limit, please write to us at MPP.GeocodingUsage@extentia.com  with information about the quota that you would like to increase and the time period for the same.\n\nIf you exceed your limit, the Map Plotter Premium application will not geocode until the daily limit is reset, normally till the next day. \n\n Regards,\n Team Map Plotter');  
                  mail.setSubject('Map Plotter -- reached 95% of your daily geocode limit');
                }
            mail.setToAddresses(new List<string>{currentUser.email});
            lstAllMessages.add(mail);
            Messaging.sendEmail(lstAllMessages,false);
            if(Integer.valueOf(APIDailyQuota.value__c) == Integer.valueOf(APICapping.value__c)){
            isEmailSend.value__c='true';
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE isEmailSend;
           }
         }
      }
      Catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());
      }
    }
}