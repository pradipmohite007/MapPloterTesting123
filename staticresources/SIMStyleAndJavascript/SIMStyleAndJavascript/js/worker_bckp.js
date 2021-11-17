onmessage = function(e) {
  	console.log('Message received from main script', e.data);
  	var workerResult = 'Result: ';
  	var mdvd = e.data[0];
  	var dArr = e.data[1];
  	var dLength = dArr.length;
  	for (var i = 0; i < dLength; i++) {
  		mdvd.push(dArr[i]);
  	}
  	//console.log('Posting message back to main script');
  	postMessage(mdvd);
};