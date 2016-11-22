import { Component, OnInit } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import { Observable } from 'rxjs';
import 'rxjs/add/operator/map';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {
  loading: boolean;
  searchResults: any;
  summaryMessage: string;

  queryMap = {
    'keywords': 'Key Words',
    'institution': 'Institution',
    'pi_first_name': 'First Name',
    'pi_last_name': 'Last Name',
    'pi_orcid': 'ORCiD',
    'city': 'Cities',
    'state': 'States/Territories',
    'country': 'Country'
  }
  
  constructor(public http: Http) {
    this.searchResults = null;
    this.loading = true;
  }

  ngOnInit() {
  }

  handleSearch(query: any) {

    for (var key in query) {
      if (!query[key])
        delete query[key];
    }

    if (Object.keys(query).length == 1) {
      this.summaryMessage = 'The default search is shown (all awards, all years). Use the search form on the left or the dashboard below to refine your search.'
    } else {
        this.summaryMessage = '';
      
      if (query.keywords)
        this.summaryMessage = '<b>Search Terms</b>: ' + query.keywords + '<br>';
      
      let filters = [];
      
      for (var key in query) {
        if (key != 'page_size' && key != 'keywords') {
          filters.push("<b>" + (this.queryMap[key] || key) + "</b>: (" + query[key] + ")")
        }
      }

      if (filters.length)
        this.summaryMessage += filters.join(', ')

    }


    this.loading = true;
    const endpoint = window.location.protocol + '//' + window.location.hostname + ':9000/search/';
    const headers = new Headers({ 'Content-Type': 'application/json' });

    console.log('searching', query);

    this.http.post(endpoint, JSON.stringify(query), { headers: headers })
      .map(res => res.json())
      .subscribe(
        data => {
          this.loading = false;

          this.searchResults =
            data.map(function (line) {
              return {
                title: line[1],
                pi: [line[3], line[4]].join(', '),
                institution: line[6],
                city: line[7],
                state: line[8],
                country: line[9],
                fundingOrg: line[10],
                awardCode: line[2],
              }
            })
        },
        error => console.error(error),
        () => console.log('done')
    );
  }

}
