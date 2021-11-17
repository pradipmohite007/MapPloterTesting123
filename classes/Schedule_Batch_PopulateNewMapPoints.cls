/********** 
   Class   : Schedule_Batch_PopulateNewMapPoints 
   Author  : Shilpa Kamble 
   Date    : 09/12/2015  
   History : v1.6 
   Details : For Shcheduling the Batch to populate then new Map Points.
***********/

global with sharing class  Schedule_Batch_PopulateNewMapPoints implements Schedulable
{    
  
    // Constructor
   
    public String objectName;
    global Schedule_Batch_PopulateNewMapPoints(String objName)
    {    
      try{
       objectName =String.escapeSingleQuotes(objName);
       
      }
       Catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());     
       }
    }

    global Schedule_Batch_PopulateNewMapPoints()
    {

    }
   
    //Override execute method 
   
    global void execute(SchedulableContext sc)
    {
              
        try{
       
        if(objectName == null)
        {
          Batch_PopulateNewMapPoints batchObjectForAccount = new Batch_PopulateNewMapPoints();
          Database.executeBatch(batchObjectForAccount,Helper_MPConstants.INTEGER_CONSTANT_TEN);
        }
        else
        {
            Batch_PopulateOldMapPoint batchObjectForAccount = new Batch_PopulateOldMapPoint(objectName);
            Database.executeBatch(batchObjectForAccount,200);
        }
      }
      Catch(Exception e){
        system.debug('MPP exception occurred==>'+e.getMessage());
      }    
    }   
}