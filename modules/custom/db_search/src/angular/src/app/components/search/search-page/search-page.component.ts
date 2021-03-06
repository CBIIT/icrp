import { Component, OnInit, Output, Input, ViewChild, AfterViewInit } from '@angular/core';
import { SharedService } from '../../../services/shared.service';
import { SearchService } from '../../../services/search.service';
import { Observable, of, timer } from 'rxjs';
import { delay, map } from 'rxjs/operators';

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

  tables = {
    projects: 'Projects',
    institutions: 'PI Institutions'
  }

  selectedTable = 'projects';

  searchResultViews = {
    institutions: null
  }

  tableSelectorForm: FormGroup;

  constructor(
    private searchService: SearchService,
    public sharedService: SharedService,
    private formBuilder: FormBuilder
  ) {
    this.resetAnalytics();
  }

  ngAfterViewInit() {
    this.state.searchID = getSearchID();

    this.updateFields()
      .subscribe(e => {
          this.loadingMessage = 'Fetching Data';
          this.retrieveInitialResults();
      });
  }

  selectTable(tableName) {
    this.selectedTable = tableName;

    if (this.selectedTable != 'projects') {
      if (!this.searchResultViews[this.selectedTable]) {
        this.searchService.getSearchResultsView({
          search_id: this.state.searchID,
          search_view: this.selectedTable,
          view_type: 'count',
          year: this.state.lastBudgetYear,
        }).subscribe(response => {
          this.searchResultViews[this.selectedTable] = response;
        });
      }


    }

  }

  retrieveInitialResults() {
    this.state.searchID
      ? this.performSavedSearch(this.state.searchID)
      : this.performDefaultSearch()
  }

  // sets the fields of the search form
  updateFields() {
    return this.searchService.getFields().map(fields => {
      this.fields = fields;
      this.searchForm.setFields(fields);
    });
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

    return true;
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

      let loadingTrue$ = timer(250)
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

      });
    }
  }

  getSortedPaginatedResults(parameters, callback?) {
    let params = deepCopy(parameters);
    this.sharedService.set('searchID', this.state.searchID);

    params.search_id = this.state.searchID;

    let loadingTrue$ = timer(500)
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

    for(let key in this.searchResultViews) {
      this.searchResultViews[key] = null;
    }

    this.selectTable('projects')

    this.searchService.getSearchResults(this.state.searchParameters)
      .subscribe(response => {
        this.state.searchID = response.search_id;
        this.state.results = response.results;
        this.state.displayParameters = response.display_parameters;
        this.state.loading = false;

        this.getSearchSummary(true)
          .subscribe(e => this.chartsPanel.updateCharts(this.state.searchID));

        this.sharedService.set('searchID', this.state.searchID);

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

        return this.state;
      })
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
