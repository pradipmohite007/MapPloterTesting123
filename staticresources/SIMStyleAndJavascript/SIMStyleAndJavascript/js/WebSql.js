/*
 * WebSQL: 
 *      version: 1.0
 *      Cross Platform: true
 *      Initialization:
 *          Initializes on object creation.
 *      Date: 
 *      Functionality:
 *          CRUD operations on WebSQL.
 */

// Applying strict mode for variable declarations.
"use strict";

// Reference to html5sql library.
var SqlDb = null;

// Method to process the queries.
var processQuery = function (query, successMsg, failureMsg) {
    var startTime = new Date();
    var $deferred = $.Deferred();
    SqlDb.process(query,
       function (transaction, results, rowsArray) { // Success callback function.
           if (rowsArray) {
                rowsArray = rowsArray.map(function (record) { 
                    //return { key: record.key, value: JSON.parse(record.value) }
                    return { key: record.key, value: checkString(record.value) }
                });
                $deferred.resolve(rowsArray);
           }
           else {
               $deferred.resolve(true);
           }
           var endTime = new Date();
          // console.log(successMsg+ ' ' + ((endTime - startTime) / 1000) + "s");
           //alert(successMsg+ ' ' + ((endTime - startTime) / 1000) + "s");
       },
       function (error, failingQuery) { // Failure callback function.
           var errorStr = "Error :" + failureMsg +
           "\n Error Desc :" + error.message +
           "\n In Statement/s :" + failingQuery;
           $deferred.reject(error);
        //   console.error(errorStr);
           //alert(errorStr);
       }
   );

    return $deferred.promise();
};

// Util function to get key,val pair from passed object.
var getKeyVal = function (obj) {
    var keys = [];
    var values = [];
    var temp = "";
    for (var k in obj) {
        keys.push(k);
        values.push(obj[k]);
    }
    for (var c in values) { temp += "'"; temp += values[c]; temp += "',"; }
    temp = temp.slice(0, temp.length - 1);
    return { keys: keys, values: values, valuesStr: temp };
};

var convertString = function(str){
    //str = str.replace(/&/g, "&amp;");
    //str = str.replace(/>/g, "&gt;");
    //str = str.replace(/</g, "&lt;");
    //str = str.replace(/"/g, "&quot;");
    str = str.replace(/'/g, "&#039;");
    return str;
};

var checkString = function(strVal){
    var val;
    try{
        val = JSON.parse(strVal);
        if(typeof(val) == "number"){
            val = val.toString();
        }
    } catch(e){
        //console.log(e);
        val = strVal;
    }
    return val;
}


//Constructor
function WebSql() {
    SqlDb = html5sql;
}

// DB Constants.
WebSql.prototype.CONSTANTS = {
    DATAPOINTS_TABLE: "DATAPOINTS",
    CITY_TABLE: "CITIES",
    COUNTRY_TABLE: "COUNTRIES",
    MP_TABLES_LIST: ["DATAPOINTS", "CITIES", "COUNTRIES"],
    DB: {
        DB_NAME: "DataPointsDB",
        DB_DISPLAY_NAME: "Map Plotter DB",
        DB_SIZE: 5*1024*1024
    }
};

// Creates new database or opens an existing one.
// Parameter: <String> dbName - Name of the DB.
//            <String> dbDesc - Display name of the DB.
//            <String> dbSize - Size of the DB.
WebSql.prototype.open = function (dbName, dbDesc, dbSize) {
    var userId = localStorage.getItem('sfuserid');
    if(userId !== null){
        var dbName = this.CONSTANTS.DB.DB_NAME+userId;
    } else {
        var dbName = this.CONSTANTS.DB.DB_NAME;
    }
    var dbDesc = dbDesc || this.CONSTANTS.DB.DB_DISPLAY_NAME;
    var dbSize = dbSize || this.CONSTANTS.DB.DB_SIZE;
    var $deferred = new $.Deferred();
    try {
        SqlDb.openDatabase(dbName, dbDesc, dbSize);
        // Return success on successful creation of the DB.
        $deferred.resolve(true);
    }
    catch (error) {
        // Return error.
        $deferred.reject(error);
      //  console.log("Error in OpenDb " + error.message);
    }
    finally {

    }
    return $deferred.promise();
};

// Insert a new row into the Db.
// Parameter: <String> tablename - name of the table to insert values into.
//            <Array> objArray - Array of the data to be inserted in key value pair.
WebSql.prototype.insert = function (tablename, objArray) {
    var sqlQueries = [];
    var str;
    for (var r in objArray) {
        // str = "INSERT INTO " + tablename + "(key,value) VALUES (" + "\'" + objArray[r].key + "\'," + "\'" + JSON.stringify(objArray[r].value) + "\'" + ")";
        if(objArray[r] && objArray[r].Id){
            str = "INSERT INTO " + tablename + "(key,value) VALUES (" + "\'" + objArray[r].Id + "\'," + "\'" + convertString(JSON.stringify(objArray[r])) + "\'" + ")";
            sqlQueries.push(str);
        } else if(typeof(objArray[r]) !== "function" && !objArray[r].Id){
            // in this case if Id is not present, use value as Id
            // this is case to store city Ids and country Names
            var keyVal = convertString(objArray[r]);
            if(keyVal){
                str = "INSERT INTO " + tablename + "(key,value) VALUES (" + "\'" + keyVal + "\'," + "\'" + keyVal + "\'" + ")";
                sqlQueries.push(str);
            }
        }
    }
    return (processQuery(sqlQueries, "Row Insert Success", "Row Insert Fail"));
};

// Selects the record on the basis of selectors provided.
// Parameters: <String> tablename - Name of the table from which the value is to be retrieved.
//             <String> key - Primary key of the data to be retrieved.
WebSql.prototype.select = function (tablename, key) {
    var sqlQueries;
    if (key) {
        // Returns the result set after successful retrieval.
        sqlQueries = "SELECT * FROM " + tablename + " WHERE key=" + "\'" + key + "\'";
    }
    else {
        // Returns all the records if no key specified.
        sqlQueries = "SELECT * FROM " + tablename;
    }

    return (processQuery(sqlQueries, "Row Select Success", "Row Select Fail"));
};

// Creates new tables in the DB.
// Parameter: <Array> tablenameArray - contains the names of the tables to be created.
WebSql.prototype.createTables = function (tablenameArray) {
    var sqlQueries = [];
    var str;
    /*for (var record in tablenameArray) {
        str = 'CREATE TABLE IF NOT EXISTS ' + tablenameArray[record] + '( \"key\" Char(100 ) PRIMARY KEY NOT NULL,\"value\" Char(1000) NOT NULL)';
        sqlQueries.push(str);
    }*/
    for (var i=0; i<tablenameArray.length; i++){
        str = 'CREATE TABLE IF NOT EXISTS ' + tablenameArray[i] + '( \"key\" Char(100 ) PRIMARY KEY NOT NULL,\"value\" Char(1000) NOT NULL)';
        sqlQueries.push(str);
    }

    return (processQuery(sqlQueries, "Create Table Success", "Create Table Fail"));
};

// Deletes a particular record from the DB table.
// Parameter: <String> tablename - name of the table to delete the record from.
//            <String> key - Primary key of the record to be deleted.
WebSql.prototype.remove = function (tablename, keyArr) {
    var sqlQueries = [];
    if(keyArr && keyArr.length > 0){
        for (var i = 0; i < keyArr.length; i++) {
            var query = "DELETE FROM " + tablename + " WHERE key=" + "\'" + keyArr[i] + "\'";
            sqlQueries.push(query);
        }
    } else {
        sqlQueries = "DELETE FROM " + tablename;
    }
    return (processQuery(sqlQueries, "Remove Success", "Remove Fail"));
    /*var sqlQueries = null;
    if (key) {
        sqlQueries = "DELETE FROM " + tablename + " WHERE key=" + "\'" + key + "\'";
    }
    else {
        sqlQueries = "DELETE FROM " + tablename;
    }
    return (processQuery(sqlQueries, "Remove Success", "Remove Fail"));*/
};

// Drops the DB table.
// Parameter: <String> tablename - name of the table to be deleted.
WebSql.prototype.drop = function (tablename) {
    var $deferred = new $.Deferred();
    var sqlQueries = "DROP TABLE IF EXISTS " + tablename;
    processQuery(sqlQueries, "Drop Table Success", "Drop Table Fail").done(function () {
        $deferred.resolve(true);
    }).fail(function (error) {
        $deferred.reject(error);
    });

    return $deferred.promise();
};

// Updates a particular record in the DB table.
// Parameters: <String> tablename - name of the table in which we need to update the record.
//             <Object> updateRequestObject - it holds the key value pair of the records to be updated.
WebSql.prototype.update = function (tablename, updateRequestObject) {
    //console.log(convertString(JSON.stringify(updateRequestObject.value)));    
    var sqlQueries = [];
    var str;
    if (updateRequestObject.key) {
        //sqlQueries = "UPDATE " + tablename + " SET value=" + "\'" + convertString(JSON.stringify(updateRequestObject.value)) + "\'" + "WHERE key=" + "\'" + updateRequestObject.key + "\'";
        str = "UPDATE " + tablename + " SET value=" + "\'" + convertString(JSON.stringify(updateRequestObject.value)) + "\'" + "WHERE key=" + "\'" + updateRequestObject.key + "\'";
        sqlQueries.push(str);
    }
    else {
        //sqlQueries = "UPDATE " + tablename + " SET value=" + "\'" + convertString(JSON.stringify(updateRequestObject.value)) + "\'";
        str = "UPDATE " + tablename + " SET value=" + "\'" + convertString(JSON.stringify(updateRequestObject.value)) + "\'";
        sqlQueries.push(str);
    }
    //console.log(sqlQueries);
    return (processQuery(sqlQueries, "Update Row Success", "Update Row Fail"));
};

// Checks the availability of the data in the USER table.
/*WebSql.prototype.isDataAvailable = function () {
    var $deferred = new $.Deferred();

    var result = {};

    this.select(this.CONSTANTS.USER_TABLE).done(function (responseObj) {

        var dataset = responseObj[0];
        console.log(responseObj[0]);
        result.availability = true;
        result.username = dataset['value']['USER_NAME'];
        result.password = dataset['value']['PASSWORD'];
        console.log("Success: " + responseObj);
        $deferred.resolve(result);
    }).fail(function (error) {
        console.log(error);
        result.availability = false;
        $deferred.resolve(result);
    });


    return $deferred.promise();
};*/

// Retrieves the user data from the USER table.
/*WebSql.prototype.getUserProfile = function () {
    var $deferred = new $.Deferred();

        this.select(this.CONSTANTS.USER_TABLE).done(function (responseObj) {
        console.log("Success get User Profile: " + JSON.stringify(responseObj));
        $deferred.resolve(responseObj);
    }).fail(function (error) {
        $deferred.reject(false);
    });

    return $deferred.promise();
};*/

// Renames the tables specified in the constants to make them temporary backups.
/*WebSql.prototype.renameAllTables = function () {

    var sqlQueries = [];
    var mapperObject = this.CONSTANTS.RENAME_TABLE_MAPPER;
    for (var i in mapperObject) {
        var str = "ALTER TABLE " + i + " RENAME TO " + mapperObject[i];
        sqlQueries.push(str);
    }

    return (processQuery(sqlQueries, "INTERNATIONALIZATION.RENAME_ALL_TABLES_SUCCESS", "INTERNATIONALIZATION.RENAME_ALL_TABLES_FAILURE"));
};*/

// Drops the DB tables listed in the constant above.
WebSql.prototype.dropDB = function () {
    var $deferred = new $.Deferred();
    var sqlQueries = [];    
    for (var index in this.CONSTANTS.MP_TABLES_LIST) {
        if(typeof(this.CONSTANTS.MP_TABLES_LIST[index]) !== "function"){
            sqlQueries.push("DROP TABLE IF EXISTS " + this.CONSTANTS.MP_TABLES_LIST[index]);
        }
    }

    processQuery(sqlQueries, "dropDB Success", "dropDB Fail").done(function () {
        $deferred.resolve(true);
    }).fail(function (error) {
        $deferred.reject(error);
    });

    return $deferred.promise();
};

// Renames the tables specified in the constants to make them temporary backups.
/*WebSql.prototype.revertTables = function () {

    var sqlQueries = [];
    var revertMapperObject = this.CONSTANTS.REVERT_TABLE_MAPPER;
    for (var i in revertMapperObject) {
        var str = "ALTER TABLE " + i + " RENAME TO " + revertMapperObject[i];
        sqlQueries.push(str);
    }

    return (processQuery(sqlQueries, "INTERNATIONALIZATION.REVERT_ALL_TABLES_SUCCESS", "INTERNATIONALIZATION.REVERT_ALL_TABLES_FAILURE"));
};*/

//return WebSql;