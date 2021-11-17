/*******Trigger Name : TriggerMPV2GeocodeAccount  Author : Shilpa kamble Date : 25/8/2015 Details : Dynamically generated tigger on object to insert,update & delete the map point *********************************/
Trigger TriggerMPV2GeocodeAccount on Account(after Update, before delete, after insert, after undelete, after delete) {
    String CSName = 'Extentia_SIM__MapPlotterTriggerSettings__c';
    String fldName = 'Extentia_SIM__Bypass_Trigger__c';
    String triggerName = 'Bypass Account Trigger';
    boolean skip = false;
    List<Sobject> lstObj = new List<Sobject>();
    if(!Test.isRunningTest()){
        String query = 'SELECT Id, Name FROM '+CSName+' WHERE Name =: triggerName AND '+fldName+' = true ';
        lstObj = Database.query(query);
    }
    String strTriggerEvent;
    List<MP_CustomMapping__c> mappinglist = Helper_SOQL.GetMappedObject('Account');
    if(mappinglist != null && !mappinglist.isempty())
    {
        List < ApexPage > pageList = [SELECT Name FROM ApexPage WHERE Name IN('Map_Plotter_Setting', 'Extentia_SIM__Map_Plotter_Setting')];
        if (!pageList.isempty()) {
            if(lstObj.size() > 0){ 
                skip = true;
            }
            if(!skip){
            if (trigger.isUpdate) {
                strTriggerEvent = Extentia_SIM.Helper_MPConstants.EVENT_UPDATE;
                Extentia_SIM.Helper_Geocode.TriggerHandler(Trigger.new, strTriggerEvent);
            }
            if (trigger.isInsert) {
                strTriggerEvent = Extentia_SIM.Helper_MPConstants.EVENT_INSERT;
                Extentia_SIM.Helper_Geocode.TriggerHandler(Trigger.new, strTriggerEvent);
            }
            if (trigger.isDelete) {
                strTriggerEvent = Extentia_SIM.Helper_MPConstants.EVENT_DELETE;
                Extentia_SIM.Helper_Geocode.TriggerHandler(Trigger.old, strTriggerEvent);
            }
            if (trigger.isUndelete) {
                strTriggerEvent = Extentia_SIM.Helper_MPConstants.EVENT_UNDELETE;
                Extentia_SIM.Helper_Geocode.TriggerHandler(Trigger.new, strTriggerEvent);
            }
            }
        }
    }
}