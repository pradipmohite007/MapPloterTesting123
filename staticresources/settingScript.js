var reportTable;
var refFieldData = [];

var radialObj = {};
var Total_Count;


// used to store total count while calling delete method recursively
var deleteDataPointCount = 0;

var dtable = {};

$(document).ready(function(){
    $('.overlay').show();
    getAPIKeys();
    getCustomSettingsObject();
    getCustomObjects();
    bindEventListeners();
    
    
    if($.fn.dataTable){
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex){
                if(settings && settings.nTable && settings.nTable.id && settings.nTable.id === 'resultsTable'){
                    var status = $('.report-status li.active').data('status');
                    var statusCol = data[6];
                    if(!status || status == 'Total'){
                        return true;
                    } else {                
                        if(status == statusCol) return true;
                        return false;   
                    }
                } else {
                    return true;
                }
            });
        }
    
    $('#progress-circle-loader').radialIndicator({
        percentage: true,
        radius: 40
    });
    radialObj = $('#progress-circle-loader').data('radialIndicator');
    
    

    $('#open-button').click(function () {
        $('body').toggleClass('show-menu');        
    });
    
    function alignModal(){
     
	      if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ){
           
            var popUpHeight = $(this).find(".modal-dialog").height();               
            var screenHeight = window.screen.height;
            
 			
          
            var remainingHeight = screenHeight - popUpHeight;
            //alert("remainingHeight"+remainingHeight);
            var heigthFromTop = remainingHeight / 2;
            //alert("heigthFromTop"+heigthFromTop);
            $(this).find(".modal-dialog").css("margin-top",heigthFromTop);
        }else{	
            var popUpHeight = $(this).find(".modal-dialog").height();          
            var screenHeight = window.innerHeight;
        
            var remainingHeight = screenHeight - popUpHeight;
            var heigthFromTop = remainingHeight / 2;
            $(this).find(".modal-dialog").css("margin-top",heigthFromTop);
        }
        
    }
    // Align modal when it is displayed
    $(".modal").on("shown.bs.modal", alignModal);
    
    // Align modal when user resize the window
    $(window).on("resize", function(){
        $(".modal:visible").each(alignModal);
    });   

   
});

function bindEventListeners(){
    $('#showResult').unbind('click').bind('click', getCustomObjData);
    $('#getExcel').unbind('click').bind('click',downloadExcel);
    $('#settingsObjContainer').unbind('change').bind('change', hendleObjectChange);
    $('#saveCustomObj').unbind('click').bind('click', saveCustomObj);
    $('.startgeo').unbind('click').bind('click', startGeocoding);
    $('.deleteobj').unbind('click').bind('click', deleteCustomObject);
    $('#saveGoogle').unbind('click').bind('click', saveGoogleAPI);
    $('#saveWeather').unbind('click').bind('click', saveWeatherAPI);
    $('#object-entry-panel select').unbind('change').bind('change', handleSelectChange);
    $('#deleteYes').unbind('click').bind('click', calldeleteRemote);
    $('.report-status li').unbind('click').bind('click', sortTableByStatus);
    $('#someSwitchOptionSuccess1').unbind('click').bind('click', deactivateEmail);  //Sandesh
    $('#confirmDeactiveKeyEmail').unbind('click').bind('click',confirmDeactiveKeyEmail);
    $('#cancelDeactiveKeyEmail').unbind('click').bind('click',cancelDeactiveKeyEmail);
    $('#gotoAction').unbind('click').bind('click', promotionFunctionAgree);  //Narayan
    $('#remindeMeLater ').unbind('click').bind('click', promotionFunctionRemindLetter);  //Narayan
    $('#customObjList').unbind('change').bind('change', customObjListHandler);  //Narayan
    $('#mainContainer').unbind('click').bind('click',function(event){
        $('#mainContainer').removeClass('show-menu');
        $('#open-button i').removeClass('fa-times').addClass('fa-th-large');
    });
    $('#open-button').unbind('click').bind('click', function () { 
        $('#mainContainer').toggleClass('show-menu');
        var opnClose = $('#open-button i');
        if(opnClose.hasClass('fa-times')){
            opnClose.removeClass('fa-times').addClass('fa-th-large');
        } else {
            opnClose.removeClass('fa-th-large').addClass('fa-times');
        }
        return false;
    });
    $('.menu-item').unbind('click').bind('click', function(){
        if(!$(this).hasClass('menu-active')){
            //NARAYAN start
             $('#object-entry-panel select').siblings('.error-text-msg').addClass('invisible');
             $('#apiFail').addClass('invisible');
             $('#googleKey').siblings('.text-danger').addClass('invisible');
             $('.error-text-msg').addClass('invisible');
             $('#apilimits').val("");
            //NARAYAN end
            $('.menu-item').removeClass('menu-active');
            $('.menu-item i').removeClass('active');
            $(this).addClass('menu-active');
            $(this).find('i').addClass('active');
            //Opening panels while tabbed
            var panelId = $(this).data('section');
            $('.custom-setting').hide();
            $('#'+panelId).show();
            $('#mainContainer').removeClass('show-menu');
            var opnClose = $('#open-button i');
            if(opnClose.hasClass('fa-times')){
                opnClose.removeClass('fa-times').addClass('fa-th-large');
            } else {
                opnClose.removeClass('fa-th-large').addClass('fa-times');
            }
            if(panelId === 'section-3') { 
                getGeocodeObjects();
                $('.overlayContent').addClass('useOverlayContent');
            }
            if(panelId === 'section-5'){ 
                getGoogleStatisticData();
                $('.overlayContent').addClass('useOverlayContent');
            }
            if(panelId === 'section-2') $('.overlayContent').removeClass('useOverlayContent');
            if(panelId === 'section-4'){
              $('.overlayContent').removeClass('useOverlayContent');      
            } 
            setTimeout(function(){
                
                window.scrollTo(0,0);
            },100);
        }
    });

    $('form').unbind('submit').bind('submit', function(e){
        e.preventDefault();
    });

    $('#googleKey, #weatherKey, #apilimits').unbind('keyup').bind('keyup', submitOnEnter);

    $('.triggerCheck').unbind('click').bind('click', updateTrigger);

    $('#saveLimitsapi').unbind('click').bind('click', getGoogleTokenData);

    $('#confirmTrigger').unbind('click').bind('click', confirmTrigger);

    $('.openRefModal').unbind('click').bind('click', selectReferenceField);

    $('#saveRef').unbind('click').bind('click', saveRefCombi);
}

// method to fetch data for table on settings tab (Objects Going To Geocode)
function getGeocodeObjects(){
    Visualforce.remoting.Manager.invokeAction(getGeocodeTable,
        function(result, event) {
            if(result){     
                var response = parseResult(result);
                
               var objData = {
                    "data": response
                };
                // template for custom settings object
                var custSettObjTemp = $('#objToGeocodeTemplate').html();
                var template = _.template(custSettObjTemp);
                $('#geocodeObjContainer').html(template(objData));			
                
                dtable = $('#objToGeocode_table').DataTable({
                    
                    scroller: true,
                    scrollY: 350,
                    paging: true,
                    bLengthChange: false, // needs paging true
                    deferRender: true,
                    columnDefs: [
                        {targets: [6], sortable: false}
                    ]             
                });
           
                var searchBox = $('#geocodeObjContainer').find('input[type="search"]').parent();
                var customSearch = 
                    '<div class="list-search-container">'+
                        '<i class="fa fa-search icon-search"></i>'+
                        '<input type="text" class="form-control list-search-input" id="objGeoSrch" placeholder="Search">'+
                    '</div>'
                searchBox.html(customSearch);
                $('#objGeoSrch').keyup(function(){
                    dtable.search($(this).val()).draw();
                });
                var lblCont = $('#objToGeocode_table_wrapper > .row').get(0);
                var lblWrap = $(lblCont).find('div')[0];
                var col6_one = $(lblCont).find('div')[1];
                $(lblWrap).addClass('col-md-8').removeClass('col-md-6');
                $(col6_one).addClass('col-md-4').removeClass('col-md-6');
                $(lblWrap).html('<div class="geocode-title"><div class="map-obj"><p class="sub-title txt-title"> Mapped Objects Ready for Geocoding</p><p>Click the Geocode button to start geocoding each of the objects. You can track the progress of all your geocoded objects from the Geocoding Status tab. When your objects are geocoded, go to the Map Plotter tab to view your data on the map. </p></div></div>');
                $($('#objToGeocode_table_wrapper thead').get(0)).find('tr th').last().attr('class', '');
                bindEventListeners();
                $('.overlay').hide();
                $('.openRefModal').hide();
				
              
            } else {
                $('.overlay').hide();
            }
        }, {
            escape:false
        }
    );
}



	//Narayan Start
	
	// Works for action happning on change of custom object list.
    function customObjListHandler(){
        $("#exportMenu").hide();
    }

    // Function for visibility of promotionpup 
	function handlePromotionPopup(){
         Visualforce.remoting.Manager.invokeAction(getPromotionData,
            function(result, event) {
                 response = JSON.parse(result);
                 var chkPopup = response.ShowPromotionAlert;
                if(chkPopup == "true"){
                    $('#promotionAlert').modal('show', {backdrop: 'static', keyboard: false});
                }else{
                    $("#promotionAlert").modal('hide');
                }
            },{
                escape:false
            } 
        );
    }

    function promotionFunctionAgree(){
        Visualforce.remoting.Manager.invokeAction(PageVisited,
            function(result, event) {
                              var url = 'https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3000000B5P9CEAV';
                  window.open(url, '_blank');
                 $("#promotionAlert").modal('hide');
            },{
                escape:false
            } 
        );
    }

	function promotionFunctionRemindLetter(){
         Visualforce.remoting.Manager.invokeAction(ReminderPageVisit,
            function(result, event) {
               $("#promotiomAlert").hide();
            }, {
                escape:false
            }
        );
    }
	//Narayan End

   // Narayan Start ** Code for converting Data Table into CSV **
    function exportTableToCSV($table, filename) {
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
        	   $('#getExcel').attr({ 'download': filename, 'href': csvData, 'target': '_blank' }); 
          }
    }    
    // Narayan End

   // Narayan Start
    function downloadExcel(){
	}
    // Narayan End

function handleSelectChange(){
    var selected = $(this);
    var selectVal = selected.val();
    var thislbl = selected.data('lbl');
    var dataType = selected.find('option:selected').data('type');

    if(selectVal == "Select"){
        selected.siblings('.error-text-msg').text('Please Select '+thislbl).removeClass('invisible');
    } else {
        selected.siblings('.error-text-msg').addClass('invisible');
    }

    selected.data('refval', null);

    
    var modalLink = selected.parent().parent().siblings('.refModelCont').find('a.openRefModal');
    if(dataType && dataType === 'REFERENCE'){
        // show popup -- call getReferenceFields
        var entName = $('#settingsObjContainer').val();
        modalLink.data('ent', entName);
        modalLink.data('field', selectVal);
        modalLink.show();
        modalLink.trigger('click');        
        $('#saveRef').data('savefor', selected.attr('id'));
    } else {
        modalLink.data('ent', null);
        modalLink.data('field', null);
        modalLink.hide();
    }
}

function getRefFields(entName, fieldName) {
     var $deferred = new $.Deferred();

    // first find data for entName<==>fieldName combination in refFieldData
    var fieldData = _.findWhere(refFieldData, {
        entity: entName,
        field: fieldName
    });

    if(fieldData && fieldData.data){
        $deferred.resolve(fieldData.data);
    } else {
        Visualforce.remoting.Manager.invokeAction(getReferenceFields, entName, fieldName,
            function(result, event) {
                if(event.result){
                    var refFieldObj = {
                        entity: entName,
                        field: fieldName,
                        data:result
                    };
                    refFieldData.push(refFieldObj);
                    $deferred.resolve(result);
                } else {
                    $deferred.reject();
                }
            }, {
                escape:false
            }
        );
    }

    return $deferred.promise();
}

// method for custom settings tab
function getCustomSettingsObject(){
    Visualforce.remoting.Manager.invokeAction(getObjects,
        function(result, event) {
            if(result){
                var response = parseResult(result);
                
                var objData = {
                    "data": response
                };
                // template for custom settings object
                var custSettObjTemp = $('#customSettObjTemplate').html();
                var template = _.template(custSettObjTemp);
                $('#settingsObjContainer').html(template(objData));
            }
        }, {
            escape:false
        }
    );
}

function getCustomObjects(){
    Visualforce.remoting.Manager.invokeAction(customObjList,
        function(result, event) {
            if(result){
                var response = parseResult(result);
                
          var objData = {
                    "data":response
                };
                // template for custom object
                var custObjTemp = $('#customObjTemplate').html();
                var template = _.template(custObjTemp);
                $('#customObjList').html(template(objData));

                if(response && response.length === 0){
                    $('#customObjList').addClass('disabled');
                    $('#notgeocode').text('No Custom objects added.').removeClass('invisible');
                }

                $('.overlay').hide();

            } else {
                $('.overlay').hide();
            }
        }, {
            escape:false
        }
    );
}

function getAPIKeys(){
    $('.overlay').show();
    Visualforce.remoting.Manager.invokeAction(getAPIKeysMethod,
        function(result, event) {
            if(event.statusCode === 200 && result){
                
                var keys = parseResult(event.result);
                $('#googleKey').val(keys.GeocodingAPIKey);
                $('#weatherKey').val(keys.WeatherAPIKey);
            }
            $('.overlay').hide();
			handlePromotionPopup();
        }, {
            escape:false
        }
    );
}

function getCustomObjData(){
    var selectedObj = $('#customObjList').val();    

    if(selectedObj && selectedObj !== null){
        $('.overlay').show();

        var respObj = {
            MapMPPointGeocodeResult: [],
            count_failed: 0,
            count_pending: 0,
            count_success: 0
        };
        Visualforce.remoting.Manager.invokeAction(getTotalMapPoints, selectedObj,
            function(result, event) {
                if(result){
                    var response = parseResult(result);
                    Total_Count = response.totalResultCount;
                } 
            }, {
                escape:false
            }
        );
   
        reportsRemoting(null, selectedObj, respObj).done(function(response){
            $('.report-status li').removeClass('active');
             if(response.MapMPPointGeocodeResult && response.MapMPPointGeocodeResult.length === 0){
                $('#notgeocode').text('The selected object is not yet geocoded or has no records. Please check if records exist and start geocoding before viewing the report.').removeClass('invisible');
            } else {
                $('#notgeocode').addClass('invisible');
            }
            
            var objTemp = {
                MapMPPointGeocodeResult: response.MapMPPointGeocodeResult.slice(0,100),
                count_failed: response.count_failed,
                count_pending: response.count_pending,
                count_success: response.count_success
            };

            
        }).fail(function(err){
            renderReportTable(respObj, []);
            if(err.message){
                $('#notgeocode').text(err.message).removeClass('invisible');
            } else {
                $('#notgeocode').text('No Data Found').removeClass('invisible');
            }
            $('.overlay').hide();
        });
    }
}

function getMobileOperatingSystem (nameReq) {
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
 }

function renderReportTable(dataObj, response){
  	var objData = {
        data: dataObj
    };

    var custObjTemp = $('#resultsTemplate').html();
    var template = _.template(custObjTemp);
    $('#reportResultContainer').html(template(objData));
	 var exportButton = [];
     var isMobile = this.getMobileOperatingSystem();	
     if(isMobile == false){
         //To hide Export button start  
            exportButton.push(
            	{
                    extend: 'csv',
                    title: 'MapPlotterReportData',                  
                    text: '<i class="fa fa-file fa-2x green-color"aria-hidden="true"></i> CSV'
                },
                {
                    extend: 'excelHtml5',
                     title: 'MapPlotterReportData',
                    text: '<i class="fa fa-file-excel-o fa-2x green-color" aria-hidden="true"></i> Excel'                  
                },               
                {
                     extend: 'pdfHtml5',
                     title: 'MapPlotterReportData',
                     text: '<i class="fa fa-file-pdf-o fa-2x red-color" aria-hidden="true"></i> PDF'
                }    
            );
         //To hide Export button end
        }
    
    reportTable = $('#resultsTable').DataTable({
        scroller: true,
        scrollY: '35vh',
        paging: true,
        bLengthChange: false, // needs paging true
        deferRender: true,        
         dom: 'Bfrtip',
        buttons: exportButton,
        responsive : true
    });
    
    
     
  
     $(".exportDrop").show().addClass("inline_block");
     $("#excelButtonCont").empty();

    if(isMobile == false){    
        //To hide Export button start
        $('#exportMenu').dropdown();
         $("#exportMenu").show();     
         reportTable.buttons().container().appendTo($("#excelButtonCont"));
        //To hide Export button start
        
    }else{
          $("#exportMenu").hide();
    }
    
    var searchBox = $('#reportResultContainer').find('input[type="search"]').parent();
    
    
    var customSearch = 
            '<div class="list-search-container">'+
                '<i class="fa fa-search icon-search"></i>'+
                '<input type="text" class="form-control list-search-input" id="reportResSrch" placeholder="Search">'+
            '</div>'
    searchBox.html(customSearch);
 
    $('#reportResSrch').keyup(function(){
        reportTable.search($(this).val()).draw();
    });

   

    $('#successCnt').text(objData.data.count_success);
    $('#failedCnt').text(objData.data.count_failed);
    $('#pendingCnt').text(objData.data.count_pending);
    
    if(response.MapMPPointGeocodeResult){
        $('#totalCnt').text(response.MapMPPointGeocodeResult.length+"/"+Total_Count);
    } else {
        $('#totalCnt').text(0);
    }
	
    if(reportTable && response.MapMPPointGeocodeResult){
        addRowsToTable(response.MapMPPointGeocodeResult.slice(100,response.MapMPPointGeocodeResult.length));
        reportTable.draw();
    } 
   
}

function reportsRemoting(offsetId, selectedObj, respObj){
    var $deferred = new $.Deferred();
   Visualforce.remoting.Manager.invokeAction(getDataMethod, selectedObj, offsetId,
        function(result, event) {
            if(result){
            var response = parseResult(result);
            
            if(response){
                for (var i = 0; i < response.lstMPPointGeocodeRslt.length; i++) {
                    respObj.MapMPPointGeocodeResult.push(response.lstMPPointGeocodeRslt[i]);
                }
                respObj.count_failed = respObj.count_failed + response.count_failed;
                respObj.count_success = respObj.count_success + response.count_success;
                respObj.count_pending = respObj.count_pending + response.count_pending;
                var objTemp = {
                            MapMPPointGeocodeResult: respObj.MapMPPointGeocodeResult.slice(0,100), //100
                            count_failed: respObj.count_failed,
                            count_pending: respObj.count_pending,
                            count_success: respObj.count_success
                   }; 
                if(offsetId == null){
					 renderReportTable(objTemp, respObj);
           			 $('.overlay').hide();
                }else{
                  	 renderReportTable(objTemp, respObj);    
                }
                
                if(response.lstMPPointGeocodeRslt.length == 5000){ //5000
                    reportsRemoting(response.lstMPPointGeocodeRslt[4999].Id, selectedObj, respObj).done(function(){
                        $deferred.resolve(respObj);
                    });
                } else {
                    $deferred.resolve(respObj);
                }
				} else {
                   $deferred.reject(event);
                }
            } else {
                $deferred.reject(event);
            }
        }, {
            escape:false
        }
    );
    return $deferred.promise();
}

function addRowsToTable(rData){
    // rData - remaining data to add in table
    for (var i=0, len=rData.length; i<len; i++) {
        var recId = rData[i].RecordID ? rData[i].RecordID : '';
        reportTable.row.add([
            '<a class="accLink" data-id="'+recId+'" onclick="gotoAccountDetails(this)" target="_blank" href="/'+recId+'">'+(rData[i].Label ? rData[i].Label : '')+'</a>',
            rData[i].Street ? rData[i].Street : '',
            rData[i].City ? rData[i].City : '',
            rData[i].State ? rData[i].State : '',
            rData[i].Postal_Code ? rData[i].Postal_Code : '',
            rData[i].Country ? rData[i].Country : '',
            rData[i].Status ? rData[i].Status : '' 
        ]);
    }
}

function hendleObjectChange(){
       var selectedVal = $(this).val();
    //NARAYAN start
    $('#object-entry-panel select').siblings('.error-text-msg').addClass('invisible'); 
	$('#object-entry-panel .openRefModal').hide();
    //NARAYAN end
    if(selectedVal == "Select"){
        $('#object-entry-panel').hide();
        $('#settingsObjContainer').siblings('.error-text-msg').text('Select at least one object to save.').removeClass('invisible');
        return;
    } else {
        $('#settingsObjContainer').siblings('.error-text-msg').addClass('invisible');
    }

    $('.overlay').show();
    Visualforce.remoting.Manager.invokeAction(getObjSelection, selectedVal,
        function(result, event) {
            if(result){
                var response = parseResult(result);

                

                var objData = {
                    "data": response
                };
                // template for custom entity name, city, country, state,....
                var custSettObjTemp = $('#customSettObjTemplate').html();
                var template = _.template(custSettObjTemp);

                $('#object-entry-panel').show();

                $('#objEntity').html(template(objData));
                $('#objCountry').html(template(objData));
                $('#objState').html(template(objData));
                $('#objCity').html(template(objData));
                $('#objStreet').html(template(objData));
                $('#objPostal').html(template(objData));

                $('.overlay').hide();
            }
        }, {
            escape:false
        }
    );
}

function saveCustomObj(){
    var selectedObj = $('#settingsObjContainer').val();
    $('.error-text-msg').addClass('invisible');
    if(selectedObj == "Select"){
        $('#settingsObjContainer').siblings('.error-text-msg').removeClass('invisible');
        return;
    }

    var fieldsArray = [];
    var isError = false;
    $('#object-entry-panel select').each(function(){
        var thisElm = $(this);
        var thisval = $(this).val();
        if(thisval == "Select"){
            $(this).siblings('.error-text-msg').removeClass('invisible');
            isError = true;
        } else {
            if(thisElm.find('option:selected').data('type') === "REFERENCE"){
                thisval = thisval+''+thisElm.data('refval');
            }
            if(fieldsArray.indexOf(thisval) < 0){
                fieldsArray.push(thisval);
            } else {
                $(this).siblings('.error-text-msg').text('This field has already been selected.').removeClass('invisible');
                isError = true;
            }
        }
    });

    var entityName = $('#objEntity').data('refval') ? $('#objEntity').data('refval') : $('#objEntity').val(),
        country = $('#objCountry').data('refval') ? $('#objCountry').data('refval') : $('#objCountry').val(),
        state = $('#objState').data('refval') ? $('#objState').data('refval') : $('#objState').val(),
        city = $('#objCity').data('refval') ? $('#objCity').data('refval') : $('#objCity').val(),
        street = $('#objStreet').data('refval') ? $('#objStreet').data('refval') : $('#objStreet').val(),
        postal = $('#objPostal').data('refval') ? $('#objPostal').data('refval') : $('#objPostal').val();

    if(!isError){
        $('.overlay').show();
        Visualforce.remoting.Manager.invokeAction(saveCustomObjMethod,
            selectedObj, entityName, country, state, city, street, postal,
            function(result, event) {
                if(event.statusCode === 200){
                    if(result !== null){
                        if(!isNaN(result)){
                            if(parseInt(result) >= 10){
                                $('#savefail').text("You have already added Ten Objects.").removeClass('invisible');
                                $('.overlay').hide();
                                $('#saveCustomObj').removeClass('disabled');
                            }else{
                                $('#savefail').addClass('invisible');
                                $('#settingsObjContainer').val('Select');
                                $('#object-entry-panel').hide();
                                getGeocodeObjects();
                                // update list on reports tab
                                getCustomObjects();

                                // update Map Field
                                getCustomSettingsObject();
                                $('#saveCustomObj').removeClass('disabled');
                                bindEventListeners();
                            }
                        }
                    } else {
                        $('#savefail').text("Something went wrong please contact your admin.").removeClass('invisible');
                        $('.overlay').hide();
                        $('#saveCustomObj').removeClass('disabled');
                    }
                } else {
                    $('#savefail').text(event.message).removeClass('invisible');
                    $('.overlay').hide();
                    $('#saveCustomObj').removeClass('disabled');
                }
            }, {
                escape:false
            }
        );
    }
}

function startGeocoding(){
   $('.overlay').show();
    var ename = $(this).data('ename');
    Visualforce.remoting.Manager.invokeAction(getGoogleAPIKey,
     function(result, event) {
          if(result && result != ""){      
           Visualforce.remoting.Manager.invokeAction(startGeocodingMethod, ename,
            function(result1, event1) {
                        if(event.statusCode === 200){
                        $('.overlay').hide();
                        
                        if(event1.result){
                            
                            showAlertModal('The geocoding process has started. It may take a few minutes. You can view the details in the Geocoding Status tab.');
                            getGeocodeObjects();
                            getCustomObjects();
                            
                        } else {
                                $('#geocodeAlertModal').modal('show');
                                
                        }
                    } else {
                        $('.overlay').hide();
                    }
                }, {
                    escape:false
                   }
               );
       }else{
           showAlertModal("Please enter the Google API key");
           $('.overlay').hide();
       }
             }, {
                escape:false
            }
        );
}

function deleteCustomObject(){
    var id = $(this).data('ename');
    var objName = $(this).data('ename');
    $('#delObj').text(objName.replace('__c', '').replace('eXMPP__', ''));
    $('#deleteConfirm').modal({backdrop: 'static', keyboard: false}); 
    $('#deleteYes').data('id', id);    
}

function calldeleteRemote(){
    $('.progress-loader-overlay').show();
    var id = $(this).data('id');
    $('#deleteConfirm').modal('hide');
   deleteRemote(id).done(function(){
        getGeocodeObjects();
        getCustomObjects();

        // update Map Field
        getCustomSettingsObject();
        $('.progress-loader-overlay').hide();
    });
}

function deleteRemote(id, isDataPointDeleted){
    var $deferred = new $.Deferred();
    Visualforce.remoting.Manager.invokeAction(deleteCustomObjMethod, id,
        function(result, event) {
            if(event.statusCode == 200 && result){
                result = JSON.parse(result);
                if(result["dataponitSize"] === 0) {
                    $deferred.resolve();
                } else if(result["dataponitSize"] === -1){
                    $deferred.resolve();
                    showAlertModal("Insufficient Access Privileges");
                } else if(!isNaN(result["totalCount"]) && !isNaN(result["dataponitSize"])){
                    var totalCount = parseInt(result["totalCount"]) + deleteDataPointCount;                        
                    deleteDataPointCount = deleteDataPointCount + parseInt(result["dataponitSize"]);                    
                    var completionPer = (deleteDataPointCount/totalCount)*100;         
                    radialObj.value(completionPer);
                    deleteRemote(id).done(function(){                        
                        $deferred.resolve();
                    });                        
                }

            } else {
                $('.overlay').hide();
                $deferred.reject();
            }
        }, {
            escape:false
        }
    );

    return $deferred.promise();
}

function submitOnEnter(e){    
    var key = e.which;
    var id = e.currentTarget.id;
    if(key === 13 && id){
        if(id === "googleKey"){
            $('#saveGoogle').trigger('click');
        } else if(id === "weatherKey"){
            $('#saveWeather').trigger('click');
        } else if(id === "apilimits"){
            getGoogleTokenData();
        }
    }
}

function saveGoogleAPI(){
    var geoCodingType = "Google API";
    var keyVal = $('#googleKey').val();
	
    //Narayan Start
         $("#googleKey").keyup(function (e) {
            $(this).siblings('.text-danger').fadeOut();
         });
     //Narayan End
    if(keyVal === ""){
        $('#googleKey').siblings('.text-danger').text('Please Enter '+geoCodingType+' key value.').removeClass('invisible').show();
        return;
    } else {
       
        $('.overlay').show();
    }
    var settings;
    if(geoCodingType == "Map quest API"){
       settings = {
            "async": true,
            "crossDomain": true,
            "url": "https://www.mapquestapi.com/geocoding/v1/address?key="+keyVal+"&location=Lancaster,PA",
            "method": "GET",
            "cache": false
        };

        $.ajax(settings).done(function (response) {
            if(response){
                saveGeocodingAPIRemote('Map Quest API', keyVal);
            }
        }).fail(function(){
            $('#googleKey').siblings('.text-danger').text('Map Quest API key is not valid. Verify and re-enter.').removeClass('invisible');
            $('.overlay').hide();
        });
    } else {
       settings = {
            "async": true,
            "crossDomain": true,
            "url": "https://maps.googleapis.com/maps/api/geocode/json?address=pune&sensor=false&key="+keyVal,
            "method": "GET",
            "cache": false
        };

        $.ajax(settings).done(function (resp) {
            var response;
            if (typeof(resp) == "string") {
                response = JSON.parse(resp);
            } else {
                response = resp;
            }

            if(response.status == "OK"){
                saveGeocodingAPIRemote("Google API", keyVal, false);
            } else if(response.status == "OVER_QUERY_LIMIT") {
                if(response.error_message){
                    $('#googleKey').siblings('.text-danger').text('The maximum limit for the Google API key has been reached. Please enter a new key to proceed.').removeClass('invisible');
                    $('.overlay').hide();
                }
                saveGeocodingAPIRemote("Google API", keyVal, true);
                $('.overlay').hide();
 		} else if(response.error_message == "The provided API key is invalid." && response.status == "REQUEST_DENIED"){
                $('#googleKey').siblings('.text-danger').text("Invalid Google API key. Please verify the key and try again.").removeClass('invisible');
                $('.text-danger').show();
                $('.overlay').hide();
            } else {
                $('#googleKey').siblings('.text-danger').text("Please enable 'Google Maps Geocoding API' library and try again.").removeClass('invisible');
                $('.text-danger').show();
                $('.overlay').hide();
            }
        });
    }
}

function saveGeocodingAPIRemote(geoCodingType, key, isLimitExceed){
    Visualforce.remoting.Manager.invokeAction(saveGoogleAPIMethod, key, true, isLimitExceed,
        function(result, event) {
            if(event.statusCode === 200 && result){
                // do stuff
               
                showAlertModal("Key Saved Successfully in Custom Settings.");
                $('#googleKey').siblings('.text-danger').addClass('invisible');
            } else {
                    }
            $('.overlay').hide();
        }, {
            escape:false
        }
    );
}

function saveWeatherAPI(){
    var weatherKey = $('#weatherKey').val();
    if(weatherKey === ""){
        $('#weatherKey').siblings('.text-danger').text('Please Enter World Weather Key.').removeClass('invisible');
        return;
    } else {
        $('.overlay').show();
        $('#weatherKey').siblings('.text-danger').addClass('invisible');
    }

    var settings = {
        "async": true,
        "crossDomain": true,
        "dataType": "jsonp",
        "url": "https://api.forecast.io/forecast/" + weatherKey + "/37.8267,-122.423",
        "headers": "{ 'Access-Control-Allow-Origin': 'true' }",
        "method": "POST",
        "headers": {
            "content-type": "application/json; charset=utf-8"
        }
    };

    $.ajax(settings).done(function(resp, status){
        if(resp && status == "success"){
            Visualforce.remoting.Manager.invokeAction(saveWeatherAPIMethod, weatherKey,
                function(result, event) {
                    $('.overlay').hide();
                    if(event.statusCode === 200){
                        
                        showAlertModal("Key Saved Successfully in Custom Settings.");
                    } 
                }, {
                    escape:false
                }
            );
        } else {
            $('#weatherKey').siblings('.text-danger').text('Invalid weather API key. Verify and re-enter a valid key.').removeClass('invisible');
            $('.overlay').hide();
        }
    }).fail(function(err){
        $('#weatherKey').siblings('.text-danger').text('Invalid weather API key. Verify and re-enter a valid key.').removeClass('invisible');
        $('.overlay').hide();
    });
}

function sortTableByStatus(e){
    $('.report-status li').removeClass('active');
    $(this).addClass('active');
    if(reportTable) reportTable.draw();
}

function gotoAccountDetails(e){
    if(event){
        event.preventDefault();
    }
    var href = e.dataset.id;
    if( (typeof sforce != 'undefined') && sforce && (!!sforce.one) ) {
        // Salesforce1 navigation
        sforce.one.navigateToSObject(href);
    } else {
        
        window.open("/"+href);
    }
}

function updateTrigger(){
    var isCheck = $(this).prop('checked'),
        entity = $(this).data('entity');

    var that = this;
    if(isCheck){
        // activating
        $('.triggerState').text('Activate');
    } else {
        // deactivating
        $('.triggerState').text('Deactivate');
    }

    $('#triggerObj').text(entity);
    $('#triggerConfirm').modal({backdrop: "static", keyboard: false});

    $('#confirmTrigger').unbind('click').bind('click', function(){
        confirmTrigger(entity, isCheck);
    });

    $('#cancelTrigger').unbind('click').bind('click', function(){
        $(that).prop('checked', !isCheck);
        $('#triggerConfirm').modal('hide');
    });
}

function confirmTrigger(entity, isCheck){
    $('.overlay').show();
    Visualforce.remoting.Manager.invokeAction(updateTriggerActivation, entity, isCheck,
        function(result, event) {
                  $('.overlay').hide();
            $('#triggerConfirm').modal('hide');
            
        }, {
            escape:false
        }
    );
}

function getGoogleStatisticData(){
    $('.overlay').show();

    Visualforce.remoting.Manager.invokeAction(getGoogleStatics,
        function(result, event) {
            $('.overlay').hide();
            if(event.statusCode === 200 && result){
                $('#daily').text(result.Usage.MaxDailyLimit);
                $('#usage').text(result.Usage.UsedDailyLimit);
                if(result.Usage.EmailNotification === 'true'){
                   $('#someSwitchOptionSuccess1').prop('checked',false); 
                } else {
                    $('#someSwitchOptionSuccess1').prop('checked',true);
                }
                                
                var objData = {
                    "data": result.Statistic
                };
                // template for custom settings object
                var googleAPITemp = $('#googleAPITemplate').html();
                var template = _.template(googleAPITemp);
                $('#googleStat').html(template(objData));

                var googleAPITable = $('#googleAPITable').DataTable({
                    paging: false,
                    scrollY: 350,
                    bLengthChange: false,
                    bFilter: false
                });

                var searchBox = $('#googleStat').find('input[type="search"]').parent();
                var customSearch = 
                    '<div class="list-search-container">'+
                        '<i class="fa fa-search icon-search"></i>'+
                        '<input type="text" class="form-control list-search-input" id="gAPISrch" placeholder="Search">'+
                    '</div>'
                searchBox.html(customSearch);
                $('#gAPISrch').keyup(function(){
                    googleAPITable.search($(this).val()).draw();
                });

                $('.deactiveapi').unbind('click').bind('click', deactivateCurrentKey);

            } else {
            }
        }, {
            escape:false
        }
    );
}

function deactivateCurrentKey(){
    var jqThis = $(this),
        recId = jqThis.data('keyrecid');

    $('#deactivateConfirm').modal({backdrop: 'static', keyboard: false});
    $('#confirmDeactiveKey').unbind('click').bind('click', function(){
       $('#deactivateConfirm').modal('hide');
        deactivateGoogleAPIKey(recId);
    });
}

function deactivateGoogleAPIKey(keyRecId){
    $('.overlay').show();
    Visualforce.remoting.Manager.invokeAction(deactivateGoogleKey, keyRecId,
        function(result, event) {
            $('.overlay').hide();
            if(event.result){
                getGoogleStatisticData();
                showAlertModal('Current Google API Key Deactivated Successfully');
            } else {
                $('$apiFail').text('Error in Deactivating Current Google API Key');
                  }
        }, {
            escape:false
        }
    );
}
//////////////////sandesh////////////////////////////
function deactivateEmail(){
   
    var recval = $(this).prop('checked');

    if(recval){
        $('#deactivateEmailConfirm').find('.call_popup').html('Do you want to enable the email notification?');
    }else{
        $('#deactivateEmailConfirm').find('.call_popup').html('Do you want to disable the email notification?');
    }
	
    $('#deactivateEmailConfirm').modal({backdrop: 'static', keyboard: false});
  
    
}

function confirmDeactiveKeyEmail(){  
     var recval = $("#someSwitchOptionSuccess1").prop('checked');
     $('#deactivateEmailConfirm').modal('hide');
     disableEmailNotificationUsage(recval);
}

function cancelDeactiveKeyEmail(){
     
     var status = $('#someSwitchOptionSuccess1').prop('checked');
     if(status){
         $('#someSwitchOptionSuccess1').prop('checked',false);
     } else{
         $('#someSwitchOptionSuccess1').prop('checked',true);
     }
         
}

function disableEmailNotificationUsage(recAPIval){
    $('.overlay').show();
    Visualforce.remoting.Manager.invokeAction(disableEmailNotification, recAPIval,
        function(result, event) {
       
            $('.overlay').hide();
            if(event.result){
                if(event.result === 'Disable'){
                  getGoogleStatisticData();
                  showAlertModal('You have disabled email notification successfully');
                  
                 } else {
                   getGoogleStatisticData();
                  showAlertModal('You have enabled email notification successfully');
                }
                
            } else {
                $('#apiFail').text('Unable to Deactivate');
            }
        }, {
            escape:false
        }
    );
}
//////////////////End/////////////////////////////////
function getGoogleTokenData(){
    var token = $('#apilimits').val();
    //Narayan Start
         $("#apilimits").keyup(function (e) {
            $("#apilimits").siblings('.text-danger').fadeOut();
         });
        //Narayan End
    if(token && token !== ""){
        $('.overlay').show();
        $('#apiFail').addClass('invisible');
        Visualforce.remoting.Manager.invokeAction(submitGoogleToken, token,
            function(result, event) {
               $('.overlay').hide();
                if(event.statusCode === 200 && result){                    
                    getGoogleStatisticData();
                    
                    showAlertModal(result);
                } else {
                    
                    $('#apiFail').removeClass('invisible').text('Key is Invalid').show();
                }
            }, {
                escape:false
            }
        );
    } else {
        $('#apiFail').removeClass('invisible').text('Please Enter Token').show();
    }
}

function selectReferenceField(){    
    var jqThis = $(this),
        entName = jqThis.data('ent'),
        fieldName = jqThis.data('field'),
        fieldRefVal = jqThis.parent().siblings('.selectCont').find('select').data('refval');

    $('#saveRef').data('savefor', jqThis.parent().siblings('.selectCont').find('select').attr('id'));
  
    $('.overlay').show();
    getRefFields(entName, fieldName).done(function(refFields){
        $('#refModal').modal({backdrop: "static", keyboard: false});    
               
       
        $('.overlay').hide();
        var tData = {
            data: refFields
        };
        
        var rfTempScr = $('#refFieldTemplate').html();
            rfTemp = _.template(rfTempScr);
        $('#refSelect').html(rfTemp(tData));
        if(fieldRefVal) $('#refSelect').val(fieldRefVal);
    }).fail(function(){
    });
}

function saveRefCombi(){
    var jqThis = $(this),
        saveFor = jqThis.data('savefor'),
        refVal = $('#refSelect').val();

 
    $('#'+saveFor).data('refval', refVal);
    $('#refModal').modal('hide');
    
    
}

function parseResult(result){
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
    if(typeof(result) === "string"){
        result = convertString(result);
        response = JSON.parse(result);
    } else {
        response = result;
    }
    return response;
}

function showAlertModal(msg){
    $('#alertMsg').text(msg);
    $('#mpAlert').modal({backdrop: 'static', keyboard: false}); 
  }

function isMobileDevice(){
    var check = false;
    (function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
    return check;
}
