import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';
import { Observable } from 'rxjs';

@Injectable()
export class ReviewService {
  deleteStage(arg0: { data_upload_id: number; }) {
    throw new Error('Method not implemented.');
  }

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
        withCredentials: this.sharedService.get('isProduction')
      }
    ).map(response => response.json());
  }

  getSponsorUploads() {
    return this.getRequest(`${this.apiRoot}/sponsor_uploads`);
  }

  getSearchResults(parameters: object) {
    return this
      .getRequest(`${this.apiRoot}/sort_paginate`, parameters)
      .map(response => ({
          search_id: response.search_id,
          results_count: response.results_count,
          results: response.results.map(row => ({
            ...row,
            project_url: `/review/project/${row.project_id}`
          })),
        }));
  }


  getSearchSummary(parameters: object) {
    return this.getRequest(`${this.apiRoot}/search_summary`, parameters);
  }

  getAnalytics(parameters: object) {
    return this.getRequest(`${this.apiRoot}/analytics`, parameters);
  }


  getFields() {
    return this.getRequest(`${this.apiRoot}/fields`)
  }

  syncProd(parameters: object) {
    return this.getRequest(`${this.apiRoot}/sync_prod`, parameters)
  }
  
  deleteImport(parameters: object) {
    return this.getRequest(`${this.apiRoot}/delete_import`, parameters)
  }

}
