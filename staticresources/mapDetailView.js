/**
 * Map Details View:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality:
 *
 */
var app = app || {};

'use strict';
app.mapDetailView = Backbone.View.extend({
	el: null,

	// contains direction location objects
	locations: [],

	initialize: function(){
        this.dataModelObj = new app.dataModel();
		this.mapModelObj = new mapModel();
		this.render();
	},

	addEventListeners: function(){
		$('.drawing-tool').unbind('click').bind('click', {'context': this}, this.mapModelObj.handleDrawigTools);
		$('#clear-drawing').unbind('click').bind('click', {'context': this}, this.mapModelObj.clearDrawing);		
		$('#getDirections').unbind('click').bind('click', {'context': this}, this.getSelectedLocations);
		$('.mdTab').unbind('click').bind('click', {'context': this}, this.handlePanels);
		$('#addWaypoints').unbind('click').bind('click', {'context': this}, this.addWaypoint);
		$('#addDestination').unbind('click').bind('click',  {'context': this}, this.addDestination);
		$('.animateMarker').unbind('click').bind('click', {'context': this}, this.animateMarker);
		$('#printRoute').unbind('click').bind('click', {'context': this}, this.printRoute);
        $('#editDatapoints').unbind('click').bind('click', {'context': this}, this.editDatapoint);
		$('.panelfcheck').unbind('click').bind('click', {'context': this}, this.handleMapCheck);
		$('#nearbyRadius').unbind('keydown').bind('keydown', app.utility.allowOnlyNumber);
		$('.minimizer').unbind('click').bind('click', {'context': this}, this.minimizePanel);
		$('#addDestSearch').unbind('keyup').bind('keyup', {'context': this}, this.handleDestSearch);
		$('#swapDir').unbind('click').bind('click', {'context': this}, this.swapDirections);
		$('.wpCross').unbind('click').bind('click', {'context': this}, this.deleteWaypoint);
		$('.destCheck').unbind('click').bind('click', {'context': this}, this.handleWayPoint);
		$('#markerList, #destMarkerList').unbind('scroll').bind('scroll', {'context': this}, this.handleDataScroll);
		$('#drawToggle').unbind('click').click(function(){				
			$(".inner-tool-bar").animate({
                width: "toggle"
            });
            $("#toggleDiv").show();
			$(this).toggleClass('active');
		});
		
		$('#showMore').unbind('click').bind('click', {'context': this}, this.showMoreMarkers);
		$('#printMap').unbind('click').bind('click', {'context': this}, this.createMapImage);
        
         // Draw area Export/mass update button handler
        $('#exportDrawPoints').unbind('click').bind('click', {'context': this}, this.exportdrawData);
        $('#massUpdateDrawPoints').unbind('click').bind('click', app.utility.massUpdate);
        $('#massupdateOk').unbind('click').bind('click', app.utility.validateMassUpdateData);
        $('#dataObject').unbind('change').bind('change', app.utility.handleFieldSetChange);
        //To hide the direction button
        //$('#getDirections').parent().remove();
  },

	render: function(){
		app.utility.showLoader();
		this.$el = $('#mapDetailViewContainer');
		var that = this;
		// initialy add 10 rows to DOM
		// remaining rows added by addRowsToList function
		var mapPointData = {
			"data": app.panelfData.slice(0, 200)
		};

		var template = app.utility.createTemplate('mapDetailViewTemplate');
		that.$el.html(template(mapPointData));

		document.getElementById('tCnt').innerHTML  = app.panelfData.length;

		that.mapModelObj.processDataArray(app.panelfData.slice(0, 10000), true);
		that.mapModelObj.addContentToMap();
		that.mapModelObj.plotUserLocation();

		$('#markerList, #destMarkerList').data('dcnt', 200);
		$('#showMore').data('plotted', 10000);

		if(app.panelfData.length <= 10000){
			$('#showMore').hide();
		}

		$('.menu-wrapper li').removeClass('menu-active');
		$('.menu-wrapper li').find('i').removeClass('active');
		$('.data-point-cross, #addCustomObj').hide();
		$('#cObjSlider').addClass('remove-listing-pad');

		that.addEventListeners();
		$('#leftSideControl').show();
         //GreySteel Customization
        //Code added by Rakesh to show Export and Mass Update button basis user profile 
        //Start here
        if(!isExportAllowed){
            $('#exportDrawPoints').hide();
            $('#massUpdateDrawPoints').hide();
        	/*$("#exportDrawPoints").attr("disabled", true); 
            $("#massUpdateDrawPoints").attr("disabled", true);*/
        } 
        else{
            $('#exportDrawPoints').show();
            $('#massUpdateDrawPoints').show();
        }
        //End here
		app.utility.hideLoader();
	},
    
	// get Directions
	getSelectedLocations: function(e){
        
		var that = e.data.context,
			addressArray = [];
		if(that.locations.length > 0){
			_.each(that.locations, function(loc){
				if(loc && loc.Id){
					$('#dest'+loc.Id).removeClass('hidden').find('input[type="checkbox"]').prop('checked', false);
				}
			});
		}
		that.locations = [];

		// check the selected locations and pass the array to getDirections in mapmodel
		var checkedLocations = $('.panelfcheck:checked'),
			checkedCnt = checkedLocations.length;

		if(checkedCnt == 1){
			// directions from current location
			// ask for directions from current location
			var confDir;
			//$("#getDirectionConfirm").modal('show');
            $('#getDirectionConfirm').modal({backdrop: 'static', keyboard: false}); 
			$("#getRouteTrue").unbind("click").bind("click", function(){
				confDir = true;
				$("#getDirectionConfirm").modal('hide');
                app.utility.showLoader();
                that.dataModelObj.getWeatherAPIKey().done(function(resp){
                	// call function in mapscript and get current address
                    that.mapModelObj.getCurrentAddress(resp.GeocodingAPIKey || "").done(function(addrObj){
                      	app.utility.hideLoader();
                        addressArray.push(addrObj.address);
                        var currentLoc = {
                            Label: 'Current Location',
                            address: addrObj.address,
                            Id: 'current_location'
                        };
                        that.locations.push(currentLoc);
    
                        // get address for selected point.
                        var recId = $(checkedLocations[0]).data('markerid');
                        var record = _.findWhere(app.panelfData, {
                            Id: recId
                        });
                        if(record){
                            // get address from record
                            var address = that.getAddressFromObj(record);
                            record.address = address;
                            addressArray.push(address);
                            that.locations.push(record);
                        }
                        that.renderLocations();
                    }).fail(function(err){
                        app.utility.hideLoader();
                        if(err){
                            app.utility.showAlertModal(err.error_message || MP_CONSTANTS.ALERT_MESSAGES.ALLOW_LOCATION);
                        }else{
                          	app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.ALLOW_LOCATION);  //default error message.
                        }
                    }); 
                }).fail(function(err){
                    app.utility.hideLoader();
                    app.utility.showAlertModal(err);
                    //app.utility.hideLoader();
                });
			});
			$("#getRouteFalse").click(function(){
				confDir = false;
				$("#getDirectionConfirm").modal('hide');
			});
		} else if(checkedCnt == 2){
			// directions between selected 2
			_.each(checkedLocations, function(cl){
				var recId = $(cl).data('markerid');
				var record = _.findWhere(app.panelfData, {
					Id: recId
				});
				if(record){
					// get address from record
					var address = that.getAddressFromObj(record);
					record.address = address;
					addressArray.push(address);
					that.locations.push(record);
				}
			});
			that.renderLocations();
		} else if(checkedCnt == 0){
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.SELECT_SOURCE_AND_DEST);
		}
	},

    editDatapoint: function(e){
      //alert("Work in progress!!");  
        switch(app.checkPanal)
        {
            case "listViewPanal":
                document.getElementById('listViewContainer').style.display = 'block';
                $('.data-point-cross, #addCustomObj').show();
                app.currentViewObj.close();
                directionsDisplay.setMap(null);
                //app.checkPanal = NULL;
                break;
                
            case "filterViewPanal":
                document.getElementById('listViewContainer').style.display = 'block';
                app.currentViewObj.close();
                directionsDisplay.setMap(null);
                //app.checkPanal = NULL;
                break;
                
            case "searchViewPanal":
                document.getElementById('searchSection').style.display = 'block';
                app.currentViewObj.close();
                directionsDisplay.setMap(null);
                //app.checkPanal = NULL;
                break;
        }
        
      
    },	
    
	swapDirections: function(e){
		var that = e.data.context;

		var tempElm = that.locations[0];
			that.locations[0] = that.locations[1];
			that.locations[1] = tempElm;

		that.renderLocations();
	},

	handlePanels: function(e){
		var that = e.data.context;
		if(!$(this).hasClass('disabledObj')){
			if($(this).hasClass('active')){
				that.minimizePanel();
			}
			$('.mdTab').removeClass('active');
			$(this).addClass('active');
			var panelId = $(this).data('panel');
			$('.panel-container').hide();
			$('#'+panelId).show();
		}
	},

	addDestination: function(e){
		var that = e.data.context;
		//addDestination			
		var locCount = that.locations.length;			
		if(locCount !== 10){
			$('#addDestinationPanel').show().removeClass('slideInUp animated').addClass('slideInUp animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
			      	$(this).removeClass('slideInUp animated');
			});
			$('#closeWaypoint, #cancelWayPoints').unbind('click');
			$('#closeWaypoint, #cancelWayPoints').click(function(){
			   	$('#addDestinationPanel').show().removeClass('slideOutDown animated').addClass('slideOutDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				      	$(this).removeClass('slideOutDown animated').hide();
				});
			});
		} else if(locCount == 10){
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.MAX_DESTINATIONS_REACHED);
		}
	},

	handleDestSearch: function(){
		var searchStr = $(this).val();
		app.utility.delay(function(){
			$('#destMarkerList li').hide();
			if(searchStr !== ""){
				$('.destLable:containsSearch("'+searchStr+'")').each(function(){
					$(this).closest('li').show();
				});
			} else {
				$('#destMarkerList li').show();
			}
		}, 400);
	},

	addWaypoint: function(e){
		var that = e.data.context,
			destArray = [];

		var wpIds = _.pluck(that.locations, 'Id');
		var checkedDest = $('.destCheck:checked');

		if(checkedDest.length > 0){
			_.each(checkedDest, function(cd){
				if(!$(cd).closest('li').hasClass('hidden')){
					var recId = $(cd).data('markerid');						
					var record = _.findWhere(app.panelfData, {
						Id: recId
					});
					if(record){
						// get address from record
						var address = that.getAddressFromObj(record);
						record.address = address;							
						if(record.Id && !(wpIds.indexOf(record.Id) > -1)) {
							that.locations.push(record);
						}
					}
				}
			});

			if(that.locations.length > 10){
				app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.MAX_DESTINATIONS);
			} else {
				that.renderLocations();
			}
		} else {
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.DESTINATION_REQUIRED);
		}
	},

	animateMarker: function(e){
		var that = e.data.context;
		var markerId  = e.currentTarget.dataset.markerid;
		if(markerId){
			that.mapModelObj.animateMarker(markerId);
		}            
	},

	printRoute: function(){
		if(directionsDisplay){
			var dirObj = directionsDisplay.getDirections();            
			var reqObj = dirObj.request;
        	window.open('/apex/TestPrint?req='+JSON.stringify(reqObj), 'Directions', "height=768,width=1024,scrollbars=1");
		}
	},

	handleMapCheck: function(e){
		//app.utility.handleSelectCount('panelfcheck', 'totalSelected', 'selectAllPanelF');
		var checked = $('.panelfcheck:checked').length;
		var total = $('#tCnt').text();
		if(checked == 1 || checked == 2 || checked == 0){
			$('#getDirections').removeClass('disabledObj');
		} else {
			$('#getDirections').addClass('disabledObj');
		}

		if(checked > 0){
			$('#plotSelected').removeClass('disabledObj');
		} else {				
			$('#plotSelected').addClass('disabledObj');
		}

		if(!isNaN(Number(total)) && total == checked){
			$('#selectAllPanelF').prop('indeterminate', false);
			$('#selectAllPanelF').prop('checked', true);
		} else if(checked === 0){
			$('#selectAllPanelF').prop('checked', false);
			$('#selectAllPanelF').prop('indeterminate', false);
		} else {
			$('#selectAllPanelF').prop('indeterminate', true);
		}
	},

	minimizePanel: function(){
		$('.custom-panel-body').slideToggle('2000');
		var iElm = $('.minimizer').find('i');
		if(iElm && iElm.hasClass('fa-angle-down')){
			iElm.removeClass('fa-angle-down').addClass('fa-angle-up');
		} else if(iElm && iElm.hasClass('fa-angle-up')) {
			iElm.removeClass('fa-angle-up').addClass('fa-angle-down');
		}
	},

	deleteWaypoint: function(e){
		var that = e.data.context,
			wpIndex = e.currentTarget.dataset.index,
			locArr = [],
			wpArr = [],
			id = that.locations[wpIndex].Id;

		if(id){
			$('.destCheck[data-markerid="'+id+'"]').prop('checked', false).closest('li').removeClass('hidden');
		}						
		$(this).closest('li.add-location').remove();
		that.locations.splice(wpIndex, 1);

		that.renderLocations();
	},

	handleWayPoint: function(e){
		var that = e.data.context,
			id = e.currentTarget.dataset.markerid,
			isChecked = e.currentTarget.checked;

		if(!isChecked){
			that.locations =  _.filter(that.locations, function(wpObj){
				if(wpObj && wpObj.Id && wpObj.Id !== id){
					return wpObj;
				}
			});
		}
	},

	handleDragDrop: function(evObj){
			var evType = evObj.type,
			oldPos = evObj.oldIndex,
			newPos = evObj.newIndex,
			that = this;
	switch(evType){
			case "start":
			// handle start event
			break;
			case "end":
			// handle end event
			// if oldPos === newPos - position is same
			if(oldPos !== newPos){
				var oldObj = that.locations.splice(oldPos, 1);
				if(oldObj && oldObj.length == 1){
					that.locations.splice(newPos, 0, oldObj[0]);
					that.renderLocations(true);
				}
			}
			break;
		}
	},

	getAddressFromObj: function(obj){
		if(obj){
			var address = obj.Street ? (obj.Street + ', ') : "";
			address+= obj.City ? (obj.City + ', ') : "";
			address+= obj.Postal_Code ? (obj.Postal_Code + ', ') : "";
			address+= obj.State ? (obj.State + ', ') : "";
			address+= obj.Country ? (obj.Country) : "";
		} else {
			return "";
		}
		return address;
	},

	renderLocations: function(optimize){
		var that = this;
		var dirLoc = $.extend(true, [], that.locations);
		var locCount = that.locations.length;
		optimize = optimize ? true : false;
		that.mapModelObj.getDirections(dirLoc, optimize).done(function(dirObj){

			if(!optimize && locCount > 2){
				// reorder the location array according to new order
				var dirLoc = $.extend(true, [], that.locations);
				var start = dirLoc.splice(0,1),
					dest = dirLoc.splice(dirLoc.length-1,1);

				var wpArr = app.utility.reOrderArray(dirLoc, dirObj.routes[0].waypoint_order);
				that.locations = start.concat(wpArr, dest);
			}

			var locData = {
				data: that.locations
			};
			var locTemplate = app.utility.createTemplate('wayPointsTemplate');
			$('#locationContainer').html(locTemplate(locData));

			if(locCount > 2){
				$('#addDestinationPanel').hide();
				// initialize sortable
				// check if it is mobile device - 
				// if mobile - disable
				var isMobile = app.utility.getMobileOperatingSystem();
				if(!isMobile){
					var listWithHandle = document.getElementById('locDraggable');					
					var sortable = Sortable.create(listWithHandle, {
					  	handle: '.dragLoc',
					  	animation: 150,
					  	onStart: function(e){
					    	that.handleDragDrop(e);
					  	},
					  	onEnd: function(e){
					    	that.handleDragDrop(e);
					  	}
					});
				}
				$('.wpCross').unbind('click').bind('click', {'context': that}, that.deleteWaypoint);
			} else {
				$('.mdTab').removeClass('active');
				$('.mdTab[data-panel="panel-2"]').addClass('active');
				$('.panel-container').hide();
				$('#panel-2').show();
				$('.mdTab[data-panel="panel-2"]').removeClass('disabledObj');
				$('.add-destination-wrapper, .exportPdf-wrapper').show();
				$('#swapDir').unbind('click').bind('click', {'context': that}, that.swapDirections);
			}

			_.each(that.locations, function(wo){
				if(wo && wo.Id){
					//$('.destCheck[data-markerid="'+wo.Id+'"]').closest('li').addClass('hidden');
					$('.destCheck[data-markerid="'+wo.Id+'"]').closest('li').remove();
				}
			});
			var avlblDestCnt = $('.desti').closest('li:not(.hidden)');
			if(avlblDestCnt && avlblDestCnt.length == 0){
				$('.add-destination-wrapper').addClass('disabledObj');
			} else {
				$('.add-destination-wrapper').removeClass('disabledObj');
			}

			var getOS = app.utility.getMobileOperatingSystem(true);
			var locCnt = that.locations.length;
			if(locCnt > 1){
				var srcAddr = app.utility.removeAllSpecialChars(that.locations[0].address),
					destAddr = app.utility.removeAllSpecialChars(that.locations[locCnt-1].address);

				switch(getOS) {
					case 'iOS':						
						var appURL = 'maps://?saddr='+srcAddr+'&daddr='+destAddr;
						$('#gotoGmap').attr('href',app.utility.replaceAll(appURL, ' ', '+'));
						$('#gotoGmap').text('Open in Apple Maps');
						break;

					case 'Android':
						var appURL = 'http://maps.google.com/maps?saddr='+srcAddr+'&daddr='+destAddr;
						$('#gotoGmap').attr('href', appURL);
						$('#gotoGmap').text('Open in Google Maps');
						break;
					default:
						$('#gotoGmap').attr('href', 'javascript:void(0)');
						$('#gotoGmap').hide();
				}
			}
		});
	},

	addRowsToList: function(data, start, end){
		var that = this;
		// divide data into chunks
		var dataChunks = app.utility.splitArray(data, 4);
		var cnt = 0;
		var chunks = dataChunks.length;
		var mlist = $('#markerList ul');
		var dlist = $('#destMarkerList ul');


		if(typeof(Worker) !== "undefined") {
		    //Web worker support!
		    var rowWorker = new Worker(pinURL+'/SIMStyleAndJavascript/js/worker.js');
		    var dataToWorker = {
		    	dObjs: dataObjects,
		    	mpdata: data
		    };
		    rowWorker.postMessage(JSON.stringify(dataToWorker));
		    
		    rowWorker.onmessage = function(e){					
				var workerResp = JSON.parse(e.data);
				if(workerResp.mRow){
					var markerRow = workerResp.mRow;
					$('#markerList ul').append(markerRow);
				}
				if(workerResp.dRow){
					var destList = workerResp.dRow;
					$('#destMarkerList ul').append(destList);
				}
				that.addEventListeners();
			};

			rowWorker.onerror = function(e){
				app.utility.hideLoader();
			};
		} else {
		    //No Web Worker support..
		    alert('web worker not supported');
		}
	},

	handleDataScroll: function(e){
		var that = e.data.context;
		var totalDataCnt = app.panelfData.length;
		if($(this).scrollTop() + $(this).innerHeight()>=$(this)[0].scrollHeight){
	      	// get rendered data count
	      	var renderedData = Number($(this).data('dcnt'));
	      	if(!isNaN(renderedData) && renderedData < totalDataCnt){
	     		var newRendered = renderedData+1000;
	      		that.addRowsToList(app.panelfData.slice(renderedData, newRendered), renderedData, newRendered);
	      		$('#markerList, #destMarkerList').data('dcnt', newRendered);
	      	} else {
	      	}		      	
	    }
	},

	showMoreMarkers: function(e){
		var that = e.data.context;
		var plotted = $(this).data('plotted');
		var allCnt = app.panelfData.length;

		if(!isNaN(plotted) && plotted < allCnt){
			$(this).addClass('disabledObj');
			var newPlotted = plotted + 10000;
			that.mapModelObj.processDataArray(app.panelfData.slice(plotted, newPlotted), false);
			$(this).data('plotted', newPlotted);
			$('#tCnt').text(allCnt);
		} else {
			$(this).data('plotted', allCnt);
			app.utility.showAlertModal('All markers are plotted');
		}
	},

	createMapImage: function(){

		try{
			$('#drawAreaControl, #leftSideControl').hide();
	        //get transform value
	        var transform=$(".gm-style>div:first>div").css("transform")
	        var comp=transform.split(",") //split up the transform matrix
	        var mapleft=parseFloat(comp[4]) //get left value
	        var maptop=parseFloat(comp[5])  //get top value
	        $(".gm-style>div:first>div").css({ //get the map container. not sure if stable
	            "transform":"none",
	            "left":mapleft,
	            "top":maptop,
	        });

	        function saveImg(){
	            var imgSrc = $('#mapImage').attr('src');
	            window.open(imgSrc, '_blank');
	        }

	        function resetMapSections() {
	        	$(".gm-style>div:first>div").css({
	                left:0,
	                top:0,
	                "transform":transform
	            });

	            $('#drawAreaControl, #leftSideControl').show();
	        }

	        html2canvas($('#map-plotter-map'), {
	            useCORS: true,
	            //allowTaint:true,
	            onrendered: function(canvas){
	                var saved = false;
	                var canvasObj =  $(canvas)[0];

	                var fullFileName = "test.png";
	                var mimeType = "image/png";

	                try{

		                var img = canvasObj.toDataURL(mimeType);

                        var ua = window.navigator.userAgent;
                        var msie = ua.indexOf("MSIE ");
                        var isIE = msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./);
                        var isSafari = ua.indexOf('safari') != -1;
                        var imgData = img.replace(/^data:[a-z/]*;base64,/, '');
                        var byteString = atob(imgData);
                        var buffer = new ArrayBuffer(byteString.length);
                        var intArray = new Uint8Array(buffer);
                        for (var i = 0; i < byteString.length; i++) {
                            intArray[i] = byteString.charCodeAt(i);
                        }

		                var blob = new Blob([buffer], { type: "image/png"});

		                //$('#mapImage').attr('src', img);
		                $('#mapImage').attr('src', window.URL.createObjectURL(blob));

		                $('#imageModal').modal('show');
		                $('#drawAreaControl, #leftSideControl').show();

		                if(isIE || isSafari){
		                    $('#saveImage').unbind('click').bind('click', saveImg);
		                } else {
		                    $('#downloadImg').attr('href', window.URL.createObjectURL(blob));
		                    $('#downloadImg').attr('download', 'testSnap');                        
		                }
		                return;
	                        	resetMapSections();
	            	} catch(e){
	            		resetMapSections();
	            	}
	            }
	        });
		} catch(e){
			resetMapSections();
		}
	},
	close: function () {
		this.mapModelObj.clearMarkers();
		if(markerCluster){
			markerCluster.clearMarkers();
			markerCluster = null;
		}
		markers = [];
		app.panelfData = [];
		if(shapesArray.length > 0){
			if(shapesArray[0].overlay){
				shapesArray[0].overlay.setMap(null);
			} else {
				try{
					shapesArray[0].setMap(null);
				} catch(e){
				}
			}
		}
		shapesArray = [];
		this.unbind(); // Unbind all local event bindings
		this.undelegateEvents();
		$('#leftSideControl, #drawAreaControl').remove();
		$(this).empty();
		this.$el.empty();
	},
   	//Map-plotter customization  - 
    //Export function- pandit/kirti
    exportdrawData:	function(e){
        app.utility.export();
 	},
  
});