var client = require('./connection.js');

client.indices.getMapping({  
    index: 'icrp',
    type: 'project_document',
  },
function (error,response) {  
    if (error){
      console.log(error.message);
    }
    else {
      console.log("Mappings:\n",response.icrp.mappings.project_document.properties);
    }
});
