/*
 * Indexed DB: 
 *      version: 1.0
 *      Cross Platform: true
 *      Initialization:
 *          Initializes on object creation.
 *      Date: 
 *      Functionality:
 *          CRUD operations on Indexed DB.
 */

// get the implementations of Indexed DB.           
window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction || window.msIDBTransaction;
window.IDBKeyRange = window.IDBKeyRange || window.webkitIDBKeyRange || window.msIDBKeyRange;

var indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB;

// Applying strict mode for variable declarations.
"use strict";

// Global variables.
var DB = null;
var mpTables = null;
var version = null;
var DBNAME = null;

// Constructor.
function IndexedDb() {
    mpTables = ['DATAPOINTS'];
    version = 1;
}

// DB Constants.
IndexedDb.prototype.CONSTANTS = {
    DATAPOINTS_TABLE: "DATAPOINTS",
    CITY_TABLE: "CITIES",
    COUNTRY_TABLE: "COUNTRIES",
    MP_TABLES_LIST: ["DATAPOINTS", "CITIES", "COUNTRIES"],
    DB: {
        DB_NAME: "DataPointsDB"
    }
};

// Creates new database or opens an existing one.
// Parameter: <Integer> versionNumber - Version number of the database to refer to.
IndexedDb.prototype.open = function (versionNumber) {

    var $deferred = new $.Deferred();
    var userId = localStorage.getItem('sfuserid');
    if(userId !== null){
        DBNAME = this.CONSTANTS.DB.DB_NAME+userId;
    } else {
        DBNAME = this.CONSTANTS.DB.DB_NAME;
    }

    if (versionNumber) {
        // Open database with the version number provided.
		try{
			var openDBRequest = indexedDB.open(DBNAME, versionNumber);
		}catch(err){
          
           appWithIndexedDB = false;
           new app.homeView();
		}
    }else {
        // Open database with the default version number.
		try{
			var openDBRequest = indexedDB.open(DBNAME);
		}catch(err){            
           appWithIndexedDB = false;
           new app.homeView();
		}
    }

    // Return success on successful creation of the DB.
    openDBRequest.onsuccess = function (e) {
        DB = e.target.result;
        version = DB.version;
        $deferred.resolve(true);
    };

    // Return error.
    openDBRequest.onerror = function (e) {
        $deferred.reject(false);
    };

    // Handle DB alter operations when the version is upgraded.
    openDBRequest.onupgradeneeded = function (e) {
        var thisDB = e.target.result;
   // Create tables.
        if (thisDB) {
            for (var i=0; i < mpTables.length; i++) {
                if (!thisDB.objectStoreNames.contains(mpTables[i])) {
                    thisDB.createObjectStore(mpTables[i]);
                }
            }
        }
    };

    return $deferred.promise();
};

// Insert a new row into the DB.
// Parameter: <String> tablename - name of the table to insert values into.
//            <Array> objArray - Array of the data to be inserted in key value pair.
IndexedDb.prototype.insert = function (tablename, objArray) {
    var $deferred = new $.Deferred();
    var counter = 0;
    var objLength = objArray.length;

    if (DB) {
        for (var record in objArray) {
            // Open a DB transaction in the readwrite mode.
            //var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).put(JSON.stringify(objArray[record].value), objArray[record].key);
            if(objArray[record] && objArray[record].Id){
                var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).put(JSON.stringify(objArray[record]), objArray[record].Id);
            } else if(typeof(objArray[record]) !== "function" && !objArray[record].Id){
                // in this case if Id is not present, use value as Id
                // this is case to store city Ids and country Names
                var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).put(JSON.stringify(objArray[record]), objArray[record]);
            }

            // Return error.
            transactionRequest.onerror = function (e) {
                $deferred.reject();
            };

            // Return success when all records are inserted.
            transactionRequest.onsuccess = function (e) {
                counter++;
                if (counter == objLength) {
                    $deferred.resolve();
                }
            };
        }
    }

    return $deferred.promise();

};

// Creates new tables in the DB.
// Parameter: <Array> tablenameArray - contains the names of the tables to be created.
IndexedDb.prototype.createTables = function (tablenameArray) {
    var $deferred = new $.Deferred();
    var isPresent = 0;

    if (DB) {
        // Check if the table already exists.
        for (var i=0, len=tablenameArray.length; i<len; i++) {
            if (!DB.objectStoreNames.contains(tablenameArray[i])) {
                isPresent = 1;
            }
        }

        if (isPresent) {
            // Close the current DB instance before upgrading the version.
            DB.close();

            // Change the version number of the DB.
            varsion = version++;

            mpTables = mpTables.concat(tablenameArray);
            this.open(version).done(function () {
                $deferred.resolve();
            }).fail(function () {
                $deferred.reject();
            });
        }
        else {
            $deferred.resolve();
        }
    }
    else {
        $deferred.reject();
    }

    return $deferred.promise();
};

// Deletes a particular record from the DB table.
// Parameter: <String> tablename - name of the table to delete the record from.
//            <String> key - Primary key of the record to be deleted.
IndexedDb.prototype.remove = function (tablename, keyArr) {
    var $deferred = new $.Deferred();
    var counter = 0;

    if (DB) {
        if(keyArr && keyArr.length > 0){
            for (var i=0, len=keyArr.length; i<len; i++) {
                // Open a DB transaction in the readwrite mode.
                //var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).put(JSON.stringify(objArray[record].value), objArray[record].key);
                if(keyArr[i]){
                    var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).delete(keyArr[i]);
                }

                // Return error.
                transactionRequest.onerror = function (e) {
                    $deferred.reject();
                };

                // Return success when all records are inserted.
                transactionRequest.onsuccess = function (e) {
                    counter++;
                    if (counter == keyArr.length) {
                        $deferred.resolve();
                    }
                };
            }
        } else {
            // clear all data from tablename
            var transaction = DB.transaction([tablename], "readwrite").objectStore(tablename).clear();
            transaction.onerror = function(e){
                $deferred.resolve();
            };

            transaction.onsuccess = function(e){
                $deferred.resolve();
            };            
        }
    }

    return $deferred.promise();
};

// Drops the DB table.
// Parameter: <String> tablename - name of the table to be deleted.
IndexedDb.prototype.drop = function (tablename) {
    var $deferred = new $.Deferred();
    var db;
    var newVersion = version + 1;
    // Opens databse with new version.
    var request = indexedDB.open(newVersion);

    // OnSuccess of opening database.
    request.onsuccess = function (evt) {
        // Db refers database.
        db = evt.target.result;
        $deferred.resolve(true);
    };

    // Error Handling Code for opening database.
    request.onerror = function (evt) {
        $deferred.reject(false);
    };

    // Create Object stores in a versionchange transaction.
    request.onupgradeneeded = function (evt) {
        db = evt.target.result;

        // Checks whether objectStore is existed. If yes, then delete existing objectStore
        if (db.objectStoreNames.contains(tablename)) {
            db.deleteObjectStore(tablename);
        }
    };

    return $deferred.promise();
};

// Selects the record on the basis of selectors provided.
// Parameters: <String> tablename - Name of the table from which the value is to be retrieved.
//             <String> key - Primary key of the data to be retrieved.
IndexedDb.prototype.select = function (tablename, key) {
    var $deferred = new $.Deferred();
    var records = [];
	
   
    
    if (DB) {
       
        if (key) {
           
            // Open the transaction in readwrite mode and get the value.
            var transactionRequest = DB.transaction([tablename], "readonly").objectStore(tablename).get(key);

            // Return error.
            transactionRequest.onerror = function (e) {
                $deferred.reject();
            };

            // Returns the result set after successful retrieval.
            transactionRequest.onsuccess = function (e) {
                var resultArray = [];
                records = e.target.result;
                if (Object.prototype.toString.call(records) === '[object Array]') {
                    for (index in records) {
                        var tempObj = { "key": key, "value": JSON.parse(records[index]) };
                        resultArray.push(tempObj);
                    }
                }
                else {
                    if (!$.isEmptyObject(records)) {
                        var tempObj = { "key": key, "value": JSON.parse(records) };
                        resultArray.push(tempObj);
                    }
                }

                $deferred.resolve(resultArray);
            };
        }
        else {
            
            // Open the transaction in readonly mode.
            var transactionRequest = DB.transaction([tablename], "readonly").objectStore(tablename).openCursor();

            // Returns all the records if no key specified.
            transactionRequest.onsuccess = function (event) {
                var cursor = event.target.result;
                if (cursor) {
                    var tempObj = { "key": cursor.key, "value": JSON.parse(cursor.value) };
                    records.push(tempObj);
                    cursor.continue();
                }
                else {
                    $deferred.resolve(records);
                }
            };
            // Return error.
            transactionRequest.onerror = function (event) {
                $deferred.reject();
            };
        }
    }
    return $deferred.promise();
};

// Updates a particular record in the DB table.
// Parameters: <String> tablename - name of the table in which we need to update the record.
//             <Object> updateRequestObject - it holds the key value pair of the records to be updated.
IndexedDb.prototype.update = function (tablename, updateRequestObject) {
    var $deferred = new $.Deferred();

    if (updateRequestObject.key) {
        var keyRange = IDBKeyRange.only(updateRequestObject.key);

        var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).openCursor(keyRange);

        // Return true on success and false on error.
        transactionRequest.onsuccess = function (event) {
            var cursor = event.target.result;
            if (cursor !== null) {
                var updateRequest = cursor.update(JSON.stringify(updateRequestObject.value));

                updateRequest.onsuccess = function () {
                    $deferred.resolve();
                };

                updateRequest.onerror = function () {
                    $deferred.reject();
                };
            } else {
                $deferred.resolve();
            }
        };

        // Return error.
        transactionRequest.onerror = function (event) {
            $deferred.reject();
        };
    } else {
    }

    return $deferred.promise();
};

// Drops the DB tables listed in the constant above.
IndexedDb.prototype.dropDB = function () {
    var $deferred = new $.Deferred();
    var that = this;
    var DB;
    var newVersion = ++version;

    //Opens databse with new version
    try{
    	var request = indexedDB.open(newVersion);    
    }catch(err){
    }
    

    //onSuccess of opening database
    request.onsuccess = function (evt) {
        // DB refers database.
        DB = evt.target.result;
        $deferred.resolve(true);
    };

    //Error Handling Code for opening database
    request.onerror = function (evt) {
        $deferred.reject(false);
    };

    //create Object stores in a versionchange transaction.
    request.onupgradeneeded = function (evt) {
        DB = evt.target.result;

        for (var i = 0, len=that.CONSTANTS.MP_TABLES_LIST.length; i<len; i++) {
            var tablename = that.CONSTANTS.MP_TABLES_LIST[i];
            if (DB.objectStoreNames.contains(tablename)) {
                DB.deleteObjectStore(tablename);
            }
        }
    };

    return $deferred.promise();
};
