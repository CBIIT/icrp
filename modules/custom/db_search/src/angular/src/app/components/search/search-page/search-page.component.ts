import { Component, OnInit, Output, Input, ViewChild, AfterViewInit } from '@angular/core';
import { SharedService } from '../../../services/shared.service';
import { SearchService } from '../../../services/search.service';
import { StoreService } from '../../../services/store.service';
import { Observable } from 'rxjs';

import { parseQuery, range, asLabelValuePair, deepCopy, getSearchID, removeEmptyProperties } from './search-page.functions';

@Component({
  selector: 'icrp-search-page',
  templateUrl: './search-page.component.html',
  styleUrls: ['./search-page.component.css']
})
export class SearchPageComponent implements AfterViewInit {

  @ViewChild('searchform') searchForm;

  search$: Observable<any>;
  fields: any = {};

  state = {
    loading: true,
    searchID: getSearchID(),
    searchParameters: {},
    displayParameters: [],
    results: [],
    numResults: 0,
    analytics: {},
    expiredSearchID: false,
  }


  constructor(
    private searchService: SearchService,
    private storeService: StoreService,
    public sharedService: SharedService,
  ) {
    this.resetAnalytics();
  }

  ngAfterViewInit() {
    this.state.searchID = getSearchID();

    // update fields first
    this.updateFields()
      .subscribe(e =>
        this.state.searchID
          ? this.performSavedSearch(this.state.searchID)
          : this.performDefaultSearch()
      );
  }

  // sets the fields of the search form
  updateFields() {
    return this.searchService.getFields().map(fields => {
      this.fields = fields;
      this.searchForm.setFields(fields);
    });
  }

  performSavedSearch(searchID) {
    this.getSearchParameters(searchID)
      .subscribe(response => {
        if (response[0] === false) {
          this.performDefaultSearch();
          this.state.expiredSearchID = true;
        }

        else {
          let parameters = removeEmptyProperties(response);
          this.searchForm.setParameters(parameters);
          this.getSearchResults({
            parameters: parameters,
          });
        }

      });
  }

  performDefaultSearch() {
    this.setDefaultParameters();
    this.getSearchResults({
      parameters: this.getDefaultParameters(),
    })
  }

  setDefaultParameters() {
    let defaultParameters =  this.getDefaultParameters();
    this.searchForm.setParameters(defaultParameters, true);
  }

  getDefaultParameters() {
    let currentYear = new Date().getFullYear();
    let defaultParameters = {
      years: [currentYear, currentYear - 1]
    };

    return defaultParameters;

  }

  // functions for retrieving search parameters based on search id
  getSearchParameters(searchID) {
    return this.searchService.getSearchParameters({search_id: searchID})
  }

  getAnalytics(id, types = [], year = null) {
    if (!types || types.length === 0)
      types = Object.keys(this.state.analytics);

    for (let key of types) {

      let loadingTrue$ = Observable.timer(250)
        .subscribe(e => this.state.analytics[key] = []);

      this.searchService.getAnalytics({
        search_id: id,
        type: key,
        year: year,
      })
      .subscribe(response => {
        loadingTrue$.unsubscribe();
        this.state.analytics[key] = response
      });
    }
  }

  getSortedPaginatedResults(parameters) {
    let params = deepCopy(parameters);
    params.search_id = this.state.searchID;

    let loadingTrue$ = Observable.timer(500)
      .subscribe(e => this.state.loading = true);

    this.searchService.getSortedPaginatedResults(params)
      .subscribe(response => {
        this.state.displayParameters = response.display_parameters;
        this.state.results = response.results;
        loadingTrue$.unsubscribe();
        this.state.loading = false;
      })
  }

  getSearchResults(event: any) {
    console.log('search', event);

    this.resetAnalytics();
    this.state.loading = true;
    this.state.searchParameters = this.filterSearchParameters(deepCopy(event.parameters));

    this.searchService.getSearchResults(this.state.searchParameters)
      .subscribe(response => {
        this.state.searchID = response.search_id;
        this.state.results = response.results;
        this.state.numResults = response.results_count;
        this.state.displayParameters = response.display_parameters;
        this.state.loading = false;
        this.getAnalytics(this.state.searchID);
      });
  }

  resetAnalytics() {
    this.state.analytics = {
      project_counts_by_country: null,
      project_counts_by_cso_research_area: null,
      project_counts_by_cancer_type: null,
      project_counts_by_type: null,

      project_funding_amounts_by_country: null,
      project_funding_amounts_by_cso_research_area: null,
      project_funding_amounts_by_cancer_type: null,
      project_funding_amounts_by_type: null,
      project_funding_amounts_by_year: null,

    };
  }

  filterSearchParameters(params) {
    let parameters = deepCopy(params);

    if (!parameters['search_terms'] || !parameters['search_type']) {
      delete parameters['search_terms'];
      delete parameters['search_type'];
    }

    if (parameters['years']) {
      parameters['years'] = parameters['years']
        .filter((item, index, array) => array.indexOf(item) === index)
    }

    if (parameters['funding_organizations']) {
      parameters['funding_organizations'] = parameters['funding_organizations']
        .filter(item => !isNaN(item))
    }

    if (parameters['cso_research_areas']) {
      parameters['cso_research_areas'] = parameters['cso_research_areas']
        .filter(item => !isNaN(item))
    }

    return parameters;
  }
}
