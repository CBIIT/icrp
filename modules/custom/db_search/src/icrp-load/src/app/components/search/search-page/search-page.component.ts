import { Component, OnInit, Output, Input, ViewChild, AfterViewInit } from '@angular/core';
import { SharedService } from '../../../services/shared.service';
import { SearchService } from '../../../services/search.service';
import { StoreService } from '../../../services/store.service';
import { Observable } from 'rxjs';

import { parseQuery, range, asLabelValuePair, deepCopy } from './search-page.functions';

@Component({
  selector: 'icrp-search-page',
  templateUrl: './search-page.component.html',
  styleUrls: ['./search-page.component.css']
})
export class SearchPageComponent implements AfterViewInit {

  @ViewChild('searchform') searchForm;
  fields: any;
  search$: Observable<any>;
  state = {
    searchID: this.getSearchID(),
    searchParameters: {},
    displayParameters: {},
    resultsCount: 0,
    results: [],
  }

  sortPaginateParameters = {
    page_size: 50,
    page_number: 1,
    sort_column: 'project_title',
    sort_direction: 'asc',
  }

  loading: boolean = true;
  numResults = 0;
  analytics = {
    project_counts_by_country: null,
    project_counts_by_cso_research_area: null,
    project_counts_by_cancer_type: null,
    project_counts_by_type: null,
    project_funding_amounts_by_year: null,
  };


  searchResults: any[];
  headers = [
    {
      label: 'Project Title',
      key: 'project_title',
      link: 'project_url',
      tooltip: 'Title of Award',
      sort: 'asc',
    },

    {
      label: 'PI',
      key: 'pi_name',
      tooltip: 'Principal Investigator',
    },

    {
      label: 'Institution',
      key: 'institution',
      tooltip: 'PI Institution',
    },

    {
      label: 'Ctry.',
      key: 'country',
      tooltip: 'PI Institution Country',
    },

    {
      label: 'Funding Org.',
      key: 'funding_organization',
      tooltip: 'Funding Organization of Award (abbreviated name shown)',
    },

    {
      label: 'Award Code',
      key: 'award_code',
      tooltip: 'Unique Identifier for Award (supplied by Partner)',
    },
  ];


  constructor(
    private searchService: SearchService,
    private storeService: StoreService,
    public sharedService: SharedService,
  ) {
    if (this.storeService.exists('searchFields')) {
      //this.fields = this.storeService.get('searchFields');
    }

    this.updateFields();
  }


  async ngAfterViewInit() {

    // first check database for search id,
    // if search id exists, then sort paginate results and store the form fields as originals
    // else perform default search without waiting for fields to arrive

    // get available form fields
    // then retrieve/apply the stored search criteria to the form

/*
    searchService.getFields()
      .subscribe(response => {
        this.fields = response
      });
*/

    // attempt to retrieve search parameters
    if (this.state.searchID) {
      this.searchService.getSearchParameters({search_id: this.state.searchID})
        .subscribe(response => {
          console.log('search parameters', response);
        });
    }


    // perform default search
    else {


//       this.searchForm.submit(this.state.searchParameters);

//      this.searchForm.setParameters();
    }
  }

  updateFields() {
    let years = range(new Date().getFullYear(), 2000, -1);

    this.fields = {
      years: years.map(asLabelValuePair),
      cities: [],
      states: [],
      countries: [],
      funding_organizations: [],
      funding_organization_types: [],
      cancer_types: [],
      is_childhood_cancer: ['Yes', 'No'].map(asLabelValuePair),
      project_types: [],
      cso_research_areas: []
    }

    return this.searchService.getFields().subscribe(response => {
      for (let key in response) {
        this.fields[key] = response[key];
      }

      // store search fields
      this.storeService.set('searchFields', this.fields);

      // apply search parameters from local storage
      if (this.storeService.exists('searchParameters')) {

        this.searchForm.setParameters(this.storeService.get('searchParameters'))
        console.log('Search Parameters from memory: ', this.storeService.get('searchParameters'))
        console.log('todo: set the search parameters in the form');


      }

    });
  }

  getSavedSearchParameters() {

  }


  // functions for retrieving search parameters based on search id

  getSearchID() {
    let query: any = parseQuery(window.location.search);
    return query && query.sid || null;
  }


  getAnalytics(id, types = [], year = null) {
    if (!types || types.length === 0)
      types = Object.keys(this.analytics);

    for (let key of types) {

      let loadingTrue$ = Observable.timer(250)
        .subscribe(e => this.analytics[key] = []);

      this.searchService.getAnalytics({
        search_id: id,
        type: key,
        year: year,
      })
      .subscribe(response => {
        loadingTrue$.unsubscribe();
        this.analytics[key] = response
      });
    }
  }


  sortPaginate(parameters) {
    this.sortPaginateParameters = Object.assign(
      this.sortPaginateParameters,
      parameters);

    this.search(
      Object.assign(this.sortPaginateParameters, {
        search_id: this.state.searchID
      })
    );
  }


  search(event: any) {
    console.log('search', event);

    this.loading = true;
    this.state.searchParameters = deepCopy(event.parameters);
    this.state.displayParameters = deepCopy(event.displayParameters);

    this.storeService.set('searchParameters', this.state.searchParameters);

    this.searchService.getSearchResults(this.state.searchParameters)
      .subscribe(response => {

        this.storeService.set('searchResults', response);

        this.state.results = response;
        this.searchResults = response.results;
        this.numResults = response.results_count;
        this.state.searchID = response.search_id;
        this.loading = false;
        this.getAnalytics(this.state.searchID);
      });
  }
}
