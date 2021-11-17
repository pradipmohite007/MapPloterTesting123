/**
 * List View:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality:
 *
 */

var app = app || {};

'use strict';
app.listView = Backbone.View.extend({

	el: null,
    daysLeft: null,
	initialize: function(options){
		var that = this;
		app.utility.showLoader();
       
        this.dataModelObj = new app.dataModel();
			
		setTimeout(function(){
			this.mapModelObj = new mapModel();              
        },100);   

		$('.app-button').removeClass('button-active');
		$('#listViewButton').addClass('button-active');
        
            that.checkCountryStateData().done(function(exCsData){
                // get data from local if prev data is present AND country data is updated.
                if(exCsData && isCountryDataUpdated){
                   
                    that.render(exCsData, false);
                } else {
                  
                    that.getCountryStateData().done(function(csData){
                        // set country data update flag to true
                        isCountryDataUpdated = true;
                        that.render(csData, false);
                    }).fail(function(){
                        that.render(false, false);
                    });
                }
            });       
		app.mapDetailViewData = [];
	},

	addEventListeners: function(){
		this.$('.countryCheck').unbind('click').bind('click', {'context': this}, this.handleSelectCountry);
		this.$('.stateCheck').unbind('click').bind('click', {'context': this}, this.handleSelectState);
		this.$('.cityCheck').unbind('click').bind('click', {'context': this}, this.handleSelectCity);
		this.$('#getListData').unbind('click').bind('click', {'context': this}, this.renderDataPointsList);
		this.$('#listViewPlot').unbind('click').bind('click', {'context': this}, this.renderMapDetailView);
		this.$('#selectAllDataPoints').unbind('click').bind('click', {'context': this}, this.handleSelectAllData);
		this.$('#country-search').unbind('keyup').bind('keyup', {'context': this}, this.handleCountrySearch);
        this.$('#is-cluster-form').unbind('click').bind('click', {'context': this}, this.enableClustering);
        
		if(dpTable){
			dpTable.$('.datapointcheck').unbind('click').bind('click', {'context': this}, this.handleDataPointCheck);
		} else {
		}

		this.$('#editLocations').unbind('click').bind('click', {'context': this}, this.editLocations);
        this.$('#getExcel').unbind('click').bind('click', {'context': this}, this.downloadExcel);
		this.resetPanelHeights();
		var isMobile = app.utility.getMobileOperatingSystem();
		if(isMobile){
			$(window).unbind('orientationchange').bind('orientationchange', this.resetPanelHeights);
		}
	},
	
	render: function(countryStateData){
        app.checkPanal = "listViewPanal";
		this.$el = $('#listViewContainer');
		var that = this;
		var template = app.utility.createTemplate('listViewTemplate');
		that.$el.html(template);
		$('.data-point-cross, #addCustomObj').show();
		$('#cObjSlider').removeClass('remove-listing-pad');
		if(countryStateData && Object.keys(countryStateData).length > 0){
			var countryData = {
				"data": countryStateData
			};
			var accordTemplate = app.utility.createTemplate('listViewAccordTemplate');
			$('#listViewAccContainer').html(accordTemplate(countryData));
		} else {
			that.checkApexJob().done(function(apexJob){
				if(apexJob){
					// apex job is not in process.
					$('#listViewAccContainer').html('<div class="noDirections"><p>'+MP_CONSTANTS.ERROR_MESSAGES.NO_DATA+'</p></div>');
				} else {
					// apex job is in process.
					$('#listViewAccContainer').html('<div class="noDirections"><p>'+MP_CONSTANTS.ERROR_MESSAGES.GEOCODING_IN_PROCESS+'</p></div>');
				}
			}).fail(function(){
			});
		}
		$('.data-point-cross, #addCustomObj').show();
		$('#cObjSlider').removeClass('remove-listing-pad');
		that.addEventListeners();
		app.utility.hideLoader();        
	},

	checkCountryStateData: function(){
       
        var $deferred = new $.Deferred();  
       
        if(appWithIndexedDB){        
            app.DbManager.select(MP_CONSTANTS.DB_TABLES.COUNTRIES_TABLE, 'csc_data').done(function(csData){
                if(csData && csData.length > 0 && csData[0].value.data){
                    $deferred.resolve(csData[0].value.data);
                } else {
                    $deferred.resolve(false);
                }
            });  
        }else{       
            $deferred.resolve(false);  
        }
        return $deferred.promise();       
	},

	checkApexJob: function(){
		var $deferred = new $.Deferred(),
		that = this;

		that.dataModelObj.checkApexJobStatus().done(function(resp){
			$deferred.resolve(resp);
		}).fail(function(){
			$deferred.reject();
		});

		return $deferred.promise();
	},

	getCountryStateData: function(){
		var $deferred = new $.Deferred();

		this.dataModelObj.getCountriesStatesData().done(function(countryStateData){
			if(Object.keys(countryStateData).length > 0){
				var csObj = {
					Id: 'csc_data',
					data: countryStateData
				};
                if(appWithIndexedDB){
                    app.DbManager.remove(MP_CONSTANTS.DB_TABLES.COUNTRIES_TABLE, ['csc_data']).done(function(){
                        app.DbManager.insert(MP_CONSTANTS.DB_TABLES.COUNTRIES_TABLE, [csObj]).done(function(){
                            $deferred.resolve(countryStateData);
                        });
                    });
                }else{
                    $deferred.resolve(countryStateData);
                }				
			} else {
				// no data available in country-state-city
				// clear all datapoints and city list saved in local
			    if(appWithIndexedDB){
                    app.DbManager.remove(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE).done(function(){
                        app.DbManager.remove(MP_CONSTANTS.DB_TABLES.CITIES_TABLE).done(function(){
                            $deferred.resolve(countryStateData);
                        });
                    });
                }else{
                    $deferred.resolve(countryStateData);
                }
			}
		}).fail(function(){
			$deferred.resolve(false);
		});

		return $deferred.promise();
	},

	handleSelectCountry: function(e){
		var that = e.data.context;

        // select all states and cities under the selected country
        var isChecked = e.currentTarget.checked;
        var countryIndex = parseInt(e.currentTarget.dataset.index);
        var stateCount = parseInt(e.currentTarget.dataset.statecount);

        for (var i = 0; i < stateCount; i++) {
            $('#stateCheck'+countryIndex+i).prop('checked', isChecked);
            var cityCount = parseInt($('#stateCheck'+countryIndex+i).data('citycount'));
            if(!isNaN(cityCount)){
                for (var j = 0; j < cityCount; j++) {
                    $('#cityCheck'+countryIndex+'_'+i+'_'+j).prop('checked', isChecked);
                }
            }
        }

        
	},

	handleSelectState: function(e){
		var that = e.data.context;

        // select all cities under the selected state
        var isChecked = e.currentTarget.checked;
        var countryIndex = parseInt(e.currentTarget.dataset.countryindex);
        var stateIndex = parseInt(e.currentTarget.dataset.index);
        var cityCount = parseInt(e.currentTarget.dataset.citycount);

        for (var i = 0; i < cityCount; i++) {
            $('#cityCheck'+countryIndex+'_'+stateIndex+'_'+i).prop('checked', isChecked);
        }

        var stateCount = $('#countryCheck'+countryIndex).data('statecount');
        var allChecked = false;
        if(!isNaN(stateCount)){
            for (var j = 0; j < stateCount; j++) {
                var isStateChecked = $('#stateCheck'+countryIndex+j).prop('checked');
                if(isStateChecked){
                    allChecked = true;
                } else {
                    allChecked = false;
                    break;
                }
            }
            $('#countryCheck'+countryIndex).prop('checked', allChecked).prop('indeterminate', !allChecked);
        }
        
	},

	handleSelectCity: function(e){
		var that = e.data.context;
        var stateIndex = parseInt(e.currentTarget.dataset.stateindex);
        var countryIndex = parseInt(e.currentTarget.dataset.countryindex);

        var cityCount = $('#stateCheck'+countryIndex+stateIndex).data('citycount');
        var allChecked = false;
        if(!isNaN(cityCount)){
            for (var i = 0; i < cityCount; i++) {
               
                var isCityChecked = $('#cityCheck'+countryIndex+'_'+stateIndex+'_'+i).prop('checked');
                if(isCityChecked){
                    allChecked = true;
                } else {
                    allChecked = false;
                    break;
                }
            }
            $('#stateCheck'+countryIndex+stateIndex).prop('checked', allChecked).prop('indeterminate', !allChecked);;
        }

        var stateCount = $('#countryCheck'+countryIndex).data('statecount');
        var allStateChecked = false;
        if(!isNaN(stateCount)){
            for (var j = 0; j < stateCount; j++) {
                var isStateChecked = $('#stateCheck'+countryIndex+j).prop('checked');
                if(isStateChecked){
                    allStateChecked = true;
                } else {
                    allStateChecked = false;
                    break;
                }
            }
            $('#countryCheck'+countryIndex).prop('checked', allStateChecked).prop('indeterminate', !allStateChecked);
        }

 	},

	locationsSelected: function(countryIndex){
		var stateCount = $('#countryCheck'+countryIndex).data('statecount');
		var cnt = 0;

		for (var i = 0; i < stateCount; i++) {
			var cityCount = $('#stateCheck'+countryIndex+i).data('citycount');
			for (var j = 0; j < cityCount; j++) {
				if($('#cityCheck'+countryIndex+'_'+i+'_'+j).prop('checked')){
					cnt++;
				}
			}
		}
		$('#locationsSelected'+countryIndex).text(cnt);
	},

	renderDataPointsList: function(e){
        var that = e.data.context,
            $deferred = new $.Deferred();

        var selectedDataPoints = [],
        	cityArray = [];

        if($('.legendObj span.data-point-name').length > 0){
          
            $('.legendObj span.data-point-name').each(function(){
                selectedDataPoints.push($(this).data('val'));
            });
        } else {
           
        	if(dpTable){
        		dpTable.rows().clear().draw();
        	}
        	app.mapDetailViewData = [];
        	document.getElementById('dpCount').innerHTML = app.mapDetailViewData.length;
            app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.CUSTOM_OBJECT_REQUIRED);
            return;
        }
        var checkedCity = $('.cityCheck:checked');
        app.cityInfo = checkedCity;
        if(checkedCity && checkedCity.length > 0){
        	
        	
            app.mapDetailViewData = [];

            app.utility.showLoader();
            $('#getListData').addClass('disabledObj');

            _.each(checkedCity, function(cobj){
                cityArray.push(cobj.dataset.cid);
            });

            var successHandler = function(){
				$('#countryPanel').removeClass('fadeOut animated').addClass('fadeOut animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				    $(this).removeClass('fadeOut animated').hide();
				});

				$('#dpResultPanel').show();
				$('#dpResultPanel').removeClass('fadeIn animated').addClass('fadeIn animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				    $(this).removeClass('fadeIn animated');
				});
                document.getElementById('dpCount').innerHTML = app.mapDetailViewData.length;

               	app.mapDetailViewData = _.sortBy(app.mapDetailViewData, 'Label');

                var resultsData = {
                    "data": app.mapDetailViewData.slice(0,100)//templateData//.slice(0, 100)
                };
                var dataPointsResTemplate = app.utility.createTemplate('largeTableTemplate');
                $('#resultsAccordionContainer').html(dataPointsResTemplate(resultsData));
                $('#listViewPlot').removeClass('disabledObj');

                // initialize datatable for #dataPointResultTable
                app.utility.initializeDataPointTable();
                if(app.mapDetailViewData.length > 99){
	                app.utility.addRowsToTable(app.mapDetailViewData.slice(100, app.mapDetailViewData.length), dpTable, 'datapointcheck');
	                dpTable.draw();
	                var thead = $('#dataPointResultTable_wrapper thead')[0];
		        	var fCol = $(thead).find('th')[0];
		        	$(fCol).attr('class', '');
	            }

                $('#getListData').removeClass('disabledObj');
                app.utility.hideLoader();
                that.addEventListeners();
            };
			
         
            if(appWithIndexedDB){
               
               // first get ids of all available cities and filter from cityArray.
				that.getAvailableCities().done(function(aCities){
					// get diff between available cities and selected cities
					// data is present for list of cities in aCities
					var newCityArray = _.difference(cityArray, aCities);

					// get data only for filtered cityArray.
					// get data from DATAPOINTS Table and filter according to cityArray and selectedDataPoints
					
					that.getAvailableCityData().done(function(datapoints){

						var exDatapoints = _.pluck(datapoints, 'value'),
							exDatapointsIds = _.pluck(exDatapoints, 'Id');

						app.mapDetailViewData = _.filter(exDatapoints, function(dObj){
							if(cityArray.indexOf(dObj.AddressKey) > -1 && selectedDataPoints.indexOf(dObj.Entity) > -1){
								return dObj
							}
						});
						if(newCityArray.length > 0){
							var masterArray = app.utility.divideArrayIntoN(newCityArray, 2000);
							// looping over master array
							that.handleMasterArr(masterArray, 0, selectedDataPoints, [], exDatapointsIds).done(function(newData){
							app.mapDetailViewData = _.filter(app.mapDetailViewData, function(dObj){
								if(cityArray.indexOf(dObj.AddressKey) > -1 && selectedDataPoints.indexOf(dObj.Entity) > -1){
									return dObj
								}
							});
								if(newData.length > 0) {
									// filter out those records which are already present in local
									var filteredRec = _.filter(newData, function(rObj){
										if(rObj && rObj.Id && exDatapointsIds.indexOf(rObj.Id) < 0){
											return rObj;
										}
									});
									if(filteredRec.length > 0){
										app.DbManager.insert(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE, filteredRec).done(function(){
											that.updateCityRecords(newCityArray).done(function(){
												successHandler.call();
											}).fail(function(){
												app.utility.hideLoader();
												successHandler.call();
											});
										}).fail(function(){
											app.utility.hideLoader();
											successHandler.call();
										});
									} else {
										successHandler.call();
									}
								} else {
									successHandler.call();
								}
							});
						} else {
							setTimeout(function(){
								successHandler.call();
							}, 100);
						}
					});
				});
			
	        }else{           
                var newCityArray = cityArray, exDatapointsIds = [];                    
                if(newCityArray.length > 0){
                    var masterArray = app.utility.divideArrayIntoN(newCityArray, 2000);
                    // looping over master array
                    that.handleMasterArr(masterArray, 0, selectedDataPoints, [], []).done(function(newData){
                        app.mapDetailViewData = _.filter(app.mapDetailViewData, function(dObj){
                            if(cityArray.indexOf(dObj.AddressKey) > -1 && selectedDataPoints.indexOf(dObj.Entity) > -1){
                                return dObj
                            }
                        });
                     
                        successHandler.call();
                    });
                } else {
                    setTimeout(function(){
                        successHandler.call();
                    }, 100);
                }
        	}    
        } else {
            app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.CITY_REQUIRED);
        }
        return $deferred.promise();
    },

    handleMasterArr: function(mArr, i, selectedDataPoints, allData, exDataIds){
        var that = this,
            $deferred = new $.Deferred();
        that.getDataPointsRecursive(mArr[i], selectedDataPoints, null, allData, exDataIds).done(function(allData){
            i++;
            if(i == mArr.length){
                $deferred.resolve(allData);
            } else {
                that.handleMasterArr(mArr, i, selectedDataPoints, allData, exDataIds).done(function(){
         	         $deferred.resolve(allData);
                }).fail(function(){
                    // handle fail
                });
            }
        });

        return $deferred.promise();
    },

    getDataPointsRecursive: function(arrElm, selectedDataPoints,  offsetId, dataArray, exDataIds){
        var that = this,
            $deferred = new $.Deferred();
        app.utility.showLoader();
        that.dataModelObj.getDataPoints(arrElm, selectedDataPoints, offsetId).done(function(response){    
            for (var i = 0; i < response.length; i++) {
            	if(response[i].Id && exDataIds.indexOf(response[i].Id) < 0){
            		app.mapDetailViewData.push(response[i]);
            		dataArray.push(response[i]);
            	}
            }
            if(response && response.length == 5000){
                if(response[4999].Id){
        	    } else {
        	    }
                that.getDataPointsRecursive(arrElm, selectedDataPoints, response[4999].Id, dataArray, exDataIds).done(function(){
                    $deferred.resolve(dataArray);
                });
            } else {
                $deferred.resolve(dataArray);
            }
        }).fail(function(e){
            app.utility.hideLoader();
            $('#getListData').removeClass('disabledObj');
        });

        return $deferred.promise();
    },

	renderMapDetailView: function(e){
		app.utility.plotRecOnMap(dpTable);
	},

	handleSelectAllData: function(e){
		var isCheck = e.currentTarget.checked;
		if(dpTable){
			var filtered = dpTable.$('tr', {"filter":"applied"});
			_.each(filtered, function(obj){
				$(obj).find('input[type="checkbox"]').prop('checked', isCheck);
			});
		} else {
			$('.datapointcheck').prop('checked', isCheck);
		}
	},

	handleDataPointCheck: function(e){
		app.utility.handleSelectCount('datapointcheck', 'dpCount', 'selectAllDataPoints', dpTable);
	},
    

	handleCountrySearch: function(){
		var searchStr = $(this).val().trim();
		app.utility.delay(function(){
			// search in country
			if(searchStr !== ""){
				$('.countryPanel').hide();
				var matchCountry = $('.country:containsSearch("'+searchStr+'")').length;
				if(matchCountry > 0){
					$('.city-list').show();
					$('.statePanel').show();
					$('.countryPanel .panel-collapse').each(function(){
						if($(this).closest('.panel').hasClass('statePanel')){
							$(this).collapse('hide');
						}
					});
					$('.country:containsSearch("'+searchStr+'")').each(function(){
						$(this).closest('.countryPanel').show();
						var colId = $(this).closest('a').attr('href');
						$(colId).collapse('show');
					});
				} else {
					$('.countryPanel').show();
					$('.countryPanel .panel-collapse').each(function(){
						if(!$(this).closest('.panel').hasClass('statePanel')){
							$(this).collapse('show');
						}
					});
					
					$('.statePanel').hide();
					var matchState = $('.state:containsSearch("'+searchStr+'")').length;
					if(matchState > 0){
						$('.city-list').show();
						$('.countryPanel').hide();
						$('.state:containsSearch("'+searchStr+'")').each(function(){
							$(this).closest('.statePanel').show();
							$(this).closest('.countryPanel').show();
							var colId = $(this).closest('a').attr('href');
							$(colId).collapse('show');
						});
					} else {
					
                        
                        $('.countryPanel .panel-collapse').collapse('show');
						$('.city').closest('.city-list').show();
						var matchCity = $('.city:containsSearch("'+searchStr+'")').length;
						if(matchCity > 0){
							$('.countryPanel').hide();
							$('.city').closest('.city-list').hide();
							$('.city:containsSearch("'+searchStr+'")').each(function(){
								$(this).closest('.city-list').show();
								$(this).closest('.statePanel').show();
								$(this).closest('.countryPanel').show();
								$(this).closest('.panel-collapse').collapse('show');
							});
						} else {
							// no match found
							$('.countryPanel .panel-collapse').collapse('hide');
							$('.countryPanel').hide();
						}
					}
				}
			} else {
				$('.statePanel').show();
				$('.countryPanel').show();
				$('.city-list').show();
				$('.countryPanel .panel-collapse').collapse('hide');
			}
		}, 400);
	},
    
    enableClustering: function(e){
    app.isClustering = e.currentTarget.checked; 
	},

	updateCityRecords: function(cityArray){
		var $deferred = new $.Deferred();

		app.DbManager.insert(MP_CONSTANTS.DB_TABLES.CITIES_TABLE, cityArray).done(function(){
			$deferred.resolve();
		}).fail(function(){
			$deferred.reject();
		});

		return $deferred.promise();
	},

	getAvailableCities: function(){
		var $deferred = new $.Deferred();

		app.DbManager.select(MP_CONSTANTS.DB_TABLES.CITIES_TABLE).done(function(resp){
			var cityArr = _.pluck(resp, 'value');
			$deferred.resolve(cityArr);
		}).fail(function(){
			$deferred.reject();
		});

		return $deferred.promise();
	},

	getAvailableCityData: function(cityArray, selectedDataPoints){
		var $deferred = new $.Deferred();

		app.DbManager.select(MP_CONSTANTS.DB_TABLES.DATAPOINTS_TABLE).done(function(resp){
			$deferred.resolve(resp);
		}).fail(function(){
			$deferred.reject();
		});

		return $deferred.promise();
	},

	editLocations: function(check){
          $('#dpResultPanel').removeClass('fadeOut animated').addClass('fadeOut animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
              $(this).removeClass('fadeOut animated');
              $(this).hide();
          });
          $('#countryPanel').show();
          $('#countryPanel').removeClass('fadeIn animated').addClass('fadeIn animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){                    
              $(this).removeClass('fadeIn animated');
              $(this).show();
		  });          
	},

    // Narayan Start
    downloadExcel: function(e){
        var that = e.data.context;
        app.utility.exportTableToCSV.apply(this,[$('#dataPointResultTable'), 'mapplotter.csv']);
	},
    // Narayan End

	resetPanelHeights: function(){
		/* new code... */
		var winHt = $(window).height(),
			docWidth = $(document).width(),
			headHt, footHt, mapHt;
		if( (typeof sforce != 'undefined') && sforce && (!!sforce.one) ) {
			// lightning
			headHt = 80;
			mapHt = winHt - headHt;

			if(docWidth <= 768){
				headHt = 38;
				mapHt = winHt - headHt;
			}
		} else {
			// classic
			headHt = 60;
			footHt = 45;
			mapHt = winHt - headHt - footHt;
		}
        
        $('#map-plotter-map').height(mapHt);
        $('#listViewContainer, #searchSection').height(mapHt);
		
		/* end */
		var mapHt = $('#map-plotter-map').height(),
			topheadHt = $('.top-head').height(),
			bottomHt = $('.bottom-footer').height();

		var innerHt = mapHt - topheadHt - bottomHt;
		

		var dpSrchHt = $('.searchResults-wrapper').height(),
			dpBtnHt = $('#listBtn').height();

		
		var dpInnerHt = mapHt - dpSrchHt - dpBtnHt  - 30;
		$('#resultsAccordionContainer').css('height', dpInnerHt+'px');
		$('#resultsAccordionContainer .dataTables_scrollBody').height(dpInnerHt - 40);
		
		var custObjHt = $('#advSCustomObjs').height(),
			advSrchHt = $('.advsearch-outer-wrapper').height();

		var srchInnerHt = mapHt - (custObjHt + advSrchHt);
		$('#advSearchResult').css('height', srchInnerHt+'px');
	},

	close: function () {
		this.unbind(); // Unbind all local event bindings
		this.undelegateEvents();
		$(this).empty();
		this.$el.empty();
	}
});