var client = require('./connection.js');
var inputfile = require("./projectDocumentJP.json");

var updateData = function(projectDocument,callback){
  for (var current in projectDocument){
    console.log(projectDocument[current].ProjectID);
    client.update({
        index: 'icrp',
      	id: projectDocument[current].ProjectID,
  	type: 'project_document',
  	body: {
          "doc" : {
             'project_content_jp': projectDocument[current].Content
          }
  	}
  },function(err,resp,status) {
  	console.log(resp);
  });
  }
}
updateData(inputfile,function(response){
  console.log("Bulk content prepared");
});

