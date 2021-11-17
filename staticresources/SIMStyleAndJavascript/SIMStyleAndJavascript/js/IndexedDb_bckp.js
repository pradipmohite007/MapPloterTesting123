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
        //DBNAME = "DataPointsDB"+userId;
        DBNAME = this.CONSTANTS.DB.DB_NAME+userId;
    } else {
        //DBNAME = "DataPointsDB";
        DBNAME = this.CONSTANTS.DB.DB_NAME;
    }

    if (versionNumber) {
        // Open database with the version number provided.
        var openDBRequest = indexedDB.open(DBNAME, versionNumber);
    }
    else {
        // Open database with the default version number.
        var openDBRequest = indexedDB.open(DBNAME);
    }

    // Return success on successful creation of the DB.
    openDBRequest.onsuccess = function (e) {
       // console.log("DB created successfully!");

        DB = e.target.result;
        version = DB.version;
        //console.dir(DB.objectStoreNames);
        $deferred.resolve(true);
    };

    // Return error.
    openDBRequest.onerror = function (e) {
      //  console.log("Error creating the DB!");
        $deferred.reject(false);
    };

    // Handle DB alter operations when the version is upgraded.
    openDBRequest.onupgradeneeded = function (e) {
     //   console.log("Upgrade needed while creating the DB.");

        var thisDB = e.target.result;

        // Create tables.
        if (thisDB) {
            /*for (var i in mpTables) {
                if (!thisDB.objectStoreNames.contains(mpTables[i])) {
                    thisDB.createObjectStore(mpTables[i]);
                    console.log("Object store '" + mpTables[i] + "' created successfully." + thisDB.version);
                }
            }*/
            /*for (var i in mpTables) {
                if (!thisDB.objectStoreNames.contains(mpTables[i])) {
                    thisDB.createObjectStore(mpTables[i]);
                    console.log("Object store '" + mpTables[i] + "' created successfully." + thisDB.version);
                }
            }*/
            for (var i=0; i < mpTables.length; i++) {
                if (!thisDB.objectStoreNames.contains(mpTables[i])) {
                    thisDB.createObjectStore(mpTables[i]);
                  //  console.log("Object store '" + mpTables[i] + "' created successfully." + thisDB.version);
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
             //   console.log("Error in inserting the values in " + tablename + " table: " + e.target.result);
                //alert("Error in inserting the values in " + tablename + " table: " + e.target.result);
                $deferred.reject();
            };

            // Return success when all records are inserted.
            transactionRequest.onsuccess = function (e) {
              //  console.log("Inserted record in " + tablename);
                //alert("Inserted record in " + tablename);
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
        /*for (var index in tablenameArray) {
            if(typeof(tablenameArray[index]) !== "function"){
                if (!DB.objectStoreNames.contains(tablenameArray[index])) {
                    isPresent = 1;
                }
            }
        }*/
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
                  //  console.log("Error in deleting the values in " + tablename + " table: " + e.target.result);
                    $deferred.reject();
                };

                // Return success when all records are inserted.
                transactionRequest.onsuccess = function (e) {
                //    console.log("deleted record in " + tablename);
                    counter++;
                    if (counter == keyArr.length) {
                        $deferred.resolve();
                    }
                };
            }
        } else {
            $deferred.resolve();
        }
        /*if (key) {
            // Open DB in readwrite mode.
            var transactionRequest = DB.transaction([tablename], "readwrite").objectStore(tablename).delete(key);

            transactionRequest.onerror = function (e) {
                console.log("Error in deleting the values from " + tablename + " table: " + e.target.result);
                $deferred.reject();
            };

            transactionRequest.onsuccess = function (e) {
                console.log("Deleted record from " + tablename);
                $deferred.resolve();
            };
        }*/
    }

    return $deferred.promise();
};

// Drops the DB table.
// Parameter: <String> tablename - name of the table to be deleted.
IndexedDb.prototype.drop = function (tablename) {
    var $deferred = new $.Deferred();
    var db;
    var newVersion = version + 1;
  //  console.log("Inside drop Table,newVersion :" + newVersion, "current version :" + version);

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
      //  console.log("IndexedDB error: " + evt.target.errorCode);
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
           //     console.log("Error in fetching the values from " + tablename + " table: " + e.target.result);
                $deferred.reject();
            };

            // Returns the result set after successful retrieval.
            transactionRequest.onsuccess = function (e) {
             //   console.log("Values fetched from " + tablename + " successfully.");
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
          //  console.log('update success');
            var cursor = event.target.result;
            if (cursor !== null) {
                var updateRequest = cursor.update(JSON.stringify(updateRequestObject.value));

                updateRequest.onsuccess = function () {
                 //   console.log('updateRequest success');
                    $deferred.resolve();
                };

                updateRequest.onerror = function () {
                 //   console.log('updateRequest fail');
                    $deferred.reject();
                };
            } else {
              //  console.log('no cursor');
                $deferred.resolve();
            }
        };

        // Return error.
        transactionRequest.onerror = function (event) {
           // console.log('update fail');
            $deferred.reject();
        };
    } else {
       // console.log('no key');
    }

    return $deferred.promise();
};

/*// Checks the availability of the data in the USER table.
IndexedDb.prototype.isDataAvailable = function () {
    var $deferred = new $.Deferred();
    var result = {};

    this.select(this.CONSTANTS.USER_TABLE).done(function (responseObj) {
        var dataset = responseObj[0];
        result.availability = true;
        result.username = dataset['value']['USER_NAME'];
        result.password = dataset['value']['PASSWORD'];
        $deferred.resolve(result);
    }).fail(function (error) {
        console.log(error);
        result.availability = false;
        $deferred.resolve(result);
    });

    return $deferred.promise();
};*/

// Drops the DB tables listed in the constant above.
IndexedDb.prototype.dropDB = function () {
    var $deferred = new $.Deferred();
    var that = this;
    var DB;
    var newVersion = ++version;

    //Opens databse with new version
    var request = indexedDB.open(newVersion);

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

        //Checks whether objectStore is existed. If yes, then delete existing objectStore
        /*for (var index in that.CONSTANTS.MP_TABLES_LIST) {
            if(typeof(that.CONSTANTS.MP_TABLES_LIST[index]) !== "function"){
                var tablename = that.CONSTANTS.MP_TABLES_LIST[index];
                if (DB.objectStoreNames.contains(tablename)) {
                    DB.deleteObjectStore(tablename);
                }
            }
        }*/

        for (var i = 0, len=that.CONSTANTS.MP_TABLES_LIST.length; i<len; i++) {
            var tablename = that.CONSTANTS.MP_TABLES_LIST[i];
            if (DB.objectStoreNames.contains(tablename)) {
                DB.deleteObjectStore(tablename);
            }
        }
    };

    return $deferred.promise();
};

// Rename all the tables of database.
// Parameter: TableObjects <Array> [Array of Objects which holds the data to be moved in new tables].
/*IndexedDb.prototype.renameAllTables = function (TableObject) {
    var that = this;
    var $deferred = new $.Deferred();
    var dataObject = TableObject;
    var renameTableName = this.CONSTANTS.RENAME_TABLE_NAMES;
    var tableNames;
    var objectLength = 0;
    this.createTables(renameTableName).done(function () {
        tableNames = that.CONSTANTS.DROP_TABLE_NAMES;
        for (var index in tableNames) {
            that.drop(tableNames[index]);
        }
        for (var len in TableObject) {
            objectLength++;
        }
        var count = 0;
        for (key in that.CONSTANTS.RENAME_TABLE_MAPPER) {
            that.insert(that.CONSTANTS.RENAME_TABLE_MAPPER[key], dataObject[key]).done(function () {
                count++;
                if (count === objectLength) {
                    $deferred.resolve(true);
                }
            });
        }
    }).fail(function () {
        $deferred.reject(false);
    });

    return $deferred.promise();
};*/

// Rename all the tables of database to thier original name.
// Parameter: TableObjects <Array> [Array of Objects which holds the data to be moved in new tables].
/*IndexedDb.prototype.revertTables = function (TableObject) {
    var that = this;
    var $deferred = new $.Deferred();
    var dataObject = TableObject;
    var renameTableName = this.CONSTANTS.DROP_TABLE_NAMES;
    var tableNames;
    var objectLength = 0;
    this.createTables(renameTableName).done(function () {
        tableNames = that.CONSTANTS.RENAME_TABLE_NAMES;
        for (var index in tableNames) {
            that.drop(tableNames[index]);
        }
        for (var len in TableObject) {
            objectLength++;
        }
        var count = 0;
        for (key in that.CONSTANTS.RENAME_TABLE_MAPPER) {
            that.insert(key, dataObject[key]).done(function () {
                count++;
                if (count === objectLength) {
                    $deferred.resolve(true);
                }
            });
        }
    }).fail(function () {
        $deferred.reject(false);
    });

    return $deferred.promise();
};*/

//return IndexedDb;

