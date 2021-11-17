var dataObjects;
self.onmessage = function(e) {
    var receivedData = JSON.parse(e.data);
  	//console.log('Message received from main script', receivedData);
  	//processArray(e.data);
    dataObjects = receivedData.dObjs;
    processArray(receivedData.mpdata);
};

function processArray(data){
    var markerList = '', destMarkerList = '';
    for(var i=0, len=data.length; i<len; i++){
        var entityName = data[i].Entity;
        var dObj;
        var markerId = data[i].Id;

        if(data[i].Color && data[i].Color !== null){

            var dRow = '<li id="dest'+markerId+'" class="list-group-item">'
            +'<i data-markerid="'+markerId+'" class="fa fa-map-marker desti customMarker" style="color:'+data[i].Color+'"></i>'
            +'<input type="checkbox" data-markerid="'+markerId+'" id="parentDestCheck'+markerId+'" class="css-checkbox destCheck" />'
            +'<label for="parentDestCheck'+markerId+'" class="css-label data-points destLable">'+data[i].Label+'</label>'
            +'</li>';

            var mRow = '<li id="panel'+markerId+'" class="list-group-item">'
            +'<i data-markerid="'+markerId+'" class="fa fa-map-marker paneli customMarker animateMarker" style="color:'+data[i].Color+'"></i>'
            +'<input type="checkbox" data-markerid="'+markerId+'" id="parentDataCheck'+markerId+'" class="css-checkbox panelfcheck" />'
            +'<label for="parentDataCheck'+markerId+'" class="css-label data-points destLable">'+data[i].Label+'</label>'
            +'</li>';

        } else {

            for(var j=0,lenj=dataObjects.length; j<lenj; j++){
                if(dataObjects[j].Entity === entityName){
                    dObj = dataObjects[j];
                }
            }

            if(dObj){ var dIndex = dObj.Pin_No };

            var dRow = '<li id="dest'+markerId+'" class="list-group-item">'
            +'<i data-markerid="'+markerId+'" class="desti marker marker-'+dIndex+'"></i>'
            +'<input type="checkbox" data-markerid="'+markerId+'" id="parentDestCheck'+markerId+'" class="css-checkbox destCheck" />'
            +'<label for="parentDestCheck'+markerId+'" class="css-label data-points destLable">'+data[i].Label+'</label>'
            +'</li>';

            var mRow = '<li id="panel'+markerId+'" class="list-group-item">'
            +'<i data-markerid="'+markerId+'" class="paneli marker marker-'+dIndex+' animateMarker"></i>'
            +'<input type="checkbox" data-markerid="'+markerId+'" id="parentDataCheck'+markerId+'" class="css-checkbox panelfcheck" />'
            +'<label for="parentDataCheck'+markerId+'" class="css-label data-points destLable">'+data[i].Label+'</label>'
            +'</li>';
        }        
        
        destMarkerList+= dRow;
        markerList+= mRow;
    }
    var respData = {
        dRow: destMarkerList,
        mRow: markerList
    };
    //self.postMessage({dRow:destMarkerList, mRow: markerList});
    self.postMessage(JSON.stringify(respData));
}    