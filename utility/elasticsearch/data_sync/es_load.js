var client = require('./connection.js');
var inputfile = require("./projectDocument.json");
var bulk = [];
var buffer = 0;

var makebulk = function(projectDocument,callback){
  for (var current in projectDocument){
        buffer ++;
   	if (buffer < 1000) {
    		bulk.push(
      			{ index: {_index: 'icrp', _type: 'project_document', _id: projectDocument[current].ProjectID } },
      			{
        			'project_id': projectDocument[current].ProjectID,
        			'project_content': projectDocument[current].Content,
        			'project_content_jp': ''
      			}
    		);
  	}else {
     		client.bulk({
    			maxRetries: 5,
    			index: 'icrp',
    			type: 'project_document',
    			body: bulk
  		},function(err,resp,status) {
      		if (err) {
        		console.log(err);
      		}		
      		else {
        		callback(resp.items);
      		}
  		})
		buffer = 0;
   		bulk = [];
                global.gc();
	}
  }
  callback(bulk);
}

makebulk(inputfile,function(response){
  console.log("Bulk content prepared");
});
