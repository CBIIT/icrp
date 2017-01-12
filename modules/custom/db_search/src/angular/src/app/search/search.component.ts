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

  searchID: any;
  mappedParameters: any;  
  parameters: any;
  results: any;
  loading: boolean;
  loadingAnalytics: boolean;
  analytics: any;

  constructor(private http: Http) {
    this.searchID = null;
    this.loadingAnalytics = true;
    this.loading = true;
    this.analytics = {};
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
        this.searchID = response['search_id'];
        this.results = response['results'];
        this.analytics['count'] = response['results_count'];
        this.loading = false;

        this.updateAnalytics({});
      },
      error => {
        console.error(error);
        this.loading = false;
      }
    )
  }

  updateAnalytics(event: Object) {
    if (this.searchID != null) {
      console.log('updating analytics with ' + this.searchID);
      this.loadingAnalytics = true;
      this.queryServerAnalytics({}).subscribe(
        response => {
          this.loadingAnalytics = false;
          this.analytics = this.processAnalytics(response);
        }
      );
    }
  }
    
  processAnalytics(response) {
    let analytics = {};

    if (response) {
      console.log('processing', response);

      for (let category of [
        'projects_by_country', 
        'projects_by_cso_research_area', 
        'projects_by_cancer_type', 
        'projects_by_type']) {

          console.log('analyzing', response[category])
          if (response[category]) {
            for (let key in response[category]) {
              analytics[category] = response[category]['results'];
            }

            analytics[category].sort((a, b) => +b.value - +a.value);
          }
      }
    }

    console.log('generated analytics', analytics);

    return analytics;
  }

  paginate(event) {
    this.parameters['page_size'] = event.page_size;
    this.parameters['page_number'] = event.page_number;
    this.resultsSortPaginate(this.parameters);
  }

  sort(event) {
    this.parameters['sort_column'] = event.sort_column;
    this.parameters['sort_type'] = event.sort_type;
    this.resultsSortPaginate(this.parameters);
  }

  queryServerAnalytics(parameters: Object): Observable<any[]> {

    let protocol = window.location.protocol;
    let host = window.location.hostname;

    let endpoint = `${protocol}//${host}/db/public/analytics`;
    
    let params = new URLSearchParams();
    params.set('search_id', this.searchID);

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
  }

  resultsSortPaginate(parameters: Object) {
    let endpoint = 'https://icrpartnership-demo.org/db/public/sort_paginate';
    let params = new URLSearchParams();

    if (!parameters['page_size'] || !parameters['page_number']) {
      parameters['page_size'] = 50;
      parameters['page_number'] = 1;
    }

    if (!parameters['sort_column'] || !parameters['sort_column']) {
      parameters['sort_column'] = 'project_title';
      parameters['sort_type'] = 'ASC';
    }

//    for (let key of ['page_size', 'page_number', 'sort_column', 'sort_type'])

/*    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'));
*/
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
