import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';

@Injectable()
export class SearchService {

  apiRoot: string;

  constructor(private http: Http, private sharedService: SharedService) {
    this.apiRoot = `${sharedService.get('apiRoot') || ''}/api/database`;
  }

  createGetRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      searchParams.set(key, parameters[key]);
    }

    return this.http.get(url, {search: searchParams})
      .map(response => response.json());
  }

  getFields() {
    return this.createGetRequest(`${this.apiRoot}/fields`);
  }

  getSearchResults(parameters: object) {
    return this.createGetRequest(`${this.apiRoot}/search`, parameters);
  }

  getSortedPaginatedResults(parameters: object) {
    return this.createGetRequest(`${this.apiRoot}/sort_paginate`, parameters);
  }

  getAnalytics(parameters: object) {
    let url = `${this.apiRoot}/analytics${this.sharedService.get('authenticated') && '_partners'}`;
    return this.createGetRequest(url, parameters);
  }

  getSearchParameters(parameters: object) {
    return this.createGetRequest(`${this.apiRoot}/search_parameters`, parameters);
  }
}
