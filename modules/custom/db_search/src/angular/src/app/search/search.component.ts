import { AfterViewInit, Component, OnInit, Inject } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { SearchParameters } from './search-parameters';

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

  devEndpoint = '';

  searchParameters: SearchParameters;

  searchID: any;
  mappedParameters: any;  
  parameters: any;
  sortPaginateParameters: any;
  results: any;
  loading: boolean;
  loadingAnalytics: boolean;
  analytics: any;
  loggedIn: boolean;

  initialID: any;
  initialParameters: any;

  conversionYears = [];

  constructor(
    private http: Http,
    @Inject('api_root') private apiRoot: string
    ) {
    this.loggedIn = false;
//    this.loggedIn = true;
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

    this.initialParameters = null;

    

    this.updateAvailableConversionYears();
    this.checkAuthenticationStatus();
  }

  updateInitialSearchId() {
    let query = window.location.search
      .substring(1)
      .split('&')
      .map(e => e.split('=')) 
      // retrieve array of query terms
      // and create object
      .reduce((prev, curr) => {
        let key = curr[0];
        let value = curr[1];

        if (key) {
          prev[key] = value;
        }
        
        return prev;
      }, [])

    this.initialID = query['sid'];
    this.updateInitalParameters();
    
  }

  updateInitalParameters() {

    let params = new URLSearchParams();
    params.set('search_id', this.initialID);

    this.http.get(`${this.apiRoot}/db/retrieve`, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => [])
      .subscribe(
        response => this.initialParameters = this.parseParameters(response),
        error => {},
        () => {}
      )
  }

  parseParameters(params) {

    for (let key in params) {
      if (!params[key])
        params[key] = '';
    }

    let parsed = {
      award_code: params['AwardCode'],
      cso_research_areas: params['CSOList'].split(','),
      cancer_types: params['CancerTypeList'].split(','),
      cities: params['CityList'].split(','),
      countries: params['CountryList'].split(','),
      funding_organizations: params['FundingOrgList'].split(','),
      institution: params['Institution'],
      project_types: params['ProjectTypeList'].split(','),
      states: params['StateList'].split(','),
      search_type: params['TermSearchType'],
      search_terms: params['Terms'],
      years: params['YearList'].split(','),
      pi_first_name: params['piFirstName'],
      pi_last_name: params['piLastName'],
      pi_orcid: params['piORCiD']
    }

    console.log('recieved parameters', params);
    console.log('parsed parameters', parsed);

    return parsed;
  }

  checkAuthenticationStatus() {
    this.http.get(`${this.apiRoot}/search-database/partners/authenticate`, {withCredentials: true})
      .map((res: Response) => res.text())
      .catch((error: any) => {
        let message = 'Server error';
        if ([401, 403].indexOf(error.status) > -1) {
          message = 'Unauthorized'
        }
        return []
      })
      .subscribe(
        response => {
          this.loggedIn = (response === 'authenticated')
        },
        error => {},
        () => {}
      )
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

      this.analytics['counts'] = [];

      for (let category of [
        'projects_by_country', 
        'projects_by_cso_research_area', 
        'projects_by_cancer_type', 
        'projects_by_type',
        'projects_by_year']) {
          if (response[category]) {
            for (let key in response[category]) {
              this.analytics[category] = response[category]['results'];
              this.analytics['counts'][category] = response[category]['count'];
            }

              this.analytics[category].sort((a, b) => +b.value - +a.value);
          }
      }

//      this.updateServerAnalyticsFunding();
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
    let endpoint = `${this.apiRoot}/db/public/analytics`;

    if (this.loggedIn) {
      endpoint = `${this.apiRoot}/db/partner/analytics`;
    }

    let host = window.location.hostname;

    let params = new URLSearchParams();
    params.set('search_id', this.searchID);

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
  }

  updateServerAnalyticsFunding(year?) {

    console.log('receiving funding update');
    let endpoint = `${this.apiRoot}/db/partner/analytics/funding`;
    let params = new URLSearchParams();

    if (!year) {
      year = 2017;
    }
    
    params.set('search_id', this.searchID);
    params.set('year', year);

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
      .subscribe(
        response => {
          

          let category = 'projects_by_year';
          let parsed_data = response.map(data => ({label: data.label, value: +data.value}));
          this.analytics[category] = parsed_data;
        }
      );
  }



  updateAvailableConversionYears() {

    console.log('receiving funding update');
    let endpoint = `${this.apiRoot}/db/partner/analytics/funding_years`;

    return this.http.get(endpoint)
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
      .subscribe(response => this.conversionYears = response.map(e => +e['year']));
  }




  resultsSortPaginate(parameters: Object) {
    
    let endpoint = `${this.apiRoot}/db/public/sort_paginate`;
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




  queryServer(parameters: Object): Observable<any[]> {
  
    let protocol = window.location.protocol;
    let host = window.location.hostname;

    let endpoint = `${this.apiRoot}/db/public/search`;

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
