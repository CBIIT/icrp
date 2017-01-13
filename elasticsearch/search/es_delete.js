var client = require('./connection.js');

client.indices.delete({index: 'icrp'},function(err,resp,status) {  
  console.log("delete",resp);
});
