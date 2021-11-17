/*
 * Utility:
 *      version: 1.0
 *      Cross Platform: true
 *      Initialization:
 *          Initializes on object creation.
 *      Date:
 *      Functionality:
 *          A module that contains all the utilities functions
 */

var app = app || {};
var recID = [];
var selectedrecords = [],objectArray=[],activemarkers = [];
var allDataPoints = [];
var isFilter = false;
var currentFileldSet="";
'use strict';
app.utility = {
showLoader: function(){
		var loader = document.getElementById('loader-overlay');
		loader.style.display = 'block';
	},

	hideLoader: function(){
		var loader = document.getElementById('loader-overlay');
		loader.style.display = 'none';
	},
    
    // function for clearing indexedDB on unistallation of app.
    clearDBfunction : function(){
        function getUrlVars()
        {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for(var i = 0; i <hashes.length;i++)
            {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        }
		
        var clearDB = getUrlVars().DbClear;
        
        if(clearDB == "true"){
            app.DbManager.dropDB();
        }
        
    },

	createTemplate: function(templateId){
		//get template from static resource
		var templatePath = pinURL+'/SIMStyleAndJavascript/templates/'+templateId+'.html';		
		function getTemplate(templatePath) {
		    var result="";
		    $.ajax({
		      	url: templatePath,
                beforeSend: function(request) {
                    request.setRequestHeader("X-Frame-Options", "sameorigin");
                    request.setRequestHeader("Cache-Control", "max-age=<900>");
                },
		      	async: false,
		      	success:function(data) {
		         	result = _.template(data);
		      	}
		   });
		   return result;
		}
		return getTemplate(templatePath);		
	},

	allowOnlyNumber: function(e){
		if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
			 // Allow: Ctrl+A, Command+A
			(e.keyCode == 65 && ( e.ctrlKey === true || e.metaKey === true ) ) || 
			 // Allow: home, end, left, right, down, up
			(e.keyCode >= 35 && e.keyCode <= 40)) {
				 // let it happen, don't do anything
				 return;
		}
		// Ensure that it is a number and stop the keypress
		if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
			e.preventDefault();
		}
	},

	parseResult: function(result){
		var response;
		var convertString = function(str){
			if(str){
				str = str.replace(/>/g, "&gt;");
			    str = str.replace(/</g, "&lt;");
			    return str;
			} else {
				return str;
			}
		};
		if(typeof(result) === MP_CONSTANTS.STRING){
			result = convertString(result);
			response = JSON.parse(result);
		} else {
			response = result;
		}
		return response;
	},

	divideArrayIntoN: function(arr, chunk_size){
		var groups = arr.map( function(e,i){ 
			return i%chunk_size===0 ? arr.slice(i,i+chunk_size) : null; 
		}).filter(function(e){
			return e;
		});
		return groups;
	},

	delay: (function(){
		var timer = 0;
		return function(callback, ms){
			clearTimeout(timer);
			timer = setTimeout(callback, ms);
		};
	})(),

	handleSelectAll: function(e, checkElm, cntElm){
		// e is event object
		// checkElm is class for checkboxes
		// cntElm is total cnt element
		var isChecked = e.currentTarget.checked,
			totalElm = document.getElementById(cntElm),
			totalCheck = totalElm.dataset.total,
			allChecks = document.getElementsByClassName(checkElm);

		for (var i = 0; i < allChecks.length; i++) {
			allChecks[i].checked = isChecked;
		}                
		if(isChecked){
			totalElm.innerText = totalCheck;
		} else {
			totalElm.innerText = 0;
		}
	},

	handleSelectCount: function(checkElm, cntElm, sAllElm, tableName){
		// checkElm is class for checkboxes
		// cntElm is total cnt element
		// sAllElm is select all checkbox
		var countElm = document.getElementById(cntElm),				
			checked = document.querySelectorAll('.'+checkElm+':checked').length,
			selectAll = document.getElementById(sAllElm);

		if(tableName){
			var allRows = tableName.$('tr', {"filter":"applied"});
			totalCheck = allRows.length;
			var checkedRows = _.filter(allRows, function(tr){
				var ipChk = $(tr).find('input[type="checkbox"]');
				if(ipChk.prop('checked')){
					return tr;
				}
			});
			checked = checkedRows.length;
		}

		if(parseInt(totalCheck) === checked){
			selectAll.checked = true;
			selectAll.indeterminate = false;
		} else if(checked === 0){
			selectAll.checked = false;
			selectAll.indeterminate = false;
		} else {
			selectAll.checked = false;
			selectAll.indeterminate = true;
		}
	},

	splitArray: function(a, n){
		// a - array to divide
		// n - number of parts to divide array
		var len = a.length,out = [], i = 0;
		while (i < len) {
			var size = Math.ceil((len - i) / n--);
			out.push(a.slice(i, i + size));
			i += size;
		}
		return out;
	},

	reOrderArray: function(arr, iArr){
		// arr - Array to reorder
		// iArr - Array containing new indexes
		if(arr.length === iArr.length){
			var tempArr = [];
			for(var j=0; j<arr.length; j++){
				tempArr.push(0);
			}
			for(var i=0; i< arr.length; i++){
				var tempelm = arr[i];
				tempArr.splice(iArr[i],1,tempelm);
			}
			return tempArr;
		} else {
			return arr;
		}
	},

	initalizeConsoleLogging: function () {
        var logLevel = MP_CONSTANTS.LOG_LEVEL;
        if (typeof window.console === "undefined") {
            window.console = {};
        }
        this.oldConsole = console;
        var logLevelMap = {
            'NONE': [],
            'ALL': ['log', 'info', 'debug', 'warn', 'error'],
            'INFO': ['info'],
            'DEBUG': ['log', 'debug', 'warn', 'error'],
            'WARN': ['warn'],
            'ERROR': ['warn', 'error'],
            'FATAL': ['error']
        };
        var enabledLogMethods = logLevelMap[logLevel];
        for (var methodIndex in logLevelMap.ALL) {
            var method = logLevelMap.ALL[methodIndex];
            // do we really want this method? OR is it not defined at all?
            if ((enabledLogMethods.indexOf(method) === -1) || (console[method] === 'undefined')) {
                console[method] = function () {};
            }
        }
    },

    getMobileOperatingSystem: function (nameReq) {
    	// nameReq -- send true if name of OS required
		var userAgent = navigator.userAgent || navigator.vendor || window.opera;
		if( userAgent.match( /iPad/i ) || userAgent.match( /iPhone/i ) || userAgent.match( /iPod/i ) ){
		    //return 'iOS';
		    return nameReq ? 'iOS' : true;
		} else if( userAgent.match( /Android/i ) ){
		    //return 'Android';
		    return nameReq ? 'Android' : true;
		} else {
		    //return 'unknown';
		    return nameReq ? 'unknown' : false;
		}
	},

    initializeDataPointTable: function(){
    	var that = this;
    	if(dpTable){
    		try{
    			dpTable.destroy();
    			dpTable = null;
    		}
    		catch(e){
    		}
    	}
        
        var isMobile = that.getMobileOperatingSystem();
        var exportButton = [];
        
        if(isMobile == false){
            //To hide Export button start
            exportButton.push(
            	{
                    extend: 'csv',
                    title: 'MapPlotterLocationsData',
                    //text: 'Excel',
                    text: '<i class="fa fa-file fa-2x green-color"aria-hidden="true"></i> CSV',
                    //className: "btn btn-default btn-sm btn-mapplotterbutton"
                   
                },
                {
                    extend: 'excelHtml5',
                     title: 'MapPlotterLocationsData',
                    text: '<i class="fa fa-file-excel-o fa-2x green-color" aria-hidden="true"></i> Excel'
                    //titleAttr: 'Excel'
                },               
                {
                     extend:    'pdfHtml5',
                     title: 'MapPlotterLocationsData',
                     text:      '<i class="fa fa-file-pdf-o fa-2x red-color" aria-hidden="true"></i> PDF',
                    // titleAttr: 'PDF'
                }   
            );
           //To hide Export button end 
        }
        
    	dpTable = $('#dataPointResultTable').DataTable({
		    scroller: true,
            scrollY: '75vh',
            paging: true,
            bLengthChange: false, // needs paging true
            deferRender: false,
            columnDefs: [
            	{targets: [0], sortable: false}
            ],
             dom: 'Bfrtip',
	         buttons: exportButton
        });
     	
       
        if(isMobile == false){
            //To hide Export button start
             $("#excelBtnCont").empty();
        	 dpTable.buttons().container().appendTo($("#excelBtnCont"));
        	
           //To hide Export button end 
        }
     	       
    	$('#dataPointResultTable_wrapper .dataTables_filter').hide();
    	$('#dataPointResultTable_wrapper .dataTables_info').hide();
    	var thead = $('#dataPointResultTable_wrapper thead')[0];
    	var fCol = $(thead).find('th')[0];
    	$(fCol).attr('class', '');

	    $('#reportResSrch').keyup(function(){
		    dpTable.search($(this).val()).draw();
		    var allRows = dpTable.$('tr', {"filter":"applied"});
		    $('#dpCount').text(allRows.length);
		    that.handleSelectCount('datapointcheck', 'dpCount', 'selectAllDataPoints', dpTable);
		});

	   	return;
    },

    showAlertModal: function(msg, isHTMLContent){
        if(isHTMLContent){
            $('#alertMsg').html(msg);    
        }else{
        	$('#alertMsg').text(msg);    
        }    	
		//To dont let go the pop up when click on screen.
        $('#mpAlert').modal({backdrop: 'static', keyboard: false});		
    },
    plotRecOnMap: function(tableName, isFromFilter){
    	// isFromFilter - boolean to detect that
    	// method calling from plot filter view
    	//var that = e.data.context;
		// get all checked points
		allDataPoints = [];
        var selectedData = [];
        if(isFromFilter) {
            isFilter = true;
        }
		else
			isFilter = false;
        var filtered = tableName.$('tr', {"filter":"applied"});
		_.each(filtered, function(obj){
			var id = $(obj).find('input[type="checkbox"]:checked').attr('id');
			if(id){
				allDataPoints.push(id);
			}
		});
		if(allDataPoints.length > 0){
			app.utility.showLoader();
			var wdata = {
			    allKeys: allDataPoints,
			    allObjects: app.mapDetailViewData
			};
			var rowWorker = new Worker(pinURL+'/SIMStyleAndJavascript/js/filter_worker.js');
			rowWorker.postMessage(JSON.stringify(wdata));
			rowWorker.onmessage = function(e){					
				var workerResp = JSON.parse(e.data);
				app.panelfData = workerResp.filtered;
				$('.data-point-cross, #addCustomObj').hide();
				$('#cObjSlider').addClass('remove-listing-pad');
				document.getElementById('listViewContainer').style.display = 'none';
				document.getElementById('searchSection').style.display = 'none';
				document.getElementById('listViewContainer').style.display = 'none';

				app.utility.hideLoader();
				var mapDetailViewObj = new app.mapDetailView({
					isFromFilter: isFromFilter
				});
				app.currentViewObj = mapDetailViewObj;
			};
			rowWorker.onerror = function(e){
				app.utility.hideLoader();
			};
		} else {
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.DATA_POINT_REQUIRED);
		}
		return;
    },
	
	addRowsToTable: function(rData, tableName, checkClass){

		if(typeof(Worker) !== "undefined") {
		    //Web worker support!
		    var rowWorker = new Worker(pinURL+'/SIMStyleAndJavascript/js/tableWorker.js');
		    var dataToWorker = {
		    	dObjs: dataObjects,
		    	mpdata: rData,
		    	cName: checkClass
		    };
		    rowWorker.postMessage(JSON.stringify(dataToWorker));
		    
		    rowWorker.onmessage = function(e){					
				var workerResp = JSON.parse(e.data);
				if(workerResp.rows){
					var tableRows = workerResp.rows;
					tableName.rows.add(tableRows);
					tableName.draw();
					var thead = $('#'+tableName.context[0].sTableId+'_wrapper thead')[0];
		        	var fCol = $(thead).find('th')[0];
		        	$(fCol).attr('class', '');
				}
			};

			rowWorker.onerror = function(e){
				alert(e);
				app.utility.hideLoader();
			};
		} else {
		    //No Web Worker support..
		    alert('web worker not supported');
		}
	},

	replaceAll: function(string, stringToReplace, replaceBy){
		return string.replace(new RegExp(stringToReplace, 'g'), replaceBy);
	},

	removeAllSpecialChars: function(string){
		return string.replace(/[^\w\s]/gi, '');
	},

	processArray: function(data, handler, callback, context){
		var maxtime = 100;		// chunk processing time
		var delay = 10;		// delay between processes
		var queue = data.concat();	// clone original array
		function recur(){
			var endtime = +new Date() + maxtime;
		    do {
		      	
		      	handler.call(context, queue.shift());
		    } while (queue.length > 0 && endtime > +new Date());

		    if (queue.length > 0) {
		      	setTimeout(recur, delay);
		    } else {
		      	if (callback) callback.call(context);
		    }
		}
		setTimeout(function() {
	 		recur();
	 	}, delay);
	},

	resetCustomObjectSlider: function(){
		var objData = {
			"data": dataObjects
		};

		// template for custom object bar
		var template = app.utility.createTemplate('dataObjectTemplate');
		$('#dataObjectContainer').html(template(objData));

		// initialize slider for custom objects
		$("#cObjSlider").horizontalTabs();
	},	
    
    //Map plotter customization Export - pandit
    export: function(){
        var that= this, filterObject = "";
        objectArray=[];
            if(allDataPoints.length == parseInt($('#tCnt')[0].innerText)){
                selectedrecords = [];
                selectedrecords = allDataPoints;
                _.filter(markers, function(m){
                    if (m.map){
                        filterObject = m.dataobj.Entity;
                    }
                });
            }else{
                selectedrecords = [];
                _.filter(activemarkers, function(m){
                    selectedrecords.push(m.id); 
                });
                filterObject = markers[0].dataobj.Entity;
            }  
       
            if(selectedrecords.length != 0){   
                if(!isFilter){
                    _.each($("#dataObjectContainer .data-point-name"), function(obj){
                        objectArray.push(obj.innerText)
                    }); 
                    objectArray.length != 1 ? app.utility.showAlertModal('Multiple object selected, please select only one object'):that.getDrawAreaExportData(selectedrecords,objectArray[0]); 
                }else{
                    that.getDrawAreaExportData(selectedrecords,filterObject);
                }
            }else{
                app.utility.showAlertModal('No result to export');
            } 	
	},
    getDrawAreaExportData: function(recIDs,objectname){
       app.utility.showLoader(); 
        var dataModelObj = new app.dataModel();
        var that = this;
        var $deferred = new $.Deferred();
       dataModelObj.exportData(null, objectname,null,recIDs).done(function(data){
            $deferred.resolve(data);
            //that.downloadExport(data);
           var dataObjArray = [];
           $.each( data, function( key, value ) {
               dataObjArray.push(value);
           });
            that.jsonConverter(dataObjArray, true);
        }).fail(function(){
			app.utility.showAlertModal('Failed to export data');
			$deferred.resolve(false);
           app.utility.hideLoader();
		});
        
    },
    //This method converts collected data in to CSV file  
   jsonConverter: function(JsonData, ShowLabel){
    var CSV = '';   
        if (ShowLabel) {
            var row = ""; 
            //This loop will extract the label from 1st index of on array
            for (var index in JsonData[0]) {
                row += index + ',';
            }
            row = row.slice(0, -1);
            CSV += row + '\r\n';
        }
    
        for (var i = 0; i < JsonData.length; i++) {
            var row = "";
               for(var index in JsonData[i]) {
                        if(JsonData[i][index] == "null"){
                            row += '" ",';
                        } else{
                            row += '"' + JsonData[i][index] + '",';
                        }
                row.slice(0, row.length - 1);
                
            }
           CSV += row + '\r\n';
        }
        if (CSV == '') {        
            alert("Invalid data");
            return;
        }   
    	var fileName = "FilterReport";
        //var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);
       var uri = URL.createObjectURL(new Blob([CSV], {
                  type: "application/octet-stream"
            }));
        //Generate link
        var link = document.createElement("a");    
        link.href = uri;
        link.setAttribute('target', '_blank');
        link.style = "visibility:hidden";
        link.download = fileName + ".csv";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        app.utility.hideLoader();
    },  
    // Narayan Start ** Code for converting Data Table into CSV **
    exportTableToCSV : function($table, filename) {
         var $rows = $table.find('tr:has(td),tr:has(th)'),
    
         // Temporary delimiter characters unlikely to be typed by keyboard
         // This is to avoid accidentally splitting the actual contents
         tmpColDelim = String.fromCharCode(11), // vertical tab character
         tmpRowDelim = String.fromCharCode(0), // null character
    
         // actual delimiter characters for CSV format
         colDelim = '","',
         rowDelim = '"\r\n"',
    
         // Grab text from table into CSV formatted string
         csv = '"' + $rows.map(function (i, row) {
            var $row = $(row), $cols = $row.find('td,th');
            return $cols.map(function (j, col) {
                var $col = $(col), text = $col.text();   
                return text.replace(/"/g, '""'); // escape double quotes   
            }).get().join(tmpColDelim);
    
          }).get().join(tmpRowDelim)
            .split(tmpRowDelim).join(rowDelim)
            .split(tmpColDelim).join(colDelim) + '"',
              
         // Data URI
          csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);
            
          if(window.navigator.msSaveBlob) {
        	  window.navigator.msSaveOrOpenBlob(new Blob([csv], {type: "text/plain;charset=utf-8;"}), "csvname.csv")
          } 
          else{
        	   $(this).attr({ 'download': filename, 'href': csvData, 'target': '_blank' }); 
          }
    },
    updateselectedrecords : function(activemarker){
    	activemarkers = [];
       activemarkers = activemarker;
    },    
    applyHeightToPopup : function(popUpHeight){
        if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ){
            var screenHeight = window.screen.height;
            var remainingHeight = screenHeight - popUpHeight;
            var heigthFromTop = remainingHeight / 2;
            return heigthFromTop;
        }else{		
            var screenHeight = window.innerHeight;
            var remainingHeight = screenHeight - popUpHeight;
            var heigthFromTop = remainingHeight / 2;
            return heigthFromTop;
        }
   },
   // Narayan End
  
  //Map plotter customization -Mass Update
    massUpdate:	function(e){
        var that = this;
        var dataModelObj = new app.dataModel();
        var $deferred = new $.Deferred();
        var objectName = "" ;
        //var filterId = $('#reportList').children("option:selected").val();
        if($('#dpTableBody')){objectName = $('#dpTableBody').children()[0].lastElementChild.lastElementChild.innerText}
        if(objectName){
        dataModelObj.massUpdatefield(objectName).done(function(data){
			$deferred.resolve(data);
           currentFileldSet = data;     
           app.utility.LoadfieldSetData(data);
           app.utility.handleFieldSetChange(data);
		}).fail(function(){
			app.utility.showAlertModal('Failed to update data');
			$deferred.resolve(false);
		});
		return $deferred.promise();    
        }
	},
	
    LoadfieldSetData: function(data){
 		$('#dataObject').html('<option value="select">Select</option>');
        for(var i = 0;i<data.length; i++){
            $('#dataObject').append(
                $('<option />')
                .text(data[i]['label'])
                .val(data[i]['Name']).attr({ 'dtype': data[i]['dataType']}).attr({ 'arrayindex': i})
            );
        }
     $('#massupdatemodal').modal({backdrop: "static"});
    },    
   
    handleFieldSetChange: function(data) {
        //hide input fileds 
        
        let selectedDataType = $('#dataObject').children("option:selected").attr("dtype");
        let fields = data;
        $('#inputDiv').html("");
        $('#inputDiv').prev().html('');
        $('#inputDiv').next().html('');
        
        if(selectedDataType == "PICKLIST") {
           $('#inputDiv').prev().html('Select Value');
           $('#inputDiv').append(
            $('<select/>').attr({ 'id': 'pickListData','class': 'form-control select-control'}).html('<option value="select">Select</option>')
           );
			//Get the pick list of selected field
            fields = currentFileldSet[parseInt($('#dataObject').children("option:selected").attr("arrayindex"))];
            for(i=0; i<fields['fldDatatypeinfo']['lstpicklistValues'].length;i++){
                $('#pickListData').append(
                    $('<option />')
                    .text(fields['fldDatatypeinfo']['lstpicklistValues'][i])
                    .val(fields['fldDatatypeinfo']['lstpicklistValues'][i])
                );
            }
        }else if(selectedDataType == "DATE"){
            $('#inputDiv').prev().html('Enter Date');
             $('#inputDiv').append(
                 $('<input/>').attr({ 'id': 'dateInput','class': 'form-control', 'placeholder': 'MM/DD/YYYY'})
             );
           
        }else if(selectedDataType == "BOOLEAN"){
            $('#inputDiv').prev().html('Select Value');
             $('#inputDiv').append(
               $('<select/>').attr({ 'id': 'pickListData','class': 'form-control select-control'}).html('<option value="select">Select</option><option value="true">True</option><option value="false">False</option>')
             );
            
        } else {
            $('#inputDiv').prev().html('Enter Value');
            $('#inputDiv').append(
                 $('<input/>').attr({ 'id': 'dataInput','class': 'form-control', 'placeholder': 'Enter the value to update'})
             );
        }
    },
        validateMassUpdateData: function(e){
            //Get Enter values for mass update  
            var that = this;
            var selectedPickListValue, dataInput, dateValue, selectedfield = $('#dataObject').val();
            var filterId = $('#reportList').children("option:selected").val();
            var objectName = $('#dpTableBody').children()[0].lastElementChild.lastElementChild.innerText;
            let selectedDataType =$('#dataObject').children("option:selected").attr("dtype");
            //regular expression for date validation     
            //var rgexp = /(^(((0[1-9]|1[0-9]|2[0-8])[-](0[1-9]|1[012]))|((29|30|31)[-](0[13578]|1[02]))|((29|30)[-](0[4,6,9]|11)))[-](19|[2-9][0-9])\d\d$)|(^29[-]02[-](19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)/;
            //var rgexp = /^(0?[1-9]|[12][0-9]|3[01])[\/](0?[1-9]|1[012])[\/]\d{4}$/;
            //var rgexp = /^((0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2})*$/;
			//Code by Rakesh - Added below REGEX to check Date in MM-DD-YYYY format
            var rgexp = /^((0?[1-9]|1[012])[/ /.](0?[1-9]|[12][0-9]|3[01])[/ /.](19|20)?[0-9]{2})*$/;
           
            $('#inputDiv').next().html('');
            $('#inputDiv').next().show();
            
            if($("#dataObject").val() != "select") {
                    $('#massObjectError').hide(); 
                    if(selectedDataType == "PICKLIST" || selectedDataType =="BOOLEAN"){
                        
                        selectedPickListValue =  $('#pickListData').val();
                        selectedPickListValue == "select" ? $('#inputDiv').next().html('Please select the value to change.') : app.utility.updateMassData(filterId, objectName, selectedfield, selectedPickListValue);
                        
                    }else if($('#dataObject').children("option:selected").attr("dtype") == "DATE"){
                        
                        dateValue = $("#dateInput").val();
                        let isValidDate = rgexp.test(dateValue);
                        !isValidDate ? $('#inputDiv').next().html('Please enter the date in the format MM/DD/YYYY.'): app.utility.updateMassData(filterId, objectName, selectedfield, dateValue);
                        
                    }else{
                        dataInput = $('#dataInput').val();
                        !dataInput ? $('#inputDiv').next().html('Please enter a vaild value to change.') : app.utility.updateMassData(filterId, objectName, selectedfield, dataInput);
                    }
            }else{
                $('#massObjectError').show(); 
            }   
    },
    updateMassData: function(filterId, objectName, selectedfield, selectedValue){
       app.utility.showLoader();
        
        if($('#massUpdate').is(":visible")){
     		app.utility.updateMassDrawAreaData(filterId, objectName, selectedfield, selectedValue, null);
        }else{
         selectedrecords = [];
         objectName = "";   
           if(allDataPoints.length == parseInt($('#tCnt')[0].innerText)){
                selectedrecords = allDataPoints;
                _.filter(markers, function(m){
                    if (m.map){
                       objectName = m.dataobj.Entity;
                    }
                });
            }else{
                _.filter(activemarkers, function(m){
                        selectedrecords.push(m.id); 
                });
                objectName = activemarkers[0].dataobj.Entity;
            }
            if(selectedrecords.length != 0){   
            if(!isFilter){
                objectArray = [];
                    _.each($("#dataObjectContainer .data-point-name"), function(obj){
                        objectArray.push(obj.innerText)
                    }); 
                    if(objectArray.length != 1){
                        $('#massupdatemodal').modal('hide');
                        app.utility.showAlertModal('Multiple object selected, please select only one object');
                        app.utility.hideLoader();
                    }else{ 
                        app.utility.updateMassDrawAreaData(null, objectName, selectedfield, selectedValue, selectedrecords);
                    }
                    
                }else{
                  app.utility.updateMassDrawAreaData(null, objectName, selectedfield, selectedValue, selectedrecords);
                }
            }else{
                app.utility.showAlertModal('No result to export');
            } 
        }  
    },
    updateMassDrawAreaData: function(filterId, objectName, selectedfield, selectedValue,massrecIDs){
        var $deferred = new $.Deferred();
            Visualforce.remoting.Manager.invokeAction(MP_REMOTING.MASS_UPDATE, filterId, objectName,selectedfield,app.utility.parseResult(JSON.stringify(selectedValue)),$('#dataObject').children("option:selected").attr("dtype"),massrecIDs,
            function(result, event) {
                if(result){
                    $deferred.resolve(response);
                    $('#massUpdatesMsgModal').modal({backdrop: "static", keyboard: false});
                    $('#massupdateMsg').html(result);
                    app.utility.hideLoader();
                } else {
                    $deferred.reject(event);
                }
            }, {
                escape:false
            }
        );
        $('#massupdatemodal').modal('hide');
    }
    
}