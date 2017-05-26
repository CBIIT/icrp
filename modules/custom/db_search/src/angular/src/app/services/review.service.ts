import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';
import { Observable } from 'rxjs';

@Injectable()
export class ReviewService {

  apiRoot: string;

  constructor(private http: Http, private sharedService: SharedService) {
    this.apiRoot = `${sharedService.get('apiRoot') || ''}/api/database/review`;
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

  getSponsorUploads() {
    return this.getRequest(`${this.apiRoot}/sponsor_uploads`);
  }

  getSearchResults(parameters: object) {
    return this.getRequest(`${this.apiRoot}/sort_paginate`, parameters)
      .map(response => {

        let data = response.results
          .map(row => {
            let copy = Object.assign({}, row);
            copy.project_url = `/review/project/${copy.project_id}`;
            return copy;
          });

        return {
          search_id: response.search_id,
          results_count: response.results_count,
          results: data,
        };
      });
  }

  getAnalytics(parameters: object) {
    return this.getRequest(`${this.apiRoot}/analytics`, parameters);
  }


  getFields() {
    return this.getRequest(`${this.apiRoot}/fields`)
  }


}
