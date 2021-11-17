//This class update records in bulk. Input parameters should be list of records, fields and their values to be changed 
public with sharing class MassUpdateHandler 
{   
    public list<sObject> ListRecordIdsToMassUpdate = new List<sObject>();
    public List<sObject> ListUpdate = new List<sObject>();
    public string FieldName;
    public string Fieldvalue;
    public string FieldDatatype;
    public integer countSuccess = 0;
    public integer countFailed = 0;
    
    public MassUpdateHandler(list<sObject> listRecordsToMassUpdate,string fieldNameOfSobj,string fieldValueofSobj,string fieldValueDataType)
    {
        ListRecordIdsToMassUpdate = listRecordsToMassUpdate;
        FieldName = fieldNameOfSobj;
        FieldValue = fieldValueofSobj;  
        FieldDatatype = fieldValueDataType;
    }
    
    public Integer UpdateRecords()
    {       
        for(sObject recToUpdate: ListRecordIdsToMassUpdate)
        {   
             if(FieldDatatype == 'DOUBLE' || FieldDatatype == 'DECIMAL' || FieldDatatype == 'CURRENCY' )
             {
                recToUpdate.put(FieldName,double.valueOf(FieldValue));   
             }
            else if(FieldDatatype == 'DATE')
            {
                integer month = integer.valueOf(FieldValue.substringBefore('/'));
                integer day = integer.valueOf((FieldValue.substringAfter('/')).substringBefore('/')); 
                integer year =integer.valueOf(FieldValue.substringAfterLast('/'));
                Date fieldValueDate = date.newinstance(year, month, day);
                String formattedDate = fieldValueDate.format();
                Date parsedDate = Date.parse(formattedDate);
                recToUpdate.put(FieldName,parsedDate);
                
            } 
            else if (FieldDatatype == 'Boolean')
            {              
                Boolean FieldValueBoolean = FieldValue.equals('true')? true:false;              
                recToUpdate.put(FieldName,FieldValueBoolean);
            }
            else
            {
                 recToUpdate.put(FieldName,FieldValue);
            }            
            ListUpdate.add(recToUpdate);
        }     
        try
        {
           
            if(!ListUpdate.isEmpty())
            {
               
                Database.SaveResult[] srList = Database.update(ListUpdate, false);
               
                for(Database.SaveResult sr:srList)
                {
                   // fetch all success DML id's in this set
                   if(sr.isSuccess())
                   {
                       countSuccess++;
                   }
                   else
                   {
                       countFailed++;
                   }
                }
                        
            }            
        }
        catch(Exception e)
        {
            system.debug('Exception==='+e.getMessage()+e.getLineNumber());                
        }
        return countSuccess;
    }
}