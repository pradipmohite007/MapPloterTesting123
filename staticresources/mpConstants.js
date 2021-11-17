var MP_CONSTANTS = {

	LOG_LEVEL: 'ALL',

	STRING: "string",
	
	ERROR_MESSAGES: {
		NO_DATA_SEARCH: 'No results found',
		ADV_SEARCH_FAILURE: 'Search Failed', 
		GEOLOCATION_NOT_SUPPORTED: 'GeoLocation not supported',
		NO_DATA: 'No data available',
		GEOCODING_IN_PROCESS: 'Geocoding is in Process. Please check after sometime.'
	},

	SUCCESS_MESSAGES: {

	},

	ALERT_MESSAGES: {
		CUSTOM_OBJECT_REQUIRED: 'Select at least one object to continue',
		SPECIAL_CHARACTER: 'Enter a valid search term',
		KEY_FOR_SEARCH: 'Enter a keyword',
		CITY_REQUIRED: 'Select at least one City to continue',
		DATA_POINT_REQUIRED: 'Select at least one data point to plot on the map',
		GET_LIST_DATA: 'Please get some data to display in list',
		ALLOW_LOCATION: 'Please allow force.com to use your location',
		SELECT_SOURCE_AND_DEST: 'Select a source and a destination',
		MAX_DESTINATIONS: 'You can add only 8 destinations',
		MAX_DESTINATIONS_REACHED: 'The maximum number of destinations has been reached',
		DESTINATION_REQUIRED: 'Select a point as new destination to continue',
		OBJECT_NOT_GEOCODED: 'Object for this report is not Geocoded',
		NO_REPORT_ID: 'Report Id is not available for this Report',
		RADIUS_NOT_VALID: 'Enter a valid radius',
		NO_DIRECTIONS: 'Directions not available',
		LOCATION_DETAILS_NOT_FOUND: 'Location unavailable',
		FILTER_NAME_REQUIRED: 'Please enter filter name',
		DUPLICATE_FILTER_NAME: 'Filter name already exists',
                MAX_LENGTH:'Filter name contains maximum 80 characters',
		BASE_OBJECT_REQUIRED: 'Please select base object',
		FIELD_REQUIRED: 'Please select field',
		OPERATOR_REQUIRED: 'Please select operator',
		QUERY_VALUE_REQUIRED: 'Please enter query value',
		COLOR_VALUE_REQUIRED: 'Please select color',
		INVALID_DATE: 'Invalid date format(Valid date format MM/DD/YYYY)',
		DUPLICATE_QUERY_VALUE: 'Duplicate query value',
		DUPLICATE_COLOR_VALUE: 'Duplicate color value',
		DUPLICATE_FILTER_NAME: 'Filter name already used',
		REVIEW_FILTER_VALUES: 'Please review all values or correct filter logic.',
        INDEXEDDB_ALERT: 'Unable to perform required operation,  for more information please visit <a target="_blank" href="http://www.extentia.com/mapplotter">FAQ</a>'
	},

	DB_TABLES: {
		DATAPOINTS_TABLE: "DATAPOINTS",
		COUNTRIES_TABLE: "COUNTRIES",
		CITIES_TABLE: "CITIES"
	},

	DB_MESSAGES: {
		CREATE_DB_FAILURE: "Error Creating DB",
        CREATE_TABLE_SUCCESS: "Tables created successfully in ",
        INSERT_ROW_SUCCESS: "Rows Inserted in ",
        UPDATE_ROW_SUCCESS: "Updated Row in ",
        DROP_TABLE_SUCCESS: "Table Dropped in ",
        DELETE_ROW_SUCCESS: "Row Deleted Succesfully in ",
        SELECT_ROWS_SUCCESS: "Rows Selected in ",
        CREATE_TABLE_FAILURE: "Table Create Failed",
        INSERT_ROW_FAILURE: "InsertRowFailure",
        UPDATE_ROW_FAILURE: "UpdateRowFailure",
        DROP_TABLE_FAILURE: "DropTableFailure",
        DELETE_ROW_FAILURE: "DeleteRowFailure",
        OPEN_DB_FAILURE: "DB Open Failed",
        SELECT_ROWS_FAILURE: "SelectRowsFailure"
    },

	LOCAL_STORAGE: {
		SF_USER_ID: 'sfuserid',
		LAST_SYNC_TIME: 'lastSync',
		LAST_APEX_JOB_COMPLETE: 'lastApexJobComplete'
	},

	MAX_CIRCLE_RADIUS: 5000000,

	FOOD_STAY_RADIUS: 5000,

	ALLOWED_FILTER_COUNT: 10,

	ALLOWED_REFINE_FILTER_COUNT: 5,
	
	MAX_INSERT_UPDATE_DELETE_RECORDS: 2000
};