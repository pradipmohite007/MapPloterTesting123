/*************************************************************
Class Name : filterHelper
Author : Sandesh Ganjare
Date : 
Details : Creating the map for datatypes and operator
*****************************************************************/ 
global with sharing class filterHelper 
{
public filterHelper() 
{
    
}
     global Map<String,Map<String,String>> GetOperators()
    {
    Map<String,Map<String,String>> mapDTandOperaters = new Map<String,Map<String,String>>();

    Map<String,String> mapNonStringOperators = new Map<String,String>();
    mapNonStringOperators.put('Equals to','=');
    mapNonStringOperators.put('Not equal to','!=');
    mapNonStringOperators.put('Greater than','>');
    mapNonStringOperators.put('Less than','<');
    mapNonStringOperators.put('Greater than or equal to','>=');
    mapNonStringOperators.put('Less than or equal to','<=');
    
    mapDTandOperaters.put('DATE',mapNonStringOperators);
    mapDTandOperaters.put('DATETIME',mapNonStringOperators);
    mapDTandOperaters.put('CURRENCY',mapNonStringOperators);
    mapDTandOperaters.put('NUMBER',mapNonStringOperators);
    mapDTandOperaters.put('PERCENT',mapNonStringOperators);
    mapDTandOperaters.put('TIME',mapNonStringOperators);
    
    Map<String,String> mapBooleanOperators = new Map<String,String>();
    mapBooleanOperators.put('Equals to','=');
    mapBooleanOperators.put('Not equal to','!=');
    mapDTandOperaters.put('BOOLEAN',mapBooleanOperators);
    mapDTandOperaters.put('CHECKBOX',mapBooleanOperators);
    
     Map<String,String> mapGeolocationOperator = new Map<String,String>();
     mapGeolocationOperator.put('Within','<');
     mapDTandOperaters.put('LOCATION',mapGeolocationOperator);
    
    Map<String,String> mapIdAndOperators = new Map<String,String>();
    mapIdAndOperators.put('Equals to','=');
    mapIdAndOperators.put('Not equal to','!=');
    mapIdAndOperators.put('Starts With','Starts');
    
    mapDTandOperaters.put('ID',mapIdAndOperators);
    mapDTandOperaters.put('REFERENCE',mapIdAndOperators);
    
    Map<String,String> mapOption_NINE = new Map<String,String>();
    mapOption_NINE.put('Equals to','=');
    mapOption_NINE.put('Not equal to','!=');
    mapOption_NINE.put('Greater than','>');
    mapOption_NINE.put('Less than','<');
    mapOption_NINE.put('Greater than or equal to','>=');
    mapOption_NINE.put('Less than or equal to','<=');
    mapOption_NINE.put('Starts With','Starts');

    mapDTandOperaters.put('PICKLIST',mapOption_NINE);
    mapDTandOperaters.put('EMAIL',mapOption_NINE);
    mapDTandOperaters.put('PHONE',mapOption_NINE);
    mapDTandOperaters.put('URL',mapOption_NINE);
    mapDTandOperaters.put('STRING',mapOption_NINE);
    mapDTandOperaters.put('TEXTAREA',mapOption_NINE);
    mapDTandOperaters.put('ALL',mapOption_NINE);
    mapDTandOperaters.put('LOOKUP',mapOption_NINE);  ////
    mapDTandOperaters.put('DOUBLE',mapOption_NINE);  
    mapDTandOperaters.put('INTEGER',mapOption_NINE); 

    Map<String,String> mapMultiPicklist = new Map<String,String>();
    mapMultiPicklist.put('Equals to','=');
    mapMultiPicklist.put('Not equal to','!=');
    mapMultiPicklist.put('INCLUDES','INCLUDES');
    mapMultiPicklist.put('EXCLUDES','EXCLUDES');
    mapDTandOperaters.put('MULTIPICKLIST',mapMultiPicklist);
    return mapDTandOperaters ;
    }
    
global static map<String, List<SelectOption>> inilizeDatatypeMap()
{
  map<String, List<SelectOption>> mapFieldOperator = new map<String, List<SelectOption>>();
  List<SelectOption> option_SIX = new List<SelectOption>();
    option_SIX.add(new selectOption('=', 'Equals to'));
    option_SIX.add(new selectOption('!=','Not equal to'));
    option_SIX.add(new selectOption('>', 'Greater than'));
    option_SIX.add(new selectOption('<','Less than'));
    option_SIX.add(new selectOption('>=', 'Greater than or equal to'));
    option_SIX.add(new selectOption('<=', 'Less than or equal to'));
            
    mapFieldOperator.put('DATE',option_SIX);
    mapFieldOperator.put('DATETIME',option_SIX);
    mapFieldOperator.put('CURRENCY',option_SIX);
    mapFieldOperator.put('NUMBER',option_SIX);
    mapFieldOperator.put('PERCENT',option_SIX);
    mapFieldOperator.put('TIME',option_SIX);
           
            
    List<SelectOption> option_ID = new List<SelectOption>();
    option_ID.add(new selectOption('=', 'Equals to'));
    option_ID.add(new selectOption('!=','Not equal to'));
    option_ID.add(new selectOption('Starts','Starts With'));  
            
    mapFieldOperator.put('ID',option_ID);
    mapFieldOperator.put('REFERENCE',option_ID);

    List<SelectOption> option_NINE = new List<SelectOption>();
    option_NINE.add(new selectOption('=', 'Equals to'));
    option_NINE.add(new selectOption('!=','Not equal to'));
    option_NINE.add(new selectOption('>', 'Greater than'));
    option_NINE.add(new selectOption('<','Less than'));
    option_NINE.add(new selectOption('>=', 'Greater than or equal to'));
    option_NINE.add(new selectOption('<=', 'Less than or equal to'));
    option_NINE.add(new selectOption('Starts', 'Starts With'));
            
    mapFieldOperator.put('PICKLIST',option_NINE);
    mapFieldOperator.put('EMAIL',option_NINE);
    mapFieldOperator.put('PHONE',option_NINE);
    mapFieldOperator.put('URL',option_NINE);
    mapFieldOperator.put('STRING',option_NINE);
    mapFieldOperator.put('TEXTAREA',option_NINE);
    mapFieldOperator.put('ALL',option_NINE);
    mapFieldOperator.put('LOOKUP',option_NINE);  ////
    mapFieldOperator.put('DOUBLE',option_NINE);  
    mapFieldOperator.put('INTEGER',option_NINE);  
            
            
    List<SelectOption> option_MultiPicklist = new List<SelectOption>();
    option_MultiPicklist.add(new selectOption('=', 'Equals to'));
    option_MultiPicklist.add(new selectOption('!=','Not equal to'));
    option_MultiPicklist.add(new selectOption('=', 'includes'));
    option_MultiPicklist.add(new selectOption('!=','excludes'));
            
    mapFieldOperator.put('MULTIPICKLIST',option_MultiPicklist);
            
            
    List<SelectOption> option_Boolean = new List<SelectOption>();
    option_Boolean.add(new selectOption('=', 'Equals to'));
    option_Boolean.add(new selectOption('!=','Not equal to'));
            
    mapFieldOperator.put('BOOLEAN',option_Boolean);
    return mapFieldOperator;
}
         
}