/**
 * Data Model:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality:
 *
 */

var app = app || {};

'use strict';
app.dataModel = Backbone.Model.extend({
        
    intialize: function () {
        
    },

    getDataObjListData: function(){
        // get custom objects
        var $deferred = new $.Deferred();

        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_CUSTOM_OBJ_LIST,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);                        
                    dataObjects = response;
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );

        return $deferred.promise();
    },

    getCountriesStatesData: function(){
        // call remoting for getting country and state data
        var $deferred = new $.Deferred();

        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_COUNTRY_DATA,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);                        
                    
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );

        return $deferred.promise();
    },

    getDataPoints: function(cityArray, selectedDataPoints, offsetId){
        // remoting call for getting data points related to countries
        // accept city array and selected datapoints as para
        
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_DATAPOINTS, cityArray, offsetId,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getSearchResult: function(searchString, customObj, offsetId){
        // remoting call for getting search results
        // accept search string and active 'custom objects' as para
        
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_SEARCH_RESULT, searchString, customObj, offsetId,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);                        
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getWeatherAPIKey: function(){
        var $deferred = new $.Deferred();
        // method return google geocoding API key
        // and world weather API key            
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_API_KEYS,
            function(result, event) {
                
                if(result){
                    var response = app.utility.parseResult(result);                        
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getReportList: function(){
        var $deferred = new $.Deferred();
        // get list of reports for report view
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_REPORT_LIST,
            function(result, event) {
                
                if(result){
                    var response = app.utility.parseResult(result);                        
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getReportsData: function(reportId, offsetId){
        var $deferred = new $.Deferred();
        // get list of reports for report view
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_REPORT_DATA, reportId, offsetId,
            function(result, event) {
                
                if(result){
                    var response = app.utility.parseResult(result);                        
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    checkApexJobStatus: function(){
        var $deferred = new $.Deferred();
        // check if any apex job is ongoing
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.CHECK_APEX_JOB_STATUS,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);                        
                    $deferred.resolve(response);
                } else {
                    $deferred.resolve(false);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getSyncData: function(lastSync, insertionOffsetId, updationOffsetId, deletionOffsetId){
        var $deferred = new $.Deferred();
        // get Delta for updated data
        // resp contains ADDED, UPDATED and DELETED(only Ids) records
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_SYNC_DATA, lastSync, insertionOffsetId, updationOffsetId, deletionOffsetId,
            function(result, event) {
                if(event.status){
                    if(result){
                        var response = app.utility.parseResult(result);
                    	$deferred.resolve(response);
                    }else{
                        $deferred.reject("dataIsUptoDate");
                    }                   
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getObjectMetadata: function(objName){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_OBJ_METADATA, objName,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getOperators: function(){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_OPERATORS,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    saveFilter: function(filterObj){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.SAVE_FILTER, filterObj,
            function(result, event) {
                if(result){
                    $deferred.resolve();
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    editFilter: function(filterId){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.EDIT_FILTER, filterId,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    deleteFilter: function(filterId){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.DELETE_FILTER, filterId,
            function(result, event) {
                if(result){                    
                    $deferred.resolve();
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

    getFilterLegend: function(filterId){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_FILTER_LEGEND, filterId,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },

   //Map-plotter customization-Export function- Kirtimala
    exportData: function(recID, objectarray,filterOffsetID,recIDs){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.EXPORT_DATA, recID,objectarray,filterOffsetID,recIDs,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },
    
    //Mass update function -Kirtimala
    massUpdatefield: function(objectName){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.MASS_UPDATE_FIELD, objectName,
            function(result, event) {
                if(result){
                    var response = app.utility.parseResult(result);
                    $deferred.resolve(response);
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },
       massUpdate: function(objectName){
        var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.MASS_UPDATE, Filterid, objectName,selectedfield,selectedPickListValue,
            function(result, event) {
                if(result){
                    $deferred.resolve(response);
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        return $deferred.promise();
    },
    //GreySteel Customization
    //Code added by Rakesh to show Export and Mass Update button basis user profile 
    //Start here
    chkUsrAllowedFrExportMU: function(){
        // call remoting to check if logged in user is allowed for Mass Update and Export option
        var $deferred = new $.Deferred();

        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.VALIDUSER_FR_EXPORTMU,
            function(result, event) {
                if(result){
                    var response = result;         
                    
                    $deferred.resolve(response);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );

        return $deferred.promise();
    },
    //End here
});