import { Http, URLSearchParams, Headers } from '@angular/http';
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
        withCredentials: this.sharedService.get('isProduction')
      }
    ).map(response => response.json());
  }

  // NCIATWP-11800: ICRP Manager bulk status change (the server checks the manager role and the CSRF token)
  getProjectStatusPreview(projectIds: number[]): Promise<any[]> {
    return this.getRequest(`${this.apiRoot}/project_status/preview`, { project_ids: projectIds.join(',') }).toPromise();
  }

  setProjectStatus(projectIds: number[], active: boolean): Promise<any> {
    const root = this.sharedService.get('apiRoot') || '';
    const withCredentials = this.sharedService.get('isProduction');
    return this.http.get(`${root}/session/token`, { withCredentials: withCredentials }).toPromise()
      .then(tokenResponse => this.http.post(
        `${this.apiRoot}/project_status`,
        JSON.stringify({ project_ids: projectIds, active: active }),
        {
          headers: new Headers({ 'Content-Type': 'application/json', 'X-CSRF-Token': tokenResponse.text() }),
          withCredentials: withCredentials
        }
      ).toPromise())
      .then(response => response.json());
  }

  getDefaultParameters() {
    let currentYear = new Date().getFullYear();
    let defaultParameters = {
      years: [currentYear, currentYear - 1]
    };

    return defaultParameters;
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

  getSearchSummary(parameters: object) {
    return this.getRequest(`${this.apiRoot}/search_summary`, parameters);
  }

  getSearchResultsView(parameters: object) {
    return this.getRequest(`${this.apiRoot}/search_results_view`, parameters);
  }

  getDataUploadCompletenessSummary() {
    return this.getRequest(`${this.apiRoot}/data_upload_completeness_summary`);
  }

  applyProjectUrls(response) {
    let results = response.results.map(row => ({
      ...row,
      project_url: `/project/${row.project_id}`
    }));

    return {
      search_id: response.search_id,
      results: results,
      display_parameters: response.search_parameters,
    };
  }
}
