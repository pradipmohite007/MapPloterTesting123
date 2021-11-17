/*
 * DbManager: 
 *      version: 1.0
 *      Cross Platform: true
 *      Initialization:
 *          Initializes on object creation.
 *      Date: 
 *      Functionality:
 *          Initializes appropriate database object depending on the support provided by the browser.
 */


// Module begins here.

// Applying strict mode for variable declarations.
"use strict";

var DbManager = (function () {

    var init = function () {
        //check for webSQL support
        if (!!window.openDatabase) {
            return webSQLObj;
        }
            //check for indexedDB support
        else if (window.indexedDB) {
            return indexedDbObj;
        }
        else {
            alert("INTERNATIONALIZATION.ERROR_CREATING_DB");
            return;
        }
    };

    // Return initialize method.
    return {
        init: init
    }

})();


