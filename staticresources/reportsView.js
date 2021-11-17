/**
 * Reports View:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality:
 *
 */

var app = app || {};

'use strict';
var isColoredFilter = false;
var wData, currentFileldSet="";
var colorpicker,inputtarget; //for ColorPicker object
var filterExportData;
app.reportsView = Backbone.View.extend({
	el: null,

	// storing meadata for objects
	objMetadataArr: [],

	// operator data related to filters
	fieldOperatorObj: null,

	// list of filters
	filterList: null,

	initialize: function(){
        app.checkPanal = "filterViewPanal";
		var that = this;
		this.dataModelObj = new app.dataModel();
		this.mapModelObj = new mapModel();
		app.utility.showLoader();
        mapModel.prototype.clearMarkers();
        directionsDisplay.setMap(null);
		this.dataModelObj.getReportList().done(function(resp){
			that.filterList = resp;
			that.render(resp);
		}).fail(function(err){
			app.utility.hideLoader();
		});
	//Assing target to ColorPicker	
 		inputtarget = document.getElementById('popupColorVal');
    	colorpicker = new CP(inputtarget);	
        colorpicker.target.oncut = this.handleColorPickerUpdate;
        colorpicker.target.onpaste = this.handleColorPickerUpdate;
        colorpicker.target.onkeyup = this.handleColorPickerUpdate;
        colorpicker.target.oninput = this.handleColorPickerUpdate; 
    },

	addEventListeners: function(){
		this.$('#getReportData').unbind('click').bind('click', {'context': this}, this.generateReport);
       
     	//Mass update
        this.$('#massUpdate').unbind('click').bind('click', app.utility.massUpdate);
        $('#massupdateOk').unbind('click').bind('click', app.utility.validateMassUpdateData);
        $('#dataObject').unbind('change').bind('change', app.utility.handleFieldSetChange);
        
		this.$('#resultPlot').unbind('click').bind('click', {'context': this}, this.plotOnMap);
		this.$('#selectAllReportData').unbind('click').bind('click', {'context': this}, this.selectAllReportDataPoint);
		if(reportTable){
			reportTable.$('.reportcheck').unbind('click').bind('click', {'context': this}, this.handleReportCheck);
		} else {
		}
		this.resetPanelHeights();
		var isMobile = app.utility.getMobileOperatingSystem();
		if(isMobile){
			$(window).unbind('orientationchange').bind('orientationchange', this.resetPanelHeights);
		}
		$('#baseObject').unbind('change').bind('change', {'context': this}, this.handleBaseObjChange);
        $('#dataObject').unbind('change').bind('change', {'context': this}, this.handleFieldSetChange);
        
		$('#filterListContainer').on('change', '.mdFields', {'context': this}, this.handleFieldChange);
		$('#refineFilterContainer').on('change', '#refinefilterListContainer .mdFields', {'context': this}, this.handleRefineFieldChange);
		$('#filterListContainer').on('change', '.fieldOps', {'context': this}, this.handleOperatorChange);
        colorpicker.on('change',this.handleColorPickerChange);
		$('#filterListContainer').off('click', '.picklistSelect').on('click', '.picklistSelect', {'context': this}, this.openPickListPopup);
		$('#refineFilterContainer').off('click', '.picklistSelect').on('click', '.picklistSelect', {'context': this}, this.openPickListPopup);
		$('#savePickList').unbind('click').bind('click', {'context': this}, this.closePickListPopup);
		$('#deleteFilterRow').unbind('click').bind('click', {'context': this}, this.deleteFilterRow);
		$('#addFilter').unbind('click').bind('click', {'context': this}, this.addFilterRow);
		$('#refineFilterContainer').off('click', '#addRefineFilter').on('click', '#addRefineFilter', {'context': this}, this.addRefineFilterRow);
		$('#refineFilterContainer').off('click', '#deleteRefineFilterRow').on('click', '#deleteRefineFilterRow', {'context': this}, this.deleteRefineFilterRow);		
		$('#saveFilter').unbind('click').bind('click', {'context': this}, this.saveFilter);
		$('#filterType').unbind('change').bind('change', {'context': this}, this.handleFilterType);
		$('#filterContainer .editFilter').unbind('click').bind('click', {'context': this}, this.editFilter);
		$('#filterContainer .deleteFilter').unbind('click').bind('click', {'context': this}, this.deleteFilter);
        $('#filterContainer .cloneFilter').unbind('click').bind('click', {'context': this}, this.cloneFilter);
		$('#myModal').on('show.bs.modal, hidden.bs.modal', this.resetFilterModal);
		//$('#addNewFilter').unbind('click').bind('click', {'context': this}, this.openFilterModel);
		//$('#addNewFilter').unbind('click').bind('click', openModel);
		$('a[data-toggle="tab"]').unbind('shown.bs.tab').bind('shown.bs.tab', {'context': this}, this.handleFilterPanelChange);
		$('#filterListContainer').on('click', '.colorVal', {'context': this}, this.openSelectColorPopup);
		$('#saveColor').unbind('click').bind('click', {'context': this}, this.closeSelectColorPopup);
		$('#queryName').unbind('blur').bind('blur', {'context': this}, this.validateFilterName);
		$('#filterType').unbind('focus').bind('focus', {'context': this}, function(){
			$(this).data('prevval', $(this).val());
		});
        
        //Filter export
         $('#exportResult').unbind('click').bind('click', {'context': this}, this.exportData);
         $('#is-cluster-form').unbind('click').bind('click', {'context': this}, this.enableClustering);
       
	},

	render: function(resp){
		this.$el = $('#listViewContainer');
		var reportList = {
			data: _.sortBy(resp, function (i) { return i.reportName.toLowerCase();})
		};
		var template = app.utility.createTemplate('reportsViewTemplate');
		this.$el.html(template(reportList));

		// render filter list on create/edit filter popup
		var filterListTemplate = app.utility.createTemplate('filterListTemplate');
		$('#filterContainer').html(filterListTemplate(reportList));

		$('.data-point-cross, #addCustomObj').hide();
		$('#cObjSlider').addClass('remove-listing-pad');

		var objData = {
			"data": [] 
		};
		// list present on ADD/EDIT Filter Popup
		var custObjListTemp = app.utility.createTemplate('customObjListTemplate');
	    for(var i=0; i< dataObjects.length; i++){
            if(dataObjects[i].IsGeocoded == true){
               objData.data.push(dataObjects[i]);
            }                   
        }
		$('#baseObject').html(custObjListTemp(objData));

		this.resetFilterModal();

		this.addEventListeners();
		app.utility.hideLoader();
	},

	generateReport: function(e){
		var that = e.data.context;
		var reportId = $('#reportList').val();
		var cntElm;
		var filterType = $('#reportList option:selected').data('filtertype');

		app.mapDetailViewData = [];

		if(reportId && reportId !== ""){
			app.utility.showLoader();

			var successHandler = function(errObj){
				app.mapDetailViewData = _.sortBy(app.mapDetailViewData, 'Label');
				
				var reportData = {
					data: app.mapDetailViewData.slice(0, 100)
				};
				var reportTemplate = app.utility.createTemplate('reportResultTemplate');
				$('#reportTableContainer').html(reportTemplate(reportData));
				cntElm = document.getElementById('reportDPCount');
				if(cntElm){
					cntElm.innerHTML = app.mapDetailViewData.length;
				}
				reportTable = $('#reportsDPTable').DataTable({
					scroller: true,
	                scrollY: '36vh',//164,
	                paging: true,
	                bLengthChange: false, // needs paging true
	                deferRender: false,
	                columnDefs: [
	                	{targets: [0], sortable: false}
	                ],
	           
				});

				$('#reportsDPTable_wrapper .dataTables_filter').hide();
				$('#reportsDPTable_wrapper .dataTables_info').hide();

				$('#reportResSrch').keyup(function(){
				    reportTable.search($(this).val()).draw();
				    var allRows = reportTable.$('tr', {"filter":"applied"});
	    			$('#reportDPCount').text(allRows.length);
	    			app.utility.handleSelectCount('reportcheck', 'reportDPCount', 'selectAllReportData', reportTable);
				});

				if(app.mapDetailViewData.length > 99){
	                app.utility.addRowsToTable(app.mapDetailViewData.slice(100, app.mapDetailViewData.length), reportTable, 'reportcheck');
	                reportTable.draw();
	            }

	            var thead = $('#reportsDPTable_wrapper thead')[0];
	        	var fCol = $(thead).find('th')[0];
	        	$(fCol).attr('class', '');

	        	
				$('#resultPlot').data('filterid', reportId);

				that.addEventListeners();

				if(filterType === "colored"){
					that.getFilterLegend(reportId).done(function(lData){
						if(lData){
							lData =  _.filter(lData, function(obj){ return !!obj.color });
							var objData = {
								"data": lData
							};
							// template for legend bar
							var template = app.utility.createTemplate('filterLegendTemplate');
							$('#dataObjectContainer').html(template(objData));
						}
					});
				} else {
					app.utility.resetCustomObjectSlider();
				}

				if(errObj){
					if(cntElm){
						cntElm.innerHTML = 0;
					}
					if(reportTable){
						try{
							reportTable.destroy();
						} catch(e){
						}
						$('#reportTableContainer').empty();
					}
					if(errObj && errObj.message){
						app.utility.showAlertModal(errObj.message);
					} else {
						app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.OBJECT_NOT_GEOCODED);
					}
				}
				app.utility.hideLoader();
			};

			that.getReportsData(reportId, null, successHandler).done(function(){
				// done
			}).fail(function(err){
				// fail
			});
		} else {
			app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.NO_REPORT_ID);
		}
	},

	getReportsData: function(reportId, offsetId, successHandler){
		var that = this,
			$deferred = new $.Deferred();

		that.dataModelObj.getReportsData(reportId, offsetId).done(function(resp){
			if(resp && resp.lstMPPoint && resp.lstMPPoint.length > 0){
				for (var i=0, len=resp.lstMPPoint.length; i < len; i++){
					app.mapDetailViewData.push(resp.lstMPPoint[i]);
				}
			}
			if(resp && resp.hasMoreRecords && resp.offsetId !== null){
		                that.getReportsData(reportId, resp.offsetId, successHandler).done(function(){
                	$deferred.resolve();
                });
			} else if(app.mapDetailViewData.length === 0) {
				successHandler(resp);
			} else {
				successHandler();
				$deferred.resolve();
			}
		});

		return $deferred.promise();
	},

	plotOnMap: function(e){
		app.utility.plotRecOnMap(reportTable, true);
	},

	selectAllReportDataPoint: function(e){
		var isCheck = e.currentTarget.checked;
		if(reportTable){
			var filtered = reportTable.$('tr', {"filter":"applied"});
			_.each(filtered, function(obj){
				$(obj).find('input[type="checkbox"]').prop('checked', isCheck);
			});
		} else {
			$('.reportcheck').prop('checked', isCheck);
		}
	},

	handleReportCheck: function(e){
		app.utility.handleSelectCount('reportcheck', 'reportDPCount', 'selectAllReportData', reportTable);
	},

	resetPanelHeights: function(){
		var mapHt = $('#map-plotter-map').height(),
			titleHt = $('.rptpanel-title').height(),
			selectHt = $('.rptform-wrapper').height();

		var innerHt = mapHt - (titleHt + selectHt);
		$('#reportTableContainer').css('min-height', innerHt+'px');
	},

	validateFilterName: function(e){
		// e && e.data.context - getting context from element
		// if method fired explicitly then context is default i.e., 'this'
		
		var that = e && e.data.context || this,
			jqThis = $('#queryName');	
        var isCloneFilter = $("#addEditText").text();
		var fName = jqThis.val().trim().toLowerCase();
		if(fName && fName !== ""){
            // find existing filter object with name entered if exists
            //var filterNames = _.pluck(that.filterList, 'reportName');
			var exNameObj = _.filter(that.filterList, function(filtername) {
			    return filtername.reportName .toLowerCase() == fName;
			});
			var editFilterId = $('#saveFilter').data('editid');
			var currentFilterId = exNameObj.length > 0 ? exNameObj[0].reportId : null;
            
			if((exNameObj.length > 0 && editFilterId !== currentFilterId)||(exNameObj.length > 0 && isCloneFilter == "Clone Filter")){
				jqThis.next().text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_FILTER_NAME).show();
				return false;
			} else {
				jqThis.next().hide();
				return true;
			}
		} else {
			jqThis.next().hide();
			return false;
		}
	},
    
    enableClustering: function(e){
    app.isClustering = e.currentTarget.checked;
	},

	handleBaseObjChange: function(e){
		var that = e.data.context;
		var selectedObj = $(this).val();

		if(selectedObj !== "Select"){
			app.utility.showLoader();
			that.getObjMetadata(selectedObj).done(function(metadata){
				app.utility.hideLoader();
				var initialFilterList = app.utility.createTemplate('initialFilterList');
				$('#filterListContainer').html(initialFilterList());

				var mdata = {
					data: _.sortBy(metadata, 'label')
				};
				var metadataFieldOptTemplate = app.utility.createTemplate('metadataFieldOptTemplate');
				$('.mdFields').html(metadataFieldOptTemplate(mdata));

				$('#fLogic, refinefLogic').addClass('fresh');

				that.handleAddDelete();
				that.renderRefineFilter(mdata);
				that.handleFilterLogicVal();
				that.handleRefineFilterLogicVal();
			}).fail(function(){
				app.utility.hideLoader();
			});
		} else {
			$('#filterListContainer').empty();
			that.handleAddDelete();
		}
	},

	getObjMetadata: function(objName){
		var $deferred = new $.Deferred(),
			that = this;

		// first find metadata in objMetadataArr
		var metaData = _.findWhere(this.objMetadataArr, {
			object: objName
		});

		if(metaData && metaData.data){
			$deferred.resolve(metaData.data);
		} else {
			this.dataModelObj.getObjectMetadata(objName).done(function(md){
				var mdObj = {
					object: objName,
					data: md
				};
				that.objMetadataArr.push(mdObj);
				$deferred.resolve(md);
			}).fail(function(){
				$deferred.reject();
			});
		}

		return $deferred.promise();
	},

	renderRefineFilter: function(mdata){
		var that = this;
		if(isColoredFilter){
			var filterRefineTemplate = app.utility.createTemplate('filterRefineTemplate');
			$('#refineFilterContainer').html(filterRefineTemplate());

		}else{
			$('#refineFilterContainer').html('');
		}
	},

	renderMetaDataFields: function(baseObj, rowNum, containerName){
		var that = this;
		that.getObjMetadata(baseObj).done(function(metadata){
			var mdata = {
				data: _.sortBy(metadata, 'label')
			};
			var metadataFieldOptTemplate = app.utility.createTemplate('metadataFieldOptTemplate');
			
			if(rowNum || rowNum === 0){
				$('#'+containerName+' select.mdFields').eq(rowNum).html(metadataFieldOptTemplate(mdata));
			}
		}).fail(function(){
			app.utility.hideLoader();
		});
	},

	handleFieldChange: function(e, doNotResetFilters){
     	var that = e.data.context,
			jqThis = $(this),
			fieldVal = jqThis.find('option:selected').data('dtype'),//jqThis.val(),
			fVal = jqThis.val(),
			fieldText = jqThis.find('option:selected').text();

		jqThis.closest('li').find('.fieldOps').html('<option value="Select">Select</option>');
		jqThis.closest('li').find('.picklistSelect').hide();
		jqThis.closest('li').find('.queryVal').val('').prop('disabled', false);

		if(fieldVal !== "Select"){
			jqThis.siblings('.error-text-msg').hide();
			that.getFieldOperators(fieldVal).done(function(ops){
				if(ops){
					var optData = {
						data: ops
					};
					var fieldOpeTemplate = app.utility.createTemplate('fieldOpeTemplate');
					jqThis.closest('li').find('.fieldOps').html(fieldOpeTemplate(optData));

					// these are single select field
					if(fieldVal === "PICKLIST"){
						jqThis.closest('li').find('.queryVal').prop('disabled', true);						
						that.renderPickListValues(fieldText, jqThis, 'single');
					// multiple select field
					} else if(fieldVal === "MULTIPICKLIST"){
						jqThis.closest('li').find('.queryVal').prop('disabled', true);
						that.renderPickListValues(fieldText, jqThis, 'multi');
					}
					if(isColoredFilter){
						// restricted to 'Equals to' criteria
						jqThis.closest('li').find('.fieldOps').val('Equals to').prop('disabled', true);//.trigger('change');
						
					}
				}
			}).fail(function(){
			});
		}
		
		if(isColoredFilter && doNotResetFilters !== "doNotResetFilters"){
			that.resetColoredFilterDropdown(fVal);
		}
	},
	
	// Added by Sachin Ranvirkar
	resetColoredFilterDropdown: function(firstDropDownVal){
		$('#filterListContainer select.mdFields').not(':first').val(firstDropDownVal);
		var firstFieldOptions = $('#filterListContainer select.fieldOps:first').html();
		$('#filterListContainer select.fieldOps').not(':first').html(firstFieldOptions);
		$('#filterListContainer select.fieldOps').not(':first').val('Equals to');
		$('#filterListContainer input.queryVal').not(':first').val('');   
        
        var dType = $('#filterListContainer select.mdFields option:selected').data("dtype");
        if(dType !== "PICKLIST" && dType !=="MULTIPICKLIST"){
            $("#filterListContainer .picklistSelect").hide();
        }else{
            $("#filterListContainer .picklistSelect").show();
        }
	},

	handleRefineFieldChange: function(e){
		var that = e.data.context,
			jqThis = $(this),
			fieldVal = jqThis.find('option:selected').data('dtype'),//jqThis.val(),
			fieldText = jqThis.find('option:selected').text();

		jqThis.closest('li').find('.fieldOps').html('<option value="Select">Select</option>');
		jqThis.closest('li').find('.picklistSelect').hide();
		jqThis.closest('li').find('.queryVal').val('').prop('disabled', false);

		if(fieldVal !== "Select"){
			jqThis.siblings('.error-text-msg').hide();
			that.getFieldOperators(fieldVal).done(function(ops){
				if(ops){
					var optData = {
						data: ops
					};
					var fieldOpeTemplate = app.utility.createTemplate('fieldOpeTemplate');
					jqThis.closest('li').find('.fieldOps').html(fieldOpeTemplate(optData));

					// these are single select field
					if(fieldVal === "PICKLIST"){
						jqThis.closest('li').find('.queryVal').prop('disabled', true);						
						that.renderPickListValues(fieldText, jqThis, 'single');
					// multiple select field
					} else if(fieldVal === "MULTIPICKLIST"){
						jqThis.closest('li').find('.queryVal').prop('disabled', true);
						that.renderPickListValues(fieldText, jqThis, 'multi');
					}
				}
			}).fail(function(){
			});
		}
	},

	getFieldOperators: function(field){
		var $deferred = new $.Deferred(),
			that = this,
			operators;
		// first check in fieldOperatorObj
		if(that.fieldOperatorObj !== null){
			operators = that.fieldOperatorObj[field];
			$deferred.resolve(operators);
		} else {
			that.dataModelObj.getOperators().done(function(opResp){
			operators = opResp[field];
				that.fieldOperatorObj = opResp;				
				$deferred.resolve(operators);
			}).fail(function(){
				$deferred.reject();
			});
		}

		return $deferred.promise();
	},

	renderPickListValues: function(fieldVal, jqThis, type){
		// type - single select or multiselect
		var baseObj = document.getElementById('baseObject').value;
		var metad = _.findWhere(this.objMetadataArr, {
			object: baseObj
		});

		if(metad && metad.data){
			var fieldObj = _.findWhere(metad.data, {
				label: fieldVal
			});

			if(fieldObj && fieldObj.fldDatatypeinfo && fieldObj.fldDatatypeinfo.lstpicklistValues){
				// append the first value to the jqThis.closest('li').find('.picklistSelect')
				// populate these array values on second popup
				if(jqThis){
					jqThis.closest('li').find('.picklistSelect').show();
				}
				var pickListHtml = '';
				if(type === 'single'){
					pickListHtml = '<select id="pickListVal" multiple="" class="ui fluid dropdown" class="form-control select-control">';
					for (var i = 0, len = fieldObj.fldDatatypeinfo.lstpicklistValues.length; i < len; i++) {
						var pval = fieldObj.fldDatatypeinfo.lstpicklistValues[i];
						pickListHtml+= '<option value="'+pval.toLowerCase()+'">'+pval+'</option>';
					}
					pickListHtml+= '</select>';
				} else if(type === 'multi'){
					pickListHtml = '<ul class="list-unstyled list-margin">';
					for (var i = 0, len = fieldObj.fldDatatypeinfo.lstpicklistValues.length; i < len; i++) {
						var pval = fieldObj.fldDatatypeinfo.lstpicklistValues[i];
						pickListHtml+= '<li><input data-val="'+pval.toLowerCase()+'" type="checkbox" id="picCheck'+i+'" class="css-checkbox picCheck"/><label for="picCheck'+i+'" class="css-label">'+pval+'</label></li>';
					}
					pickListHtml+= '</ul>';
				}
				$('#pickValues').html(pickListHtml);
			}
		}
	},

	openPickListPopup: function(e){
		var that = e.data.context,
			jqThis = $(this),
			saveFor = jqThis.closest('li').find('.queryVal').attr('id');
		$('#savePickList').data('savefor',saveFor);

		var fieldVal = jqThis.closest('li').find('.mdFields option:selected').text();
	
		var fieldType = jqThis.closest('li').find('.mdFields option:selected').data('dtype');//jqThis.closest('li').find('.mdFields').val();
		var checkType;

		if(fieldType === "PICKLIST"){
			
			checkType = 'multi';
		} else {
			checkType = 'multi';
		}

		that.renderPickListValues(fieldVal, null, checkType); 
		
		var qVal = jqThis.closest('li').find('.queryVal').val(); 
		jqThis.closest('li').find('.queryVal').siblings('.error-text-msg').hide();
		if(qVal !== ''){
			
			$('#pickListVal').val(qVal);
			if(checkType === 'multi'){
				var checkedVals = qVal.split(';');
				if(checkedVals && checkedVals.length > 0){
					$('.picCheck').each(function(){
						if(checkedVals.indexOf($(this).data('val')) > -1){
							$(this).prop('checked', true);
						} else {
							$(this).prop('checked', false);
						}
					});
				}
			}
		}		

		$('#pickListModal').modal({backdrop: "static", keyboard: false});
		$('#pickListModal').show();
	},

	closePickListPopup: function(){
		var selPickVal = $('#pickListVal').val(),
			savefor = $(this).data('savefor');

		if(selPickVal){
			// got value from select box
			$('#'+savefor).val(selPickVal);
		} else {
			// got values from checkboxes
			selPickVal = [];
			$('.picCheck:checked').each(function(){
				selPickVal.push($(this).data('val'));
			});
			$('#'+savefor).val(selPickVal.join(';'));
		}
		//$('#pickListModal').modal('hide');
			$('#pickListModal').hide();
           	$('.modal-backdrop')[1].remove();
	},

	deleteFilterRow: function(e){
		var that = e.data.context;
		$('#filterListContainer li').last().remove();
		//$('#fLogic').addClass('fresh');
		that.handleAddDelete();
		that.handleRefineFilterRowIndex();
		if($('#fLogic').hasClass('fresh')){
			that.handleFilterLogicVal();
		}
		if($('#refinefLogic').hasClass('fresh')){
			that.handleRefineFilterLogicVal();
		}
	},

	deleteRefineFilterRow: function(e){
		var that = e.data.context;
		$('#refinefilterListContainer li').last().remove();
		that.handleRefineAddDelete();
        if($('#refinefLogic').hasClass('fresh')){
        	that.handleRefineFilterLogicVal();    
        }
	},
	
    addFilterRowCreatedFilter: function(e){
        var that = e && e.data.context || this;
        // get count of existing rows
        var rowCnt = $('#filterListContainer li').length;
        
        if(rowCnt < MP_CONSTANTS.ALLOWED_FILTER_COUNT){
            var rowObj = {
                data: {
                    srno: rowCnt+1
                }
            };
            var baseObj = document.getElementById('baseObject').value;
            var rowTemp = app.utility.createTemplate('filterRowTemplate');
            // NARAYAN start
            $("#scrollBottom").animate({ scrollTop: $(document).height(100) }, "slow");
            // NARAYAN end
            $('#filterListContainer').append(rowTemp(rowObj));
            that.renderMetaDataFields(baseObj, rowCnt, "filterListContainer");
            
            if(isColoredFilter){
                that.resetFilterRow(rowCnt);
            }
            
           
            
        } else if(rowCnt === MP_CONSTANTS.ALLOWED_FILTER_COUNT){
           }
        that.handleAddDelete();
        that.handleRefineFilterRowIndex();
        if($('#fLogic').hasClass('fresh')){
            that.handleFilterLogicVal();
        }
        if($('#refinefLogic').hasClass('fresh')){
            that.handleRefineFilterLogicVal();
        }
    },
	addFilterRow: function(e){
		var that = e && e.data.context || this;
		// get count of existing rows
		var rowCnt = $('#filterListContainer li').length;
		var addRow = false;
		var isError = false;
		if(rowCnt < MP_CONSTANTS.ALLOWED_FILTER_COUNT){
		
			var filterCnt = $('#filterListContainer li').length;
			var filterArr = [];

			if(filterCnt !== 0){
				var selectedColors = [];
				$('#filterListContainer li').each(function(){
					
					var fieldVal = $(this).find('.mdFields').val();
					var fieldType = $(this).find('.mdFields').find('option:selected').data('dtype');//$(this).find('.mdFields').val();
					if(!fieldVal || fieldVal === 'Select'){
						isError = true;
						$(this).find('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).show();
						addRow = false;
						return false;
						//Narayan Start 
						$('.mdFields').on('change', function() {
							if ( $(this).val() != 'Select')
							{
							    $('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).hide();
								$('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).hide();
								addRow = true;
							}
						});
						//Narayan End 
					}else{
						addRow = true;
					}
					
					var operVal = $(this).find('.fieldOps').val();
					
					if(operVal === 'Select'){
					
						//Narayan Start 
						$('.fieldOps').on('change', function() {
						  if ( $(this).val() != 'Select')
						  {
							//$('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).hide();
							$('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).hide();
							
							addRow = true;
						  }
						});
						//Narayan End 
					
						isError = true;
						$(this).find('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).show();
						addRow = false;
						return false;
						
					}else{
						addRow = true;
					}

					var qVal = $(this).find('.queryVal').val();
					if(qVal === ''){
									
						//Narayan Start
						$(".form-control").keyup(function (e) {
							$(this).siblings('.error-text-msg').fadeOut();
							var qVal = $(this).find('.queryVal').val();
							if(qVal != ''){
								addRow = true;
							}							
						});	
						//Narayan End
							
						//Narayan Start
						$( "#savePickList" ).click(function() {
						    $('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).hide(); 
							addRow = true;
						});
						//Narayan End
						
						isError = true;
						$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).show();
						addRow = false;
						return false;
						
					}else{
						addRow = true;
					}
					if(isColoredFilter){                   
						//Narayan Start
						$(".queryVal").keyup(function (e) {
							$(this).siblings('.error-text-msg').fadeOut();
							addRow = true;
						});
						
						 $("#queryName").keyup(function (e) {                   
							$(this).siblings('.error-text-msg').fadeOut();
							addRow = true;
						});
						//Narayan End                   
						var colorVal = $(this).find('.colorVal').data('colorval');//$(this).find('.colorVal').val();
						if(colorVal === ''){
							isError = true;
							
							$(this).find('.colorVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.COLOR_VALUE_REQUIRED).show();
							addRow = false;
							return false;
						} else {
							if(selectedColors.indexOf(colorVal) > -1){
								isError = true;
								addRow = false;
								$(this).find('.colorVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_COLOR_VALUE).show();
								$( "#saveColor" ).click(function() {
								  $('.colorVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_COLOR_VALUE).hide(); 
								  addRow = true;
								});
							} else {
								selectedColors.push(colorVal);
								//addRow = true;
							}
						}
					}

					if(fieldType === 'DATE' || fieldType === 'DATETIME'){
						//Code by Rakesh - Added below REGEX to check Date in MM-DD-YYYY format
						var rgexpDt = /^((0?[1-9]|1[012])[/ /.](0?[1-9]|[12][0-9]|3[01])[/ /.](19|20)?[0-9]{2})*$/;
						if(qVal.trim() === ""){
							isError = true;  
							addRow = false;
							
							$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).show();
							return false;
						}else if(!rgexpDt.test(qVal)){
							//console.log('4::');
							isError = true;  
							addRow = false;	
							$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.INVALID_DATE).show();
							return false;
						}else{
							addRow = true;
						}  

						$(".queryVal").keyup(function (e) {
							$(this).siblings('.error-text-msg').fadeOut();							
						});
					}

					if(!isError){
						var fObj = {
							fldName: fieldVal,
							fldDataType: fieldType,
							operVal: operVal,
							fldValue: qVal,
							ftype:$('#filterType').val()
						};
						var isObjExists = _.findWhere(filterArr, fObj);
						if(!isObjExists){
							fObj.color = isColoredFilter ? colorVal : null;
							filterArr.push(fObj);
						} else {
							isError = true;
							$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_QUERY_VALUE).show();
						}
					}
				});
			} else {
				isError = true;
			} 
		
			
			if(addRow == true){
				var baseObj = document.getElementById('baseObject').value;
				var rowTemp = app.utility.createTemplate('filterRowTemplate');
				// NARAYAN start
				$("#scrollBottom").animate({ scrollTop: $(document).height() }, "slow");
				// NARAYAN end
				var rowObj = {
					data: {
						srno: rowCnt+1
					}
				};
				$('#filterListContainer').append(rowTemp(rowObj));
				that.renderMetaDataFields(baseObj, rowCnt, "filterListContainer");
			}
			
			if(isColoredFilter){
				that.resetFilterRow(rowCnt);
			}

			

		} else if(rowCnt === MP_CONSTANTS.ALLOWED_FILTER_COUNT){
		}
		that.handleAddDelete();
		that.handleRefineFilterRowIndex();
		if($('#fLogic').hasClass('fresh')){
			that.handleFilterLogicVal();
		}
		if($('#refinefLogic').hasClass('fresh')){
			that.handleRefineFilterLogicVal();
		}	
	},
	
	addRefineFilterRowCreatedFilter: function(e){
		var that = e && e.data.context || this;
		// get count of existing rows
		var normalFrowCnt = $('#filterListContainer li').length;
		var refineFRowCnt = $('#refinefilterListContainer li').length;

		if(refineFRowCnt < MP_CONSTANTS.ALLOWED_REFINE_FILTER_COUNT){
			var rowObj = {
				data: {
					srno: refineFRowCnt+normalFrowCnt+1
				}
			};
			
            $("#refineFilterContainer").animate({ scrollTop: $(document).height() }, "slow");

			var baseObj = document.getElementById('baseObject').value;
			var refineRowTemp = app.utility.createTemplate('filterRefineRowTemplate');
            $("#scrollRefine").animate({ scrollTop: $(document).height() }, "slow");
			$('#refinefilterListContainer').append(refineRowTemp(rowObj));
			that.renderMetaDataFields(baseObj, refineFRowCnt, "refinefilterListContainer");
		}
		that.handleRefineAddDelete();
		if($('#refinefLogic').hasClass('fresh')){
			that.handleRefineFilterLogicVal();
		}
	},
	
	addRefineFilterRow: function(e){
		var that = e && e.data.context || this;
		var filterArr = [];
		// get count of existing rows
		var normalFrowCnt = $('#filterListContainer li').length;
		var refineFRowCnt = $('#refinefilterListContainer li').length;
		var addRow = false;
		var isError = false;
		if(refineFRowCnt < MP_CONSTANTS.ALLOWED_REFINE_FILTER_COUNT){
									
			if(refineFRowCnt > 0){
				$('#refinefilterListContainer li').each(function(){

				
							
					var fieldVal = $(this).find('.mdFields').find('option:selected').data('apiname');
					var fieldType = $(this).find('.mdFields').find('option:selected').data('dtype');
					
					if(!fieldVal || fieldVal === 'Select'){
						
						//Narayan Start 
						$('.mdFields').on('change', function() {
							if ( $(this).val() != 'Select')
							{
							    $('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).hide();
								//$('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).hide();
								addRow = true;
							}
						});
						//Narayan End 
					
						isError = true;
						$(this).find('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).show();
						addRow = false;
						return false;
						
					}else{
						addRow = true;
					}

					var operVal = $(this).find('.fieldOps').val();
					if(operVal === 'Select'){
					
						 $('.fieldOps').on('change', function() {
							if ( $(this).val() != 'Select')
							{
								$('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.BASE_OBJECT_REQUIRED).hide();
							}
						});
					
						isError = true;
						$(this).find('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).show();
						addRow = false;
						return false;
					} 
					
					
					var operVal = $(this).find('.fieldOps').val();
					
					if(operVal === 'Select'){
						
						//Narayan Start 
						$('.fieldOps').on('change', function() {
						  if ( $(this).val() != 'Select')
						  {
							
							$('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).hide();
							
							addRow = true;
						  }
						});
						//Narayan End 
						
						isError = true;
						$(this).find('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).show();
						addRow = false;
						return false;					
					}else{
						addRow = true;
					}
					

					var qVal = $(this).find('.queryVal').val();
					if(qVal === ''){
						isError = true;
						$(".form-control").keyup(function (e) {
							$(this).siblings('.error-text-msg').fadeOut();
							var qVal = $(this).find('.queryVal').val();
							if(qVal != ''){
								addRow = true;
							}							
						});	
						$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).show();
						addRow = false;
						return false;
					}else{
						addRow = true;
					}

					if(fieldType === 'DATETIME'){
						//Code by Rakesh - Added below REGEX to check Date in MM-DD-YYYY format
						var qValTmp =qVal.split("/");
						qVal=qValTmp[2]+'-'+qValTmp[0]+'-'+qValTmp[1] ;
						qVal = new Date(qVal).getTime();
						isError = isNaN(qVal) ? true : false;
						if(isError){
							$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.INVALID_DATE).show();
							addRow = false;
							return false;
						}else{
							$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.INVALID_DATE).hide();
							addRow = true;
						}
					}

					if(!isError){
						var fObj = {
							//fldName: fldName, fieldVal
							fldName: fieldVal,
							fldDataType: fieldType,
							operVal: operVal,
							color:null,
							ftype:"normal",
							//fldValue: qVal.toLowerCase()
							fldValue: qVal
						};
						var isObjExists = _.findWhere(filterArr, fObj);
						if(!isObjExists){
							filterArr.push(fObj);
						}else{
							isError = true;
							$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_QUERY_VALUE).show();
						}
					}
				});

				
			}else if(refineFRowCnt == 0){
				addRow = true;
			}
						
			if(addRow == true){
				var rowObj = {
					data: {
						srno: refineFRowCnt+normalFrowCnt+1
					}
				};
				
				$("#refineFilterContainer").animate({ scrollTop: $(document).height() }, "slow");

				var baseObj = document.getElementById('baseObject').value;
				var refineRowTemp = app.utility.createTemplate('filterRefineRowTemplate');
				$("#scrollRefine").animate({ scrollTop: $(document).height() }, "slow");
				$('#refinefilterListContainer').append(refineRowTemp(rowObj));
				that.renderMetaDataFields(baseObj, refineFRowCnt, "refinefilterListContainer");	
			}
		}
		that.handleRefineAddDelete();
		
		if($('#refinefLogic').hasClass('fresh')){
			that.handleRefineFilterLogicVal();
		}
	},

	handleAddDelete: function(){
		var rowCnt = $('#filterListContainer li').length;
		$('#deleteFilterRow').removeClass('disabledObj');
		$('#addFilter').removeClass('disabledObj');
		if(rowCnt === 0){
			$('#deleteFilterRow').addClass('disabledObj');
			$('#addFilter').addClass('disabledObj');
		} else if(rowCnt === 1){
			$('#deleteFilterRow').addClass('disabledObj');
			$('#addFilter').removeClass('disabledObj');
		} else if(rowCnt === MP_CONSTANTS.ALLOWED_FILTER_COUNT){
			$('#deleteFilterRow').removeClass('disabledObj');
			$('#addFilter').addClass('disabledObj');
		}
	},

	handleRefineAddDelete: function(){
		var rowCnt = $('#refinefilterListContainer li').length;
		$('#deleteRefineFilterRow').removeClass('disabledObj');
		$('#addRefineFilter').removeClass('disabledObj');
		$('#filterCollapse').find('input').eq(1).parent().show();
		if(rowCnt === 0){
			$('#deleteRefineFilterRow').addClass('disabledObj');
			$('#addRefineFilter').removeClass('disabledObj');
			$('#filterCollapse').find('input').eq(1).parent().hide();
		} else if(rowCnt === MP_CONSTANTS.ALLOWED_REFINE_FILTER_COUNT){
			$('#deleteRefineFilterRow').removeClass('disabledObj');
			$('#addRefineFilter').addClass('disabledObj');
		}
	},

	handleRefineFilterRowIndex: function(){
		var normalRowCnt = $('#filterListContainer li').length;
		var refineFilterRowCnt = $('#refinefilterListContainer li').length;
		if(refineFilterRowCnt > 0){
			$('#refinefilterListContainer li').each(function(index, liItem){
				$(liItem).find('.sr-no').text(index+1+normalRowCnt);
				$(liItem).find('.queryVal').attr('id','queryv'+(index+1+normalRowCnt));
			});
		}
	},

	handleFilterLogicVal: function(){
		var fLofic = $('#fLogic');
		var rowCnt = $('#filterListContainer li').length;
		var condition = isColoredFilter ? " or " : " and ";
		fLofic.val(_.range(1, rowCnt+1).join(condition));
		if(isColoredFilter){
			fLofic.attr('disabled', true);
		} else {
			fLofic.attr('disabled', false);
		}
	},

	handleRefineFilterLogicVal: function(){
		var rfLofic = $('#refinefLogic');
		var colFilterCnt = $('#filterListContainer li').length;
		var rowCnt = $('#refinefilterListContainer li').length;
		
		rfLofic.val(_.range(colFilterCnt+1, rowCnt+colFilterCnt+1).join(' and '));
		if(rowCnt === 0){
			rfLofic.val('');
		}
		if(isColoredFilter){
			rfLofic.show();
		} else {
			rfLofic.hide();
		}
	},

	handleFilterType: function(e){
		var that = e.data.context,
			fType = $(this).val();

		var prevVal = $(this).data('prevval');

		var changeTypeModal = $('#changeTypeConfirm');

		if(fType === "colored"){
			isColoredFilter = true;
		} else {
			isColoredFilter = false;
		}

		if($('#filterListContainer li').length > 0){

			changeTypeModal.modal({backdrop: "static", keyboard: false});
			

			$('#changeTypeNo').off('click').on('click', function(){
				$('#filterType').val(prevVal);
				changeTypeModal.modal('hide');
				
				isColoredFilter = !isColoredFilter;
			});

			$('#changeTypeYes').off('click').on('click', function(){
				$('#baseObject').trigger('change');
				changeTypeModal.modal('hide');
				
			});

		}
	},

	resetFilterRow: function(rowNum){
		
		if(rowNum){
			$('.mdFields').eq(rowNum).val($('.mdFields').eq(0).val()).trigger('change', ['doNotResetFilters']);
			$('.fieldOps').eq(rowNum).val($('.fieldOps').eq(0).val());
		}
	},

	handleOperatorChange: function(e){
		// method not valid
		// as operator restricted to 'Equals to'
		var that = e.data.context;
		if(isColoredFilter){
			that.resetFilterRow();
		}
		if($(this).val() !== "Select"){
			$(this).siblings('.error-text-msg').hide();
		}
	},

	saveFilter: function(e){
		var that = e.data.context,
			isError = false;
		$('.error-text-msg').hide();
		var isCustomFcLogic = true;

		var filterName = $('#queryName').val().trim();
        var nameLength = $("#queryName").val();
		var isFilterNameValid = that.validateFilterName();
		if(filterName === ''){
             //Narayan Start
               $("#queryName").keyup(function (e) {                   
                    $(this).siblings('.error-text-msg').fadeOut();
                });
             //Narayan End
			$('#queryName').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FILTER_NAME_REQUIRED).show();
			return;
		} else if(!isFilterNameValid){
			$('#queryName').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_FILTER_NAME).show();
			return;
        } else if (nameLength.length > 80){
            $('#queryName').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.MAX_LENGTH).show();
            return;
        }

		var baseObj = $('#baseObject').val();
		if(baseObj === 'Select'){ 
			$('#baseObject').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.BASE_OBJECT_REQUIRED).show();
            // Narayan Start
            $('#baseObject').on('change', function() {
              if ( this.value != 'Select')
              {
                $('#baseObject').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.BASE_OBJECT_REQUIRED).hide();
              }
            });
            //Narayan End
			return;
        }

		var filterCnt = $('#filterListContainer li').length;
		var refineFilterCnt = $('#refinefilterListContainer li').length;
		var filterArr = [];

		if(filterCnt !== 0){
		
			var selectedColors = [];
			$('#filterListContainer li').each(function(){
				
				var fieldVal = $(this).find('.mdFields').find('option:selected').data('apiname');
				var fieldType = $(this).find('.mdFields').find('option:selected').data('dtype');//$(this).find('.mdFields').val();
				if(!fieldVal || fieldVal === 'Select'){
					isError = true;
					$(this).find('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).show();
                    //Narayan Start 
                    $('.mdFields').on('change', function() {
                      if ( $(this).val() != 'Select')
                      {
                        $('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).hide();
                        $('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).hide();
                      }
                    });
                    //Narayan End 
				}
				var operVal = $(this).find('.fieldOps').val();
				if(operVal === 'Select'){
					isError = true;
					$(this).find('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).show();                   
				}

				var qVal = $(this).find('.queryVal').val();
				if(qVal === ''){
                    //Narayan Start
                    $(".form-control").keyup(function (e) {
                        $(this).siblings('.error-text-msg').fadeOut();
                    });
                    //Narayan End
                    
					isError = true;
					$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).show();

                    //Narayan Start
                    $( "#savePickList" ).click(function() {
                      $('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).hide(); 
                    });
                    //Narayan End
				}
                qVal = qVal.split(",").join("");
				if(isColoredFilter){                   
                    //Narayan Start
                    $(".queryVal").keyup(function (e) {
                        $(this).siblings('.error-text-msg').fadeOut();
                    });
					
					 $("#queryName").keyup(function (e) {                   
						$(this).siblings('.error-text-msg').fadeOut();
					});
                    //Narayan End                   
					var colorVal = $(this).find('.colorVal').data('colorval');//$(this).find('.colorVal').val();
					if(colorVal === ''){
						isError = true;
						$(this).find('.colorVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.COLOR_VALUE_REQUIRED).show();
					} else {
						if(selectedColors.indexOf(colorVal) > -1){
							isError = true;
							$(this).find('.colorVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_COLOR_VALUE).show();
                            $( "#saveColor" ).click(function() {
                              $('.colorVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_COLOR_VALUE).hide(); 
                            });
						} else {
							selectedColors.push(colorVal);
						}
					}
				}

				if(fieldType === 'DATE' || fieldType === 'DATETIME'){
					//Added below regEx to validate date with new format:MM-DD-YYYY
					var rgexpDt = /^((0?[1-9]|1[012])[/ /.](0?[1-9]|[12][0-9]|3[01])[/ /.](19|20)?[0-9]{2})*$/;                 
                    if(qVal.trim() === ""){
                        isError = true;    
                        $(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).show();
                    }else if(!rgexpDt.test(qVal)){ 
                        //console.log('2::'); 
                        isError = true;    
                        $(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.INVALID_DATE).show();
                    }  

					  $(".queryVal").keyup(function (e) {
                        $(this).siblings('.error-text-msg').fadeOut();
                    });
					
					var qValTmp =qVal.split("/");
					var tmpMnth= qValTmp[0];
					var tmpDt= qValTmp[1];
					if(tmpMnth.length == 1)
						tmpMnth='0'+tmpMnth;
					if(tmpDt.length == 1)
						tmpDt='0'+tmpDt;
					qVal=qValTmp[2]+'-'+tmpMnth+'-'+tmpDt ;
					//console.log('qVal::'+qVal);
				}

				if(!isError){
					//console.log('LOG1::');
					var fObj = {
						fldName: fieldVal,
						fldDataType: fieldType,
						operVal: operVal,
						
						fldValue: qVal,
						ftype:$('#filterType').val()
					};
					var isObjExists = _.findWhere(filterArr, fObj);
					if(!isObjExists){
						fObj.color = isColoredFilter ? colorVal : null;
						filterArr.push(fObj);
					} else {
						isError = true;
						$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_QUERY_VALUE).show();
					}
				}
			});
		} else {
			isError = true;
		}

		if(refineFilterCnt > 0){
			$('#refinefilterListContainer li').each(function(){

				var fldName = $(this).find('.mdFields').find('option:selected').data('apiname');
				var fieldType = $(this).find('.mdFields').find('option:selected').data('dtype');
				if(!fldName || fldName === 'Select'){
					isError = true;
					$(this).find('.mdFields').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.FIELD_REQUIRED).show();
				}

				var operVal = $(this).find('.fieldOps').val();
				if(operVal === 'Select'){
					isError = true;
					$(this).find('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.OPERATOR_REQUIRED).show();
                    
                   $('.fieldOps').on('change', function() {
                      if ( $(this).val() != 'Select')
                      {
                        $('.fieldOps').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.BASE_OBJECT_REQUIRED).hide();
                      }
                    });
				}

				var qVal = $(this).find('.queryVal').val();
				if(qVal === ''){
					isError = true;
					$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.QUERY_VALUE_REQUIRED).show();
				}

				if(fieldType === 'DATETIME'){
                    //Code by Rakesh - Added below REGEX to check Date in MM-DD-YYYY format
                    var qValTmp =qVal.split("/");
					qVal=qValTmp[2]+'-'+qValTmp[0]+'-'+qValTmp[1] ;
					qValDTm = new Date(qVal).getTime();
					isError = isNaN(qValDTm) ? true : false;
					if(isError){
						$(this).find('.q	ueryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.INVALID_DATE).show();
					}
					else{
						$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.INVALID_DATE).hide();
					}
					
				}

				if(!isError){
					var fObj = {
						fldName: fldName,
						fldDataType: fieldType,
						operVal: operVal,
						color:null,
						ftype:"normal",
						
						fldValue: qVal
					};
					var isObjExists = _.findWhere(filterArr, fObj);
					if(!isObjExists){
						filterArr.push(fObj);
					}else{
						isError = true;
						$(this).find('.queryVal').siblings('.error-text-msg').text(MP_CONSTANTS.ALERT_MESSAGES.DUPLICATE_QUERY_VALUE).show();
					}
				}
			});

			
		}

		if(!$('#fLogic').hasClass('fresh')){
			if(!that.isFlogicValid($('#fLogic').val(), 1, $('#filterListContainer li').length)){
				isError = true;
				app.utility.showAlertModal('Invalid Filter logic entered. It must contain all the rows indexes.');
			}
		} else {
			isCustomFcLogic = false;
		}

		if(isColoredFilter){
			if($('#refinefilterListContainer li').length){
				if($('#refinefLogic').hasClass('fresh')){
					isCustomFcLogic = false;
				} else {
					isCustomFcLogic = true;
					if(!that.isFlogicValid($('#refinefLogic').val(), $('#filterListContainer li').length+1 , $('#filterListContainer li').length + $('#refinefilterListContainer li').length)){
						isError = true;
						app.utility.showAlertModal('Invalid Refine Filter logic entered. It must contain all the refine rows indexes.');
					}
				}
			}
		}
if($('#addEditText').text() == "Clone Filter"){		// This for clone Filter 
             var filterObj = {
                fId: null,
                fName: filterName,
                fDesc: $('#filterDesc').val(),
                baseObj: $('#baseObject').val(),
                fLogic1: $('#fLogic').val(),
                fLogic2: isColoredFilter ? $('#refinefLogic').val() : null,
                isCustom: isCustomFcLogic,
                fType: $('#filterType').val(),
                filters: filterArr
            };
        }else{
		var filterObj = {
			fId: $('#saveFilter').data('editid'),
			fName: filterName,
			fDesc: $('#filterDesc').val(),
			baseObj: $('#baseObject').val(),
			fLogic1: $('#fLogic').val(),
			fLogic2: isColoredFilter ? $('#refinefLogic').val() : null,
			isCustom: isCustomFcLogic,
			fType: $('#filterType').val(),
			filters: filterArr
		};
}
			if(!isError){
			app.utility.showLoader();
             //pandit
             $('#addEditText').removeClass('active');  
            //add parseResult to encode HTML form the captured data        
			that.dataModelObj.saveFilter(JSON.stringify(app.utility.parseResult(JSON.stringify(filterObj)))).done(function(){
              	that.initialize();
				app.utility.hideLoader();
                
			}).fail(function(e){
				app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.REVIEW_FILTER_VALUES);
				app.utility.hideLoader();
			});
		}
	},

	editFilter: function(e){
		var that = e.data.context,
			fId = $(this).data('filterid');

		app.utility.showLoader();
		that.getEditFilterData(fId).done(function(fData){			
			$('#manageQuery').removeClass('show active');
			$('#editQuery').addClass('show active');
			$('#addEditText').text('Edit Filter').closest('li').addClass('active');
			$('#addEditText').addClass('active');
			//pandit$('#manageText').closest('li').removeClass('active');
			$('#manageText').removeClass('active');
			$('#fLogic, #refinefLogic').addClass('fresh');
			
			that.handleEditData(fData);
			app.utility.hideLoader();
		}).fail(function(){
			app.utility.hideLoader();
		});
	},

	handleEditData: function(data){
		//Code by Rakesh - Added below logic to format saved Date in MM-DD-YYYY format		
		if(data && data.filters){
			for (indx = 0; indx < data.filters.length; indx++) {
			  dataDet= data.filters[indx] ;
			  if(dataDet.fldDataType === 'DATE' || dataDet.fldDataType === 'DATETIME' ){
					var dtTmpVal =dataDet.fldValue.split("-");
					data.filters[indx].fldValue=dtTmpVal[1]+'/'+dtTmpVal[2]+'/'+dtTmpVal[0] ;				  
			  }
			}
		}
		//console.log('DATA1::'+JSON.stringify(data));
		
		$('#queryName').val(data.fName);
		$('#filterDesc').val(data.fDesc);
		$('#filterType').val(data.fType);
		$('#baseObject').val(data.baseObj);
		$('#fLogic').val(data.fLogic1);
		$('#refinefLogic').val(data.fLogic2 || '');
		$('#saveFilter').data('editid', data.fId);
		isColoredFilter = data.fType === 'colored' ? true : false;
		var that = this;
		var refineFContainerAdded = false;
		var filterContainerName = "";

		if(data.isCustom && data.fType === "normal"){
			$('#fLogic').removeClass('fresh');
		} else if(data.isCustom && data.fType === "colored"){
			$('#refinefLogic').removeClass('fresh');
		}

		if(data.fType === "normal"){
			$('#fLogic').attr('disabled',false);
		}

		var processFilter = function(i){

			if(isColoredFilter){
				if(data.fType === data.filters[i].ftype){
					that.addFilterRowCreatedFilter();
					filterContainerName = "filterListContainer";
				}else{
					that.addRefineFilterRowCreatedFilter();
					filterContainerName = "refinefilterListContainer";
					$('#refinefLogic').parent().show();
					$('#refinefLogic').val(data.fLogic2);
				}
			}else{
				that.addFilterRowCreatedFilter();
				filterContainerName = "filterListContainer";
			}

			setTimeout(function(){
				if(i === 0 || !isColoredFilter){
					$('#'+filterContainerName+' .mdFields').eq(i).val(data.filters[i].fldName).prop('disabled', false).trigger('change', ["doNotResetFilters"]);
				} else {
					if(filterContainerName === "refinefilterListContainer"){
						$('#'+filterContainerName+' .mdFields').eq($('#refinefilterListContainer li').length - 1).val(data.filters[i].fldName).trigger('change');
					}else{
						$('#'+filterContainerName+' .mdFields').eq(i).val(data.filters[i].fldName);
					}
				}
				if(filterContainerName === "refinefilterListContainer"){
					$('#'+filterContainerName+' .fieldOps').eq($('#refinefilterListContainer li').length - 1).val(data.filters[i].operVal);
					$('#'+filterContainerName+' .queryVal').eq($('#refinefilterListContainer li').length - 1).val(data.filters[i].fldValue);
				}else{
					$('#'+filterContainerName+' .fieldOps').eq(i).val(data.filters[i].operVal);
					$('#'+filterContainerName+' .queryVal').eq(i).val(data.filters[i].fldValue);
				}
				if(isColoredFilter){
					//$('.colorVal').eq(i).val(data.filters[i].color);
					$('.colorVal').eq(i).data('colorval', data.filters[i].color).css('color', data.filters[i].color);
				}
				i++;
				if(i === data.filters.length){
				} else {
					processFilter(i);
				}
			}, 100);
		};

		that.getObjMetadata(data.baseObj).done(function(){
			that.getFieldOperators().done(function(){
				if(isColoredFilter){
					that.renderRefineFilter({});
				}
				processFilter(0);
			});
		});
	},

	getEditFilterData: function(fId){
		var $deferred = new $.Deferred();

		this.dataModelObj.editFilter(fId).done(function(eData){
			$deferred.resolve(eData);
		}).fail(function(){
			$deferred.reject();
		});

		return $deferred.promise();
	},

	deleteFilter: function(e){
		var that = e.data.context,
			fId = $(this).data('filterid');
		var deleteFilterModal = $('#deleteFilterConfirm');
  		deleteFilterModal.modal({backdrop: "static", keyboard: false});	
        $('#deleteFilterYes').off('click').on('click', function(){
				that.dataModelObj.deleteFilter(fId).done(function(){
                    that.initialize();
                }).fail(function(){
                    app.utility.hideLoader();
                    app.utility.showAlertModal('Failed to delete filter');
                });
    			deleteFilterModal.modal('hide');
				app.utility.showLoader();
		});

		$('#deleteFilterNo').off('click').on('click', function(){
			deleteFilterModal.modal('hide');
		});
		
	},
    //By Rushikesh 
    cloneFilter: function(e){
      
var that = e.data.context,
			fId = $(this).data('filterid');

		app.utility.showLoader();
		that.getEditFilterData(fId).done(function(fData){			
			$('#manageQuery').removeClass('show active');
			$('#editQuery').addClass('show active');
            $('#addEditText').addClass('active'); //pandit
			$('#addEditText').text('Clone Filter').closest('li').addClass('show active');
			//pandit$('#manageText').closest('li').removeClass('show active');
			$('#manageText').removeClass('active');
            
			$('#fLogic, #refinefLogic').addClass('fresh');
			//$('#refinefLogic').val('').removeClass('fresh');
			//$('#refinefLogic').parent().hide();
			that.handleEditData(fData);
			app.utility.hideLoader();
            $('#queryName').val("");
		}).fail(function(){
			app.utility.hideLoader();
		}); 

    },
    
	
	resetFilterModal: function(){
		$('#manageQuery').addClass('show active');
		$('#editQuery').removeClass('show active');
		//$('#addEditText').text('Create Filter').closest('li').removeClass('show active');
        $('#addEditText').text('Create Filter').removeClass('show active');
		//pandit$('#manageText').closest('li').addClass('show active');
		$('#manageText').addClass('show active');
		$('#queryName, #filterDesc, #fLogic').val('');
		$('#baseObject').val('Select');
		$('#filterType').val('normal');//.trigger('change');
		$('#saveFilter').data('editid', null);
		$('#filterListContainer').empty();
		$('.error-text-msg').hide();
		$('#addFilter, #deleteFilterRow').addClass('disabledObj');
		$('#fLogic').addClass('fresh');
		$('#refinefLogic').val('');
		$('#refinefLogic').parent().hide();
		$('#refineFilterContainer').html('');
		isColoredFilter = false;
	},

	handleFilterPanelChange: function(e){
		var that = e.data.context;
		if(e.target.id === "manageText"){
			that.resetFilterModal();
		}
	},

	openSelectColorPopup: function(e){
		var that = e.data.context;
		var colorVal = $(this).data('colorval');
		if(colorVal){
			$('#popupColorVal').val(colorVal.replace(/#/g, '')).css('background-color', colorVal);
		} else {
			$('#popupColorVal').val("000").css('background-color', "#000");
		}
		$('#saveColor').data('savefor', $(this).attr('id'));
		$('#selectColorPopup').addClass('is-visible');
	},

	closeSelectColorPopup: function(e){
		var that = e.data.context;
		var pColVal = $('#popupColorVal').val(),
			saveFor = $(this).data('savefor'),
			colorCode = pColVal;

		$('#'+saveFor).data('colorval', colorCode).css('color', colorCode);
		$('#selectColorPopup').removeClass('is-visible');
	},

	getFilterLegend: function(fId){
		var $deferred = new $.Deferred();

		this.dataModelObj.getFilterLegend(fId).done(function(legends){
			$deferred.resolve(legends);
		}).fail(function(){
			app.utility.showAlertModal('Failed to get Legends');
			$deferred.resolve(false);
		});

		return $deferred.promise();
	},

	close: function () {
		app.utility.resetCustomObjectSlider();
		this.unbind(); // Unbind all local event bindings
		this.undelegateEvents();
		$(this).empty();
		this.$el.empty();
	},

	isFlogicValid: function (str, stratsFrom, endsTo){
	   if(!endsTo){
	      endsTo = stratsFrom;
	   }
	   var isValid = true;
	    for(var i=stratsFrom; i<=endsTo; i++){
	       if(str.match(i)){
	           continue;
	       }else{
	           isValid = false;
	           break;
	       }
	    }
	    return isValid;
	},
          
     //Map-plotter customization
    //Export function- By Kirtimala
    exportData:	function(e){
        $('#ExportFilterConfirm').modal('hide');
        var that =e.data.context;
        let dataModalObj = new app.dataModel();
    	
        let filterId = $('#reportList').children("option:selected").val();
        let objectName = $('#dpTableBody').children()[0].lastElementChild.lastElementChild.innerText;
        filterExportData =[];
        if(filterId && objectName){
        	that.getExportFilterData(that,filterId, objectName, null);
        }
  	},
    //This method used to get all exported filter data in chunks 
    getExportFilterData: function(that,filterId, objectName, filterOffsetID){
        app.utility.showLoader();
         that.dataModelObj.exportData(filterId,objectName,filterOffsetID, null).done(function(exportdata){
			    if(Object.keys(exportdata).length == 2000){
                 var lastKey = Object.keys(exportdata).sort().reverse()[0];
                   $.each( exportdata, function( key, value ) {
                       filterExportData.push(value);
                   });
                  that.getExportFilterData(that,filterId,objectName,lastKey);  
                }else{
                   $.each( exportdata, function( key, value ) {
                       filterExportData.push(value);
                   });
                 
                 app.utility.jsonConverter(filterExportData,true);   
                }    
                
           // that.downloadExport(exportdata);
		}).fail(function(){
            app.utility.hideLoader(); 
			app.utility.showAlertModal("Failed to export data."+" Please check whether you have fields in fieldset or if there any filtered data for selected object.");
           return null;
		});
      
    },
    //By Rushikesh 
    handleColorPickerChange: function(color){		//To Handel Chnages 
		inputtarget.value = '#' +color;
        inputtarget.style.backgroundColor = '#' +color;		   
	},
    handleColorPickerUpdate: function (){			//To Handel Updates
        colorpicker.set(this.value).enter();
        inputtarget.style.backgroundColor ='#' + this.value;
    }   
});