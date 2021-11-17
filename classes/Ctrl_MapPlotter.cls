Global with sharing class Ctrl_MapPlotter {
    global set<Id> setRecIdTest = new set<Id>();
    global static String MapPlotterPageUrl
    { get; set;}
    
    global static String namespacevar {
        get {
            return Helper_MPConstants.org_namespaceprefix;
        }
        set;
    }
    global static String clientId {
        get {
            return (/*MapPlotterPremiumSettings__c.getValues('ClientId').Value__c*/'');
        }
        set;
    }
    //V1.2-GKadam Starts-show/hide rate us/review line
    public static String isRated {
        get {
            return (MapPlotterPremiumSettings__c.getValues('IsRated')!=null?MapPlotterPremiumSettings__c.getValues('IsRated').Value__c:'');
        }
        set;
    }
    //GKadam Ends
    public static String googleAPIkey {
        get {
            return (MapPlotterPremiumSettings__c.getValues('GoogleAPIKey')!=null?MapPlotterPremiumSettings__c.getValues('GoogleAPIKey').Value__c:'');
        }
        set;
    }
    //Wrapper Classes
    
    global class MappedObject {
        public String City;
        public String Country;
        public String Entity;
        public String Label;
        public Decimal Pin_No;
        public String Postal_Code;
        public String State;
        public String Street;
        public Boolean IsGeocoded; //Added from MPP 1.11.4
    }
    
    global class MapPoint {
        public String Id;
        public String AddressKey;
        public String City;
        public String Country;
        public String Entity;
        public String GeoCode_Precision;
        public String IsInsert;
        public String Label;
        public Decimal Latitude;
        public Decimal Longitude;
        public String Postal_Code;
        public String RecordID;
        public String State;
        public String Status;
        public String Street;
        public String Color;
        public Datetime CreatedDate;
    }
    
    global class objectMetaData {
        public String ObjectName;
        public List < ObjectFieldData > lstFields;
    }
    
    global Class ObjectFieldData {
        public String label;
        public String Name;
        public String dataType;
        public DatatypeInfo fldDatatypeinfo;
    }
    
    global class DatatypeInfo {
        public string Datatype;
        public List < String > lstpicklistValues;
    }
    
    global class FilterWrapperCls {
        public string fldName {
            get;
            set;
        }
        public string operVal {
            get;
            set;
        }
        public string fldValue {
            get;
            set;
        }
        public string fldDataType {
            get;
            set;
        }
        public string ftype {
            get;
            set;
        }
        public string color {
            get;
            set;
        }
        public Integer index {
            get;
            set;
        }
    }
    
    global class QueryWrapper {
        public string fName {
            get;
            set;
        }
        public string fId {
            get;
            set;
        }
        public string fDesc {
            get;
            set;
        }
        public string baseObj {
            get;
            set;
        }
        public string fLogic {
            get;
            set;
        }
        public string fLogic1 {
            get;
            set;
        }
        public string fLogic2 {
            get;
            set;
        }
        public string fType {
            get;
            set;
        }
        public boolean isCustom {
            get;
            set;
        }
        public List < FilterWrapperCls > filters {
            get;
            set;
        }
    }
    public static String randomNumber{
        get{
            return String.valueOf(Integer.valueOf(Math.random() * 100));
        }
        set;
    }
    global class legendWrapper {
        public string fieldName;
        public string fieldValue;
        public string color;
    }
    
    global class DeltaResult {
        public List < MapPoint > lstInsertedMapPoints;
        public List < MapPoint > lstUpdatedMapPoints;
        public List < MapPoint > lstDeletedMapPoints;
        public Boolean isAddressInfoChanged;
        public Set < String > setInsertedAddressInfo;
        public Set < String > setDeletedAddressInfo;
        public String lastSyncTimeStamp;
        public String lastApexJobComplete;
    }
    
    global Class ObjectDetials {
        public String APIName;
        public String Label;
        public String Type;
    }
    
    public class ReportDetail {
        Id reportId;
        String reportName;
        string filterType;
        string description;
    }
    
    global class ErrorMessage {
        public List < MapPoint > lstMPPoint;
        public String message;
        public boolean hasMoreRecords;
        public String offsetId;
        
    }
    
    global class GeocodedReport {
        public Integer count_pending;
        public Integer count_success;
        public Integer count_failed;
        public List < MapPoint > lstMPPointGeocodeRslt;
    }
    
    //////Constructor
    
    global Ctrl_MapPlotter() {
        //MapPlotterPageUrl = Util.getUrls().get('Map Plotter');
    }
    
    @RemoteAction
    global static String GetObjectMetaData(String selectedObject) {
        try {
            List < ObjectFieldData > lstfields = new List < ObjectFieldData > ();
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
            Map < String, Schema.SObjectField > fieldMapData = ObjectSchema.getDescribe().fields.getMap();
            List < SelectOption > fieldNames = new List < SelectOption > ();
            List < DatatypeInfo > lstDatatype = new list < DatatypeInfo > ();
            for (String fieldName: fieldMapData.keySet()) {
                
                DatatypeInfo dtInfo = new DatatypeInfo();
                ObjectFieldData filedData = new ObjectFieldData();
                Schema.DescribeFieldResult fieldDescribe = fieldMapData.get(fieldName).getDescribe();
                string type = string.valueOf(fieldDescribe.getType());
                filedData.label = fieldMapData.get(fieldName).getDescribe().getLabel();
                filedData.Name = fieldName;
                dtInfo.datatype = type;
                if (!type.equalsIgnoreCase('TextArea') && !type.equalsIgnoreCase('REFERENCE') && !type.equalsIgnoreCase('ADDRESS')) {
                    if (type == 'PICKLIST') {
                        filedData.datatype = type;
                        List < Schema.PicklistEntry > pick_list_values = fieldMapData.get(fieldName).getDescribe().getPickListValues();
                        //grab the list of picklist values for the passed field on the sobject
                        List < String > lstPickListValues = new List < String > ();
                        for (Schema.PicklistEntry a: pick_list_values) {
                            lstPickListValues.add(a.getLabel());
                        }
                        dtInfo.lstpicklistValues = lstPickListValues;
                        filedData.fldDatatypeinfo = dtInfo;
                    } else if (type == 'MULTIPICKLIST') {
                        filedData.datatype = type;
                        List < Schema.PicklistEntry > pick_list_values = fieldMapData.get(fieldName).getDescribe().getPickListValues();
                        //grab the list of picklist values for the passed field on the sobject
                        List < String > lstPickListValues = new List < String > ();
                        for (Schema.PicklistEntry a: pick_list_values) {
                            lstPickListValues.add(a.getLabel());
                        }
                        dtInfo.lstpicklistValues = lstPickListValues;
                        filedData.fldDatatypeinfo = dtInfo;
                    } else if (type == 'BOOLEAN') {
                        filedData.datatype = type;
                        List < String > lstPickListValues = new List < String > ();
                        lstPickListValues.add('True');
                        lstPickListValues.add('False');
                        dtInfo.lstpicklistValues = lstPickListValues;
                        filedData.fldDatatypeinfo = dtInfo;
                    } else {
                        
                        filedData.datatype = type;
                    }
                    
                    lstfields.add(filedData);
                }
            }
            return json.serialize(lstfields);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            return null;
        }
    }
    
    @RemoteAction
    global static String GetOperators() {
        try {
            filterHelper op = new filterHelper();
            Map < String, Map < String, String >> mapOperatorjson = op.GetOperators();
            if (mapOperatorjson != null) {
                return json.serialize(mapOperatorjson);
            }
            return null;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            return null;
        }
    }
    @RemoteAction
    global static string editFilter(string filterId) {
        try {
            MP_MapFilter__c editFilter = new MP_MapFilter__c();
            QueryWrapper filterDetails = new QueryWrapper();
            if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                'Name',
                    'Expression__c',
                    'Expression1__c',
                    'Type__c',
                    'isCustomExpression__c',
                    'Description__c',
                    'Filter_Criteria__c',
                    'MP_CustomMapping__c'
                    })) {
                        editFilter = [select name, MP_CustomMapping__c, Type__c, isCustomExpression__c, Expression__c, Expression1__c, MP_CustomMapping__r.entity__c, Description__c, Filter_Criteria__c from MP_MapFilter__c where id = : String.escapeSingleQuotes(filterId)];
                    }
            if (editFilter != null) {
                filterDetails.fName = editFilter.Name;
                filterDetails.fDesc = editFilter.Description__c; 
                filterDetails.baseObj = editFilter.MP_CustomMapping__r.entity__c; 
                filterDetails.fLogic = editFilter.Expression__c; 
                filterDetails.fLogic1 = editFilter.Expression__c;
                filterDetails.fLogic2 = editFilter.Expression1__c;
                filterDetails.fType = editFilter.Type__c;
                filterDetails.fId = editFilter.Id; 
                filterDetails.isCustom = editFilter.isCustomExpression__c;
                filterDetails.filters = (List < FilterWrapperCls > ) JSON.deSerialize(editFilter.Filter_Criteria__c, List < FilterWrapperCls > .class);
                return JSON.serialize(filterDetails);
            } else {
                return null;
            }
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    public static string createQueryConditionNew(string queryExpression, List < FilterWrapperCls > criteriaList) {
        try {
            String expression = String.escapeSingleQuotes(queryExpression);
            map < Integer, string > conditionMap = new map < Integer, string > ();
            Map < String, String > mapStringToOperator = new Map < String, String > ();
            mapStringToOperator.put('Equals to', '=');
            mapStringToOperator.put('Not equal to', '!=');
            mapStringToOperator.put('Greater than', '>');
            mapStringToOperator.put('Less than', '<');
            mapStringToOperator.put('Greater than or equal to', '>=');
            mapStringToOperator.put('Less than or equal to', '<=');
            mapStringToOperator.put('Starts With', 'Starts');
            mapStringToOperator.put('INCLUDES', 'INCLUDES');
            mapStringToOperator.put('EXCLUDES', 'EXCLUDES');
            mapStringToOperator.put('Within', '<');
            string queryString;
            for (Integer i = 0; i < criteriaList.size(); i++) {
                FilterWrapperCls criteria = criteriaList[i];
                String operatorValue = mapStringToOperator.get(criteria.operVal);
                if (operatorValue.equalsIgnoreCase('NotContains')) {
                    queryString = 'NOT ' + string.escapeSingleQuotes(criteria.fldName) + ' ';
                    queryString += 'LIKE \'%' + string.escapeSingleQuotes(criteria.fldValue) + '%\'';
                } else {
                    if (criteria.fldDataType.equalsIgnoreCase('DATETIME')) {
                        //Datetime field is converted into Date only using Day_Only() function
                        queryString = 'DAY_ONLY(' + string.escapeSingleQuotes(criteria.fldName) + ')' + ' ';
                    }
                    //V1.1- TanmayD Starts: Code change for multiple picklist values
                    else if (criteria.fldDataType.equalsIgnoreCase('PICKLIST') || criteria.fldDataType.equalsIgnoreCase('MULTIPICKLIST')) {
                        String fldValueForQuery = '';
                        List < String > fldValueList = criteria.fldValue.split(';');
                        if (fldValueList.size() > 0) {
                            for (String fldVal: fldValueList) {
                                fldValueForQuery += '\'' + string.escapeSingleQuotes(fldVal) + '\',';
                            }
                            fldValueForQuery = fldValueForQuery.removeEnd(',');
                        }
                        if (criteria.operVal.equalsIgnoreCase('Equals to')) {
                            queryString = string.escapeSingleQuotes(criteria.fldName) + ' IN (' + fldValueForQuery + ')';
                        } else if (criteria.operVal.equalsIgnoreCase('Not equal to')) {
                            queryString = string.escapeSingleQuotes(criteria.fldName) + ' NOT IN (' + fldValueForQuery + ')';
                        } else if (operatorValue.equalsIgnoreCase('INCLUDES')) {
                            queryString = string.escapeSingleQuotes(criteria.fldName) + ' INCLUDES (' + fldValueForQuery + ') ';
                        } else if (criteria.operVal.equalsIgnoreCase('EXCLUDES')) {
                            queryString = string.escapeSingleQuotes(criteria.fldName) + ' EXCLUDES (' + fldValueForQuery + ')';
                        }
                    }
                    //TanmayD Ends
                    else {
                        queryString = string.escapeSingleQuotes(criteria.fldName) + ' ';
                    }
                    
                    if (!(criteria.fldDataType.equalsIgnoreCase('PICKLIST') || criteria.fldDataType.equalsIgnoreCase('MULTIPICKLIST'))) {
                        if (operatorValue.equalsIgnoreCase('Starts')) {
                            queryString += 'LIKE \'' + string.escapeSingleQuotes(criteria.fldValue) + '%\'';
                        } else if (operatorValue.equalsIgnoreCase('Contains')) {
                            queryString += 'LIKE \'%' + string.escapeSingleQuotes(criteria.fldValue) + '%\'';
                        } else if (operatorValue.equalsIgnoreCase('INCLUDES')) {
                            queryString += 'INCLUDES (\'' + string.escapeSingleQuotes(criteria.fldValue) + '\')';
                        } else if (operatorValue.equalsIgnoreCase('EXCLUDES')) {
                            queryString += 'EXCLUDES (\'' + string.escapeSingleQuotes(criteria.fldValue) + '\')';
                        } else {
                            queryString += string.escapeSingleQuotes(operatorValue) + ' ';
                            if (checkFieldType(criteria.fldDataType)) {
                                //value enclosed in single quotes
                                queryString += '\'' + string.escapeSingleQuotes(criteria.fldValue) + '\'';
                            } else {
                                queryString += string.escapeSingleQuotes(criteria.fldValue) + '';
                            }
                        }
                    }
                    integer criteriaIndex = Integer.valueOf(criteria.index);
                    conditionMap.put(criteriaIndex, queryString);
                    expression = expression.replaceFirst(string.valueOf(criteriaIndex), 'condition' + (criteriaIndex));
                }
            }
            for (Integer i: conditionMap.keySet()) {
                expression = expression.replaceFirst('condition' + string.valueOf(i), conditionMap.get(i));
            }
            return expression;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    //Return the filtered result
    static Map < Id, Sobject > getRecordsNew(string objectName, string expression, List < FilterWrapperCls > criteriaList, Id offsetId) {
        try {
            String queryString; 
            string objName = string.escapeSingleQuotes(objectName);
            Set<String> setCriteriaName= new Set<String>();
            if (offsetId == null) {
                queryString = 'select id ';
                System.debug('criteriaList[0].fldName>>>'+criteriaList[0].fldName);
                
                for(FilterWrapperCls criteria : criteriaList){
                    System.debug('criteriaList[0].fldName>>>'+criteria.fldName);
                    //Code by Rakesh -  Added condition in below to fix issue of adding duplicate field in select list
                    if (!string.escapeSingleQuotes(criteria.fldName).equalsIgnoreCase('Id') && !setCriteriaName.contains(criteria.fldName)){
                        queryString += ', ' + string.escapeSingleQuotes(criteria.fldName);
                        setCriteriaName.add(criteria.fldName);
                    }
                }
                queryString += ' from ' + string.escapeSingleQuotes(objectName);
                queryString += ' where ' + createQueryConditionNew(expression, criteriaList);
                queryString += ' ORDER BY Id ASC LIMIT 2000';
            } else {
                queryString = 'select id ';
               for(FilterWrapperCls criteria : criteriaList){
                    //Code by Rakesh -  Added condition in below to fix issue of adding duplicate field in select list
                    if (!string.escapeSingleQuotes(criteria.fldName).equalsIgnoreCase('Id') && !setCriteriaName.contains(criteria.fldName)){
                        queryString += ', ' + string.escapeSingleQuotes(criteria.fldName);
                        setCriteriaName.add(criteria.fldName);
                    }
                }
                queryString += ' from ' + string.escapeSingleQuotes(objectName);
                queryString += ' where ' + createQueryConditionNew(expression, criteriaList);
                queryString += ' AND id > \'' + offsetId + '\'';
                queryString += ' ORDER BY Id ASC LIMIT 2000';
            }
            system.debug('queryString== '+queryString);
            if (util.getReadAccessCheck(objName, new List < string > {
                'id'
                    })) {
                        List < Sobject > queryResult = (List < Sobject > ) database.query(queryString);
                        Map < Id, Sobject > queryResultMap = new Map < Id, Sobject > (queryResult);
                        system.debug('queryResultMap==='+queryResultMap.size());
                        return queryResultMap;                        
                    } else {
                        return null;
                    }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    @RemoteAction
    Global Static Boolean SaveAndRunFilter(String expression) {
        try {
            String strExpression = string.escapeSingleQuotes(expression);
            QueryWrapper querycls = new QueryWrapper();
            querycls = (QueryWrapper) JSON.deserialize(strExpression, QueryWrapper.class);
            List < FilterWrapperCls > criteriaList = new List < FilterWrapperCls > ();
            MP_CustomMapping__c mappedObj = new MP_CustomMapping__c();
            MP_MapFilter__c newFilter = new MP_MapFilter__c();
            Integer i = 1;
            for (FilterWrapperCls criteria: querycls.filters) {
                criteria.index = i;
                i++;
                criteriaList.add(criteria);
            }
            if (Util.getReadAccessCheck('MP_CustomMapping__c', new List < string > {
                'Entity__c',
                    'name'
                    })) {
                        mappedObj = [select id, Name, entity__c from MP_CustomMapping__c where entity__c = : String.escapeSingleQuotes(querycls.baseObj)];
                    }
            querycls.fLogic = '( ' + String.escapeSingleQuotes(querycls.fLogic1) + ' ) ';
            if (String.isNotBlank(querycls.fLogic2)) {
                querycls.fLogic += ' and ( ' + String.escapeSingleQuotes(querycls.fLogic2) + ' )';
            }
            Map < Id, Sobject > filvalue = getRecordsNew(mappedObj.entity__c, querycls.fLogic, querycls.filters, null);
            if (filvalue != null) {
                newFilter.Name = String.escapeSingleQuotes(querycls.fName);
                newFilter.Description__c = String.escapeSingleQuotes(querycls.fDesc);
                newFilter.Expression__c = String.escapeSingleQuotes(querycls.fLogic1);
                if (querycls.fLogic2 != null) {
                    newFilter.Expression1__c = String.escapeSingleQuotes(querycls.fLogic2);
                } else {
                    newFilter.Expression1__c = '';
                }
                newFilter.Type__c = String.escapeSingleQuotes(querycls.fType);
                newFilter.Filter_Criteria__c = JSON.serialize(querycls.filters);
                newFilter.isCustomExpression__c = querycls.isCustom;
                newFilter.MP_CustomMapping__c = mappedObj.Id;
                if (querycls.fId != null) {
                    newFilter.Id = String.escapeSingleQuotes(querycls.fId);
                }
                if (Util.getCreateAccessCheck('MP_MapFilter__c', new List < string > {
                    'Name',
                        'Expression__c',
                        'Expression1__c',
                        'Type__c',
                        'isCustomExpression__c',
                        'Description__c',
                        'Filter_Criteria__c',
                        'MP_CustomMapping__c'
                        }) && Util.getUpdateAccessCheck('MP_MapFilter__c', new List < string > {
                            'Name',
                                'Expression__c',
                                'Expression1__c',
                                'Type__c',
                                'isCustomExpression__c',
                                'Description__c',
                                'Filter_Criteria__c',
                                'MP_CustomMapping__c'
                                })) {
                                    upsert newFilter;
                                }
                return true;
            }
            return false;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    
    @RemoteAction
    Global static string GetFilterLegend(string selectedFilterId) {
        try {
            MP_MapFilter__c selectedFilter = new MP_MapFilter__c();
            if (Util.getCreateAccessCheck('MP_MapFilter__c', new List < string > {
                'Name',
                    'Expression__c',
                    'Expression1__c',
                    'Type__c',
                    'isCustomExpression__c',
                    'Description__c',
                    'Filter_Criteria__c',
                    'MP_CustomMapping__c'
                    })) {
                        selectedFilter = [select name, MP_CustomMapping__c, expression__c, Expression1__c, Type__c, isCustomExpression__c, MP_CustomMapping__r.entity__c, Description__c, Filter_Criteria__c from MP_MapFilter__c where id = : String.escapeSingleQuotes(selectedFilterId)];
                    }
            List < FilterWrapperCls > filterCriteriaList = (List < FilterWrapperCls > ) JSON.deserialize(selectedFilter.Filter_Criteria__c, List < FilterWrapperCls > .class);
            List < FilterWrapperCls > criteriaList = new List < FilterWrapperCls > ();
            criteriaList = (List < FilterWrapperCls > ) JSON.deSerialize(selectedFilter.Filter_Criteria__c, List < FilterWrapperCls > .class);
            List < legendWrapper > legendWrapperList = new List < legendWrapper > ();
            for (FilterWrapperCls criteria: criteriaList) {
                legendWrapper legend = new legendWrapper();
                legend.fieldName = Schema.getGlobalDescribe().get(selectedFilter.MP_CustomMapping__r.entity__c).getDescribe().fields.getMap().get(criteria.fldName).getDescribe().getLabel();
                legend.fieldValue = criteria.fldValue;
                legend.color = criteria.color;
                legendWrapperList.add(legend);
            }
            return JSON.serialize(legendWrapperList);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    @RemoteAction
    Global static string GetSFReportData(string selectedFilterId, id offsetId) {
        ErrorMessage errorHandler = new ErrorMessage();
        try {
            if (selectedFilterId != null) {
                MP_MapFilter__c selectedFilter = new MP_MapFilter__c();
                List < Id > lstrecords = new List < Id > ();
                List < MapPoint > lstMPMapPoint = new List < MapPoint > ();
                if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                    'MP_CustomMapping__c',
                        'name',
                        'isCustomExpression__c',
                        'Expression__c',
                        'Expression1__c',
                        'Type__c',
                        'Description__c',
                        'Filter_Criteria__c'
                        })) {
                            selectedFilter = [select name, MP_CustomMapping__c, expression__c, expression1__c, Type__c, isCustomExpression__c, MP_CustomMapping__r.entity__c, Description__c, Filter_Criteria__c from MP_MapFilter__c where id = : String.escapeSingleQuotes(selectedFilterId) Limit 1];
                        }
                if (selectedFilter != null) {
                    List < FilterWrapperCls > filterCriteriaList = (List < FilterWrapperCls > ) JSON.deserialize(selectedFilter.Filter_Criteria__c, List < FilterWrapperCls > .class);
                    String filterLofic = '( ' + selectedFilter.expression__c + ' )';
                    
                    if (String.isNotBlank(selectedFilter.expression1__c)) {
                        filterLofic += ' and ( ' + selectedFilter.expression1__c + ' )';
                    }
                    Map < Id, Sobject > recordIdList = getRecordsNew(selectedFilter.MP_CustomMapping__r.entity__c, filterLofic, filterCriteriaList, offsetId);
                    
                    if (recordIdList != null) {
                        lstrecords.addAll(recordIdList.keySet());
                    }
                    if (recordIdList == null || recordIdList.size() == 0) {
                        errorHandler.hasMoreRecords = false;
                        errorHandler.lstMPPoint = null;
                        errorHandler.offsetId = null;
                        errorHandler.message = 'No records matching query condition';
                        return json.serialize(errorHandler);
                    }
                    List < MP_Map_Point__c > lstMPPointSearchresult = Helper_SOQL.GetMapPointsForRecordsIds(recordIdList.keySet());
                    List < FilterWrapperCls > criteriaList;
                    if (selectedFilter.Type__c == Helper_MPConstants.COLORED_FILTER) {
                        criteriaList = new List < FilterWrapperCls > ();
                        criteriaList = (List < FilterWrapperCls > ) JSON.deSerialize(selectedFilter.Filter_Criteria__c, List < FilterWrapperCls > .class);
                    }
                    if (lstMPPointSearchresult.size() > 0) {
                        for (MP_Map_Point__c mpPoint: lstMPPointSearchresult) {
                            MapPoint mp = new MapPoint();
                            mp.Id = mpPoint.Id;
                            if (selectedFilter.Type__c == Helper_MPConstants.COLORED_FILTER) {
                                string fieldValue = string.valueOf(recordIdList.get(mpPoint.RecordId__c).get(criteriaList[0].fldName));
                                
                                
                                for (FilterWrapperCls criteria: criteriaList) {
                                    if (criteriaList[0].fldDataType == 'DATE') {
                                        if (date.valueOf(criteria.fldValue) == date.valueOf(fieldValue))
                                            mp.color = criteria.color;
                                    }
                                    if (criteriaList[0].fldDataType == 'DOUBLE') {
                                        if (double.valueOf(criteria.fldValue) == double.valueOf(fieldValue))
                                            mp.color = criteria.color;
                                    } else {
                                        if (criteria.fldValue.equalsIgnoreCase(fieldValue) && criteria.ftype.equalsIgnoreCase('colored')) {
                                            mp.color = criteria.color;
                                            
                                        }
                                    }
                                }
                                
                            }
                            mp.AddressKey = mpPoint.AddressKey__C;
                            mp.Entity = mpPoint.Entity__c;
                            mp.Latitude = mpPoint.Latitude__c;
                            mp.Longitude = mpPoint.Longitude__c;
                            mp.RecordId = mpPoint.RecordId__c;
                            mp.Label = mpPoint.Label__c;
                            mp.Country = mpPoint.Country__c;
                            mp.State = mpPoint.State__c;
                            mp.City = mpPoint.City__c;
                            mp.Street = mpPoint.Street__c;
                            mp.Status = mpPoint.Status__c;
                            mp.Postal_Code = mpPoint.Postal_Code__c;
                            mp.CreatedDate = mpPoint.CreatedDate;
                            lstMPMapPoint.add(mp);
                        }
                    }
                    if (recordIdList.size() > 0 && lstMPMapPoint.size() == 0) {
                        if (recordIdList.size() == 2000) {
                            errorHandler.hasMoreRecords = true;
                            errorHandler.offsetId = lstrecords[(lstrecords.size()) - 1];
                        } else {
                            errorHandler.hasMoreRecords = false;
                            errorHandler.offsetId = null;
                        }
                        errorHandler.lstMPPoint = null;
                        errorHandler.message = 'No records from query were successfully geocoded.';
                        return json.serialize(errorHandler);
                    } else {
                        if (recordIdList.size() == 2000) {
                            errorHandler.hasMoreRecords = true;
                            errorHandler.offsetId = lstrecords[(lstrecords.size()) - 1];
                        } else {
                            errorHandler.hasMoreRecords = false;
                            errorHandler.offsetId = null;
                        }
                        errorHandler.lstMPPoint = lstMPMapPoint;
                        errorHandler.message = '';
                        return json.serialize(errorHandler);
                    }
                } else {
                    errorHandler.hasMoreRecords = false;
                    errorHandler.lstMPPoint = null;
                    errorHandler.offsetId = null;
                    errorHandler.message = 'You do not have the filter';
                    return json.serialize(errorHandler);
                }
            } else {
                errorHandler.hasMoreRecords = false;
                errorHandler.lstMPPoint = null;
                errorHandler.offsetId = null;
                errorHandler.message = 'You do not have the filter';
                return json.serialize(errorHandler);
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            errorHandler.hasMoreRecords = false;
            errorHandler.lstMPPoint = null;
            errorHandler.offsetId = null;
            errorHandler.message = 'Something went wrong';
            return json.serialize(errorHandler);
        }
    }
    
    @RemoteAction
    global static boolean deleteFilter(string filterId) {
        try {
            if (MP_MapFilter__c.sObjectType.getDescribe().isDeletable()) {
                MP_MapFilter__c filterObj = new MP_MapFilter__c(id = String.escapeSingleQuotes(filterId));
                delete filterObj;
                return true;
            } else {
                return false;
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    
    static Boolean checkFieldType(string dataType) {
        try {
            if (dataType == 'STRING' || dataType == 'EMAIL' || dataType == 'ID' || dataType == 'TEXTAREA' || dataType == 'PICKLIST' || dataType == 'MULTIPICKLIST' || dataType == 'PHONE' || dataType == 'REFERENCE')
                return true;
            return false;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    
    @remoteAction
        global static string GetSFReportList() {
        try {
            list < ReportDetail > filterOptionList = new list < ReportDetail > ();
            List < MP_MapFilter__c > filterList = new list < MP_MapFilter__c > ();
            if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                'name',
                    'MP_CustomMapping__c',
                    'Expression__c',
                    'isCustomExpression__c',
                    'Description__c',
                    'Filter_Criteria__c',
                    'Type__c'
                    })) {
                        //Added by Rakesh - Modified below query to make filters visible to only the creator or the system admin user.
                        String qry='select name, MP_CustomMapping__c, expression__c, isCustomExpression__c, MP_CustomMapping__r.entity__c, Description__c, Filter_Criteria__c, Type__c from MP_MapFilter__c ';
                        String whrCls ='' ;
                        String loggedInProfile = [SELECT Profile.name FROM User where Id =: UserInfo.getUserId()].Profile.name; 
                        
                        if(loggedInProfile != 'System Administrator')
                            whrCls= ' where createdbyId=' + '\'' +userinfo.getuserid() + '\'   limit 500 '  ;
                        else
                            whrCls= ' limit 500 '  ;
                        
                        qry =qry + whrCls;
                        system.debug('qry::'+qry);
                        filterList=Database.query(qry);
                        //filterList = [select name, MP_CustomMapping__c, expression__c, isCustomExpression__c, MP_CustomMapping__r.entity__c,  Description__c, Filter_Criteria__c, Type__c from MP_MapFilter__c limit 500];
                    }
            for (MP_MapFilter__c filter: filterList) {
                ReportDetail detail = new ReportDetail();
                detail.reportId = filter.Id;
                detail.reportName = filter.Name;
                detail.description = filter.Description__c;
                detail.filterType = filter.Type__c;
                filterOptionList.add(detail);
            }            
            return json.serialize(filterOptionList);
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }

    ///To identify weather the org is sandbox or Not
    @ deprecated @remoteAction
        Global static boolean OrgIsSandbox() {
            return false;
            
        }
    //Save Geocoding API Setting
    @RemoteAction
    Global Static String SaveGeoCodingAPIKey(String geocodingAPIKey, Boolean isAPIKeyValid, Boolean isKeyLimiExceeded) {
        try {
            Map < String, MapPlotterPremiumSettings__c > mapCustomSetting = MapPlotterPremiumSettings__c.getAll();
            MapPlotterPremiumSettings__c settingGoogleAPIKey = mapCustomSetting.get('GoogleAPIKey');
            settingGoogleAPIKey.Value__c = geocodingAPIKey;
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE settingGoogleAPIKey;
            
            MapPlotterPremiumSettings__c settingIsKeyValid = mapCustomSetting.get('IsGoogleKeyValid');
            if (isAPIKeyValid) {
                settingIsKeyValid.Value__c = 'Yes';
            } else {
                settingIsKeyValid.Value__c = 'No';
            }
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE settingIsKeyValid;
            
            MapPlotterPremiumSettings__c settingIsKeyLimitExceeded = mapCustomSetting.get('IsGoogleAPIQueryLimitExceeded');
            if (!isKeyLimiExceeded) {
                settingIsKeyLimitExceeded.Value__c = 'No';
            } else {
                settingIsKeyLimitExceeded.Value__c = 'Yes';
            }
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE settingIsKeyLimitExceeded;
            return 'true';
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    //Save World Weather API Setting
    
    @RemoteAction
    Global Static String SaveWeatherKey(String weatherAPIKey) {
        try {
            MapPlotterPremiumSettings__c weatherKey = MapPlotterPremiumSettings__c.getValues('DarkSkyForecastKey');
            weatherKey.Value__c = weatherAPIKey;
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            UPDATE weatherKey;
            return 'true';
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
        
    }
    
    // Remote method for getting Mapped Objects.
    
    @RemoteAction
    Global static String GetSelectedDataPoints() {
        try {
            List < MappedObject > lstMappedObj = new List < MappedObject > ();
            List < MP_CustomMapping__c > lstSelectdObjects = Helper_SOQL.GetCustomMappingObjects();
            For(MP_CustomMapping__c mappedObj: lstSelectdObjects) {
                MappedObject mObject = new MappedObject();
                mObject.Label = mappedObj.Label__c;
                mObject.Entity = mappedObj.Entity__c;
                mObject.Country = mappedObj.Country__c;
                mObject.State = mappedObj.State__c;
                mObject.City = mappedObj.City__c;
                mObject.Street = mappedObj.Street__c;
                mObject.Postal_Code = mappedObj.postal_code__C;
                mObject.Pin_No = mappedObj.Pin_No__c;
                mObject.IsGeocoded = mappedObj.IsGeocode__c; //Tells geocoding status  //MPP 1.11.4
                
                lstMappedObj.add(mObject);
            }
            if (lstMappedObj != null) {
                return json.serialize(lstMappedObj);
                
            }
            return null;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    // Remote method for getting list of objects
    
    @RemoteAction
    Global static String Getobjects() {
        try {
            List < String > lstObject = new List < String > ();
            List < MP_CustomMapping__c > LstOfObjects = Helper_SOQL.GetCustomMappingObjects();
            
            Set < String > setcustomMappingObject = new Set < String > ();
            if (LstOfObjects != null) {
                For(MP_CustomMapping__c mapping: LstOfObjects) {
                    setcustomMappingObject.add(mapping.entity__C);
                }
            }
            map < String, schema.SObjecttype > mapObjects = schema.getGlobalDescribe();
            List < ObjectDetials > lstobjDetail = new List < ObjectDetials > ();
            
            for (Schema.SObjectType objectType: mapObjects.values()) {
                Schema.DescribeSObjectResult objectDescription = objectType.getDescribe();
                // fetching only those object which are creatable,searcable & not custom setting
                if (!objectDescription.isCreateable() || objectDescription.isCustomSetting()|| !objectDescription.isSearchable()) {
                    continue;
                }
                
                if (objectDescription.getname() != Helper_MPConstants.org_namespaceprefix + 'MP_CustomMapping__c' && objectDescription.getname() != Helper_MPConstants.org_namespaceprefix + 'MP_Map_Point__C' && objectDescription.getname() != Helper_MPConstants.org_namespaceprefix + 'MP_AddressInfo__c' && objectDescription.getname() != Helper_MPConstants.org_namespaceprefix + 'MP_MapFilter__c') {
                    if (!setcustomMappingObject.contains(objectDescription.getname())) {
                        
                        ObjectDetials objDetail = new ObjectDetials();
                        objDetail.APIName = objectDescription.getName();
                        objDetail.Label = objectDescription.getLabel();
                        lstobjDetail.add(objDetail);
                    }
                }
                
            }
            return JSON.serialize(lstobjDetail);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    // Get the list of fields for Selected objects
    
    @RemoteAction
    Global static String Getfields(String objName) {
        try {
            List < ObjectDetials > lstfieldDetail = new List < ObjectDetials > ();
            map < string, schema.sobjecttype > describe = schema.getglobaldescribe(); 
            if (describe.containskey(objName)) {
                map < string, schema.sobjectfield > fieldmap = describe.get(objName).getdescribe().fields.getmap();
                for (string fieldname: fieldmap.keyset()) {
                    ObjectDetials fieldDetail = new ObjectDetials();
                    fieldDetail.APIName = fieldmap.get(fieldname).getdescribe().getname();
                    fieldDetail.label = fieldmap.get(fieldname).getdescribe().getlabel();
                    fieldDetail.Type = string.valueOf(fieldmap.get(fieldname).getdescribe().getType());
                    if (fieldDetail.Type == 'REFERENCE' || fieldDetail.Type == 'STRING' || fieldDetail.Type == 'TEXTAREA' || fieldDetail.Type == 'DOUBLE' || fieldDetail.Type == 'PICKLIST') {
                        lstfieldDetail.add(fieldDetail);
                    }
                }
            }
            return JSON.serialize(lstfieldDetail);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    ///Get List Of Mapped Objects for Geocoding Report
    
    @RemoteAction
    Global static String GetLstObjectReports() {
        try {
            List < String > options = new List < String > ();
            List < MP_CustomMapping__c > lstCustomSetting = Helper_SOQL.GetCustomMappingObjects();
            for (MP_CustomMapping__c mappedRec: lstCustomSetting) {
                options.add(mappedRec.Entity__c);
            }
            return JSON.serialize(options);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    //Method to create auto mapping for Account,contact and lead objects
    
    public static List < MP_CustomMapping__c > createAutoMapping() {
        List < MP_CustomMapping__c > customMappingToInsert = new List < MP_CustomMapping__c > ();
        try {
            List < MP_CustomMapping__c > LstOfObjects = Helper_SOQL.GetCustomMappingObjects();
            Set < String > alreadyMappedObjects = new Set < String > ();
            if (LstOfObjects != null && LstOfObjects.size() > 0) {
                for (MP_CustomMapping__c mappingObj: LstOfObjects) {
                    alreadyMappedObjects.add(mappingObj.Entity__c);
                }
            }
            if (!alreadyMappedObjects.contains('Lead')) {
                customMappingToInsert.add(new MP_CustomMapping__c(Pin_No__c = 1, Entity__c = 'Lead', Label__c = 'LastName', Country__c = 'Country', State__c = 'State', City__c = 'City', Street__c = 'Street', Postal_code__c = 'PostalCode'));
            }
            
            if (!alreadyMappedObjects.contains('Account')) {
                customMappingToInsert.add(new MP_CustomMapping__c(Pin_No__c = 2, Entity__c = 'Account', Label__c = 'Name', Country__c = 'BillingCountry', State__c = 'BillingState', City__c = 'BillingCity', Street__c = 'BillingStreet', Postal_code__c = 'BillingPostalCode'));
            }
            
            if (!alreadyMappedObjects.contains('Contact')) {
                customMappingToInsert.add(new MP_CustomMapping__c(Pin_No__c = 3, Entity__c = 'Contact', Label__c = 'LastName', Country__c = 'MailingCountry', State__c = 'MailingState', City__c = 'MailingCity', Street__c = 'MailingStreet', Postal_code__c = 'MailingPostalCode'));
            }
            
            if (customMappingToInsert != null && customMappingToInsert.size() > 0) {
                
                if (Util.getCreateAccessCheck('MP_CustomMapping__c', new List < string > {
                    'Entity__c',
                        'Label__c',
                        'Country__c',
                        'State__c',
                        'City__c',
                        'Street__c',
                        'Postal_code__C',
                        'Pin_No__c'
                        })) {
                            INSERT customMappingToInsert;
                        }
            }
            
            List < CronTrigger > CronTriggerScheduledJobs = [SELECT id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = : Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME LIMIT 1];
            if (CronTriggerScheduledJobs.size() == 0) {
                Schedule_Refresh_API_Quaota_Value schedulerForRefresh_API_Quota_Value = new Schedule_Refresh_API_Quaota_Value();
                datetime dt = DateTime.newInstanceGMT(2015, 5, 31, 07, 0, 0);
                String cronExpression = '0 ' + dt.minute() + ' ' + dt.hour() + ' * * ?';
                system.schedule(Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME, cronExpression, schedulerForRefresh_API_Quota_Value);
            }
            
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
        }
        
        return customMappingToInsert;
    }
    
    // Remote method for getting Mapped Objects.
    @RemoteAction
    Global static String SaveMapping(String currentobject, String label, String country, String state, String city, String street, String postalcode) {
        try {
            List < MP_CustomMapping__c > LstOfObjects = Helper_SOQL.GetCustomMappingObjects();
            if (LstOfObjects.size() < 10) {
                MP_CustomMapping__c mapping = new MP_CustomMapping__c();
                mapping.Entity__c = currentobject;
                mapping.Label__c = String.valueof(label);
                mapping.Country__c = String.valueof(country);
                mapping.State__c = String.valueof(state);
                mapping.City__c = String.valueof(city);
                mapping.Street__c = String.valueof(street);
                mapping.Postal_code__C = String.valueof(postalcode);
                Integer countPinNo = 0;
                String ObjName = mapping.Entity__c;
                if (ObjName.endsWith('__c')) {
                    ObjName = ObjName.removeEnd('__c');
                }
                ObjName = ObjName.replace('__', '_');
                List<String> pkgCheckList = new List<String>();
                pkgCheckList.add('Map_Plotter_Setting');
                pkgCheckList.add(Helper_MPConstants.org_namespaceprefix+'Map_Plotter_Setting');
                //-------------------code for managed pkg------------------------
                String mppTriggerName = 'TriggerMPGeocode'+ObjName , mpfTriggerName = 'TriggerSIMGeocode'+ObjName, mpv2TriggerName = 'TriggerMPV2Geocode'+ObjName;
                Integer SIMTriggerCount = [SELECT COUNT() FROM ApexTrigger WHERE Name=: mppTriggerName OR Name=: mpfTriggerName OR Name=:mpv2TriggerName ];
                
                if(SIMTriggerCount == 0){
                    String Triggerbody = '/*******Trigger Name : TriggerMPV2Geocode' + ObjName + '  Author : Shilpa kamble Date : 25/8/2015 Details : Dynamically generated tigger on object to insert,update & delete the map point *********************************/ ';
                    Triggerbody += 'Trigger TriggerMPV2Geocode' + ObjName + ' on ' + mapping.Entity__c + '(after Update,before delete,after insert,after undelete,after delete){';
                    Triggerbody += 'List < Extentia_SIM__MP_CustomMapping__c > MappingList = [SELECT Name FROM Extentia_SIM__MP_CustomMapping__c WHERE Extentia_SIM__Entity__c =\''+ mapping.Entity__c +'\' LIMIT 1];';
                    Triggerbody += 'String CSName = \'Extentia_SIM__MapPlotterTriggerSettings__c\';';
                    Triggerbody += 'String fldName = \'Extentia_SIM__Bypass_Trigger__c\';';
                    Triggerbody += 'String triggerName = \'Bypass '+ObjName+' Trigger\';';
                    Triggerbody += 'boolean skip = false;';
                    Triggerbody += 'List<Sobject> lstObj = new List<Sobject>();';
                    Triggerbody += 'if(!Test.isRunningTest()){';
                    Triggerbody += 'String query = \'SELECT Id, Name FROM \'+CSName+\' WHERE Name =: triggerName AND \'+fldName+\' = true \';';
                    Triggerbody += 'lstObj = Database.query(query);}';
                    Triggerbody += 'String strTriggerEvent;';
                    Triggerbody += 'List < ApexPage > pageList = [SELECT Name FROM ApexPage WHERE Name IN (\'Map_Plotter_Setting\', \''+Helper_MPConstants.org_namespaceprefix+'Map_Plotter_Setting\')];';
                    Triggerbody += 'if(!pageList.isempty() && !MappingList.isEmpty()){';
                    Triggerbody += 'if(lstObj.size() > 0){';
                    Triggerbody += 'skip = true;}';
                    Triggerbody += 'if(!skip){';
                    Triggerbody += 'if(trigger.isUpdate){';
                    Triggerbody += 'strTriggerEvent = '+Helper_MPConstants.orgNamespace+'.Helper_MPConstants.EVENT_UPDATE;';
                    Triggerbody += Helper_MPConstants.orgNamespace+'.Helper_Geocode.TriggerHandler(Trigger.new,strTriggerEvent);}';
                    Triggerbody += 'if(trigger.isInsert){';
                    Triggerbody += 'strTriggerEvent ='+Helper_MPConstants.orgNamespace+'.Helper_MPConstants.EVENT_INSERT;';
                    Triggerbody += Helper_MPConstants.orgNamespace+'.Helper_Geocode.TriggerHandler(Trigger.new,strTriggerEvent);}';
                    Triggerbody += 'if(trigger.isDelete){';
                    Triggerbody += 'strTriggerEvent = '+Helper_MPConstants.orgNamespace+'.Helper_MPConstants.EVENT_DELETE;';
                    Triggerbody += Helper_MPConstants.orgNamespace+'.Helper_Geocode.TriggerHandler(Trigger.old,strTriggerEvent);}';
                    Triggerbody += 'if(trigger.isUndelete){';
                    Triggerbody += 'strTriggerEvent = '+Helper_MPConstants.orgNamespace+'.Helper_MPConstants.EVENT_UNDELETE;';
                    Triggerbody += Helper_MPConstants.orgNamespace+'.Helper_Geocode.TriggerHandler(Trigger.new,strTriggerEvent);}}}}';
                    //-------------------Trigger code with namespace to give it with managed package ends here-----------------------
                    // HTTP call out to create dynamic trigger
                    
                    if (!test.isRunningTest()) {
                        String json = '{ "Name"  : "TriggerMPV2Geocode' + mapping.Entity__c + '\", "TableEnumOrId" :\"' + mapping.Entity__c + '\", "Body" : \"' + Triggerbody + '\" }';
                        Httprequest req = new HttpRequest();
                        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v40.0/sobjects/ApexTrigger');
                        req.setMethod('POST');
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                        req.setBody(json);
                        Http httpReq = new Http();
                        HttpResponse res = httpReq.send(req);
                    }
                }
                if (mapping != null) {
                    
                    if (Util.getCreateAccessCheck('MP_CustomMapping__c', new List < string > {
                        'Entity__c',
                            'Label__c',
                            'Country__c',
                            'State__c',
                            'City__c',
                            'Street__c',
                            'Postal_code__C',
                            'Pin_No__c'
                            })) {
                                INSERT mapping;
                            }
                }
                List < MP_CustomMapping__c > LstOfObjectsPinNO = Helper_SOQL.GetCustomMappingObjects();
                Integer i; //countPinNo;
                Set < Decimal > Pinno = new Set < Decimal > ();
                if (LstOfObjectsPinNO != null) {
                    for (MP_CustomMapping__c mpObj: LstOfObjectsPinNO) {
                        if (mpObj.Pin_No__c != null) {
                            Pinno.add(mpObj.Pin_No__c);
                        }
                    }
                    for (i = 0; i <= Pinno.size(); i++) {
                        if (!Pinno.contains(i)) {
                            break;
                        }
                    }
                    
                    for (MP_CustomMapping__c mpObj: LstOfObjectsPinNO) {
                        if (mpObj.Pin_No__c == null) {
                            mpObj.Pin_No__c = i;
                        }
                    }
                    if (Util.getUpdateAccessCheck('MP_CustomMapping__c', new List < string > {
                        'Pin_No__c'
                            })) {
                                Update LstOfObjectsPinNO;
                            }
                }
                 //Added by Smita Pawar on 02-09-2019 starts here       
                createFieldsetonGeocodedObject(mapping.Entity__c+'.ExportFilteredList','ExportFilteredList','To export field set on visualforce page in filter section');       
                createFieldsetonGeocodedObject(mapping.Entity__c+'.MapPointDetails','MapPointDetails','Display additional details related to map point');       
                createFieldsetonGeocodedObject(mapping.Entity__c+'.Mass_Update','Mass_Update','Used in map plotter. This is set of fields which will be updated in bulk.');     
                //Added by Smita Pawar on 02-09-2019 ends here
                //False Positive
                //Access is not check on CronTrigger because irrespective of user permission we have to schedule batch for daily limit reset.
                List < CronTrigger > CronTriggerScheduledJobs = [SELECT id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name = : Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME LIMIT 1];
                if (CronTriggerScheduledJobs.size() == 0) {
                    Schedule_Refresh_API_Quaota_Value schedulerForRefresh_API_Quota_Value = new Schedule_Refresh_API_Quaota_Value();
                    datetime dt = DateTime.newInstanceGMT(2015, 5, 31, 07, 0, 0);
                    String cronExpression = '0 ' + dt.minute() + ' ' + dt.hour() + ' * * ?';
                    system.schedule(Helper_MPConstants.REFRESH_DAILY_QUOTA_SCHEDULER_NAME, cronExpression, schedulerForRefresh_API_Quota_Value);
                }
                return String.valueOf(LstOfObjects.size());
            } else {
                return String.valueOf(LstOfObjects.size());
            }
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    // Display the Geocoding Result for Selected Object
    //V1.0-GKadam starts : Returns total counts of Map Ponints for show result functionality
    @RemoteAction @ReadOnly
    Global static String GetTotalMapPointsforObject(String ObjectType) {
        try{
            Integer totalResultCount = ([SELECT Id FROM MP_Map_Point__c WHERE Entity__c = : String.escapeSingleQuotes(ObjectType)]).size();
            String resultJSON = '{"totalResultCount":"' + totalResultCount + '"}';
            return resultJSON;
        }catch(exception e){
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    //GKadam ends
    
    @RemoteAction
    Global static string showResult(String SelectedObject, ID offdetID) {
        try {
            GeocodedReport geoReport = new GeocodedReport();
            List < MP_Map_Point__c > lstMapPointGeocodeResult = Helper_SOQL.GetMapPointsforObject(SelectedObject, offdetID);
            List < MapPoint > lstMapPoints = new List < MapPoint > ();
            for (MP_Map_Point__c mpPoint: lstMapPointGeocodeResult) {
                MapPoint mp = new MapPoint();
                mp.Id = mpPoint.Id;
                mp.Entity = mpPoint.Entity__c;
                mp.Latitude = mpPoint.Latitude__c;
                mp.Longitude = mpPoint.Longitude__c;
                mp.RecordId = mpPoint.RecordId__c;
                mp.Label = mpPoint.Label__c;
                mp.Country = mpPoint.Country__c;
                mp.State = mpPoint.State__c;
                mp.City = mpPoint.City__c;
                mp.Street = mpPoint.Street__c;
                mp.Postal_Code = mpPoint.Postal_Code__c;
                mp.Status = mpPoint.Status__c;
                lstMapPoints.add(mp);
            }
            Integer countSuccess = 0;
            Integer countFailed = 0;
            Integer countPending = 0;
            if (lstMapPointGeocodeResult.size() > 0) {
                for (MP_Map_Point__c MPPoint: lstMapPointGeocodeResult) {
                    string strStatus = MPPoint.Status__c;
                    
                    if (strStatus.equalsIgnoreCase(Helper_MPConstants.GEOCODE_SUCCESS)) {
                        countSuccess = countSuccess + 1;
                    } else if (strStatus.equalsIgnoreCase(Helper_MPConstants.GEOCODE_PENDING)) {
                        countPending = countPending + 1;
                    } else {
                        countFailed = countFailed + 1;
                    }
                }
            }
            geoReport.count_pending = countPending;
            geoReport.count_Success = countSuccess;
            geoReport.count_failed = countFailed;
            geoReport.lstMPPointGeocodeRslt = lstMapPoints;
            return JSON.serialize(geoReport);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    @RemoteAction
    Global static Integer DeleteDataPoint(String objectName, Boolean isDataPointDeleted) {
        try {
            Integer mapPointsize = Helper_SOQL.DeleteDataPoint(objectName, isDataPointDeleted);
            if (mapPointsize != null) {
                return mapPointsize;
            }
            return null;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
     @RemoteAction
    Global static String DeleteDataPointNew(String objectName) {
        try {
            //Added by Priyanka on 18-12
            if(objectName != 'Account' && objectName !='Contact' && objectName != 'Lead')
            {
            String ObjName;
            if (objectName.endsWith('__c')) {
                   ObjName = objectName.removeEnd('__c');
                }
                ObjName = ObjName.replace('__', '_');
            //Priyanka code ends here
            // Pdank Start : Add Delete trigger Fuctionlity Calling class 'DeleteDynamicTrigger' and Its deleteTrigger method 
            String triggerName = 'TriggerMPV2Geocode'+ObjName;
            //Check for not deleting the package triggers
                ApexTrigger[] apt = [SELECT Id FROM ApexTrigger WHERE Name =:triggerName LIMIT 1];
                if(apt.size()>0)
                {   
                    DeleteDynamicTrigger delTrigger = new DeleteDynamicTrigger();
                    delTrigger.deleteTrigger(apt[0].Id);   
                }
                
            }
            String mapPointsize = Helper_SOQL.DeleteDataPoint(objectName);
            if (mapPointsize != null) 
            {
                return mapPointsize;
            }
            return null;// END PDank
        } catch (Exception e) {
            system.debug(e.getMessage()+'<<Line Number>>'+e.getLineNumber());
            return null;
        }
    }
    
    
    @RemoteAction
    Global static Boolean CheckApexJobsStatus() {
        try {
            //False Positive
            //Accessibility is not added because we have to check if job exist in system. we are not showing data to user. this is only for logic purpose
            List < AsyncApexJob > lstapexJob = [select id, apexclass.name, status from asyncapexjob where apexclass.name = 'Schedule_Batch_PopulateNewMapPoints'
                                                and createdDate > YESTERDAY order by createdDate desc limit 1
                                               ];
            if (lstapexJob.size() > 0) {
                if (lstapexJob[0].status == 'Queued') {
                    //False Positive
                    //Accessibility is not added because we have to check if job exist in system. we are not showing data to user. this is only for logic purpose
                    List < AsyncApexJob > lstapexJobforOldBatch = [select id, apexclass.name, status from asyncapexjob where apexclass.name = 'Batch_PopulateOldMapPoint'
                                                                   and createdDate > YESTERDAY order by createdDate desc limit 1
                                                                  ];
                    if (lstapexJobforOldBatch.size() > 0) {
                        if (lstapexJob[0].status == 'Aborted') {
                            return true;
                        } else if (lstapexJobforOldBatch[0].status == 'Completed') {
                            //False Positive
                            //Accessibility is not added because we have to check if job exist in system. we are not showing data to user. this is only for logic purpose
                            List < AsyncApexJob > lstapexJobforNewBatch = [select id, apexclass.name, status from asyncapexjob where apexclass.name = 'Batch_PopulateNewMapPoints'
                                                                           and createdDate > YESTERDAY order by createdDate desc limit 1
                                                                          ];
                            if (lstapexJobforNewBatch.size() > 0) {
                                if (lstapexJobforNewBatch[0].status == 'Aborted') {
                                    return true;
                                } else if (lstapexJobforNewBatch[0].status == 'Completed') {
                                    return true;
                                } else if (lstapexJobforNewBatch[0].status == 'Processing') {
                                    return false;
                                } else if (lstapexJobforNewBatch[0].status == 'Holding') {
                                    return false;
                                } else if (lstapexJobforNewBatch[0].status == 'Queued') {
                                    return false;
                                } else if (lstapexJobforNewBatch[0].status == 'Failed') {
                                    return true;
                                } else if (lstapexJobforNewBatch[0].status == 'Preparing') {
                                    return true;
                                } else {
                                    return true;
                                }
                            } else {
                                return true;
                            }
                        } else if (lstapexJobforOldBatch[0].status == 'Processing') {
                            return false;
                        } else if (lstapexJobforOldBatch[0].status == 'Holding') {
                            return false;
                        } else if (lstapexJobforOldBatch[0].status == 'Queued') {
                            return false;
                        } else if (lstapexJobforOldBatch[0].status == 'Failed') {
                            return true;
                        } else if (lstapexJobforOldBatch[0].status == 'Preparing') {
                            return true;
                        } else {
                            return true;
                        }
                    } else {
                        return false;
                    }
                } else if (lstapexJob[0].status == 'Aborted') {
                    return true;
                } else if (lstapexJob[0].status == 'Failed') {
                    return true;
                } else {
                    return true;
                }
            }
            return true;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return true;
        }
    }
    
    // Schedules the jobs if they are not already scheduled
    @RemoteAction
    Global static Boolean StartGeocoding1(String objName) {
        objName= String.escapeSingleQuotes(objName);
        String nameofscheduler='Schedule job to populate Map Points records:'+ objName;
        
        try {
            //False Positive
            //Accessibility is not added because we have to check if job exist in system. we are not showing data to user. this is only for logic purpose
            List < AsyncApexJob > lstapexJobforBatch = [select id, apexclass.name, status from asyncapexjob where(apexclass.name = 'Batch_PopulateNewMapPoints'
                                                                                                                  OR apexclass.name = 'Batch_PopulateOldMapPoint') and(status = 'Holding'
                                                                                                                                                                       OR status = 'Queued'
                                                                                                                                                                       OR status = 'Preparing'
                                                                                                                                                                       OR status = 'Processing') limit 1];
            if (lstapexJobforBatch.size() == 0) {
                
                //False Positive
                // Check is our Scheduled Job exists
                //Accessibility is not added because we have to check if CronTrigger exist in system. we are not showing data to user. this is only for logic purpose
                List < CronTrigger > CronTriggerScheduledJobs = [SELECT id, CronJobDetail.Name FROM CronTrigger Where CronJobDetail.Name =: nameofscheduler LIMIT 1
                                                                ];
                // Delete the Scheduled Job
                if (CronTriggerScheduledJobs != null && CronTriggerScheduledJobs.size() > 0) {
                    System.abortJob(CronTriggerScheduledJobs[0].id);
                }
                // If Job does not exist, Schedule the Job.
                Schedule_Batch_PopulateNewMapPoints scheduler = new Schedule_Batch_PopulateNewMapPoints(objName);
                Datetime sysTime = System.now().addSeconds(5);
                String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' * * ? *';
                system.schedule(nameofscheduler, cronExpression, scheduler);
                //Update the Geocoding Status
                List < MP_CustomMapping__c > lstCustomMappedObj = Helper_SOQL.GetMappedObject(objName);
                if (lstCustomMappedObj != null) {
                    if (Util.getUpdateAccessCheck('MP_CustomMapping__c', new List < string > {
                        'IsGeocode__c'
                            })) {
                                lstCustomMappedObj[0].IsGeocode__c = true;
                                //False Positive
                                //FLS update check is not added because we are updating Protected custom setting.
                                Update lstCustomMappedObj;
                            }
                }
                
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    
    //Get delta in salesforce and indexedDB
    
    @RemoteAction
    Global static string GetDataBtnIndexedDBandSF(Long lastSyncTime, Id InsertOffsetId) {
        return null;
    }
    @RemoteAction
    Global static string GetDataBtnIndexedDBandSF1(Long lastSyncTime, Id InsertOffsetId, Id UpdateOffsetId, Id DeleteOffsetId) {
        try {
            DateTime lastSyncDateTime = DateTime.newInstance(lastSyncTime);
            DeltaResult deltaRes = new DeltaResult();
            List < MP_Map_Point__c > lstInsertedPoints = new List < MP_Map_Point__c > ();
            List < MP_Map_Point__c > lstUpdatedPoints = new List < MP_Map_Point__c > ();
            List < MP_Map_Point__c > lstDeletedPoints = new List < MP_Map_Point__c > ();
            Set < String > setNewInsertedAddressInfo = new Set < String > ();
            Set < String > setNewDeletedAddressInfo = new Set < String > ();
            Set < String > setAddresskey = new Set < String > ();
            List < MapPoint > lstDeletePts = new List < MapPoint > ();
            
            List < MP_CustomMapping__c > lstCustomMapping = Helper_SOQL.GetCustomMappingObjects();
            String apexTimeStamp;
            DateTime dateTimeNow = dateTime.now();
            String unixTime = '' + dateTimeNow.getTime();
            
            
            List < AsyncApexJob > lstapexJob = Helper_SOQL.GetApexJobs();
            if (lstapexJob != null && lstapexJob.size() > 0) {
                DateTime dateTimeLastJob = lstapexJob[0].completedDate;
                apexTimeStamp = '' + dateTimeLastJob.getTime();
            } else {
                apexTimeStamp = null;
            }
            lstInsertedPoints = Helper_SOQL.GetDeltaOfMapPoints(lastSyncDateTime, InsertOffsetId, Helper_MPConstants.EVENT_INSERT);
            if (lstInsertedPoints.size() > 0) {
                for (MP_Map_Point__c mappoint: lstInsertedPoints) {
                    if (mappoint.AddressKey__c != null) {
                        setAddresskey.add(String.escapeSingleQuotes(mappoint.AddressKey__c));
                    }
                }
            }
            if (lstInsertedPoints.size() > 0) {
                List < MapPoint > lstInsertMpPoints = GetMapPointList(lstInsertedPoints);
                deltaRes.lstInsertedMapPoints = lstInsertMpPoints;
            }
            
            lstUpdatedPoints = Helper_SOQL.GetDeltaOfMapPoints(lastSyncDateTime, UpdateOffsetId, Helper_MPConstants.EVENT_UPDATE);
            
            if (lstUpdatedPoints.size() > 0) {
                for (MP_Map_Point__c mappointupdated: lstUpdatedPoints) {
                    if (mappointupdated.AddressKey__c != null) {
                        setAddresskey.add(String.escapeSingleQuotes(mappointupdated.AddressKey__c));
                    }
                }
            }
            
            if (lstUpdatedPoints.size() > 0) {
                List < MapPoint > lstUpdateMpPoints = GetMapPointList(lstUpdatedPoints);
                deltaRes.lstUpdatedMapPoints = lstUpdateMpPoints;
            }
            
            List < MP_Map_Point__c > lstFailedUpdatedPoints = Helper_SOQL.GetDeltaOfMapPoints(lastSyncDateTime, UpdateOffsetId, Helper_MPConstants.EVENT_UPDATE_FAILED);
            
            if (lstFailedUpdatedPoints != null && lstFailedUpdatedPoints.size() > 0) {
                List < MapPoint > lstUpdateMpPoints = GetMapPointList(lstFailedUpdatedPoints);
                for (MapPoint mp: lstUpdateMpPoints) {
                    lstDeletePts.add(mp);
                }
            }
            
            lstDeletedPoints = Helper_SOQL.GetDeltaOfMapPoints(lastSyncDateTime, DeleteOffsetId, Helper_MPConstants.EVENT_DELETE);
            
            if (lstDeletedPoints.size() > 0) {
                List < MapPoint > lstDeleteMpPoints = GetMapPointList(lstDeletedPoints);
                
                for (MapPoint mp: lstDeleteMpPoints) {
                    lstDeletePts.add(mp);
                }
            }
            
            List < MP_AddressInfo__c > lstInsertAddressInfo = new List < MP_AddressInfo__c > ();
            if (Util.getReadAccessCheck('MP_AddressInfo__c', new List < string > {
                'name'
                    })) {
                        lstInsertAddressInfo = [SELECT Id, Name FROM MP_AddressInfo__c WHERE Name IN: setAddresskey ORDER BY LastModifiedDate DESC LIMIT 50000];
                    }
            
            List < MP_AddressInfo__c > lstDeletedAddressInfo = new List < MP_AddressInfo__c > ();
            if (Util.getReadAccessCheck('MP_AddressInfo__c', new List < string > {
                'name'
                    })) {
                        lstDeletedAddressInfo = [SELECT Id, Name FROM MP_AddressInfo__c WHERE LastModifiedDate > : lastSyncDateTime AND IsDeleted = true ORDER BY LastModifiedDate DESC LIMIT 50000 ALL ROWS];
                    }
            
            
            if (lstInsertAddressInfo.size() > 0 || lstDeletedAddressInfo.size() > 0) {
                deltaRes.isAddressInfoChanged = true;
            } else {
                deltaRes.isAddressInfoChanged = false;
            }
            if (lstCustomMapping.size() == 0) {
                deltaRes.isAddressInfoChanged = true;
            }
            
            if (lstInsertAddressInfo != null && lstInsertAddressInfo.size() > 0) {
                for (MP_AddressInfo__c addressInfo: lstInsertAddressInfo) {
                    setNewInsertedAddressInfo.add(addressInfo.Name);
                }
                deltaRes.setInsertedAddressInfo = setNewInsertedAddressInfo;
            }
            
            if (lstDeletedAddressInfo != null && lstDeletedAddressInfo.size() > 0) {
                for (MP_AddressInfo__c addressInfo: lstDeletedAddressInfo) {
                    setNewDeletedAddressInfo.add(addressInfo.Name);
                }
                deltaRes.setDeletedAddressInfo = setNewDeletedAddressInfo;
            }
            deltaRes.lstDeletedMapPoints = lstDeletePts;
            deltaRes.lastSyncTimeStamp = unixTime;
            deltaRes.lastApexJobComplete = apexTimeStamp;
            
            return JSON.serialize(deltaRes);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    //Get Google API key and world weather API key in custom setting
    
    @RemoteAction
    Global static string GetAPIKeys() {
        try {
            Map < String, MapPlotterPremiumSettings__c > mapCustomsSetting = MapPlotterPremiumSettings__c.getAll();
            MapPlotterPremiumSettings__c settingGoogleAPIKey = mapCustomsSetting.get('GoogleAPIKey');
            String strAPIKey = settingGoogleAPIKey.value__c;
            MapPlotterPremiumSettings__c darkSkyForecastKeysBank01 = mapCustomsSetting.get('DarkSkyForecastKeysBank01');
            MapPlotterPremiumSettings__c darkSkyForecastKeysBank02 = mapCustomsSetting.get('DarkSkyForecastKeysBank02');
            String[] arrWeatherAPIBank01 = darkSkyForecastKeysBank01.value__c.split(',');
            String[] arrWeatherAPIBank02 = darkSkyForecastKeysBank02.value__c.split(',');
            String strWeatherKey;
            ////Conversion of UserTimeZone to PST/PDT
            Datetime thisDT = System.now();
            
            String myDate = thisDT.format('yyyy-MM-dd HH:mm:ss', 'PST');
            
            Datetime stringDate = Datetime.valueOfGMT(myDate);
            
            Integer hour = stringDate.hourGMT();
            
            
            ////Logic for selecting Weather API Key
            if (hour >= 0 && hour < 2) {
                strWeatherKey = arrWeatherAPIBank01[0];
            } else if (hour >= 2 && hour < 4) {
                strWeatherKey = arrWeatherAPIBank01[1];
            } else if (hour >= 4 && hour < 6) {
                strWeatherKey = arrWeatherAPIBank01[2];
            } else if (hour >= 6 && hour < 8) {
                strWeatherKey = arrWeatherAPIBank01[3];
            } else if (hour >= 8 && hour < 10) {
                strWeatherKey = arrWeatherAPIBank01[4];
            } else if (hour >= 10 && hour < 12) {
                strWeatherKey = arrWeatherAPIBank01[5];
            } else if (hour >= 12 && hour < 14) {
                strWeatherKey = arrWeatherAPIBank02[0];
            } else if (hour >= 14 && hour < 16) {
                strWeatherKey = arrWeatherAPIBank02[1];
            } else if (hour >= 16 && hour < 18) {
                strWeatherKey = arrWeatherAPIBank02[2];
            } else if (hour >= 18 && hour < 20) {
                strWeatherKey = arrWeatherAPIBank02[3];
            } else if (hour >= 20 && hour < 22) {
                strWeatherKey = arrWeatherAPIBank02[4];
            } else if (hour >= 22 && hour < 24) {
                strWeatherKey = arrWeatherAPIBank02[5];
            }
            MapPlotterPremiumSettings__c settingWeatherKey = mapCustomsSetting.get('DarkSkyForecastKey');
            settingWeatherKey.value__c = strWeatherKey;
            //False Positive
            //FLS update check is not added because we are updating protected custom setting.
            UPDATE settingWeatherKey;
            
            Map < String, String > mapKeys = new Map < String, String > ();
            mapKeys.put('GeocodingAPIKey', strAPIKey);
            mapKeys.put('WeatherAPIKey', strWeatherKey);
            return JSON.serialize(mapKeys);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            return null;
        }
    }
    
    global static List < MapPoint > GetMapPointList(List < MP_Map_Point__c > lstmappoints) {
        try {
            List < MapPoint > lstMapPoint = new List < MapPoint > ();
            for (MP_Map_Point__c mpPoint: lstmappoints) {
                MapPoint mp = new MapPoint();
                mp.Id = mpPoint.Id;
                mp.AddressKey = mpPoint.AddressKey__C;
                mp.Entity = mpPoint.Entity__c;
                mp.Latitude = mpPoint.Latitude__c;
                mp.Longitude = mpPoint.Longitude__c;
                mp.RecordId = mpPoint.RecordId__c;
                mp.Label = mpPoint.Label__c;
                mp.Country = mpPoint.Country__c;
                mp.State = mpPoint.State__c;
                mp.City = mpPoint.City__c;
                mp.Street = mpPoint.Street__c;
                mp.Postal_Code = mpPoint.Postal_Code__c;
                mp.CreatedDate = mpPoint.CreatedDate;
                lstMapPoint.add(mp);
            }
            if (lstMapPoint != null) {
                return lstMapPoint;
            }
            return null;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    // Remote Action method Fetch records depend on selection of object & location
    
    @RemoteAction
    Global static String OnClickFetchMapPointsForLocationFilter(List < String > lstCityKeys, Id offsetId) {
        try {
            List < MP_Map_Point__c > listMPMapPoints = new List < MP_Map_Point__c > ();
            List < MapPoint > lstMapPoints = new List < MapPoint > ();
            Set < String > setCityKey = new Set < String > ();
            for (String cityKey: lstCityKeys) {
                setCityKey.add(String.escapeSingleQuotes(cityKey));
            }
            
            listMPMapPoints = Helper_SOQL.OnClickFetchMapPointsForLocationFilter(setCityKey, offsetId);
            
            lstMapPoints = GetMapPointList(listMPMapPoints);
            
            if (lstMapPoints != null && lstMapPoints.size() > 0) {
                return json.serialize(lstMapPoints);
            }
            return json.serialize(lstMapPoints);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    ////Search the entered input in MP_Map_point
    
    @RemoteAction
    Global static String OnClickSearchText(String SearchInput, List < String > ListObjects, String offsetName) {
        try {
            Set < String > setObjectAPINames = new Set < String > ();
            for (String objectN: ListObjects) {
                setObjectAPINames.add(String.escapeSingleQuotes(objectN));
            }
            String suppliedSearchText = String.escapeSingleQuotes(SearchInput);
            
            List < MP_Map_Point__c > lstMPPointSearchresult = Helper_SOQL.GetSearchResult(suppliedSearchText, setObjectAPINames, offsetName);
            List < MapPoint > lstMapPoints = GetMapPointList(lstMPPointSearchresult);
            if (lstMapPoints != null) {
                return JSON.serialize(lstMapPoints);
            }
            return null;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    //Remote action Method For populate countries
    
    @RemoteAction
    Global static String PopulateCountries() {
        try {
            Map < string, Map < string, List < MPCity >>> mapcountry = Helper_Search.GetLocationFilter();
            if (mapcountry != null) {
                return json.serialize(mapcountry);
            } else {
                return null;
            }
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    /////////populating the fields for the Lookups
    
    @RemoteAction
    public static map < string, string > getReferencedToFields(string selectedObject, string selectedField) {
        try {
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
            string relationshipName;
            String type;
            map < string, string > parentFieldList = new map < string, string > ();
            for (Schema.SObjectField sfield: fieldMap.Values()) {
                schema.describefieldresult dfield = sfield.getDescribe();
                if (dfield.getname() == selectedField) {
                    
                    relationshipName = dfield.getRelationshipName();
                    Schema.DescribeSObjectResult parentObj = dfield.getReferenceTo()[0].getDescribe();
                    
                    Map < String, Schema.SObjectField > parentFieldMap = parentObj.fields.getMap();
                    for (Schema.SObjectField parentSfield: parentFieldMap.Values()) {
                        schema.describefieldresult parentField = parentSfield.getDescribe();
                        type = string.valueOf(parentField.getType());
                        if (type == 'STRING' || type == 'TEXTAREA') {
                            parentFieldList.put(parentField.getLabel(), relationshipName + '.' + parentField.getName());
                        }
                    }
                    break;
                }
            }
            return parentFieldList;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    // MPP Conversion to MPF -Gkadam Starts
    @remoteaction
    global static boolean PageVisited() {
        try {
            //Update the custom setting IsPageVisited with 'Yes'.
            Map < String, MapPlotterPremiumSettings__c > mapCustomsSetting = MapPlotterPremiumSettings__c.getAll();
            MapPlotterPremiumSettings__c setIsPageVisited = mapCustomsSetting.get('IsPageVisited');
            setIsPageVisited.value__c = 'Yes';
            //False Positive
            //FLS update check is not added because we are updating protected custom setting.
            UPDATE setIsPageVisited;
            return true;
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    
    @remoteaction
    global static boolean ReminderPageVisit() {
        try {
            //Update the custom setting PromotionAfterDays.
            Map < String, MapPlotterPremiumSettings__c > mapCustomsSetting = MapPlotterPremiumSettings__c.getAll();
            String PromotionAfterDays = mapCustomsSetting.get('PromotionAfterDays').value__c;
            
            String RemindeAfterDays = mapCustomsSetting.get('RemindAfterDays').value__c;
            
            Integer addDays = Integer.valueOf(PromotionAfterDays) + Integer.valueOf(RemindeAfterDays);
            
            MapPlotterPremiumSettings__c settingPromotionAfterDays = mapCustomsSetting.get('PromotionAfterDays');
            settingPromotionAfterDays.value__c = String.valueOf(addDays);
            //False Positive
            //FLS update check is not added because we are updating protected custom setting.
            UPDATE settingPromotionAfterDays;
            
            return true;
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    //Get the data related to the package for promotional alerts
    @remoteaction
    global static String getPromotionData() {
        try {
            Map < String, MapPlotterPremiumSettings__c > mapCustomsSetting = MapPlotterPremiumSettings__c.getAll();
            String PromotionAfterDays = mapCustomsSetting.get('PromotionAfterDays').value__c;
            
            Integer NoOfDays = Integer.valueOf(PromotionAfterDays); //Custom Setting
            String isPageVisited = mapCustomsSetting.get('IsPageVisited').value__c; // Custom setting
            
            String showPromotion = isPageVisited == 'Yes' ? 'false' : 'true';
            String trialDays;
            //False Positive
            //Access is not check on PackageLicense because irrespective of user permission we have to check the status of package status.
            //GKadam Start - Modification done in where clause
            
            List <PackageLicense> lstpackage = [SELECT CreatedDate, ExpirationDate, Status FROM PackageLicense WHERE(NamespacePrefix = : Helper_MPConstants.orgNamespace )];
            
            if (lstpackage != null && lstpackage.size() > 0) {
                
                Date CheckDate = date.valueOf((lstpackage[0].CreatedDate).addDays(NoOfDays)); //NoOfDays
                Date TodaysDate = date.today();
                
                if (isPageVisited.equalsIgnoreCase('Yes')) {
                    showPromotion = 'false';
                } else if (TodaysDate > CheckDate || (TodaysDate.dayOfYear() == CheckDate.dayOfYear() &&  TodaysDate.year() == CheckDate.year())) {
                    showPromotion = 'true';
                } else {
                    showPromotion = null;
                }
                
            }
            
            //Show Promotional data in MPF End*/
            Map < String, String > PromotionalData = new Map < String, String > ();
            PromotionalData.put('ShowPromotionAlert', showPromotion); //'true'
            System.debug('PromotionalData==>' + PromotionalData);
            return JSON.serialize(PromotionalData);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
    
    
    //V1.2-GKadam Starts- Show/hide rate us line
    @RemoteAction
    public static Boolean setRatingReview() {
        try {
            Map < String, MapPlotterPremiumSettings__c > mapCustomsSetting = MapPlotterPremiumSettings__c.getAll();
            MapPlotterPremiumSettings__c ratingReviewSettingObj = mapCustomsSetting.get('IsRated');
            ratingReviewSettingObj.Value__c = 'true';
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            update ratingReviewSettingObj;
            return true;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return false;
        }
    }
    //GKdam Ends
    
    ///////// Old Implementation of filter
    public List < MappedObject > lstMappedObjects = new List < MappedObject > ();
    //Code for conversion of apex to json for plot filter logic end here
    public List < selectoption > mappedObjList {
        get;
        set;
    }
    public List < SelectOption > fieldNames {
        get;
        set;
    }
    public List < UIFilterWrapper > UIFilterLogicList {
        get;
        set;
    }
    public string selectedObject {
        get;
        set;
    }
    public string selectedFilter {
        get;
        set;
    }
    public string selectedIndex {
        get;
        set;
    }
    public string selectedField {
        get;
        set;
    }
    public MP_MapFilter__c newFilter {
        get;
        set;
    }
    public List < MP_MapFilter__c > existingFilters {
        get;
        set;
    }
    public boolean hasError {
        get;
        set;
    }
    public List < FilterWrapper > filterLogicList {
        get;
        set;
    }
    public string oldFilter;
    public Map < String, Schema.SObjectField > fieldMap;
    public Map < String, List < SelectOption >> mapFieldOperator;
    public List < MP_CustomMapping__c > mappingList;
    
    class filterWrapper {
        Integer index {
            get;
            set;
        }
        string filterField {
            get;
            set;
        }
        string filterOperator {
            get;
            set;
        }
        string filterValue {
            get;
            set;
        }
        string filterLogic {
            get;
            set;
        }
        string dataType {
            get;
            set;
        }
    }
    
    public class UIFilterWrapper {
        public Integer index {
            get;
            set;
        }
        public string filterField {
            get;
            set;
        }
        public string filterOperator {
            get;
            set;
        }
        public string filterValue {
            get;
            set;
        }
        public string filterLogic {
            get;
            set;
        }
        public List < SelectOption > operatorList {
            get;
            set;
        }
        public string dataType {
            get;
            set;
        }
        public List < SelectOption > pickListVal {
            get;
            set;
        }
        public string selectedValue {
            get;
            set;
        }
        public List < string > selectedValues {
            get;
            set;
        }
        public UIFilterWrapper(integer ind) {
            operatorList = new List < SelectOption > ();
            pickListVal = new List < selectoption > ();
            selectedValues = new List < string > ();
            selectedValue = '';
            filterValue = '';
            index = ind;
        }
    }
    
    public void filterMapPoint() {
        try {
            if (Util.getReadAccessCheck('MP_CustomMapping__c', new List < string > {
                'Name',
                    'entity__c'
                    })) {
                        mappingList = [select id, Name, entity__c from MP_CustomMapping__c limit 200];
                    }
            init();
            mapFieldOperator = filterHelper.inilizeDatatypeMap();
            
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
        
    }
    
    private void init() {
        try {
            mappedObjList = new List < selectoption > ();
            newFilter = new MP_MapFilter__c();
            selectedObject = '--None--';
            if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                'name',
                    'MP_CustomMapping__c',
                    'Expression__c',
                    'isCustomExpression__c',
                    'Description__c',
                    'Filter_Criteria__c'
                    })) {
                        existingFilters = [select name, MP_CustomMapping__c, Expression__c, isCustomExpression__c, Description__c, Filter_Criteria__c from MP_MapFilter__c limit 500];
                    }
            UIFilterLogicList = new List < UIFilterWrapper > ();
            mappedObjList.add(new selectoption('--None--', '--None--'));
            for (MP_CustomMapping__c mapping: mappingList) {
                mappedObjList.add(new selectoption(mapping.entity__c, mapping.entity__c));
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void describeSelectedobject() {
        try {
            getObjectDescribe();
            if (selectedObject != '--None--') {
                getFilterCriteria();
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    private void getFilterCriteria() {
        try {
            UIFilterLogicList = new List < UIFilterWrapper > ();
            for (Integer i = 0; i < 5; i++) {
                UIFilterWrapper filterEntry = new UIFilterWrapper(i + 1);
                filterEntry.operatorList = mapFieldOperator.get('ALL');
                UIFilterLogicList.add(filterEntry);
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    private void getObjectDescribe() {
        try {
            if (selectedObject != '--None--') {
                Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
                fieldMap = ObjectSchema.getDescribe().fields.getMap();
                UIFilterLogicList = new List < UIFilterWrapper > ();
                fieldNames = new List < SelectOption > ();
                if (newFilter.id == null || newFilter.MP_CustomMapping__r.entity__c != selectedObject) {
                    fieldNames.add(new selectoption('--None--', '--None--'));
                }
                for (String fieldName: fieldMap.keySet()) {
                    Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                    string type = string.valueOf(fieldDescribe.getType());
                    if (type != 'REFERENCE' && type != 'ADDRESS' && type != 'URL' && type != 'COMBOBOX') {
                        fieldNames.add(new SelectOption(fieldName, fieldMap.get(fieldName).getDescribe().getLabel()));
                    } else if (type.equalsIgnoreCase('REFERENCE') && fieldName.equalsIgnoreCase('ownerid')) {
                        fieldNames.add(new SelectOption('owner.firstName', 'Owner First Name'));
                        fieldNames.add(new SelectOption('owner.lastName', 'Owner Last Name'));
                    }
                }
            } else {
                UIFilterLogicList = new List < UIFilterWrapper > ();
                fieldNames = new List < SelectOption > ();
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void getOperator() {
        try {
            Schema.DescribeFieldResult fieldDescribe;
            if (!selectedField.containsIgnoreCase('owner')) {
                fieldDescribe = fieldMap.get(selectedField).getDescribe();
            }
            for (UIFilterWrapper filterEntry: UIFilterLogicList) {
                if (filterEntry.index == Integer.valueOf(selectedIndex)) {
                    string type = !selectedField.containsIgnoreCase('owner') ? string.valueOf(fieldDescribe.getType()) : 'STRING';
                    filterEntry.operatorList = mapFieldOperator.get(type);
                    filterEntry.pickListVal = new List < selectoption > ();
                    filterEntry.dataType = type;
                    if (type == 'PICKLIST' || type == 'MULTIPICKLIST') {
                        for (Schema.PicklistEntry pickListval: fieldDescribe.getPicklistValues()) {
                            filterEntry.pickListVal.add(new selectoption(pickListval.getLabel(), pickListval.getLabel()));
                        }
                    }
                    break;
                }
            }
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void getpicklistval() {
        try {
            UIFilterWrapper filterEntry = UIFilterLogicList[Integer.valueOf(selectedIndex) - 1];
            if (filterEntry.index == Integer.valueOf(selectedIndex)) {
                if (filterEntry.dataType == 'MULTIPICKLIST') {
                    filterEntry.filterValue = String.join(filterEntry.selectedValues, ';');
                }
                if (filterEntry.dataType == 'PICKLIST') {
                    filterEntry.filterValue = filterEntry.selectedValue;
                }
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void deleteFilter() {
        try {
            if (MP_MapFilter__c.sObjectType.getDescribe().isDeletable()) {
                MP_MapFilter__c filterObj = new MP_MapFilter__c(id = selectedFilter);
                delete filterObj;
                init();
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You dont have permission to delete filter'));
            }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void editFilter() {
        try {
            if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                'MP_CustomMapping__c',
                    'name',
                    'isCustomExpression__c',
                    'Expression__c',
                    'Description__c',
                    'Filter_Criteria__c'
                    })) {
                        newFilter = [select name, MP_CustomMapping__c, isCustomExpression__c, Expression__c, MP_CustomMapping__r.entity__c, Description__c, Filter_Criteria__c from MP_MapFilter__c where id = : String.escapeSingleQuotes(selectedFilter) Limit 1];
                    }
            if (newFilter != null) {
                selectedObject = newFilter.MP_CustomMapping__r.entity__c;
                oldFilter = newFilter.Expression__c;
                getObjectDescribe();
                filterLogicList = (List < filterWrapper > ) JSON.deserialize(newFilter.Filter_Criteria__c, List < filterWrapper > .class);
                for (Integer i = 0; i < filterLogicList.size(); i++) {
                    filterWrapper filter = filterLogicList[i];
                    Schema.DescribeFieldResult fieldDescribe;
                    if (filter.filterField != 'owner.firstName' && filter.filterField != 'owner.lastName') {
                        fieldDescribe = fieldMap.get(filter.filterField).getDescribe();
                    }
                    string type = filter.dataType;
                    
                    UIFilterWrapper filterEntry = new UIFilterWrapper(filter.index);
                    filterEntry.operatorList = mapFieldOperator.get(type);
                    if (type == 'MULTIPICKLIST' || type == 'PICKLIST') {
                        for (Schema.PicklistEntry pickListval: fieldDescribe.getPicklistValues())
                            filterEntry.pickListVal.add(new selectoption(pickListval.getLabel(), pickListval.getLabel()));
                        if (filterEntry.filterValue != null && filterEntry.filterValue != '')
                            filterEntry.selectedValues = filter.filterValue.split(';');
                    }
                    filterEntry.filterField = filter.filterField;
                    filterEntry.filterOperator = filter.filterOperator;
                    filterEntry.filterValue = filter.filterValue;
                    filterEntry.dataType = filter.dataType;
                    UIFilterLogicList.add(filterEntry);
                }
            }
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void addNewRow() {
        try {
            UIFilterWrapper filterEntry = new UIFilterWrapper(UIFilterLogicList.size() + 1);
            filterEntry.operatorList = mapFieldOperator.get('ALL');
            UIFilterLogicList.add(filterEntry);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    
    public void removeRow() {
        try {
            if (UIFilterLogicList.size() > 1)
                UIFilterLogicList.remove(UIFilterLogicList.size() - 1);
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    public void saveAndRunFilter() {
        try {
            hasError = false;
            List < MP_MapFilter__c > lstMapFilter = new List < MP_MapFilter__c > ();
            MP_CustomMapping__c mappedObj = new MP_CustomMapping__c();
            if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                'name'
                    })) {
                        lstMapFilter = [SELECT id, name FROM MP_MapFilter__c WHERE(name = : string.escapeSingleQuotes(newFilter.Name) AND id != : newFilter.id) LIMIT 1];
                    }
            if (lstMapFilter.size() == 0) {
                if (uifilterLogicList.size() > 0) {
                    if (Util.getReadAccessCheck('MP_CustomMapping__c', new List < string > {
                        'name',
                            'Entity__c'
                            })) {
                                mappedObj = [select id, Name, entity__c from MP_CustomMapping__c where entity__c = : String.escapeSingleQuotes(selectedObject)];
                            }
                    List < filterWrapper > filterEntryList = new List < filterWrapper > ();
                    for (UIFilterWrapper filterEntry: UIFilterLogicList) {
                        if (filterEntry.filterField != '--None--' && filterEntry.filterOperator != '--None--' && filterEntry.filterValue != '--None--') {
                            filterWrapper validFilterEntry = new filterWrapper();
                            validFilterEntry.index = filterEntry.index;
                            validFilterEntry.filterField = String.escapeSingleQuotes(filterEntry.filterField);
                            validFilterEntry.filterOperator = String.escapeSingleQuotes(filterEntry.filterOperator);
                            validFilterEntry.filterValue = String.escapeSingleQuotes(filterEntry.filterValue);
                            
                            validFilterEntry.dataType = filterEntry.dataType;
                            filterEntryList.add(validFilterEntry);
                        }
                    }
                    if (oldFilter != newFilter.expression__c)
                        newFilter.isCustomExpression__c = true;
                    if (newFilter.expression__c == null || newFilter.expression__c == '' || newFilter.isCustomExpression__c == false) {
                        newFilter.expression__c = '';
                        for (Integer i = 0; i < filterEntryList.size(); i++) {
                            filterWrapper filterEntry = filterEntryList[i];
                            if (filterEntry.filterField != '--None--' && filterEntry.filterOperator != '--None--') {
                                newFilter.expression__c += filterEntry.index + ' AND ';
                            }
                        }
                        newFilter.expression__c = newFilter.expression__c.removeEnd('AND ');
                        if (mappedObj != null)
                            newFilter.MP_CustomMapping__c = mappedObj.id;
                        newFilter.Filter_Criteria__c = JSON.serialize(filterEntryList);
                        newFilter.isCustomExpression__c = false;
                        try {
                            if ((Util.getUpdateAccessCheck('MP_MapFilter__c', new List < string > {
                                'Name',
                                    'Expression__c',
                                    'isCustomExpression__c',
                                    'Description__c',
                                    'Filter_Criteria__c',
                                    'MP_CustomMapping__c'
                                    })) && (Util.getCreateAccessCheck('MP_MapFilter__c', new List < string > {
                                        'Name',
                                            'Expression__c',
                                            'isCustomExpression__c',
                                            'Description__c',
                                            'Filter_Criteria__c',
                                            'MP_CustomMapping__c'
                                            }))) {
                                                upsert newFilter;
                                            }
                        }
                        Catch(Exception e) {
                            system.debug('MPV2 exception occurred==>' + e.getMessage());
                            hasError = true;
                        }
                        
                        newFilter = new MP_MapFilter__c();
                        UIFilterLogicList = new List < UIFilterWrapper > ();
                        selectedObject = '--None--';
                        if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                            'Name',
                                'Expression__c',
                                'isCustomExpression__c',
                                'Description__c',
                                'Filter_Criteria__c',
                                'MP_CustomMapping__c'
                                })) {
                                    existingFilters = [select name, MP_CustomMapping__c, Expression__c, isCustomExpression__c, Description__c, Filter_Criteria__c from MP_MapFilter__c limit 500];
                                }
                    } else {
                        try {
                            boolean logicError = true;
                            for (filterWrapper filterEntry: filterEntryList) {
                                if (newFilter.expression__c.containsNone(string.valueOf(filterEntry.index))) {
                                    logicError = false;
                                    hasError = true;
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please include all criteria in expression'));
                                    break;
                                }
                            }
                            if (logicError) {
                                Set < Id > checkRecordIdList = getRecords(mappedObj.entity__c, newFilter.expression__c, filterEntryList, null);
                                if (mappedObj != null)
                                    newFilter.MP_CustomMapping__c = mappedObj.id;
                                newFilter.Filter_Criteria__c = JSON.serialize(filterEntryList);
                                newFilter.isCustomExpression__c = true;
                                if (lstMapFilter != null) {
                                    if ((Util.getUpdateAccessCheck('MP_MapFilter__c', new List < string > {
                                        'Name',
                                            'Expression__c',
                                            'isCustomExpression__c',
                                            'Description__c',
                                            'Filter_Criteria__c',
                                            'MP_CustomMapping__c'
                                            })) && (Util.getCreateAccessCheck('MP_MapFilter__c', new List < string > {
                                                'Name',
                                                    'Expression__c',
                                                    'isCustomExpression__c',
                                                    'Description__c',
                                                    'Filter_Criteria__c',
                                                    'MP_CustomMapping__c'
                                                    }))) {
                                                        upsert newFilter;
                                                    }
                                } else {
                                    hasError = true;
                                }
                                newFilter = new MP_MapFilter__c();
                                UIFilterLogicList = new List < UIFilterWrapper > ();
                                selectedObject = '--None--';
                                if (Util.getReadAccessCheck('MP_MapFilter__c', new List < string > {
                                    'name',
                                        'MP_CustomMapping__c',
                                        'Expression__c',
                                        'isCustomExpression__c',
                                        'Description__c',
                                        'Filter_Criteria__c'
                                        })) {
                                            existingFilters = [select name, MP_CustomMapping__c, Expression__c, isCustomExpression__c, Description__c, Filter_Criteria__c from MP_MapFilter__c limit 500];
                                        }
                            }
                        } catch (exception e) {
                            hasError = true;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'One or more criteria contains invalid value or inValid expression'));
                        }
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Filter contains atleast one filtering criteria'));
                }
            } else {
                hasError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Filter Name Already Exist.'));
            }
        }
        Catch(exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong'));
        }
    }
    static set < id > getRecords(string objectName, string expression, List < filterWrapper > criteriaList, Id offsetId) {
        try {
            String queryString;
            string objName = string.escapeSingleQuotes(objectName);
            if (offsetId == null) {
                queryString = 'select id from ' + string.escapeSingleQuotes(objectName);
                queryString += ' where ' + createQueryCondition(expression, criteriaList);
                queryString += ' ORDER BY Id ASC LIMIT 5000';
            } else {
                queryString = 'select id from ' + string.escapeSingleQuotes(objectName);
                queryString += ' where ' + createQueryCondition(expression, criteriaList);
                queryString += 'AND id > \'' + string.escapeSingleQuotes(offsetId) + '\'';
                queryString += ' ORDER BY Id ASC LIMIT 5000';
            }
            if (util.getReadAccessCheck(objName, new List < string > {
                'id'
                    })) {
                        List < Sobject > queryResult = (List < Sobject > ) database.query(queryString);
                        Map < Id, Sobject > queryResultMap = new Map < Id, Sobject > (queryResult);
                        return queryResultMap.keySet();
                    } else {
                        return null;
                    }
        }
        Catch(Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Invalid Input')); // check it
            return null;
        }
    }
    private static string createQueryCondition(string queryExpression, List < filterWrapper > criteriaList) {
        try {
            string expression = string.escapeSingleQuotes(queryExpression);
            map < Integer, string > conditionMap = new map < Integer, string > ();
            string queryString;
            for (Integer i = 0; i < criteriaList.size(); i++) {
                filterWrapper criteria = criteriaList[i];
                string field = string.escapeSingleQuotes(criteria.filterField);
                string fieldValue = string.escapeSingleQuotes(criteria.filterValue);
                
                if (criteria.filterOperator.equalsIgnoreCase('NotContains')) {
                    queryString = 'NOT ' + string.escapeSingleQuotes(criteria.filterField) + ' ';
                    queryString += 'LIKE \'%' + string.escapeSingleQuotes(criteria.filterValue) + '%\'';
                } else {
                    queryString = string.escapeSingleQuotes(criteria.filterField) + ' ';
                    if (criteria.filterOperator == 'Starts') {
                        queryString += 'LIKE \'' + string.escapeSingleQuotes(criteria.filterValue) + '%\'';
                    } else if (criteria.filterOperator.equalsIgnoreCase('Contains')) {
                        queryString += 'LIKE \'%' + string.escapeSingleQuotes(criteria.filterValue) + '%\'';
                    } else if (criteria.filterOperator.equalsIgnoreCase('INCLUDES')) {
                        queryString += 'INCLUDES (\'' + string.escapeSingleQuotes(criteria.filterValue) + '\')';
                    } else if (criteria.filterOperator.equalsIgnoreCase('EXCLUDES')) {
                        queryString += 'EXCLUDES (\'' + string.escapeSingleQuotes(criteria.filterValue) + '\')';
                    } else {
                        queryString += string.escapeSingleQuotes(criteria.filterOperator) + ' ';
                        if (checkFieldType(criteria.dataType)) {
                            queryString += '\'' + string.escapeSingleQuotes(criteria.filterValue) + '\'';
                        } else {
                            queryString += string.escapeSingleQuotes(criteria.filterValue) + '';
                        }
                    }
                    integer criteriaIndex = Integer.valueOf(criteria.index);
                    conditionMap.put(criteriaIndex, queryString);
                    expression = expression.replaceFirst(string.valueOf(criteriaIndex), 'condition' + (criteriaIndex));
                }
            }
            for (Integer i: conditionMap.keySet()) {
                expression = expression.replaceFirst('condition' + string.valueOf(i), conditionMap.get(i));
            }
            return expression;
        } catch (Exception e) {
            system.debug('MPV2 exception occurred==>' + e.getMessage());
            return '';
        }
    }
    
    
    @RemoteAction
    public static String getStoredGoogleAPIKey(){
        //False Positive
        //Used name as Protected custom setting
        MapPlotterPremiumSettings__c settingRecord = MapPlotterPremiumSettings__c.getValues('GoogleAPIKey');
        if(settingRecord != null && !String.isEmpty(settingRecord.value__c))
            return settingRecord.value__c;
        return null;
    }
    
    global static string setPromotionalAlert(integer day){
        try{
            MapPlotterPremiumSettings__c settingRecord = MapPlotterPremiumSettings__c.getValues('PromotionAfterDays');
            settingRecord.value__c= string.valueof(day);
            //False Positive
            //FLS update check is not added because we are updating Protected custom setting.
            update settingRecord;
            return String.valueOf(settingRecord);
        }catch(Exception e){
            return null;
        }
    }
    
    global static String getMapPlotterCustomSettingData(String v){
        try{
            Map < String, MapPlotterPremiumSettings__c > mapCustomsSetting = MapPlotterPremiumSettings__c.getAll();
            return mapCustomsSetting.get(v).value__c;
        }catch(Exception e){
            return null;
        }
    }
    
    
    public static Boolean createCustomSettingRecords(Map<String,Set<String>> customSettingKeyValue){
        try{
            List<MapPlotterPremiumSettings__c> mapCustomsSetting =new List<MapPlotterPremiumSettings__c>();
            for(String key:customSettingKeyValue.keySet()){
                if(customSettingKeyValue.get(key)!=null){
                    mapCustomsSetting.add(new MapPlotterPremiumSettings__c(Name=key,Value__c=JSON.serialize(customSettingKeyValue.get(key))));
                }
            }
            //False Positive
            //FLS check is not added because we are updating Protected custom setting.
            if(!mapCustomsSetting.isEmpty()){
                upsert mapCustomsSetting;
            }
            return true;
        }catch(Exception e){
            return false;
        }
    }
    // GS-MP Customization starts here.
    //Added by Priyanka Modani on 02 Sept 2019 Starts here
    global static set<Id> GetErrorMessage(Id filterId,Id offsetId)
    {
        set<Id> setObjRecId = new set<Id>();  
        boolean booleanHasMoreRecords;
        Id offsetIdNew = offsetId;
        integer count=0;
        do{
            ErrorMessage errorMsg =null;
            string strErrorMessage = GetSFReportData(filterId,offsetIdNew);
            errorMsg = (ErrorMessage)JSON.deserialize(strErrorMessage,ErrorMessage.class); 
            for(MapPoint mapPointRec: errorMsg.lstMPPoint)
            {
               setObjRecId.add(Id.valueOf(mapPointRec.RecordID));
            } 

            booleanHasMoreRecords = errorMsg.hasMoreRecords; 
            offsetIdNew =errorMsg.offsetId;
           
            count += 1;           
        }while(booleanHasMoreRecords);
         
        return setObjRecId;
    }
    //Get filtered records based on filterId
    global static set<Id> getFilteredData(string objectName,Id filterId,Id offsetId)
    {
        set<Id> setObjRecId = new set<Id>();  
        ErrorMessage errorMsg;
        setObjRecId = GetErrorMessage(filterId,offsetId);  
        return setObjRecId;      
    }
                
    // get fieldset value for export functionality.
    @RemoteAction
    global static Map<Id, Map<String,Object>> ExportFilteredData(Id filterId, String objAPIName, String offsetId,string lstDrewDataPoints){ 
        try{  
            String objectAPIName = String.escapeSingleQuotes(objAPIName);       
            List<Id> lstrecords = new List<Id> ();
            Set<String> setDateFieldAPI = new Set<String>();
            Set<String> setDateTimeFieldAPI = new Set<String>();
            Map<Id, Map<String,Object>> idValMap = new Map<Id, Map<String,Object>>();
            Map<Id, Map<String,Object>> idValMapNew = new Map<Id, Map<String,Object>>();
            Map<String, Object> labelNullMap = new Map<String, Object>();
            Map<string,string> fieldApiLabelMap = new Map<string,string>();
            Set<Id> setObjRecIds = new Set<Id>();
            if(filterId != null)
                setObjRecIds = getFilteredData(objectAPIName,filterId,offsetId);
            else if(lstDrewDataPoints != null)
            {
                set<Id> setId = new set<Id>();
                lstDrewDataPoints = lstDrewDataPoints.deleteWhitespace();
                setId.addAll((Set<Id>) JSON.deserialize(JSON.serialize((lstDrewDataPoints.substringBetween('[',']')).split(',')), Set<Id>.class));
                List<MP_Map_Point__c> lstMapPoint =  Helper_SOQL.GetMapPoints(setId);  
                for(MP_Map_Point__c mapPointRec: lstMapPoint)
                {
                   setObjRecIds.add(Id.valueOf(mapPointRec.recordId__c));
                } 
            }
            String fieldSetName = System.Label.orgNamespace+'__'+System.Label.ExportFilteredListFieldSetName;
            if(!setObjRecIds.isEmpty())
            {
                lstrecords.addAll(setObjRecIds);
            }
            if(!lstrecords.isEmpty() && fieldsetName != null)
            { 
                Schema.FieldSet fieldSetObj = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().FieldSets.getMap().get(fieldSetName);
                Map<String,Schema.SObjectField> fieldMap = schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
                String query = 'SELECT ';
                
                for(Schema.FieldSetMember f : fieldSetObj.getFields()) 
                { 
                    if (fieldMap.get(f.getFieldPath()).getDescribe().isAccessible())
                    {
                        labelNullMap.put(f.getFieldPath(),'null');
                        fieldApiLabelMap.put(f.getFieldPath(),f.getLabel());
                        if(f.getFieldPath() != 'Id')
                        query += f.getFieldPath() + ', '; 
                        if(string.valueOf(f.getType()) == 'DATE')
                        {
                            setDateFieldAPI.add(f.getFieldPath());
                        }
                        else if(string.valueOf(f.getType()) == 'DATETIME'){
                            setDateTimeFieldAPI.add(f.getFieldPath());
                        }
                    }
                }
                if(offsetId == null)
                {
                    query += 'Id FROM  ' +objectAPIName+ ' WHERE Id IN: lstrecords ORDER BY ID ASC LIMIT 2000';               
                }
                else
                {
                    query += 'Id FROM  ' +objectAPIName+ ' WHERE Id IN: lstrecords AND Id >= : offsetId ORDER BY ID ASC LIMIT 2000';
                }
                List<Sobject> lstobjRecords = Database.query(query);
                if(!lstobjRecords.isEmpty())
                { 
                    for(integer i=0;i<lstobjRecords.size();i++)
                    {                        
                        Map<String, Object> lableValueMap = new Map<String, Object>();
                        Map<String, Object> fieldsToValue = lstobjRecords[i].getPopulatedFieldsAsMap();                       
                        lableValueMap.putAll(labelNullMap);                        
                        lableValueMap.putAll(fieldsToValue);                       
                        idValMap.put(lstobjRecords[i].Id,lableValueMap);                        
                    }
                }
                if(idValMap.size()>0)
                {
                    for(string key : idValMap.keyset())                    
                    {
                        map<string,object> fieldsToValue = new map<string,object>();
                        map<string,object> fieldsToValueNew = new map<string,object>();
                        fieldsToValue = idValMap.get(key);
                        for(string fieldKey: fieldsToValue.keyset())
                        {                        
                            if(fieldApiLabelMap.get(fieldKey) != null && !setDateFieldAPI.contains(fieldKey) && !setDateTimeFieldAPI.contains(fieldKey))
                            {
                                fieldsToValueNew.put(fieldApiLabelMap.get(fieldKey),fieldsToValue.get(fieldKey));
                            } 
                            else if(fieldApiLabelMap.get(fieldKey) != null && setDateFieldAPI.contains(fieldKey) && !setDateTimeFieldAPI.contains(fieldKey)) 
                            {
                                if(fieldsToValue.get(fieldKey) != 'null')
                                {
                                    String formattedDate = Date.valueOf(fieldsToValue.get(fieldKey)).format();
                                    fieldsToValueNew.put(fieldApiLabelMap.get(fieldKey),formattedDate);
                                }
                                else
                                {
                                    fieldsToValueNew.put(fieldApiLabelMap.get(fieldKey),fieldsToValue.get(fieldKey));
                                }
                            }
                            else if(fieldApiLabelMap.get(fieldKey) != null && setDateTimeFieldAPI.contains(fieldKey) && !setDateFieldAPI.contains(fieldKey)){
                                if(fieldsToValue.get(fieldKey) != 'null')
                                {
                                    String formattedDateTime = DateTime.valueOf(fieldsToValue.get(fieldKey)).format();
                                    fieldsToValueNew.put(fieldApiLabelMap.get(fieldKey),formattedDateTime);
                                }
                                else
                                {
                                    fieldsToValueNew.put(fieldApiLabelMap.get(fieldKey),fieldsToValue.get(fieldKey));
                                }
                            }
                        }
                        if(fieldsToValueNew.size()>0)
                            idValMapNew.put(key,fieldsToValueNew);                        
                    }
                }
                if(idValMapNew.size()>0)
                    return idValMapNew;   
            }
            return null; 
        }
        catch(Exception e){
            System.debug(e.getMessage()+'<<Line Number>>'+e.getLineNumber());
            return null;
        }        
    }      
            
    //  for single record detail
    @RemoteAction
    global static Map<String,String> GetFieldSetsValueOnRecordDetail(String recordId,string objAPIName){
        try{
            String recId = String.escapeSingleQuotes(recordId);
            String objectAPIName = String.escapeSingleQuotes(objAPIName);           
            String fieldSetName = System.Label.orgNamespace+'__'+System.Label.MapPointDetailsFieldSetName;
            Set<String> setDateFieldAPI = new Set<String>();
            Set<String> setDateTimeFieldAPI = new Set<String>();            
            Schema.FieldSet fieldSetObj = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().FieldSets.getMap().get(fieldSetName);
            List<Schema.FieldSetMember> fieldSet = new List<Schema.FieldSetMember>();
            List<Schema.FieldSetMember> fieldSetList = fieldSetObj.getFields();
            for(integer i=0;i<fieldSetList.size();i++)
            {
                fieldSet.add(fieldSetList[i]);
            }
            Map<String,Schema.SObjectField> fieldMap = schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : fieldSet) {
                if(f.getFieldPath() != 'Id')
                query += f.getFieldPath() + ', ';
            }               
            query += 'Id FROM  ' +objectAPIName+ ' where Id =: recId';
            List<Sobject> objectRecords = Database.query(query);
            if(!objectRecords.isEmpty())
            {
                Map<String,String> fieldValMap = new Map<String,String>();
                for(Sobject obj: objectRecords){                        
                    for(Schema.FieldSetMember f : fieldSet){                       
                        String fieldApiName = f.getFieldPath();
                        String fieldValueObj = fieldApiName.contains('.') ? (string.valueOf(obj.getsObject(fieldApiName.substringBefore('.'))) == null ? 'null' :
                                                    String.valueOf(obj.getsObject(fieldApiName.substringBefore('.')))) : string.valueOf(obj.get(fieldApiName));                           
                        String fieldValue = fieldValueObj != null ? fieldValueObj : '';
                        if(String.valueOf(f.getType()) != 'DATE' && String.valueOf(f.getType()) != 'DATETIME')
                        {
                            fieldValMap.put(f.getLabel(),fieldValue);  
                        }
                        else if(String.valueOf(f.getType()) == 'DATE')
                        {
                            if(fieldValue != '')
                            {
                                String formattedDate = Date.valueOf(fieldValue).format();
                                fieldValMap.put(f.getLabel(),formattedDate);
                          }
                            else
                            {
                                fieldValMap.put(f.getLabel(),fieldValue); 
                            }
                        }
                        else if(String.valueOf(f.getType()) == 'DATETIME')
                        {
                            
                            if(fieldValue != '')
                            { 
                                String formattedDateTime = DateTime.valueOf(obj.get(fieldApiName)).format();
                                fieldValMap.put(f.getLabel(),formattedDateTime);
                          }
                            else
                            {
                                fieldValMap.put(f.getLabel(),fieldValue); 
                            }
                        }
                    }
                }
                if(fieldValMap.size()>0)
                    return fieldValMap;           
            }
            return null;
        }
        catch(Exception e){
            System.debug(e.getMessage()+'<<Line Number>>'+e.getLineNumber());
            return null;
        }
    }       
    //Added by Priyanka Modani on 02 Sept 2019 Ends here        
            
    //Added by Smita Pawar on 02 Sept 2019 Starts here
    //Returns Field Label,API,Datatype and Picklist values, if any, to JS
    @RemoteAction
    global static string fieldsForMassUpdate(String objAPIName)
    {
        try{
            String objectAPIName = String.escapeSingleQuotes(objAPIName);
            Map<string,list<string>> mapFieldVals = new Map<string,list<string>>();
            String fieldSetName = System.Label.orgNamespace+'__'+System.Label.MassUpdateFilteredListFieldSetName; 
            Schema.FieldSet fieldSetObj = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().FieldSets.getMap().get(fieldSetName);
            string sObjectFields = GetObjectMetaData(objectAPIName);
            list<ObjectFieldData> lstFields = (list<ObjectFieldData>)JSON.deserialize(sObjectFields,list<ObjectFieldData>.class);
            list<ObjectFieldData> lstFieldsForMassUpdate = new list<ObjectFieldData>();
            map<string,string> mapFieldApiLabel = new map<string,string>();
            for(ObjectFieldData fname: lstFields)
            {
                for(Schema.FieldSetMember f : fieldSetObj.getFields()) 
                {
                    if(((f.getFieldPath()).toLowerCase()).equals(fname.Name))
                    {                   
                        lstFieldsForMassUpdate.add(fname);  
                    }
                } 
            }      
            return json.serialize(lstFieldsForMassUpdate);
        }   
        catch(Exception e){
            System.debug(e.getMessage()+'<<Line Number>>'+e.getLineNumber());
            return null;
        }
    }
   
    //Mass update the selected field with input value in all records of selected object
    @RemoteAction
    global static string MassUpdatesObject(Id filterId, String objAPIName,string FieldName,string Fieldvalue,string FieldDataType, string lstDrewDataPoints)
    {
        try{
            String objectAPIName = String.escapeSingleQuotes(objAPIName);
            String fldValue = String.escapeSingleQuotes(Fieldvalue);
            String fldName = String.escapeSingleQuotes(FieldName);
            String fldDataType = String.escapeSingleQuotes(FieldDataType);
            String lastDrewDataPoints = String.escapeSingleQuotes(lstDrewDataPoints);
            string message = '';
            List<Id> lstrecordIds = new List<Id> ();
            Set<Id> setObjRecIds = new Set<Id>();
            Id offSetId = null;
            Boolean isUpdateableObj = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().isUpdateable();
            Map<String, Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
            Boolean isUpdatableField = mapFields.get(fldName).getDescribe().isUpdateable();
            if(isUpdateableObj && isUpdatableField)
            {
                if(filterId != null)
                {
                    setObjRecIds = getFilteredData(objectAPIName,filterId,offsetId);
                }
                else if(lastDrewDataPoints != null)
                {
                    set<Id> setId = new set<Id>();
                    lastDrewDataPoints = lastDrewDataPoints.deleteWhitespace();
                    setId.addAll((Set<Id>) JSON.deserialize(JSON.serialize((lastDrewDataPoints.substringBetween('[',']')).split(',')), Set<Id>.class));
                    if(!setId.isEmpty()){
                        List<MP_Map_Point__c> lstMapPoint =  Helper_SOQL.GetMapPoints(setId);  
                        for(MP_Map_Point__c mapPointRec: lstMapPoint)
                        {
                           setObjRecIds.add(Id.valueOf(mapPointRec.recordId__c));
                        } 
                    }
                }
                if(!setObjRecIds.isEmpty())
                {
                    lstrecordIds.addAll(setObjRecIds);
                }
                if(!lstrecordIds.isEmpty())
                {
                    if(lstrecordIds.size() < 10)
                    {
                        list<sObject> lstSobj = new list<sObject>();  
                        if(Util.getReadAccessCheck(objectAPIName, new List<string>{'Id', fldName})){
                            string query = 'SELECT Id,'+fldName+' FROM '+objectAPIName+' where Id IN: lstrecordIds';
                            lstSobj = Database.query(query);
                            MassUpdateHandler obj = new MassUpdateHandler(lstSobj,fldName,fldValue,fldDataType);
                            integer cntSuccess = obj.UpdateRecords();
                            message = 'Records updated successfully.';
                        }
                    }
                    else
                    {
                         List < AsyncApexJob > lstapexJobforBatch = [select id, apexclass.name, status from asyncapexjob where apexclass.name = 'Batch_MassUpdateFilteredResult' and(status = 'Holding'
                                                                                                                                                                               OR status = 'Queued'
                                                                                                                                                                               OR status = 'Preparing'
                                                                                                                                                                               OR status = 'Processing') limit 1];
                        if (lstapexJobforBatch.size() == 0) 
                        {
                            Batch_MassUpdateFilteredResult obj = new Batch_MassUpdateFilteredResult(lstrecordIds,fldName,fldValue,fldDataType);
                            DataBase.executeBatch(obj); 
                            message = 'The update is in progress. You will receive an email as soon as it is completed.';
                        }
                        else
                        {
                            message = 'Previous update is in progress. Please try again later.';
                        }
                    }   
                }   
            }
            else
            {
                 message = 'You do not permission to update this field.';
            }
            return message; 
        }
        catch(Exception e){
            System.debug(e.getMessage()+'<<Line Number>>'+e.getLineNumber());
            return null;
        }
    }    
    public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
    
    //Create fieldset for mass update and export functionality on Filter tab, so that fieldset name will be same for all geocoded objects.
    @future(callout=true)
    global static void createFieldsetonGeocodedObject(string fullName,string label,string description)
    {
        try{
            MetadataService.MetadataPort service = createService();
            MetadataService.FieldSet fieldSet = new MetadataService.FieldSet();
            fieldSet.fullName = fullName;
            fieldSet.label = label;
            fieldSet.description = description;
            if(!test.isRunningTest())
            {
               List<MetadataService.SaveResult> results =  service.createMetadata(new List<MetadataService.Metadata> { fieldSet });
            } 
        }
        catch(Exception e){
            System.debug(e.getMessage()+'<<Line Number>>'+e.getLineNumber());
        }
    }
     //Added by Smita Pawar on 02 Sept 2019 Ends here
     // GreySteel Customization
     //Code added by Priyanka to show Export and Mass Update button basis user profile 
    @RemoteAction
    Global static String ChkUsrAllowedFrExportMU() {
        try{
            Map<String,String> mapResp= new Map<String,String>();
            String isProfileInCS;
            String loggedInProfile = [SELECT Profile.name FROM User where Id =: UserInfo.getUserId()].Profile.name; 
            List<Export_MUEnabler__c> profileNameSettings = Export_MUEnabler__c.getall().values();
            Export_MUEnabler__c profileNameSetting = profileNameSettings.get(0);            
            String profileName = profileNameSetting.ProfileList__c;
            List<String> profiles = profileName.split(',');            
            for(String profile : profiles)
            {
                if(loggedInProfile == profile){
                    isProfileInCS = 'true';
                    break;
                }
                else
                    isProfileInCS = 'false';
            }
            mapResp.put('validUsrFrExportMA',isProfileInCS);
            return JSON.serialize(mapResp);
        }
        catch(Exception e){
            system.debug('MPV2 exception occurred==>' + e.getMessage() );
            return null;
        }
    }
}