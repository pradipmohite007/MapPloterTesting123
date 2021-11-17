/********** 
   Class   : Util 
   Author  : Jitendra Kawale 
   Date    : 06/23/2016 
   History : v1.0 
   Details : Common utility methods.
***********/
public with sharing class Util {
  /********** 
     Method   : getUpdateAccessCheck 
     Parameter : ObjectName, Fields to check access
     Date    : 06/23/2016 
     History : v1.0 
     Details : Common utility methods.
  ***********/
    public static boolean getUpdateAccessCheck(string objectName, List<string> FieldsToUpdate) {
      try {
     
          objectName=(objectName!=null && objectName.toLowerCase().contains('__c'))?Helper_MPConstants.org_namespaceprefix+objectName:objectName;
        
          if(!Schema.getGlobalDescribe().get(objectName).getDescribe().isUpdateable()){
             return false;
          }
          List<String> lstfieldAPIName= new List<String>();
          if(FieldsToUpdate!=null && FieldsToUpdate.size()>0){            
              for(String fieldAPIName:FieldsToUpdate){
                lstfieldAPIName.add((fieldAPIName!=null && fieldAPIName.toLowerCase().contains('__c'))?Helper_MPConstants.org_namespaceprefix+fieldAPIName:fieldAPIName);
              }
              FieldsToUpdate=lstfieldAPIName;
          }
          
          Map<String,Schema.SObjectField> m = Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap();
          Boolean permission = true;
                for (String fieldToCheck : FieldsToUpdate) {
                  // Check if the user has create access on the each field
                  if ((!m.get(fieldToCheck).getDescribe().isUpdateable())) {
                    permission  = false;
                    break;
                  }
                }
          return permission;
      }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());  
        return false;
      }
    }
    /********** 
     Method   : getCreateAccessCheck 
     Parameter : ObjectName, Fields to check access
     Date    : 06/23/2016 
     History : v1.0 
     Details : Common utility methods.
  ***********/
    public static boolean getCreateAccessCheck(string objectName, List<string> FieldsToInsert) {
      try {
          objectName=(objectName!=null && objectName.toLowerCase().contains('__c'))?Helper_MPConstants.org_namespaceprefix+objectName:objectName;
          
          if(!Schema.getGlobalDescribe().get(objectName).getDescribe().isCreateable()){
             return false;
          }
         
          List<String> lstfieldAPIName= new List<String>();
          if(FieldsToInsert!=null && FieldsToInsert.size()>0){            
              for(String fieldAPIName:FieldsToInsert){
                lstfieldAPIName.add((fieldAPIName!=null && fieldAPIName.toLowerCase().contains('__c'))?Helper_MPConstants.org_namespaceprefix+fieldAPIName:fieldAPIName);
              }
              FieldsToInsert=lstfieldAPIName;
          }
          Map<String,Schema.SObjectField> m = Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap();
          Boolean permission = true;
                for (String fieldToCheck : FieldsToInsert) {
                  // Check if the user has create access on the each field
                  if ((!m.get(fieldToCheck).getDescribe().isCreateable())) {
                    permission  = false;
                    break;
                  }
                }
          return permission;
        }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());  
        return false;
      }
    }
  /********** 
     Method   : getReadAccessCheck 
     Parameter : ObjectName, Fields to check access
     Date    : 06/23/2016 
     History : v1.0 
     Details : Common utility methods.
  ***********/
    public static boolean getReadAccessCheck(string objectName, List<string> FieldsToUpdate) {
      try {        
          objectName=(objectName!=null && objectName.toLowerCase().contains('__c'))?Helper_MPConstants.org_namespaceprefix+objectName:objectName;
          
             if(!Schema.getGlobalDescribe().get(objectName).getDescribe().isAccessible()){
             return false;
          }
          
          List<String> lstfieldAPIName= new List<String>();
          if(FieldsToUpdate!=null && FieldsToUpdate.size()>0){            
              for(String fieldAPIName:FieldsToUpdate){
                lstfieldAPIName.add((fieldAPIName!=null && fieldAPIName.toLowerCase().contains('__c'))?Helper_MPConstants.org_namespaceprefix+fieldAPIName:fieldAPIName);
              }
              FieldsToUpdate=lstfieldAPIName;
          }           
        
          Map<String,Schema.SObjectField> m = Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap();
          map<String, string> relReferenceMap = new map<String, string>();
            for (String fieldName: m.keySet()) {
                  Schema.DescribeFieldResult fieldDescribe = m.get(fieldName).getDescribe();
                  String type = string.valueOf(fieldDescribe.getRelationshipName());
                   if(type != null && fieldDescribe.getReferenceTo().size() > 0){
                          relReferenceMap.put(type, string.valueOf(fieldDescribe.getReferenceTo()[0].getDescribe().getName()));
                      } 
              }               
            Boolean permission = true;
            
          for (String  fieldToCheck : FieldsToUpdate) {          
          if(fieldToCheck.contains('.')) {            
            List<string> field = fieldToCheck.split('\\.');            
            permission  = getReadAccessCheck(relReferenceMap.get(field[0]), new List<string>{field[1]});
            if(permission  == false)
            return false;
          }
          else {
          

            if (!m.get(fieldToCheck.toLowerCase()).getDescribe().isAccessible()) {
              permission  = false;
              return permission;
            }
          }
         }
          return permission;
        }
      catch(Exception e) {
        system.debug('MPV2 exception occurred==>'+e.getMessage());  
        return false;
      }
    }
    
}