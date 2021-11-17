public with sharing class Batch_MassUpdateFilteredResult implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful
{    
    public list<Id> ListRecordIdsToMassUpdate;
    public List<sObject> ListUpdate;
    public string FieldName;
    public string Fieldvalue;
    public string FieldDatatype;
    public string objectName;
    public integer countSuccess = 0;
    public integer countFailure = 0;

    public Batch_MassUpdateFilteredResult(list<Id> listRecordsToMassUpdate,string fieldNameOfSobj,string fieldValueofSobj,string fieldValueDataType){
        ListRecordIdsToMassUpdate = listRecordsToMassUpdate;
        FieldName = fieldNameOfSobj;
        FieldValue = fieldValueofSobj;
        FieldDatatype = fieldValueDataType;
    }
    
    // Start Method
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {
       //False Positive
       //Access is not checked because we have to process all records from MP_Map_Point__c object for latitude and longitude calculations.
        
        Id recordId = ListRecordIdsToMassUpdate[0];
        objectName = string.valueOf(recordId.getsobjecttype());     
        string query = 'SELECT Id,'+FieldName+' FROM '+objectName +' where Id IN: ListRecordIdsToMassUpdate';
        
        return Database.getQueryLocator(query);
    }
        
    // Execute Method
    public void execute(Database.BatchableContext BC, List<SObject> lstRecords) 
    {  
        integer totalNumberOfRecords = lstRecords.size();        
        MassUpdateHandler obj = new MassUpdateHandler(lstRecords,FieldName,Fieldvalue,FieldDatatype);
        integer cntSuccess = obj.UpdateRecords();
        countSuccess += cntSuccess;
        integer cntFailure = totalNumberOfRecords - cntSuccess;
        countFailure += cntFailure;
    }
    
    // Finish Method
    public void finish(Database.BatchableContext BC) 
    {
        try{
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                              TotalJobItems, CreatedBy.Email
                              FROM AsyncApexJob WHERE Id =:BC.getJobId()];
           
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.createdBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Map Plotter Mass Update ' + a.Status);
            mail.setPlainTextBody
            ('Your data has been updated. \n There were '+countSuccess +' successfully updated records and '+countFailure+' failed updates. \n Thanks.');
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }       
        catch(Exception e){
            System.debug('GS_MP exception occured==>'+e.getMessage());
        }
    }
}