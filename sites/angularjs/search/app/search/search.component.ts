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
  displayHeaders = ['Title', 'Principal Investigator', 'Institution', 'City', 'State', 'Ctry.', 'Funding Org.', 'Award Code']

  constructor(public http: Http) {
    this.searchResults = null;
    this.loading = true;
  }

  handleSearch(query: Object) {

    this.loading = true;
    const endpoint = window.location.protocol + '//' + window.location.hostname + ':9000/search/';
    const headers = new Headers({ 'Content-Type': 'application/json' });

    console.log('searching', query);

    this.http.post(endpoint, JSON.stringify(query), { headers: headers })
      .map(res => res.json())
      .subscribe(
        data => {
          this.loading = false;

          this.searchResults = {
            headers: this.displayHeaders,
            data: data.map(function (line) {
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
          }
        },
        error => console.error(error),
        () => console.log('done')
    );
  }


  ngOnInit() {
  }

}
