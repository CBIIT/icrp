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
  searchResults: Object; 

  headers = ['id', 'code', 'title', 'piLastName', 'piFirstName', 'institution', 'city', 'state', 'country', 'fundingorgId', 'abstractId', 'projectType', 'importYear', 'piORCiD']
  displayHeaders = ['Title', 'Principal Investigator', 'Institution', 'City', 'State', 'Ctry.', 'Funding Org.', 'Award Code']

  constructor(public http: Http) {
    this.searchResults = null;
    this.loading = true;
  }

  handleSearch(query: Object) {

    this.loading = true;

    const endpoint = 'http://localhost:9000/search/'; 
    const headers = new Headers({'Content-Type': 'application/json'});

    console.log('searching', query);
    /*query = {
        keywords: 'Glioblastoma',
        importYear: '2015',

    }*/

    this.http.post(endpoint, JSON.stringify(query), { headers: headers })
      .map(res => res.json())
      .subscribe(
      data => {
        this.loading = false;
        this.searchResults = {
          headers: this.displayHeaders,
          data: data.map(function (line) {
            return {
              title: line[2],
              pi: [line[3], line[4]].join(', '),
              institution: line[5],
              city: line[6],
              state: line[7],
              country: line[8],
              fundingOrg: line[9],
              awardCode: line[1],
            }
          })
        }
        },
        error => console.error(error),
        () => console.log('done')
      );
  }


  ngOnInit() {
  }

}
