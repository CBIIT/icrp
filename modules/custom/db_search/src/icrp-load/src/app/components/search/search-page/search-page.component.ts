import { Component, OnInit, Output, Input, ViewChild, AfterViewInit } from '@angular/core';
import { SearchService } from '../../../services/search.service';
import { StoreService } from '../../../services/store.service';
import { Observable } from 'rxjs';

import { parseQuery, range, asLabelValuePair } from './search-page.functions';

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

  constructor(private searchService: SearchService, private storeService: StoreService) {
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

  search(event: any) {
    console.log('search', event);
    this.state.searchParameters = event.parameters;
    this.state.displayParameters = event.displayParameters;

    this.storeService.set('searchParameters', event.parameters);

    this.searchService.getSearchResults(event.parameters)
      .subscribe(response => {
        this.state.results = response;
      });
  }
}
