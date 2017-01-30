import { AfterViewInit, Component, OnInit } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

declare var fetch;

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit, AfterViewInit {

  searchID: any;
  mappedParameters: any;  
  parameters: any;
  sortPaginateParameters: any;
  results: any;
  loading: boolean;
  loadingAnalytics: boolean;
  analytics: any;
  loggedIn: boolean;

  constructor(private http: Http) {
    this.loggedIn = false;
    this.loggedIn = false;
    this.searchID = null;
    this.loadingAnalytics = true;
    this.loading = true;
    this.analytics = {};
    this.mappedParameters = {};

    this.sortPaginateParameters = {
      search_id: null,
      sort_column: 'project_title',
      sort_type: 'asc',
      page_number: 1,
      page_size: 50,
    }

    this.checkAuthentication();
  }

  checkAuthentication() {
    fetch('/search-database/partners/authenticate', {
      credentials: 'include'
    })
    .then(response => response.text())
    .then(response => {
      this.loggedIn = (response === 'authenticated');
    });
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
      this.loadingAnalytics = true;
      this.queryServerAnalytics({}).subscribe(
        response => {
          this.loadingAnalytics = false;
          this.processAnalytics(response);
        }
      );
    }
  }
    
  processAnalytics(response) {
//    let analytics = {};

    if (response) {

      for (let category of [
        'projects_by_country', 
        'projects_by_cso_research_area', 
        'projects_by_cancer_type', 
        'projects_by_type',
        'projects_by_year']) {
          if (response[category]) {
            for (let key in response[category]) {
              this.analytics[category] = response[category]['results'];
            }

              this.analytics[category].sort((a, b) => +b.value - +a.value);
          }
      }
    }
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
    let endpoint = '/db/public/analytics';

    if (this.loggedIn) {
      endpoint = '/db/partner/analytics';
    }

    let host = window.location.hostname;

    let params = new URLSearchParams();
    params.set('search_id', this.searchID);

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
  }

  resultsSortPaginate(parameters: Object) {
    
    let endpoint = '/db/public/sort_paginate';
    let host = window.location.hostname;

    let params = new URLSearchParams();

    if (!parameters['page_size'] || !parameters['page_number']) {
      parameters['page_size'] = 50;
      parameters['page_number'] = 1;
    }

    if (!parameters['sort_column'] || !parameters['sort_column']) {
      parameters['sort_column'] = 'project_title';
      parameters['sort_type'] = 'ASC';
    }

    params.set('search_id', this.searchID);
    for (let key of Object.keys(parameters)) {
      params.set(key, parameters[key]);
    }

    this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
      .subscribe(response => {
        this.results = response;
        this.loading = false;
      })
    
  }

  sortPaginateServer(parameters: Object) {
    
  }

  queryServer(parameters: Object): Observable<any[]> {
  
    let protocol = window.location.protocol;
    let host = window.location.hostname;

    let endpoint = '/db/public/search';

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
//    this.updateResults({});
  }

  ngOnInit() {
  }

}
