import { AfterViewInit, Component, OnInit } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';


@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit, AfterViewInit {

  parameters: any;
  results: any;
  loading: boolean;

  analytics: any;

  count: {
    country: { "label": string, "value": number }[],
    cso_code: { "label": string, "value": number }[],
    cancer_type_id: { "label": number, "value": number }[],
    project_type: { "label": string, "value": number }[]
  };

  constructor(private http: Http) {
    this.loading = true;

    this.count = {
      country: [],
      cso_code: [],
      cancer_type_id: [],
      project_type: [],
//    funding_organization: [],
//    institution: []
    }
  }

  updateResults(event: Object) {

    this.loading = true;
    this.parameters = {};
    
    for (let key in event) {
      if (event[key]) {
        this.parameters[key] = event[key];
      }
    }

    this.queryServer(this.parameters).subscribe(
      response => {
        this.results = response;
        this.loading = false;
      },
      error => {
        console.error(error);
        this.loading = false;
      }
    )

    this.queryServerAnalytics(this.parameters).subscribe(
      response => this.analytics = response
    );
  }

  paginate(event) {

    this.parameters['page_size'] = event.page_size;
    this.parameters['page_number'] = event.page_number;
    this.updateResults(this.parameters);
  }

  sort(event) {
    this.parameters['sort_column'] = event.sort_column;
    this.parameters['sort_type'] = event.sort_type;
    this.updateResults(this.parameters);
  }

  queryServerAnalytics(parameters: Object): Observable<any[]> {
    let endpoint = 'https://icrpartnership-demo.org/db/public/analytics';
    let params = new URLSearchParams();

    for (let key of Object.keys(parameters)) {
      params.set(key, parameters[key]);
    }

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
  }
  

  queryServer(parameters: Object): Observable<any[]> {
    let endpoint = 'https://icrpartnership-demo.org/db/public/search';
    let params = new URLSearchParams();

    if (!parameters['page_size'] || !parameters['page_number']) {
      parameters['page_size'] = 50;
      parameters['page_number'] = 1;
    }

    for (let key of Object.keys(parameters)) {
      params.set(key, parameters[key]);
    }

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
  }

  ngAfterViewInit() {
    this.updateResults({});
  }

  ngOnInit() {
  }

}
