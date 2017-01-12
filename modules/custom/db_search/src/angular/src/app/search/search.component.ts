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

  mappedParameters: any;  
  parameters: any;
  results: any;
  loading: boolean;
  loadingAnalytics: boolean;
  analytics: any;

  constructor(private http: Http) {
    this.loadingAnalytics = true;
    this.loading = true;
    this.analytics = null;
    this.mappedParameters = {};
  }

  updateMappedParameters(event: Object) {
    this.mappedParameters = event;
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
  }

  updateAnalytics(event: Object) {
    this.loadingAnalytics = true;
    this.queryServerAnalytics(this.parameters).subscribe(
      response => {
        this.loadingAnalytics = false;
        this.analytics = this.processAnalytics(response);
      }
    );
  }
    
  processAnalytics(response) {
    let analytics = {};

    if (response && response.count) {
      analytics['count'] = response.count;

      for (let category of [
        'projects_by_country', 
        'projects_by_cso_category', 
        'projects_by_cancer_type', 
        'projects_by_type']) {

          console.log('analyzing', response[category])
          if (response[category]) {
            for (let key in response[category]) {
              if (!analytics[category]) {
                analytics[category] = [];
              }

              analytics[category].push({label: key, value: response[category][key]})
            }

            analytics[category].sort((a, b) => +b.value - +a.value);
          }
      }
    }

    return analytics;
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
  
    let protocol = window.location.protocol;
    let host = window.location.hostname;
    let endpoint = `${protocol}//${host}/db/public/search`;
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
