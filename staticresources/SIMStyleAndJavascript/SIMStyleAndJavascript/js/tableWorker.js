var dataObjects;
self.onmessage = function(e) {  	
  	//processArray(e.data);
    var receivedData = JSON.parse(e.data);
    //console.log('Message received from main script', receivedData);
    dataObjects = receivedData.dObjs;
    processArray(receivedData.mpdata, receivedData.cName);
};

function processArray(data, checkClass){
    var rowsArr = [];
    for(var i=0, len=data.length; i<len; i++){
        var entityName = data[i].Entity;
        var dObj;
        var recId = data[i].Id;

        if(data[i].Color && data[i].Color !== null){
            var row = [
                '<input type="checkbox" id="'+recId+'" class="css-checkbox '+checkClass+'" /><label for="'+recId+'" class="css-label">',
                '<span>'+data[i].Label+'</span>',
                '<i class="fa fa-map-marker customMarker" style="color: '+data[i].Color+'"></i><span class="hidden">'+data[i].Entity+'</span>'
            ];
        } else {
            for(var j=0,lenj=dataObjects.length; j<lenj; j++){
                if(dataObjects[j].Entity === entityName){
                    dObj = dataObjects[j];
                }
            }
    		if(dObj){ var dIndex = dObj.Pin_No };        
            var row = [
                '<input type="checkbox" id="'+recId+'" class="css-checkbox '+checkClass+'" /><label for="'+recId+'" class="css-label">',
                '<span>'+data[i].Label+'</span>',
                '<i class="marker marker-'+dIndex+'"></i><span class="hidden">'+data[i].Entity+'</span>'
            ];
        }
        rowsArr.push(row);
    }
    var respData = {
        rows: rowsArr
    };
    //self.postMessage({rows: rowsArr});
    self.postMessage(JSON.stringify(respData));
}    