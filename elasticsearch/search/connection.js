var elasticsearch=require('elasticsearch');

var client = new elasticsearch.Client( {  
  hosts: [
    'http://localhost:9200/',
  ],
  requestTimeout: 600000
});

module.exports = client;  
