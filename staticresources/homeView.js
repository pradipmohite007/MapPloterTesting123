/**
 * Home View:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality:
 *
 */

var app = app || {};

'use strict';
app.homeView = Backbone.View.extend({
	el: null,

	initialize: function(options){
		var that = this;
		app.mapDetailViewData = [];
		this.dataModelObj = new app.dataModel();
       
        if(appWithIndexedDB){
            this.handleSyncService().done(function(){
                if(options && options.home){
                    that.render(true);
                } else {
                    that.render(false);
                }
            });
        }else{
            if(options && options.home){
                that.render(true);
            } else {
                that.render(false);
            }
        }		
	},

	addEventListeners: function(){
		this.$('.menu-wrapper li').unbind('click').bind('click', {'context': this}, this.handleViews);
		this.$('.data-point-cross').unbind('click').bind('click', {'context': this}, this.deleteDataObj);
		this.$('#addCustomObj').unbind('click').bind('click', {'context': this}, this.addCustomObjects);
		this.$('#advSearchButton').unbind('click').bind('click', {'context': this}, this.processAdvanceSearch);
		this.$('#saveObjSelection').unbind('click').bind('click', {'context': this}, this.saveCustomObjSelection);     
        
        this.$('#gotoAction').unbind('click').bind('click', {'context': this}, this.promotionFunctionAgree); //Narayan
        this.$('#remindeMeLater').unbind('click').bind('click', {'context': this}, this.promotionFunctionRemindLetter); //Narayan
        
		$('#homeViewContainer').unbind('click').bind('click',function(event){
			$('#homeViewContainer').removeClass('show-menu');
          	$('#open-button i').removeClass('fa-times').addClass('fa-th-large');
		});
		this.$('#open-button').unbind('click').click(function () { 
            $('#homeViewContainer').toggleClass('show-menu');
            var opnClose = $('#open-button i');
	        if(opnClose.hasClass('fa-times')){
	            opnClose.removeClass('fa-times').addClass('fa-th-large');
	        } else {
	            opnClose.removeClass('fa-th-large').addClass('fa-times');
	        }
            return false;
        });

        this.$('#advSearchText').unbind('keyup').bind('keyup', {'context': this}, this.searchOnEnter);
		
		var isMobile = app.utility.getMobileOperatingSystem();
		if(isMobile){
			$(window).unbind('orientationchange').bind('orientationchange', this.resetPanelHeights);
		}
        
        $('.modal').unbind('shown.bs.modal').bind('shown.bs.modal', function (e) {
             var popupHeight = $(this).find(".modal-dialog").height();
             var hiegthFromTop = app.utility.applyHeightToPopup(popupHeight);
             $(this).find(".modal-dialog").css("margin-top",hiegthFromTop);
        });
        
	},

	render: function(isHome){  
        
		this.$el = $('#homeViewContainer');
		var that = this;
		var homeTemplate = app.utility.createTemplate('homeTemplate');		
		that.$el.append(homeTemplate);
		$('#initLoad').remove();	
        
        (function(that){
            var initializeMapMpdel = function(){
                if(typeof window.google === 'object' && typeof window.google.maps === 'object'){
                	that.mapModelObj = new mapModel();        
		    		that.mapModelObj.initializeMapDetail([]);    
                }else{
                    setTimeout(function(){
                        initializeMapMpdel();
                    },100);
                }
            };
            initializeMapMpdel();            
        })(this);
        
		that.dataModelObj.getDataObjListData().done(function(response){
			if(response && response.length > 0){
				var objData = {
					"data": response
				};

				// template for custom object bar
				var template = app.utility.createTemplate('dataObjectTemplate');
				$('#dataObjectContainer').html(template(objData));

				// initialize slider for custom objects
				$("#cObjSlider").horizontalTabs();

				// template for data point panel
				var template = app.utility.createTemplate('dataPointTemplate');
				$('#dataPointPanel').html(template(objData));

				var newObjData = {
					"data": response
				};

				if(isHome){
					$('.data-point-cross, #addCustomObj').hide();
					$('#cObjSlider').addClass('remove-listing-pad');
				}

				var srchTemplate = app.utility.createTemplate('searchTemplate');
				$('#searchSection').html(srchTemplate());

				var templateCO = app.utility.createTemplate('advSCustObjTemplate');
				$('#advSCustomObjs').html(templateCO(newObjData));
				
				that.addEventListeners();
                var listViewObj = new app.listView();
				app.currentViewObj = listViewObj;
				
				that.scrollPageToTop();
                 //GreySteel Customization
                //Code added by Rakesh to show Export and Mass Update button basis user profile 
        		//Start here
				that.dataModelObj.chkUsrAllowedFrExportMU().done(function(useResponse){
					
					if(useResponse && useResponse.length > 0){
						var allwedUsrData = JSON.parse(useResponse);	
						if(allwedUsrData && allwedUsrData.validUsrFrExportMA && allwedUsrData.validUsrFrExportMA === 'true'){
							isExportAllowed = true;	
						}
					}	
				});
				//End here
			} else {
				// clear all data saved in local
				$('#listViewContainer').html('<div class="noDirections"><p>'+'No objects mapped.'+'</p></div>');
				app.DbManager.dropDB();
				$('.navbar-nav, #addCustomObj').addClass('disabledObj');
			}
			app.utility.hideLoader();
		}).fail(function(){
			app.utility.hideLoader();
		});

		var $modalDialog = $('.common-dialog'),
        	modalHeight = $modalDialog.height(),
        	browserHeight = window.innerHeight;

    	$modalDialog.css({'margin-top' : modalHeight >= browserHeight ? 0 : (browserHeight - modalHeight)/2});
        
        $("#subscribeSpan").hide();
        that.handlePromotionPopup();
	},

	handleViews: function(e){
		var that = e.data.context;
		var srchSect = document.getElementById('searchSection');
		var listSect = document.getElementById('listViewContainer');
		var mapSect = document.getElementById('leftSideControl');
        if($('.data-point-panel').is(":visible")){
           $('.data-point-panel').hide(); 
        }
		if(!$(this).hasClass('menu-active')){
			var viewName = e.currentTarget.dataset.viewname;

			$('.menu-wrapper li').removeClass('menu-active');
			$('.menu-wrapper li').find('i').removeClass('active');
			$(this).addClass('menu-active');
			$(this).find('i').addClass('active');

			$('#homeViewContainer').removeClass('show-menu');

			var opnClose = $('#open-button i');
            if(opnClose.hasClass('fa-times')){
                opnClose.removeClass('fa-times').addClass('fa-th-large');
            } else {
                opnClose.removeClass('fa-th-large').addClass('fa-times');
            }

            if(app.currentViewObj && app.currentViewObj !== null){
				app.currentViewObj.close();
			}

			switch(viewName){
				case "list":
					if(listSect) listSect.style.display = 'block';
					if(srchSect) srchSect.style.display = 'none';
					if(mapSect) mapSect.style.display = 'none';

					var listViewObj = new app.listView();
					app.currentViewObj = listViewObj;
                    app.isClustering = false;
                    app.
					$('.data-point-cross, #addCustomObj').show();
					$('#cObjSlider').removeClass('remove-listing-pad');
                    mapModel.prototype.clearMarkers();
                    directionsDisplay.setMap(null);
                    that.renderObjectTemp();
					break;
				case "report":
					if(listSect) listSect.style.display = 'block';
					if(srchSect) srchSect.style.display = 'none';
					if(mapSect) mapSect.style.display = 'none';	
					$('.data-point-cross, #addCustomObj').hide();
					$('#cObjSlider').addClass('remove-listing-pad');

					var reportsViewObj = new app.reportsView();
					app.currentViewObj = reportsViewObj;
                    app.isClustering = false;
                    mapModel.prototype.clearMarkers();
                    directionsDisplay.setMap(null);
                     that.renderObjectTemp();
					break;
				case "search":
					if(srchSect) srchSect.style.display = 'block';
					if(listSect) listSect.style.display = 'none';
					if(mapSect) mapSect.style.display = 'none';
                    app.isClustering = false;
					$('.advCustObj').prop('checked', false);
					$('#advSearchResult').html('');
					$('#advSearchText').val('');
					$('#dpCountSrch').text('0');
					$('.data-point-cross, #addCustomObj').hide();
					$('#cObjSlider').addClass('remove-listing-pad');
                     mapModel.prototype.clearMarkers();
       				 directionsDisplay.setMap(null);
                     that.renderObjectTemp();
					break;
			}
		}
	},
	
    renderObjectTemp : function(e){
        var that =this;
   		that.dataModelObj.getDataObjListData().done(function(response){
			if(response && response.length > 0){
				var objData = {
					"data": response
				};

				// template for custom object bar
				var template = app.utility.createTemplate('dataObjectTemplate');
				$('#dataObjectContainer').html(template(objData));

				// initialize slider for custom objects
				$("#cObjSlider").horizontalTabs();
								
				that.scrollPageToTop();
			} else {
				// clear all data saved in local
				$('#listViewContainer').html('<div class="noDirections"><p>'+'No objects mapped.'+'</p></div>');
				app.DbManager.dropDB();
				$('.navbar-nav, #addCustomObj').addClass('disabledObj');
			}
			app.utility.hideLoader();
		}).fail(function(){
			app.utility.hideLoader();
		});    
	        
    },
    
	deleteDataObj: function(e){
		var that = e.data.context;		
		$(this).closest('li').remove();
		$("#cObjSlider").horizontalTabs();
		var entityName = e.currentTarget.dataset.name;
		if(app.mapDetailViewData.length > 0){
			app.utility.showLoader();
			var filteredData = _.filter(app.mapDetailViewData, function(dataObj){
				if(dataObj.Entity && dataObj.Entity !== entityName){
					return dataObj;
				}
			});

			app.mapDetailViewData = filteredData;
			app.mapDetailViewData= _.sortBy(app.mapDetailViewData, 'Label');
			var resultsData = {
				"data": app.mapDetailViewData.slice(0,100)
			};
			var dataPointsResTemplate = app.utility.createTemplate('largeTableTemplate');
			$('#resultsAccordionContainer').html(dataPointsResTemplate(resultsData));
			// initialize datatable for #dataPointResultTable
            app.utility.initializeDataPointTable();
            if(app.mapDetailViewData.length > 99){
	            app.utility.addRowsToTable(app.mapDetailViewData.slice(100, app.mapDetailViewData.length), dpTable, 'datapointcheck');
	        }
            document.getElementById('dpCount').innerHTML = app.mapDetailViewData.length;
	    	$('#getListData').removeClass('disabledObj');
			app.currentViewObj.addEventListeners();
			app.utility.hideLoader();
		}
	},

	addCustomObjects: function(){
		$('.data-point-panel').show();
		$('#dataPointPanel input[type="checkbox"]').prop('checked', false);		
		$('.legendObj span.data-point-name').each(function(){			
			var lbl = $(this).data('val');			
			var checkId = $('#dataPointPanel label[data-val="'+lbl+'"]').attr('for');
			$('#'+checkId).prop('checked', true);
		});

		$('#cancelObjSelection').unbind('click').bind('click', function(){			
			$('.data-point-panel').hide();
		});
	},

	saveCustomObjSelection: function(e){
		var that = e.data.context;
		var checkedDataPoint = $('#dataPointPanel input[type="checkbox"]:checked');            
		var arr = [];
		for (var i = 0; i < checkedDataPoint.length; i++) {
			var id = $(checkedDataPoint[i]).attr('id');			
			var entName = $("label[for='"+ id +"']").data('val');
			var eObj = _.findWhere(dataObjects, {
				"Entity": entName
			});
			if(eObj){
				arr.push(eObj);
			}
		}
		var objData = {
			"data": arr
		};
		// template for custom object bar
		var template = app.utility.createTemplate('dataObjectTemplate');
		$('#dataObjectContainer').html(template(objData));

		$("#cObjSlider").horizontalTabs();

		that.addEventListeners();		
		//check for selected cities, if any - fetch data
		var checkedCity = $('.cityCheck:checked');
		var isCountryVisible = $('#countryPanel').css('display');
		if(checkedCity.length > 0 && isCountryVisible == "none"){
		    $('#getListData').trigger('click');
		}
		$('.data-point-panel').hide();
	},

	searchOnEnter: function(e){
		var key = e.which;
		if(key === 13){
                $('#advSearchButton').trigger('click');
		}
	},

	processAdvanceSearch: function(e){
        app.checkPanal = "searchViewPanal";
		var that = e.data.context;
		var searchString = $('#advSearchText').val().trim();
		var customObjs = [];

		// regular expression for checking special characters		
		var regex = /^[a-z0-9&_ .-]*$/i;

		var checkedObj =  $('.advCustObj:checked');

		if(checkedObj && checkedObj.length > 0){
			for (var i = 0; i < checkedObj.length; i++) {
				var coId = $(checkedObj[i]).attr('id');				
				var lblName = $("label[for='"+ coId +"']").data('val');
				customObjs.push(lblName);
			}
		} else {
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.CUSTOM_OBJECT_REQUIRED);
			return;
		}

		if(searchString && searchString !== '' && customObjs.length > 0){
			if(!regex.test(searchString)){
				app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.SPECIAL_CHARACTER);
				return;
			}
			app.utility.showLoader();
			app.mapDetailViewData = [];
			that.handleSearchRecursive(searchString, customObjs, null, []).done(function(resp){
				if(resp && resp.length > 0){
					app.mapDetailViewData = resp;					
					app.mapDetailViewData = _.sortBy(app.mapDetailViewData, 'Label');
					var resultsData = {
						"data": app.mapDetailViewData.slice(0, 100)
					};
					var template = app.utility.createTemplate('advSearchResultTemplate');
					$('#advSearchResult').html(template(resultsData));

					$('#dpCountSrch').text(app.mapDetailViewData.length);

					srchResTable = $('#searchResultTable').DataTable({
						scroller: true,
		                scrollY: '46vh',
		                paging: true,
		                bLengthChange: false, // needs paging true
		                deferRender: false,
		                columnDefs: [
		                	{targets: [0], sortable: false}
		                ],
		         	});

					$('#searchResultTable_wrapper .dataTables_filter').hide();
    				$('#searchResultTable_wrapper .dataTables_info').hide();	    				

    				$('#plotOnMapSrch').unbind('click').bind('click', {'context': that}, that.plotOnMap);
    				srchResTable.$('.dpCheckSrch').unbind('click').bind('click', {'context': that}, that.handleDataPointCheck);

    				if(app.mapDetailViewData.length > 99){
    					app.utility.addRowsToTable(app.mapDetailViewData.slice(100, app.mapDetailViewData.length), srchResTable, 'dpCheckSrch');
	            		srchResTable.draw();
    				}

    				var thead = $('#searchResultTable_wrapper thead')[0];
		        	var fCol = $(thead).find('th')[0];
		        	$(fCol).attr('class', '');

    				$('#selectAllDPSrch').unbind('click').bind('click', function(e){    					
    					var isCheck = e.currentTarget.checked;
						if(srchResTable){
							var filtered = srchResTable.$('tr', {"filter":"applied"});
							_.each(filtered, function(obj){
								$(obj).find('input[type="checkbox"]').prop('checked', isCheck);
							});
						} else {
							$('.dpCheckSrch').prop('checked', isCheck);
						}
    				});
                    
                    $('#is-cluster-form').unbind('click').bind('click', function(e){
                    app.isClustering = e.currentTarget.checked;
                    });
                    
                    

    				// filter the custom objects depending on selected customObjs, ad update custom obj list
					var filterDataPoints = _.filter(dataObjects, function(obj){
					    if(customObjs.indexOf(obj.Entity) > -1){
							return obj;
					    }
					});

					var objData = {
						"data": filterDataPoints
					};
					var template = app.utility.createTemplate('dataObjectTemplate');
					$('#dataObjectContainer').html(template(objData));

					$("#cObjSlider").horizontalTabs();

					$('.data-point-cross, #addCustomObj').hide();
					$('#cObjSlider').addClass('remove-listing-pad');
					app.utility.hideLoader();
				} else {
					app.utility.showAlertModal(MP_CONSTANTS.ERROR_MESSAGES.NO_DATA_SEARCH);
					if(srchResTable){
						srchResTable.clear().draw();
					}
					$('#dpCountSrch').text(0);
					app.utility.hideLoader();
				}
			}).fail(function(){
				app.utility.showAlertModal(MP_CONSTANTS.ERROR_MESSAGES.ADV_SEARCH_FAILURE);
				app.utility.hideLoader();
			});
		} else {
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.KEY_FOR_SEARCH);
		}
	},

	handleDataPointCheck: function(e){
		app.utility.handleSelectCount('dpCheckSrch', 'dpCountSrch', 'selectAllDPSrch', srchResTable);
	},

	handleSearchRecursive: function(searchString,  customObjs, offsetId, dataArr){
		var that = this,
            $deferred = new $.Deferred();
        app.utility.showLoader();

        that.dataModelObj.getSearchResult(searchString, customObjs, offsetId).done(function(response){
             for (var i = 0; i < response.length; i++) {
                dataArr.push(response[i]);
            }
            if(response && response.length == 2000){
                that.handleSearchRecursive(searchString, customObjs, response[1999].Id, dataArr).done(function(){
                    $deferred.resolve(dataArr);
                });
            } else {
                $deferred.resolve(dataArr);
            }
        }).fail(function(){
            app.utility.hideLoader();
        });

        return $deferred.promise();
	},

	plotOnMap: function(e){
		app.utility.plotRecOnMap(srchResTable);
	},

	handleSyncService: function(){			
		var $deferred = new $.Deferred();
		var that = this;

		var lastSyncStr = MP_CONSTANTS.LOCAL_STORAGE.LAST_SYNC_TIME+currentSFUserId;
		var lastApexJobStr = MP_CONSTANTS.LOCAL_STORAGE.LAST_APEX_JOB_COMPLETE+currentSFUserId;

		var lastSyncUser = localStorage.getItem(lastSyncStr);
		var lastApexJobUser = localStorage.getItem(lastApexJobStr);

		var lastSync = lastSyncUser ? lastSyncUser : new Date().getTime().toString();
		var lastApexJob = lastApexJobUser ? lastApexJobUser : new Date().getTime().toString();

		// check if any data present in local DB in CITIES table
		// if no data is present, it means no data is stored in local for any city
		that.checkLocalDB().done(function(isDataPresent){
			if(isDataPresent){
				that.processSyncService(true, lastSyncStr, lastApexJobStr, lastApexJob, lastSync, null, null, null).done(function(sResp){
					// save timestamp from server
                    if(sResp){
                     	if(sResp.lastSyncTimeStamp && sResp.lastSyncTimeStamp !== null){
                            localStorage.setItem(lastSyncStr, sResp.lastSyncTimeStamp);
                        }   
                    }						
					$deferred.resolve();
				}).fail(function(err){
                    app.DbManager.dropDB().done(function(){						
                        that.reloadMapPlotter();
                    });					
				});
			} else {
				// clear data in DATAPOINTS table
				that.clearDataPoints().done(function(){
					var now = new Date().getTime();					
					localStorage.setItem(lastSyncStr, now);
					$deferred.resolve();
				});
			}
		});

		return $deferred.promise();
	},
	
	processSyncService: function(isFirstTime, lastSyncStr, lastApexJobStr, lastApexJob, lastSync, insertionOffsetId, updationOffsetId, deletionOffsetId){
		var $deferred = new $.Deferred();
		var that = this;		
		
		if((insertionOffsetId || updationOffsetId || deletionOffsetId) || isFirstTime){
			that.dataModelObj.getSyncData(lastSync, insertionOffsetId, updationOffsetId, deletionOffsetId).done(function(sResp){
				
				isFirstTime = false;
				
				if(sResp && sResp.lastApexJobComplete){
					// check weather the last apex job complete timestamp is changed
					// if it is changed - clear the local DB and update the timestamp.
					if(sResp.lastApexJobComplete !== lastApexJob){
                		app.DbManager.dropDB().done(function(){
							localStorage.setItem(lastApexJobStr, sResp.lastApexJobComplete);
							that.reloadMapPlotter();
						});								
					}
				}
				
				if(sResp.lstInsertedMapPoints && sResp.lstInsertedMapPoints.length >= MP_CONSTANTS.MAX_INSERT_UPDATE_DELETE_RECORDS){
					insertionOffsetId = sResp.lstInsertedMapPoints[sResp.lstInsertedMapPoints.length - 1]['Id'];
				}else{
					insertionOffsetId = null;
				}
				
				if(sResp.lstUpdatedMapPoints && sResp.lstUpdatedMapPoints.length >= MP_CONSTANTS.MAX_INSERT_UPDATE_DELETE_RECORDS){
					updationOffsetId = sResp.lstUpdatedMapPoints[sResp.lstUpdatedMapPoints.length - 1]['Id'];
				}else{
					updationOffsetId = null;
				}
				
				if(sResp.lstDeletedMapPoints && sResp.lstDeletedMapPoints.length >= MP_CONSTANTS.MAX_INSERT_UPDATE_DELETE_RECORDS){
					deletionOffsetId = sResp.lstDeletedMapPoints[sResp.lstDeletedMapPoints.length - 1]['Id'];
				}else{
					deletionOffsetId = null;
				}
				
				that.processSyncData(sResp).done(function(){
					that.processSyncService(isFirstTime, lastSyncStr, lastApexJobStr, lastApexJob, lastSync, insertionOffsetId, updationOffsetId, deletionOffsetId).done(function(){
						$deferred.resolve({lastSyncTimeStamp: sResp.lastSyncTimeStamp});
					});
				
				});
			}).fail(function(err){
				// clear local DB and reload
                if(err === "dataIsUptoDate"){
                    $deferred.resolve();
                }else{
                	$deferred.reject(err);
                }				
			});
		}else{
			$deferred.resolve();
		}
		
		return $deferred.promise(); 
	},
	
	checkLocalDB: function(){
		var $deferred = new $.Deferred();
        // If indexedDB supported
        if(appWithIndexedDB){
            app.DbManager.select(MP_CONSTANTS.DB_TABLES.CITIES_TABLE).done(function(cityData){			
                if(cityData && cityData.length > 0){
                    $deferred.resolve(true);
                } else {
                    $deferred.resolve(false);
                }
            });
        }else{
          	$deferred.resolve(false);  
        }
		return $deferred.promise();
	},

	clearDataPoints: function(){
		var $deferred = new $.Deferred();
        
        if(appWithIndexedDB){
        	app.DbManager.remove(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE).done(function(){
                app.DbManager.remove(MP_CONSTANTS.DB_TABLES.COUNTRIES_TABLE).done(function(){
                    $deferred.resolve();
                });
            });    
        }else{
            $deferred.resolve();
        }		
		return $deferred.promise();
	},

	processSyncData: function(syncRecords){
		var that = this,
			$deferred = new $.Deferred();

		if(syncRecords.setDeletedAddressInfo && syncRecords.setDeletedAddressInfo.length > 0){
			that.deleteAddressInfo(syncRecords.setDeletedAddressInfo).done(function(){
				delete syncRecords.setDeletedAddressInfo;
				that.processSyncData(syncRecords).done(function(){
					$deferred.resolve();
				});
			});
		} else if(syncRecords.setInsertedAddressInfo && syncRecords.setInsertedAddressInfo.length > 0){
			that.insertAddressInfo(syncRecords.setInsertedAddressInfo).done(function(){
				delete syncRecords.setInsertedAddressInfo;
				that.processSyncData(syncRecords).done(function(){
					$deferred.resolve();
				});
			});
		} else if(syncRecords.lstInsertedMapPoints && syncRecords.lstInsertedMapPoints.length > 0){
			that.insertRecordsToDB(syncRecords.lstInsertedMapPoints).done(function(){
				delete syncRecords.lstInsertedMapPoints;
				that.processSyncData(syncRecords).done(function(){
					$deferred.resolve();
				});
			});
		} else if(syncRecords.lstUpdatedMapPoints && syncRecords.lstUpdatedMapPoints.length > 0){
			that.updateRecordsToDB(0, syncRecords.lstUpdatedMapPoints).done(function(){
				delete syncRecords.lstUpdatedMapPoints;
				that.processSyncData(syncRecords).done(function(){
					$deferred.resolve();
				});
			});
		} else if(syncRecords.lstDeletedMapPoints && syncRecords.lstDeletedMapPoints.length > 0){
			that.deleteRecordsFromDB(syncRecords.lstDeletedMapPoints).done(function(){
				delete syncRecords.lstDeletedMapPoints;
				that.processSyncData(syncRecords).done(function(){
					$deferred.resolve();
				});
			});
		// check if address info (country-state-city) data is changed or not
		} else if(syncRecords.isAddressInfoChanged) {
			// update address info(country-state-city) data
			// set country data update flag to false
			isCountryDataUpdated = false;
			$deferred.resolve();
		} else {
			$deferred.resolve();
		}
		return $deferred.promise();
	},

	deleteAddressInfo: function(records){
		var that = this,
			$deferred = new $.Deferred();

		app.DbManager.remove(MP_CONSTANTS.DB_TABLES.CITIES_TABLE, records).done(function(){
			$deferred.resolve();
		});

		return $deferred.promise();
	},

	insertAddressInfo: function(records){
		var that = this,
			$deferred = new $.Deferred();

		app.DbManager.select(MP_CONSTANTS.DB_TABLES.CITIES_TABLE).done(function(cities){
			cities = _.pluck(cities, 'value');
			// filter previously available cities
			var fCities = _.filter(records, function(addrInfRec){
				if(cities.indexOf(addrInfRec) < 0){
					return addrInfRec;
				}
			});

			if(fCities && fCities.length > 0){
				app.DbManager.insert(MP_CONSTANTS.DB_TABLES.CITIES_TABLE, fCities).done(function(){
					$deferred.resolve();
				});
			} else {
				$deferred.resolve();
			}
		});			

		return $deferred.promise();
	},

	insertRecordsToDB: function(records){
		var that = this,
			$deferred = new $.Deferred();
		// get cities for which data is saved in local.
		app.DbManager.select(MP_CONSTANTS.DB_TABLES.CITIES_TABLE).done(function(cities){
			var exCities = _.pluck(cities, 'value');
			
			// get existing records in DATAPOINTS table
			app.DbManager.select(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE).done(function(datapoints){
				var exDatapoints = _.pluck(datapoints, 'value'),
					exDatapointsIds = _.pluck(exDatapoints, 'Id');

				// filter out those records which are already present in local
				var filteredRec = _.filter(records, function(rObj){
					if(rObj && rObj.Id && exDatapointsIds.indexOf(rObj.Id) < 0){
						return rObj;
					}
				});

				if(filteredRec.length > 0){
					app.DbManager.insert(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE, filteredRec).done(function(){
						$deferred.resolve();
					});
				} else {
					$deferred.resolve();
				}
			});
		});

		return $deferred.promise();
	},

	updateRecordsToDB: function(i, records){
		var that = this,
			$deferred = new $.Deferred();

		if(records && records[i] && records[i].Id){
			var record = {
				key: records[i].Id,
				value: records[i]
			};
			app.DbManager.update(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE, record).done(function(){
				setTimeout(function(){
					i++;
					if(i === records.length){
						$deferred.resolve();
					} else {
						that.updateRecordsToDB(i, records).done(function(){
							$deferred.resolve();
						});
					}
				}, 1);
			});
		} else {
			$deferred.resolve();
		}

		return $deferred.promise();
	},

	deleteRecordsFromDB: function(records){
		var that = this,
			$deferred = new $.Deferred();

		var keyArr = _.pluck(records, 'Id');
		if(keyArr && keyArr.length > 0){
			app.DbManager.remove(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE, keyArr).done(function(){
				$deferred.resolve();
			});
		} else {
			$deferred.resolve();
		}

		return $deferred.promise();
	},
	
	resetPanelHeights: function(){
		var winHt = $(window).height(),
			docWidth = $(document).width(),
			headHt, footHt, mapHt;		
		if( (typeof sforce != 'undefined') && sforce && (!!sforce.one) ) {
			// lightning mode
			headHt = 80;
			mapHt = winHt - headHt;			
			if(docWidth <= 768){
				headHt = 38;
				mapHt = winHt - headHt;
			}
		} else {
			// classic mode
			headHt = 111;
			footHt = 50;
			mapHt = winHt - headHt - footHt;
		}
		
	},

	reloadMapPlotter: function(){ 
         window.location.reload();
	},
	scrollPageToTop: function(){
		$("body, html").animate({scrollTop:0}, 'slow');
	},
    
     //Narayan Start
     //Moved code from list view to home view because of some reason 
     //Promotion popup and expiry date functions starts
    handlePromotionPopup : function(){       
        var that = this;
		Visualforce.remoting.Manager.invokeAction(MP_REMOTING.getPromotionData,
            function(result, event) {
		        response = JSON.parse(result);
                var chkPopup = response.ShowPromotionAlert;
                that.$daysLeft = response.TrialRemainingDays;
                that.expirydateAlert(response.TrialRemainingDays);
               
                if(chkPopup == "true"){
                    $('#promotionAlert').modal('show', {backdrop: 'static', keyboard: false});
                }else{
                    $("#promotionAlert").modal('hide');
                }               
            },{
                escape:false
            } 
        );
    },
    
    expirydateAlert: function(daysLeft){        
        if(daysLeft && daysLeft != null){
            $("#subscribeSpan").show();
            $('#expiryMsg').text(daysLeft);
        }else{
            $("#subscribeSpan").hide();
        }        
    },
    
    promotionFunctionAgree : function(){
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.PageVisited,
            function(result, event) {
                  var url = 'https://appexchange.salesforce.com/listingDetail?listingId=a0N3A00000E1hEiUAJ';
                  window.open(url, '_blank');
                 $("#promotionAlert").modal('hide');
            },{
                escape:false
            } 
        );
    },
    
    promotionFunctionRemindLetter : function(){
         Visualforce.remoting.Manager.invokeAction(MP_REMOTING.ReminderPageVisit,
            function(result, event) {
               $("#promotiomAlert").hide();
            }, {
                escape:false
            }
        );
    }
    
});