var client = require('./connection.js');

client.indices.putMapping({  
  index: 'icrp',
  type: 'project_document',
  body: {
    properties: {
      'project_id' : {
        'type' : "long"
      },
      'project_content': {
        'type': 'string', // type is a required attribute if index is specified
      },
      'project_content_jp': {
        'type': 'string', // type is a required attribute if index is specified
        'index': 'not_analyzed'
      },
    }
  }
},function(err,resp,status){
    if (err) {
      console.log(err);
    }
    else {
      console.log(resp);
    }
});
