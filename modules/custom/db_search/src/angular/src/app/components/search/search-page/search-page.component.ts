import { Component, OnInit, Output, Input, ViewChild, AfterViewInit } from '@angular/core';
import { SharedService } from '../../../services/shared.service';
import { SearchService } from '../../../services/search.service';
import { StoreService } from '../../../services/store.service';
import { Observable } from 'rxjs';

import { parseQuery, range, asLabelValuePair, deepCopy, getSearchID, removeEmptyProperties } from './search-page.functions';
import { FormBuilder, FormGroup } from '@angular/forms';

@Component({
  selector: 'icrp-search-page',
  templateUrl: './search-page.component.html',
  styleUrls: ['./search-page.component.css']
})
export class SearchPageComponent implements AfterViewInit {

  @ViewChild('searchform') searchForm;
  @ViewChild('summarypanel') summaryPanel;
  @ViewChild('chartspanel') chartsPanel;

  search$: Observable<any>;
  fields: any = {};

  loadingMessage = 'Loading Page';
  radioModel = 'Projects';

  state = {
    loading: true,
    searchID: getSearchID(),
    searchParameters: {},
    sortPaginateParameters: {},
    displayParameters: [],
    results: [],
    projectCount: 0,
    relatedProjectCount: 0,
    lastBudgetYear: 0,
    analytics: {},
    expiredSearchID: false,
  }

  selectedTable = 'Projects';

  tableSelectorForm: FormGroup;

  constructor(
    private searchService: SearchService,
    private storeService: StoreService,
    public sharedService: SharedService,
    private formBuilder: FormBuilder
  ) {
    this.resetAnalytics();
    this.storeService.clearAll();
  }

  ngAfterViewInit() {
    this.state.searchID = getSearchID();
    this.storeService.clearAll();

    this.updateFields()
      .subscribe(e => {
          this.storeService.clearAll();
          this.loadingMessage = 'Fetching Data';
          this.retrieveInitialResults();
      });
  }

  selectTable(tableName) {
    this.selectedTable = tableName;
  }

  retrieveInitialResults() {
    this.state.searchID
      ? this.performSavedSearch(this.state.searchID)
      : this.performDefaultSearch()
  }

  // sets the fields of the search form
  updateFields() {
    let storedFields = this.storeService.get('fields');
    if (storedFields) {
      return Observable.of(true)
        .delay(0)
        .map(e => {
          this.fields = storedFields;
          this.searchForm.setFields(storedFields);
        });
    }

    else {
      return this.searchService.getFields().map(fields => {
        this.fields = fields;
        this.searchForm.setFields(fields);
        this.storeService.set('fields', fields);
      });
    }
  }

  isStoredStateValid() {


    let storedFields = [
      'searchID',
      'searchParameters',
      'displayParameters',
      'results',
      'projectCount',
      'relatedProjectCount',
      'lastBudgetYear',
      'analytics'
    ];

    if (getSearchID())
      return false;

    if (!this.storeService.exists('previouslyAuthenticated')
    || (this.sharedService.get('authenticated') !== this.storeService.get('previouslyAuthenticated'))) {
      return false;
    }

    for (let field of storedFields) {
      if (!this.storeService.exists(field) || !this.storeService.get(field)) {
        console.log('error retrieving: ', field);
        return false;
      }
    }

    return true;
  }

  restoreState() {
    let storedFields = [
      'searchID',
      'searchParameters',
      'sortPaginateParameters',
      'displayParameters',
      'results',
      'projectCount',
      'relatedProjectCount',
      'lastBudgetYear',
      'analytics'
    ];

    for (let field of storedFields) {
      Observable.of(true)
        .delay(0)
        .subscribe(e => {
          this.state[field] = this.storeService.get(field);

          switch(field) {
            case 'searchParameters':
              this.searchForm.setParameters(this.state[field], true);
              break;

            case 'lastBudgetYear':
              Observable.of(this.state.lastBudgetYear.toString())
                .delay(0)
                .subscribe(year => this.chartsPanel.form.controls.conversion_year.patchValue(year));
              break;

            case 'searchID':
              this.sharedService.set('searchID', this.state.searchID);
              break;
          }
      });
    }

    Observable.of(false)
      .delay(100)
      .subscribe(e => this.state.loading = e)
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
          if (parameters['years']) {
            let currentYear = new Date().getFullYear();
            let isAuthenticated = this.sharedService.get('authenticated');
            parameters['include_future_years'] = false;

            for(let year of parameters['years']) {

              if (year > currentYear) {
                if (isAuthenticated) {
                  parameters['include_future_years'] = true;
                }

                else {
//                  parameters['years'] = this.searchService.getDefaultParameters().years;
//                  break;
                }
              }
            }
          }

          this.searchForm.setParameters(parameters);
          this.getSortedPaginatedResults({ search_id: searchID }, () => {
            this.getSearchSummary(true)
              .subscribe(e => this.chartsPanel.updateCharts(searchID));
          });
        }

      });
  }

  performDefaultSearch() {
    let defaultParameters = this.searchService.getDefaultParameters();
    this.searchForm.setParameters(defaultParameters, true);
    this.getSearchResults({
      parameters: defaultParameters,
    })
  }

  // functions for retrieving search parameters based on search id
  getSearchParameters(searchID) {
    return this.searchService.getSearchParameters({search_id: searchID})
  }

  getAnalytics(id, types = [], year = null) {
    // if (!types || types.length === 0)
    //   types = this.sharedService.get('authenticated')
    //     ? Object.keys(this.state.analytics)
    //     : [
    //       'project_counts_by_country',
    //       'project_counts_by_cso_research_area',
    //       'project_counts_by_cancer_type',
    //       'project_counts_by_type',
    //     ];


    if (!types || types.length === 0) {
      types = [
        'project_counts_by_country',
        'project_counts_by_cso_research_area',
        'project_counts_by_cancer_type',
        'project_counts_by_type',
      ];
    }

    for (let key of types) {

      let loadingTrue$ = Observable.timer(250)
        .subscribe(e => this.state.analytics[key] = []);

      if (year == null) {
        year = this.state.lastBudgetYear;
      }

      this.searchService.getAnalytics({
        search_id: id,
        type: key,
        year: year,
      })
      .subscribe(response => {
        loadingTrue$.unsubscribe();

        if (['project_counts_by_year', 'project_funding_amounts_by_year'].indexOf(key) > -1) {
          console.log(key, response);
        }

        this.state.analytics[key] = response;

        this.storeService.merge('analytics', this.state.analytics);
      });
    }
  }

  getSortedPaginatedResults(parameters, callback?) {
    let params = deepCopy(parameters);
    this.storeService.set('sortPaginateParameters', parameters);
    this.sharedService.set('searchID', this.state.searchID);

    params.search_id = this.state.searchID;

    let loadingTrue$ = Observable.timer(500)
      .subscribe(e => this.state.loading = true);

    this.searchService.getSortedPaginatedResults(params)
      .subscribe(response => {
        this.state.displayParameters = response.display_parameters;
        this.state.results = response.results;
        loadingTrue$.unsubscribe();
        this.state.loading = false;

        if (callback) {
          callback();
        }
      });
  }

  getSearchResults(event: any) {
    this.resetAnalytics();
    this.state.loading = true;
    this.state.searchParameters = this.filterSearchParameters(deepCopy(event.parameters));

    this.searchService.getSearchResults(this.state.searchParameters)
      .subscribe(response => {
        this.state.searchID = response.search_id;
        this.state.results = response.results;
        this.state.displayParameters = response.display_parameters;
        this.state.loading = false;

        this.getSearchSummary(true)
          .subscribe(e => this.chartsPanel.updateCharts(this.state.searchID));

        this.sharedService.set('searchID', this.state.searchID);

        this.storeService.set('previouslyAuthenticated', this.sharedService.get('authenticated'));
        this.storeFields([
          'searchID',
          'searchParameters',
          'displayParameters',
          'results',
        ]);
      });
  }

  getSearchSummary(updateConversionYear: boolean = true) {
    return this.searchService.getSearchSummary({ search_id: this.state.searchID })
      .map(response => {
        this.state.projectCount = +response.project_count;
        this.state.relatedProjectCount = +response.related_project_count;


        if (updateConversionYear) {
          let validYears = this.fields.conversion_years.map(e => +e.value);
          let budgetYear = +response.last_budget_year;

          this.state.lastBudgetYear = (validYears.indexOf(budgetYear) > -1)
            ? budgetYear
            : validYears[0];

          this.chartsPanel.form.controls.conversion_year.patchValue(this.state.lastBudgetYear.toString());
        }


        this.storeFields([
          'projectCount',
          'relatedProjectCount',
          'lastBudgetYear',
        ]);

        return this.state;
      })
  }

  storeFields(fields) {
    for (let field of fields) {
      this.storeService.set(field, this.state[field]);
    }
  }


  resetAnalytics() {
    this.state.analytics = {
      project_counts_by_country: null,
      project_counts_by_cso_research_area: null,
      project_counts_by_cancer_type: null,
      project_counts_by_type: null,
      project_counts_by_year: null,
      project_counts_by_institution: null,
      project_counts_by_childhood_cancer: null,
      project_counts_by_funding_organization: null,

      project_funding_amounts_by_country: null,
      project_funding_amounts_by_cso_research_area: null,
      project_funding_amounts_by_cancer_type: null,
      project_funding_amounts_by_type: null,
      project_funding_amounts_by_year: null,
      project_funding_amounts_by_institution: null,
      project_funding_amounts_by_childhood_cancer: null,
      project_funding_amounts_by_funding_organization: null,
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
