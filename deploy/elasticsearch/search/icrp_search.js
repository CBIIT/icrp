var client = require('./connection.js');

class ICRP_Search {

    constructor (search_method, search_terms) {
  	this.search_method = search_method;
  	this.search_terms = search_terms;
    }

/****************************************
 * 
 * This function will perform full text search based 
 * on the terms and search method provided by the user.
 *
 * **************************************/
    search(callback) {
        var search_all_query = '{\
                "index": "icrp",\
                "type": "project_document",\
                "scroll": "10s",\
                "size": 5000,\
                "body": {\
                        "_source": ["project_id"],\
                        "query": {\
                                "match" : {\
                                        "project_content" : {\
                                                "query" :"' + this.search_terms + '",\
                                                "operator" : "and"\
                                        }\
                                }\
                        }\
                }\
        }';
        var search_none_query = '{\
                "index": "icrp",\
                "type": "project_document",\
                "scroll": "10s",\
                "size": 5000,\
                "body": {\
                        "_source": ["project_id"],\
                        "query": {\
                                "bool" : {\
                                        "must_not" : {\
                                                "match" : {\
                                                        "project_content" : "' + this.search_terms + '"\
                                        	}\
                                        }\
                                }\
                        }\
                }\
        }';
        var search_any_query = '{\
                "index": "icrp",\
                "type": "project_document",\
                "scroll": "10s",\
                "size": 5000,\
                "body": {\
                        "_source": ["project_id"],\
                        "query": {\
                                "match" : {\
                                        "project_content" : "' + this.search_terms + '"\
                                }\
                        }\
                }\
        }';
        var search_exact_query = '\
	{\
                "index": "icrp",\
                "type": "project_document",\
                "scroll": "10s",\
                "size": 5000,\
                "body": {\
                        "_source": ["project_id"],\
                        "query": {\
                                "match_phrase" : {\
                                        "project_content" : "' + this.search_terms + '"\
                                }\
                        }\
                }\
        }';
 	var search_json;
        if (this.search_method == "all") {
         	search_json = JSON.parse(search_all_query);
	}
        if (this.search_method == "none") {
         	search_json = JSON.parse(search_none_query);
	}
        if (this.search_method == "any") {
         	search_json = JSON.parse(search_any_query);
	}
        if (this.search_method == "exact") {
         	search_json = JSON.parse(search_exact_query);
	}
  	var currentSize = 0;
  	var ids = "";
  	client.search(search_json,function postProcess(err, res) {
      		if (err) {
        		return callback(err);
      		}
      		res.hits.hits.forEach(function (hit) {
        		currentSize ++;
        		if (ids != "") ids += ",";
        		ids += hit._source.project_id;
      		})
      		if (res.hits.total !== currentSize) {
  			client.scroll({
				scrollId: res._scroll_id,
				scroll: '10s'
			}, postProcess);
      		} else {
                        console.log(res.hits.total);
      			return callback(null, ids);
      		}
  	})
    }
}

module.exports = ICRP_Search;
