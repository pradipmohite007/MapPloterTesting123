var dataObjects;
self.onmessage = function(e) {
    var receivedData = JSON.parse(e.data);
  	//console.log('Message received from main script', receivedData);  	
    processArray(receivedData.allKeys, receivedData.allObjects);
};

function processArray(keys, objects){
    var filteredData = [];
    for(var i=0, len=objects.length; i<len; i++){
        if(keys.indexOf(objects[i].Id) > -1){
            filteredData.push(objects[i]);
        }
    }
    var respData = {
        filtered: filteredData
    };
    self.postMessage(JSON.stringify(respData));
}