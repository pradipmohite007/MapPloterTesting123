/**
 * Main Controller:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality:
 *      Main Controller is the parent controller which is loaded at the app initialization.      
 *      It is also responsible for initializing and holding the global objects and data which is required access the app.
 */

// Strict mode allows you to place the code in the 'strict' operating context.
'use strict';

var app = app || {};
var dpTable, reportTable, srchResTable;
var isCountryDataUpdated = true;
var isLocationAllowed = true;
//GreySteel Customization
//Code added by Rakesh to show Export and Mass Update button basis user profile 
var isExportAllowed = false;

$(function () {
	app.init = function(){
		app.utility.clearDBfunction();
		app.utility.initalizeConsoleLogging();
		var that = this;
		app.utility.showLoader();

	    var DbManager = (function () {
                            var init = function () {
				if (window.indexedDB) {	
                                    return IndexedDb;
                                }else {
                                    appWithIndexedDB= false;
					new app.homeView();                                   
                                }
		                  };
                    // Return initialize method.
                    return {
                        init: init
                    }
		     })();
		var dbObj = DbManager.init();
		app.DbManager = new dbObj();
		that.checkUserDB().done(function(){
			app.DbManager.open().done(function(){
				app.DbManager.createTables(app.DbManager.CONSTANTS.MP_TABLES_LIST).done(function(){
					new app.homeView();
				}).fail(function(e){
					alert('private browsing mode');
					alert(MP_CONSTANTS.DB_MESSAGES.CREATE_TABLE_FAILURE + JSON.stringify(e));
				});
			}).fail(function(e){
				alert('private browsing mode');
				alert(MP_CONSTANTS.DB_MESSAGES.OPEN_DB_FAILURE + JSON.stringify(e));
			});
		});

		jQuery.expr[':'].containsSearch = function(a, i, m) {
			return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
		};
	};

	app.checkUserDB = function(){		
		var $deferred = new $.Deferred();
		// get last user id and check with current
		// if same -- do nothing
		var lastUserId = localStorage.getItem(MP_CONSTANTS.LOCAL_STORAGE.SF_USER_ID);
		if(lastUserId == null || lastUserId == currentSFUserId){
			if(lastUserId == null){
				try{
					localStorage.setItem(MP_CONSTANTS.LOCAL_STORAGE.SF_USER_ID, currentSFUserId);
				} catch(e){
					alert('localstorage not available');
				}
			}
			$deferred.resolve();
		} else if(lastUserId !== currentSFUserId) {
			
			//  update lastUserId with new currentSFUserId
			localStorage.setItem(MP_CONSTANTS.LOCAL_STORAGE.SF_USER_ID, currentSFUserId);	
			$deferred.resolve();
	}

		return $deferred.promise();
	};

	app.mapDetailViewData = [];
	app.panelfData = [];
	app.currentViewObj = null;
    
    app.checkPanal; 
    
	app.init();
});