import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';

@Injectable()
export class ReviewService {

  apiRoot: string;

  constructor(private http: Http, private sharedService: SharedService) {
    this.apiRoot = `${sharedService.get('apiRoot') || ''}/api/database/review`;
  }

  createGetRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      searchParams.set(key, parameters[key]);
    }

    return this.http.get(url, {search: searchParams})
      .map(response => response.json());
  }

  getSponsorUploads() {
    return this.createGetRequest(`${this.apiRoot}/sponsor_uploads`);
  }

  getSearchResults(parameters: object) {
    return this.createGetRequest(`${this.apiRoot}/sort_paginate`, parameters)
      .map(response => {

        let data = response.results
          .map(row => {
            let clone = Object.assign({}, row);
            clone.project_url = `/review/project/${clone.project_id}`;
            return clone;
          });

        return {
          search_id: response.search_id,
          results_count: response.results_count,
          results: data,
        };
      });
  }

  getAnalytics(parameters: object) {
    return this.createGetRequest(`${this.apiRoot}/analytics`, parameters);
  }


  getFields() {
    return this.createGetRequest(`${this.apiRoot}/fields`)
  }


}
