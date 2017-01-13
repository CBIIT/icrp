var express = require('express')
var ICRP_Search = require('./icrp_search.js');
var app = express()

app.get('/get', function (req, res) {
  if ( req.query.search_method == 'get') {
  	res.send('Hello World!' + req.query.search_terms + ":" + req.query.search_method);
  }else {
     	var search_instance = new ICRP_Search(req.query.search_method,req.query.search_terms);
	search_instance.search(
		(err, trials) => {
         		if(err) {
               			return res.sendStatus(500);
         		}
         		return res.json(trials);
         	}
      	);
  }
})

app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
})
