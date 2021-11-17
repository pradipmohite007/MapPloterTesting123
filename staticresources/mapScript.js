/**
 * Map Model:
 * Cross Platform: True.
 * Initialization: Initializes on object creation.
 * Date:
 * Functionality: Contains all functions related to Google Map
 *
 */

'use strict';
var map;
var directionsDisplay;
var drawingManager;
var markers = [];
var markerCluster = null;
var shapesArray = [];
var mapBounds;
var infowindow;
var southWest;
var northEast;
var allowedBounds;
var lastValidCenter;
var lastValidZoom;
var app = app || {};
var markerSpiderfier;
function mapModel(){
    // constructor
}

// new path for images of MarkerClusterer
// google moved their code to github
MarkerClusterer.prototype.MARKER_CLUSTER_IMAGE_PATH_ =
    'https://raw.githubusercontent.com/googlemaps/js-marker-clusterer/gh-pages/' +
    'images/m';

mapModel.prototype.resetMapBounds = function(){
    var mBounds = map.getBounds();
    if(mBounds !== null){
        if ((allowedBounds.getNorthEast().lat() > (mBounds.getNorthEast().lat())) && (allowedBounds.getSouthWest().lat() < (mBounds.getSouthWest().lat()))) {
            lastValidCenter = map.getCenter();
            lastValidZoom = map.getZoom();
            return;
        }
    }
    // not valid anymore => return to last valid position
    map.panTo(lastValidCenter);
    map.setZoom(lastValidZoom);
};

mapModel.prototype.clearMarkers = function(){
    // disable all markers
    
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }
    markerSpiderfier.clearMarkers(); 
};


mapModel.prototype.initializeMapDetail = function(markersData){
    var that = this;
    
    var minZoomLevel = 3,
        maxZoomLevel = 15;    
    
    var myOptions = {
        zoom: 3,
        minZoom: minZoomLevel,
        center: new google.maps.LatLng(37.422104808, -122.0838851),
        mapTypeControl: false,
        mapTypeControlOptions: {
            style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
            position: google.maps.ControlPosition.BOTTOM_RIGHT
        }
    };
    $("#example-popover-2").popover({
        html : true, 
        content: function() {
            return $("#example-popover-2-content").html();
        },
        title: function() {
            return $("#example-popover-2-title").html();
        }
    });
    
    var handleColorPicker = function () {
        if (!jQuery().colorpicker) {
            return;
        }
        $('.colorpicker-default').colorpicker({
            format: 'hex'
        });
        $('.colorpicker-rgba').colorpicker();
    }
    function hideMe(){  //hide the review line 
        $('#review').hide();
        
    }
    function checkIsRated(){
        var isRated = '{!JSINHTMLENCODE(IsRated)}';
        if(isRated == 'true'){
            $('#review').hide();       
        }else{
            $('#review').show();
        } 
    }   
    
    map = new google.maps.Map(document.getElementById("map-plotter-map"), myOptions);
    infowindow = new google.maps.InfoWindow();
    // these variables are used for panning map out of bounds
    southWest = new google.maps.LatLng(-85.000, -122.591);
    northEast = new google.maps.LatLng(85.000, -122.333);
    allowedBounds = new google.maps.LatLngBounds(southWest, northEast);
    
    if(markersData && markersData.length > 0){
        this.plotUserLocation();
    }
    
    directionsDisplay = new google.maps.DirectionsRenderer();
    directionsDisplay.setMap(map);
    directionsDisplay.setPanel(document.getElementById('get-map-direction'));
    // initialize the drawing tools
    drawingManager = new google.maps.drawing.DrawingManager({
        
        drawingControl: false,
        drawingControlOptions: {
            position: google.maps.ControlPosition.RIGHT_TOP,
            drawingModes: [
                google.maps.drawing.OverlayType.CIRCLE,
                google.maps.drawing.OverlayType.POLYGON,
                google.maps.drawing.OverlayType.RECTANGLE
            ]
        },
        circleOptions: {
            fillColor: '#f00',
            fillOpacity: 0,
            strokeWeight: 2,
            strokeColor: '#f00',
            clickable: true,
            editable: false,
            zIndex: 1
        },
        polygonOptions: {
            fillColor: '#f00',
            fillOpacity: 0,
            strokeWeight: 2,
            strokeColor: '#f00',
            clickable: true,
            editable: true,
            zIndex: 1
        },
        rectangleOptions: {
            fillColor: '#f00',
            fillOpacity: 0,
            strokeWeight: 2,
            strokeColor: '#f00',
            clickable: true,
            editable: false,
            zIndex: 1
        }
    });
   drawingManager.setMap(map);
    
    google.maps.event.addListener(drawingManager, 'overlaycomplete', function(event) {
        drawingManager.setDrawingMode(null);
        $('#draw-circle').removeClass('circle-active');
        $('#draw-square').removeClass('square-active');
        $('#draw-poly').removeClass('poly-active');
        $('#dragger').addClass('dragger-active');
        if(markerCluster){
            markerCluster.clearMarkers();
            
        }
        if(shapesArray.length > 0){
            if(shapesArray[0].overlay){
                shapesArray[0].overlay.setMap(null);
            } else {
                try {
                    shapesArray[0].setMap(null);
                } catch (err){
                }
            }
            shapesArray = [];
        }
        shapesArray.push(event);
        if (event.type == google.maps.drawing.OverlayType.RECTANGLE || event.type == google.maps.drawing.OverlayType.CIRCLE) {
            var shapeCoOrdinates = event.overlay.getBounds();
        } else if (event.type == google.maps.drawing.OverlayType.POLYGON) {
            var shapeCoOrdinates = event.overlay,
                paths = shapeCoOrdinates.getPaths();
            
            paths.forEach(function(path, index){
                // add listeners for coordinate change event
                google.maps.event.addListener(path, 'insert_at', function(e){
                    // New point
                    that.handleMarkerRegion(google.maps.drawing.OverlayType.POLYGON, shapeCoOrdinates, markers);
                });
                
                google.maps.event.addListener(path, 'remove_at', function(e){
                    
                    that.handleMarkerRegion(google.maps.drawing.OverlayType.POLYGON, shapeCoOrdinates, markers);
                });
                
                google.maps.event.addListener(path, 'set_at', function(e){
                    // Point was moved
                    that.handleMarkerRegion(google.maps.drawing.OverlayType.POLYGON, shapeCoOrdinates, markers);
                });
            });
        }
        if(event.type == google.maps.drawing.OverlayType.CIRCLE){
            var radius = event.overlay.radius;
            var center = event.overlay.getCenter();
            that.handleMarkerRegion(event.type, shapeCoOrdinates, markers, radius, center);
        } else {
            that.handleMarkerRegion(event.type, shapeCoOrdinates, markers);
        }
    });
    
    
    google.maps.event.addListener(map, 'zoom_changed', function() {
        var mzoom = map.getZoom();
        if(mzoom == 13 && markerCluster && !directionsDisplay.map){
            
            markerCluster.clearMarkers();
            if(shapesArray.length == 0){
                for(var i=0; i<markers.length; i++){
                    markers[i].setMap(map);    
                }                
            }
        } else if(mzoom == 12 && markerCluster && !directionsDisplay.map){
           
            markerCluster.addMarkers(markers);
            if(shapesArray.length > 0){
                that.clearDrawing();
            }
        } else if(mzoom > 12 && markerCluster && !directionsDisplay.map) {
            if(markerCluster.getMarkers().length > 0){
                markerCluster.clearMarkers();
                if(shapesArray.length == 0){
                    for(var i=0; i<markers.length; i++){
                        markers[i].setMap(map)
                    }
                }	
            }
        };
    });
    
    google.maps.event.addListener(map, 'center_changed', function() {
        that.resetMapBounds();
    });
    
    google.maps.event.addListener(map, 'bounds_changed', function() {
        that.resetMapBounds();
    });
    
    google.maps.event.addListener(infowindow,'closeclick',function(){
        $('#drawAreaControl').show();
    });
    
    markerSpiderfier = new OverlappingMarkerSpiderfier(map,{ 
        markersWontMove: true,   
        markersWontHide: true,
        keepSpiderfied: true
    });
    //This function used to capture the error on map load and displayed them into pop instead of console.
    var originallog = window.console.error;                        
    var warninglog = window.console.warn;       
    window.console.warn = function(warnTxt){
        // Warnings for the map rendering
        if(warnTxt.match("Google Maps API warning:")){
            if(warnTxt.match("NoApiKeys")){                        
                app.utility.showAlertModal("Get started by entering your Google API key here:<br />Map Plotter Settings > Setup Geocoding API <br /><br />This key is required to plot all of your data on the map.", true);
            }        
            warninglog.apply(window.console, arguments);
        }
    }
    
    window.console.error = function(txt) {
        //  Errors for the map rendering
        if(txt.match("Google Maps API error:")){
            if(txt.match("ApiNotActivatedMapError")){
                app.utility.showAlertModal("Please enable Google Maps JavaScript API from Google API Console.");
            }
            else if(txt.match("UnauthorizedURLForClientIdMapError") || txt.match("InvalidKeyOrUnauthorizedURLMapError")){
                app.utility.showAlertModal("To whitelist your current page URL, please reach out to mapplotterpremium.support@extentia.com.");
                
            }
                else if(txt.match("OverQuotaMapError")){
                    app.utility.showAlertModal("The number of requests has exceeded the usage limits for the Google Maps JavaScript API. Your app's requests will work again at the next daily quota reset.");
                }
                    else if(txt.match("ExpiredKeyMapError")){
                        app.utility.showAlertModal("The API key is expired. You may need to generate a new API key in the Google API Console.");
                    }
                        else if(txt.match("RefererNotAllowedMapError")){
                            app.utility.showAlertModal("The current URL loading the Google Maps JavaScript API has not been added to the list of allowed referrers. Please check the referrer settings of your API key on the Google API Console.");
                        }
                            else{
                                app.utility.showAlertModal(txt);
                            }                   
        }        
        originallog.apply(window.console, arguments);
    }        
    
};

mapModel.prototype.addContentToMap = function(){
    if(map){
        // right side drawing controls and nearby controls
        map.controls[google.maps.ControlPosition.LEFT_TOP].push(document.getElementById('leftSideControl')); 
        map.controls[google.maps.ControlPosition.TOP_CENTER].push(document.getElementById('drawAreaControl'));
        
        // left side panel
        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(document.getElementById('drawAreaControl'));
        
        map.controls[google.maps.ControlPosition.BOTTOM_RIGHT].push(document.getElementsByClassName('addBtn')[0]);
    }else{
        mapModel.prototype.initializeMapDetail();
        mapModel.prototype.addContentToMap();
    }
    
};

mapModel.prototype.getDirections = function(selectedLocations, noOptimize) {
    var $deferred = new $.Deferred(),
        that = this,
        wpoints = null,
        optimizeWP = true;
    
    if(noOptimize && noOptimize === true) optimizeWP = false;
    
    directionsDisplay.setMap(map);
    
    // selectedLocations conatins all points - src, dest, waypoints
    // 0th element is source
    // last element is destination
    // remaining elements are waypoints
    var startObj = selectedLocations.splice(0,1)[0],
        start = startObj.address,
        destObj = selectedLocations.splice(selectedLocations.length-1,1)[0],
        dest = destObj.address;
    
    // check wather waypoints are present or not
    if(selectedLocations.length > 0){
        // waypoints are present
        wpoints = [];
        for (var i = 0; i < selectedLocations.length; i++) {
            var wptObj = {
                location: selectedLocations[i].address,
                stopover: true
            };
            wpoints.push(wptObj);
        }
    }
    
    var directionsService = new google.maps.DirectionsService();
    var request = {
        origin: start,
        destination: dest,
        waypoints: wpoints,
        optimizeWaypoints: optimizeWP,
        //travelMode: google.maps.TravelMode.DRIVING,
        travelMode: google.maps.TravelMode.DRIVING,
        drivingOptions: {
            departureTime: new Date(Date.now() + 1000),  // for the time 1 milliseconds from now.          
            trafficModel: 'optimistic'
        },
        provideRouteAlternatives: true
    };
    directionsService.route(request, function(response, status) {
        if (status === google.maps.DirectionsStatus.OK) {
            
            var summaryPanel = document.getElementById('get-map-direction');
            summaryPanel.innerHTML = '';
            directionsDisplay.setPanel(summaryPanel);
            directionsDisplay.setDirections(response);
            that.clearMarkers();
            if (markerCluster) {				
                markerCluster.clearMarkers();
            }
            $deferred.resolve(response);
        } else if(status === google.maps.DirectionsStatus.OVER_QUERY_LIMIT){
         } else {
            if(request.waypoints === null){
                directionsDisplay.setMap(null);
                $('#locationContainer').empty();
                $('#get-map-direction').empty();
                $('#locationContainer').html('<div class="noDirections"><p>Please select origin and destination points for directions.</p></div>');
                $('.exportPdf-wrapper, .add-destination-wrapper').hide();
                
                $('#addDestinationPanel').show().removeClass('slideOutDown animated').addClass('slideOutDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
                    $(this).removeClass('slideOutDown animated').hide();
                });
                app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.NO_DIRECTIONS);
                $('.panelfcheck:checked').each(function(ele, elemt){ $(elemt).prop('checked', false); }); //To uncheck the selected location for direction 
            }
            //app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.NO_DIRECTIONS);
            app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.NO_DIRECTIONS);
			$('.destCheck:checked').each(function(ele, elemt){ $(elemt).prop('checked', false); });
            $deferred.reject();
        }
    });
    
    return $deferred.promise();
};

mapModel.prototype.reverseGeocode = function(lat, lng, gApiKey){
    var $deferred = new $.Deferred();
    
    // Added check if google api key not passed then request for geocode withou key
    var url = "";
    if(gApiKey){
       	url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "%2C" + lng + "&sensor=true&key="+gApiKey;
    }else{
        url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "%2C" + lng + "&sensor=true";
    }  
    
    var settings = {
        "async": true,
        "crossDomain": true,
        "url": url,
        "method": "GET"
    };
    
    $.ajax(settings).done(function(response) {
        
        if (response.results.length > 0) {
            var result = response.results[0],
                addressCompo = result.address_components,
                addressObject = {},
                stateName,
                countryName;
            
            for (var i = 0; i < addressCompo.length; i++) {
                var addrCompo = addressCompo[i],
                    type = addrCompo.types[0]
                if (type === "country") {
                    countryName = addrCompo;
                }
                if (type === "administrative_area_level_1") {
                    stateName = addrCompo;
                }
            }
            
            if (stateName && stateName.long_name) {
                addressObject.state = stateName.long_name;
            }
            if (countryName && countryName.long_name) {
                addressObject.country = countryName.long_name;
            }
            if(result && result.formatted_address){
                addressObject.address = result.formatted_address;
            }
            $deferred.resolve(addressObject);
        } else {
            $deferred.reject(response);
        }
    }).fail(function() {
        $deferred.reject();
    });
    
    return $deferred.promise();
};

mapModel.prototype.isMarkerInRegion = function(shapeType, selectedArea, markerObj, cRadius, cCenter) {
    if (shapeType == google.maps.drawing.OverlayType.RECTANGLE) {
        if (selectedArea.contains(new google.maps.LatLng(markerObj.getPosition().lat(), markerObj.getPosition().lng()))) {
            markerObj.setMap(map);
        } else {
           
        }
    } else if (shapeType == google.maps.drawing.OverlayType.POLYGON) {
        var latlng = new google.maps.LatLng(markerObj.getPosition().lat(), markerObj.getPosition().lng());
        if (google.maps.geometry.poly.containsLocation(latlng, selectedArea)) {
            markerObj.setMap(map);
        } else {
            
        }
    } else if(shapeType == google.maps.drawing.OverlayType.CIRCLE && cRadius && cCenter){
        var markerPos = new google.maps.LatLng(markerObj.getPosition().lat(), markerObj.getPosition().lng());
        var circlePos = new google.maps.LatLng(cCenter.lat(), cCenter.lng());
        
        // now calculate distance between two points
        // 1. circle center and 2. marker pos
        // if the distance is greater that circle radius --> marker is outside circle
        // else marker is inside circle
        var distance = google.maps.geometry.spherical.computeDistanceBetween(circlePos, markerPos);
        if(distance && distance <= Number(cRadius)){
            markerObj.setMap(map);
        } else if(distance === 0){
            markerObj.setMap(map);
        }
    }
};

mapModel.prototype.handleMarkerRegion = function(shape, bounds, markers, cicleRadius, circleCenter){	
    $('#destMarkerList ul').empty();
    $('#markerList ul').empty();	
    var that = this;
    var handler = function(markerObj){
        markerObj.setMap(null);
        that.isMarkerInRegion(shape, bounds, markerObj, cicleRadius, circleCenter);
    };
    var callBack = function(){
        $('#leftSideControl .list-group-item').removeClass('hidden');
        var activeMarkers = _.filter(markers, function(m){
            if (m.map) return m;
        });
        app.utility.updateselectedrecords(activeMarkers);
        var totalCnt = activeMarkers.length;
        app.currentViewObj.addRowsToList(_.pluck(activeMarkers, 'dataobj'), 0, activeMarkers.length);
        
		setTimeout(function(){
            $('#markerList, #destMarkerList').unbind('scroll');
            $('#tCnt').text(totalCnt);
            if(markerCluster){
            	markerCluster.addMarkers(activeMarkers);
            }
		}, 1000);
    };
    
    app.utility.processArray(markers, handler, callBack, that);
};

mapModel.prototype.handleDrawigTools = function(){
    // detect the tool clicked
    // set the selected tool as drawing mode to drawing manager
    var selectedTool = $(this).data('tool');
    $('#dragger').removeClass('dragger-active');
    $('#draw-circle').removeClass('circle-active');
    $('#draw-poly').removeClass('poly-active');
    $('#draw-square').removeClass('square-active');
    
    switch(selectedTool){
        case 'circle':
            drawingManager.setDrawingMode(google.maps.drawing.OverlayType.CIRCLE);
            $('#draw-circle').addClass('circle-active');
            break;
        case 'polygon':
            drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYGON);
            $('#draw-poly').addClass('poly-active');
            break;
        case 'square':
            drawingManager.setDrawingMode(google.maps.drawing.OverlayType.RECTANGLE);
            $('#draw-square').addClass('square-active');
            break;
        default:
            drawingManager.setDrawingMode(null);
            $('#dragger').addClass('dragger-active');
    }
};

mapModel.prototype.clearDrawing = function(e){
    var that = this;
    
    var handler = function(mObj){
        mObj.setMap(map);
        if(markerCluster){
            markerCluster.addMarker(mObj);
        }
    };
    
    var callback = function(){
        $('#leftSideControl .list-group-item').removeClass('hidden');
        var totalCnt = app.panelfData.length;//markers.length;
        if(totalCnt){
            $('#tCnt').text(totalCnt);
        }
        if(directionsDisplay) directionsDisplay.setMap(null);
        $('#locationContainer').empty();
        $('#get-map-direction').empty();
        $('#locationContainer').html('<div class="noDirections"><p>Please select origin and destination points for directions.</p></div>');
        $('.exportPdf-wrapper, .add-destination-wrapper').hide();
        
        $('#addDestinationPanel').show().removeClass('slideOutDown animated').addClass('slideOutDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
            $(this).removeClass('slideOutDown animated').hide();
        });
        $('label[for="selectAllPanelF"]').removeClass('disabledObj');
        $('#markerList ul').empty();
        $('#destMarkerList ul').empty();
        app.currentViewObj.addRowsToList(app.panelfData.slice(0, 200));
        setTimeout(function(){
            $('#markerList, #destMarkerList').unbind('scroll').bind('scroll', {'context': app.currentViewObj}, app.currentViewObj.handleDataScroll);
            $('#markerList').data('dcnt', 200);
        }, 1000);
    };
    
    if(markerCluster){
        markerCluster.clearMarkers();
        markerCluster.removeMarker(markers);
        markerCluster = null;
    }
    if(app.isClustering){
        markerCluster = new MarkerClusterer(map, [], {
            maxZoom: 12
        });
    }
    if(shapesArray[0]){
        if(shapesArray[0].overlay){
            shapesArray[0].overlay.setMap(null);
        } else {
            try {
                shapesArray[0].setMap(null);
            } catch (err){
           }		
        }
    }
    
    shapesArray = [];
    drawingManager.setDrawingMode(null);
    
    app.utility.processArray(markers, handler, callback, that);
};

mapModel.prototype.attachMarkerEvent = function(marker){
    
    
    var mainScope = this;
    var loader = document.getElementById('loader-overlay');
    
    google.maps.event.addListener(marker, 'click', function(evt) {
        
        loader.style.display = 'block';
        var that = this,
            lat = evt.latLng.lat(),
            lng = evt.latLng.lng(),
            mapZoom = map.getZoom();
        
        mainScope.handleMarkerClick(lat, lng, marker.id, marker.dataobj).done(function(infoWindowContent){
            var recordId =marker.dataobj.RecordID;
            //Removed Zoom functionality 8-3-21//
            /*var objName = marker.dataobj.Entity;
             if(mapZoom < 13){
                map.setZoom(15);
            }*/
            map.setCenter(marker.position);
            infowindow.setContent(infoWindowContent);
           
            infowindow.open(map, marker);
            
            var isMobileOS = app.utility.getMobileOperatingSystem();
            if(isMobileOS){
                map.setZoom(map.getZoom()-4);
                $('#drawAreaControl').hide();
            }else{
                $('#drawAreaControl').show();
            }
            
            $('#'+marker.id+' .tab-header span').off('click');
            setTimeout(function(){
            $('#'+marker.id+' .tab-header span').click(function(){
                $('#'+marker.id+' .tab-header span').removeClass('selected');
                $(this).addClass('selected');
                //Open panels according to tab selection
                //Opening panels while tabbed
                var panelId = $(this).data('section');
                $('#'+marker.id+' .tabbedPanel').hide();
                var isFetched = $(this).data('fetch');
                if(panelId == 'section-3' && !isFetched){
                    // get food and stay data
                    mainScope.getFoodStay(lat, lng, marker.id);
                } else if(panelId == 'section-2' && !isFetched){
                    // get weather data
                    mainScope.getWeather(lat, lng, marker.id);
                } else if(panelId == 'section-4' && !isFetched){
                    //get extra deatils
                    //mainScope.getSearchResult(lat, lng, marker.id);
                    mainScope.getCustomDetails(recordId, objName, marker.id);
                }
                $('#'+marker.id+' #'+panelId).show();
            });
           },500);
            setTimeout(function(){ 
                $('#view'+marker.id).off('click');
                $('#view'+marker.id).click(function(){
                    mainScope.getNearByPoints(marker.id, lat, lng, infowindow);
                    
                    $('#drawAreaControl').show();
                    $("#drawToggle").show();
                });
            },0);
            
            $('.accLink').off('click');
            $('.accLink').click(function(e){            	
                e.preventDefault();
                var href = e.currentTarget.dataset.id;
                if( (typeof sforce != 'undefined') && sforce && (!!sforce.one) ) {
                    // Salesforce1 navigation
                    sforce.one.navigateToSObject(href);
                } else {
                    window.open("/"+href);
                }
            });            
            loader.style.display = 'none';
            
            if (marker.getAnimation() != null) {
                marker.setAnimation(null);
            }
        });
    });
};

mapModel.prototype.animateMarker = function(markerid){
    var selectedMarker = _.findWhere(markers, {
        'id': markerid
    });
    
    if(selectedMarker){
        if (selectedMarker.getAnimation() != null) {
            selectedMarker.setAnimation(null);		    
        } else {
            if(selectedMarker.map == null) selectedMarker.setMap(map);
            selectedMarker.setAnimation(google.maps.Animation.BOUNCE);
            //map.getZoom() <= 13 ? map.setZoom(14) : null; 
            map.setCenter(selectedMarker.position);
            setTimeout(function(){
                selectedMarker.setAnimation(null);
            },5000);
        }
    }	
  
};

mapModel.prototype.plotUserLocation = function(){
    var that = this;
    
    if(navigator.geolocation){
        navigator.geolocation.getCurrentPosition(function(position){
            var lat = position.coords.latitude,
                lng = position.coords.longitude;
            var currentLoc = new google.maps.LatLng(lat, lng);
           var currentLocMarker = new google.maps.Marker({
                map: map,
                position: currentLoc,
                icon: pinURL+ "/SIMStyleAndJavascript/images/markers/current_loc_marker.png"
            });
            currentLocMarker.id = 'currentUser';
            currentLocMarker.data = {
                Latitude: lat,
                Longitude: lng
            };
            
            google.maps.event.addListener(currentLocMarker, 'click', function(e){
                var iThis = this;
                that.handleMarkerClick(lat, lng, currentLocMarker.id, currentLocMarker.data).done(function(infoWindowContent){
                    infowindow.setContent(infoWindowContent);
                    infowindow.open(map, iThis);
                    map.setCenter(currentLocMarker.position);
                    
                    var isMobileOS = app.utility.getMobileOperatingSystem();
                    if(isMobileOS){
                        $('#drawAreaControl').hide();
                    }else{
                        $('#drawAreaControl').show();
                    }
                    
                    $('#'+currentLocMarker.id+' .tab-header span').off('click');
                    $('#'+currentLocMarker.id+' .tab-header span').click(function(){
                        $('#'+currentLocMarker.id+' .tab-header span').removeClass('selected');
                        $(this).addClass('selected');
                        var panelId = $(this).data('section');
                        $('#'+currentLocMarker.id+' .tabbedPanel').hide();
                        var isFetched = $(this).data('fetch');
                        if(panelId == 'section-3' && !isFetched){
                            that.getFoodStay(lat, lng, currentLocMarker.id);
                        } else if(panelId == 'section-2' && !isFetched){
                            that.getWeather(lat, lng, currentLocMarker.id);
                        } else if(panelId == 'section-4' && !isFetched){
                            // get extra deatils
                            that.getCustomDetails(recordId, objName, currentLocMarker.id);
                        }
                        $('#'+currentLocMarker.id+' #'+panelId).show();
                    });
                    
                    $('#viewcurrentUser').off('click');
                    $('#viewcurrentUser').click(function(){
                        that.getNearByPoints(currentLocMarker.id, lat, lng, infowindow);
                    });
                    app.utility.hideLoader();
                });
            });
        }, function(e){
            var isLocBlocked = sessionStorage.getItem('islocationblocked');
            if(!isLocBlocked){
                sessionStorage.setItem('islocationblocked', 'true');
                app.utility.showAlertModal(MP_CONSTANTS.ALERT_MESSAGES.ALLOW_LOCATION);
            }
        });
    } else {
        app.utility.showAlertModal(MP_CONSTANTS.ERROR_MESSAGES.GEOLOCATION_NOT_SUPPORTED);
    }
};

mapModel.prototype.handleMarkerClick = function(lat, lng, id, markerData){
    var $deferred = new $.Deferred();	
    var data = {
        "id":id,
        "data": markerData,
    };
    
    var infowindowTemplate = app.utility.createTemplate('infoWindowTemplate');
    $deferred.resolve(infowindowTemplate(data));
    
    return $deferred.promise();
};

mapModel.prototype.getWeather = function(lat, lng, divId){
   var weatherAPIKey;
    Visualforce.remoting.Manager.invokeAction(MP_REMOTING.GET_API_KEYS,
                                              function(result, event){
                                                  if (event.status) {
                                                      
            result = app.utility.parseResult(result);
            weatherAPIKey = result.WeatherAPIKey;
            if(weatherAPIKey && weatherAPIKey !== ""){
                var settings = {
                    "async": true,
                    "crossDomain": true,
                    "dataType": "jsonp",
                    "headers": "{ 'Access-Control-Allow-Origin': 'true' }",
                    "url": "https://api.darksky.net/forecast/" + weatherAPIKey + "/" + lat + "," +lng,
                    "method": "GET"
                };
                
                $.ajax(settings).done(function (response) {
                   var data = {
                        "weatherdata": response,
                    };
                    var weatherTemplate = app.utility.createTemplate('weatherTemplate');
                    
                    $('#'+divId+' #section-2').html(weatherTemplate(data));
                    //To hide weather tab 
                    //$('#'+divId+' span[data-section="section-2"]').data('fetch', 'true');
                    
                    var skycons = new Skycons({"color": "#737373"});
                    var iconElms = $('.wIcon');
                    for(var i=0; i<iconElms.length; i++){
                        var id = $(iconElms[i]).data('cid');
                        var icon = $(iconElms[i]).data('icon');
                        skycons.add(id, icon);
                    }
                    skycons.play();
                    
                    var swiper = new Swiper('.swiper-container', {
                        nextButton: '.swiper-button-next',
                        prevButton: '.swiper-button-prev',
                        slidesPerView: 3
                    });
                    
                }).fail(function(){
                    $('#'+divId+' #section-2').html('<p>Failed to get Weather Data.</p>');
                });
            } else {
                $('#'+divId+' #section-2').html('<p>Weather API key not Available.</p>');
            }
        } else {
            $('#'+divId+' #section-2').html('<p>Failed to get Weather API key.</p>');
        }
        }, {
            escape: false
        });
};

mapModel.prototype.getFoodStay = function(lat, lng, divId){
    
    var placeTypes = ["restaurant", "bar", "cafe", "lodging", "food"];
    var places = [];
     function placeService(i){
        var request = {
            location: new google.maps.LatLng(lat,lng),
            radius: 5000,
            type: placeTypes[i]
        };
        
        var foodStayService = new google.maps.places.PlacesService(map);
        foodStayService.nearbySearch(request, function(data ,status){
           if(status === "OK"){
                for (var j = data.length - 1; j >= 0; j--) {
                    places.push(data[j]);
                }
            }
            i++;
            if(i === placeTypes.length){
               if(places.length > 0){
                    // get unique places
                    var uniquePlaces = _.uniq(places, function(place){
                        return place.place_id
                    });
                   var objData = {
                        "data": _.sortBy(uniquePlaces, 'name')
                    };
                    var fsTemplate = app.utility.createTemplate('foodStayTemplate');
                    $('#'+divId+' #section-3').html(fsTemplate(objData));
                    $('#'+divId+' span[data-section="section-3"]').data('fetch', 'true');
                } else {
                    $('#'+divId+' #section-3').html("No Data Available.");
                }
            } else {
                placeService(i);
            }
        });
    }
    
    placeService(0);
};

//POI functionality
mapModel.prototype.getSearchResult = function(lat, lng, divId){
    
    
    function getSearchData(){       
        var input = document.getElementById('resultSearch');
        var searchBox = new google.maps.places.SearchBox(input);
        
        // Bias the SearchBox results towards current map's viewport.
        map.addListener('bounds_changed', function() {
            searchBox.setBounds(map.getBounds());
        });
        document.getElementById('userSearchResultCont').style.display= "block"
        var markers = [];
        
        searchBox.addListener('places_changed', function() {
            var places = searchBox.getPlaces();
             if (places.length == 0) {
                return;
            }
            var objData = {
                "data": _.sortBy(places, 'name')
            };
            var fsTemplate = app.utility.createTemplate('foodStayTemplate');
            $('#'+divId+' #section-4 #userSearchResultCont').html(fsTemplate(objData));
            $('#'+divId+' span[data-section="section-4"]').data('fetch', 'true');
            // For each place, get the icon, name and location.
            var bounds = new google.maps.LatLngBounds();
        });
    }                          
    getSearchData(); 
};


mapModel.prototype.getCurrentAddress = function(gApiKey){
    var $deferred = new $.Deferred(),
        that = this,
        lat, lng;
    
    if(navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position){ // success callback
                  lat = position.coords.latitude;
            lng = position.coords.longitude;
            that.reverseGeocode(lat, lng, gApiKey).done(function(addrObj){
                $deferred.resolve(addrObj);
            }).fail(function(err){
                $deferred.reject(err);
            });
        }, function(e){ // error callback
           isLocationAllowed = false;
            $deferred.reject();
        });
    }
    
    return $deferred.promise();
};

mapModel.prototype.getNearByPoints = function(mId, lat, lng, ifObj){
    var radius = $('#radius'+mId).val();
    var unit = $('#unit'+mId).val();
    var multiplier = 1;
    var maxVal = 5000000; // max value for radius in meters
    
    if(unit == "km"){
        multiplier = 1000;
    } else if(unit == "mi"){
        multiplier = 1609.34;
    }
    
    $('#radius'+mId).keyup(function(){
        $('#radError'+mId).text('').hide();
    });
    
    var that = this;
    
    if(radius && radius !== "" && !isNaN(radius) && radius > 0){
        
        var radiusVal = Number(radius)*multiplier;
        // set max value to 5000km = 3106.856Mile
        if(radiusVal > maxVal){
            radiusVal = maxVal;
        }
        var markerLoc = new google.maps.LatLng(lat, lng);
        var circle = new google.maps.Circle({
            center: markerLoc,
            map: map,
            radius: radiusVal,
            fillColor: '#f00',
            fillOpacity: 0,
            strokeWeight: 2,
            strokeColor: '#f00'
        });
        if(markerCluster){
            markerCluster.clearMarkers();
            markerCluster = null;
        }
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
        shapesArray.push(circle);
        map.setCenter(markerLoc);
        var circleBounds = circle.getBounds();
        that.handleMarkerRegion(google.maps.drawing.OverlayType.CIRCLE, circleBounds, markers, radiusVal, markerLoc);
        map.fitBounds(circleBounds);
        if(ifObj){
            ifObj.close();
        }
        $('#radError'+mId).text('').hide();
    } else {
        
        $('#radError'+mId).text(MP_CONSTANTS.ALERT_MESSAGES.RADIUS_NOT_VALID).show();
    }
};

mapModel.prototype.processDataArray = function(data, firstCall){
     var that = this;
    if(firstCall){
        this.clearMarkers();
        if(markerCluster !== null){
            markerCluster.clearMarkers();
            markerCluster.removeMarker(markers);
            markerCluster = null;
        }
        
        markers = [];
        
        mapBounds = new google.maps.LatLngBounds();
        
        if(app.isClustering){
            markerCluster = new MarkerClusterer(map, markers, {
                maxZoom: 12
            });
            
        }
    }
    
    if(directionsDisplay){
        directionsDisplay.setMap(null);
    }
    
    if(shapesArray.length > 0){
        if(shapesArray[0].overlay){
            shapesArray[0].overlay.setMap(null);
        } else {
            try {
                shapesArray[0].setMap(null);
            } catch (err){
            }
        }
        shapesArray = [];
        if(app.isClustering){
            markerCluster = new MarkerClusterer(map, markers, {
                maxZoom: 12
            });
        }
        $('#destMarkerList ul').empty();
        $('#markerList ul').empty();
        app.currentViewObj.addRowsToList(app.panelfData.slice(0, 200));
    }
    
    app.utility.processArray(data, that.processMarker, that.processMarkerDone, that);
};

mapModel.prototype.processMarker = function(markerObj){
    var that = this;
    if(markerObj.Latitude && markerObj.Longitude){
        
        if(markerObj.Color && markerObj.Color !== null){
            var marker = new google.maps.Marker({
                map: map,
                
                position: new google.maps.LatLng(markerObj.Latitude, markerObj.Longitude), 
                icon: {
                    
                    path: "M 256,480c-84.828,0-153.6-68.157-153.6-152.228c0-84.081, 153.6-359.782, 153.6-359.782s 153.6,275.702, 153.6,359.782C 409.6,411.843, 340.828,480, 256,480z M 255.498,282.245c-26.184,0-47.401,21.043-47.401,46.981c0,25.958, 21.217,46.991, 47.401,46.991c 26.204,0, 47.421-21.033, 47.421-46.991 C 302.92,303.288, 281.702,282.245, 255.498,282.245z",
                    
                    scale: .07,
                    rotation: 180,
                    strokeWeight: 0.2,
                    strokeColor: 'black',
                    strokeOpacity: 1,
                    anchor: new google.maps.Point(255.498,-26.204),
                    fillColor: markerObj.Color,
                    fillOpacity: 0.85,		            
                }
            });
        } else {
            var customObj = _.findWhere(dataObjects, {"Entity": markerObj.Entity});
            var markerIconIndex;
            if(customObj){
                markerIconIndex = customObj.Pin_No;
            } else {
                markerIconIndex = '';
            }
            var marker = new google.maps.Marker({
                map: map,
               
                position: new google.maps.LatLng(markerObj.Latitude, markerObj.Longitude),
                icon: pinURL+ "/SIMStyleAndJavascript/images/markers/" + markerIconIndex + ".png"
            });
        }
        markers.push(marker);
        marker.set('id', markerObj.Id);
        marker.set('dataobj',markerObj);
        that.attachMarkerEvent(marker);
        markerSpiderfier.addMarker(marker);
        mapBounds.extend(marker.position);		
        if(markerCluster !== null){
            markerCluster.addMarker(marker);           
        }else {
        }
    }
};

mapModel.prototype.processMarkerDone = function(markerObj){
    $('#showMore').removeClass('disabledObj');
    map.fitBounds(mapBounds);
};

//Info-window details -Kirtimala
//This method used to get the details of record field details
mapModel.prototype.getCustomDetails = function(recordId, objName, divId){
    var $deferred = new $.Deferred();
        Visualforce.remoting.Manager.invokeAction(MP_REMOTING.CUSTOM_DETAILS, recordId, objName, function(result, event) {
                if(result){
                    var response = app.utility.parseResult(JSON.stringify(result));
                    $deferred.resolve(response);
                    var data = {
                        "data":response,
                    };
                    if(data){
                        var infoTemplate = app.utility.createTemplate('customDetailsTemplate');
                        console.log("infoTemplate "+infoTemplate);
                        $('#'+divId+' #section-4').html(infoTemplate(data));
                        $('#'+divId+' span[data-section="section-4"]').data('fetch', 'true');
                    } else {
	                       $('#'+divId+' #section-4').html("No Data Available.").css("font-weight","bold");
                    }
                } else {
                    $deferred.reject(event);
                    $('#'+divId+' #section-4').html("No Data Available.").css("font-weight","bold");
                }
            }, {
                escape:false
            }
        );
     return $deferred.promise();
};
    
