import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';

@Injectable()
export class SearchService {

  apiRoot: string;

  constructor(private http: Http, private sharedService: SharedService) {
    this.apiRoot = `${sharedService.get('apiRoot') || ''}/api/database`;
  }

  getRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      searchParams.set(key, parameters[key]);
    }

    return this.http.get(
      url,
      {
        search: searchParams,
        withCredentials: this.sharedService.get('is_production')
      }
    ).map(response => response.json());
  }

  getFields() {
    return this.getRequest(`${this.apiRoot}/fields`);
  }

  getSearchResults(parameters: object) {
    return this.getRequest(`${this.apiRoot}/search`, parameters)
      .map(this.applyProjectUrls);
  }

  getSortedPaginatedResults(parameters: object) {
    return this.getRequest(`${this.apiRoot}/sort_paginate`, parameters)
      .map(this.applyProjectUrls);
  }

  getAnalytics(parameters: object) {
    let url = `${this.apiRoot}/analytics${this.sharedService.get('authenticated') ? '_partners' : ''}`;
    return this.getRequest(url, parameters);
  }

  getSearchParameters(parameters: object) {
    return this.getRequest(`${this.apiRoot}/search_parameters`, parameters);
  }

  applyProjectUrls(response) {
    let results = response.results
      .map(row => {
        let copy = Object.assign({}, row);
        copy.project_url = `/project/${copy.project_id}`;
        return copy;
      });

    return {
      search_id: response.search_id,
      results_count: response.results_count,
      results: results,
      display_parameters: response.display_parameters,
    }; 
  }
}
