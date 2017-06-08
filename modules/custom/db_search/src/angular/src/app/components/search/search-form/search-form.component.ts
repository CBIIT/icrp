import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';
import { SearchService } from '../../../services/search.service';
import { StoreService } from '../../../services/store.service';

/**
 * The <icrp-search-form> component renders the search form panel and
 * search parameters
 */

@Component({
  selector: 'icrp-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent {

  fields: any = {
    search_terms: [],
    search_type: [],
    years: [],
    include_future_years: [],

    institution: [],
    pi_first_name: [],
    pi_last_name: [],
    pi_orcid: [],
    award_code: [],

    countries: [],
    states: [],
    cities: [],

    funding_organizations: [],
    funding_organization_types: [],
    cancer_types: [],
    is_childhood_cancer: [],
    project_types: [],
    cso_research_areas: []
  }

  @Output()
  search: EventEmitter<object>;

  form: FormGroup;

  parameters: any = {};
  defaultParameters: any = {};
  displayParameters: any = {};

  constructor(
    private formBuilder: FormBuilder,
    private searchService: SearchService,
    private storeService: StoreService,
  ) {
    this.search = new EventEmitter<object>();

    this.form = formBuilder.group({
      search_terms: [''],
      search_type: [''],
      years: [''],
      include_future_years: [],

      institution: [''],
      pi_first_name: [''],
      pi_last_name: [''],
      pi_orcid: [''],
      award_code: [''],

      countries: [''],
      states: [''],
      cities: [''],

      funding_organizations: [''],
      funding_organization_types: [''],
      cancer_types: [''],
      is_childhood_cancer: [''],
      project_types: [''],
      cso_research_areas: [''],
    });
  }

  submit() {

    this.parameters = {};
    for (let key in this.form.controls) {
      let value = this.form.controls[key].value;

      if (value != null && value.length > 0 || value === true)
        this.parameters[key] = value;
    }

    window.setTimeout(e =>
      this.search.emit({
        parameters: this.parameters,
        displayParameters: this.displayParameters
      }), 0)
  }

  setFields(fields) {
    this.fields = fields;
  }

  setParameters(parameters, clearForm: boolean = false) {
    if (clearForm) {
      this.form.reset();
    }

    for (let key in parameters) {
      setTimeout(e => this.form.controls[key].patchValue(parameters[key]), 0)
    }
  }

  setDefaultParameters() {
    this.defaultParameters = this.searchService.getDefaultParameters();
    this.setParameters(this.defaultParameters, true);
  }

  updateDisplayParameters(key, value) {
    if (value && value.length) {
      this.displayParameters[key] = value.map(e => e.label || e.value || e);
    }
  }

  filterYears() {
    let includeFutureYears = this.form.controls['include_future_years'].value;

    if (!this.fields || !this.fields.years || !this.fields.years.length) {
      return [];
    }

    let years = this.fields.years
      .filter(year =>
        includeFutureYears || year.value <= new Date().getFullYear())

    years.unshift({
      label: 'All Years',
      value: years.map(year => year.value).join(',')
    });

    return years;
  }

  filterStates(states: { "value": string, "label": string, "group_1": string }[], countries: string[]) {
    return states.filter(state => countries.indexOf(state.group_1) > -1 || !countries.length);
  }

  filterCities(
    cities: { "value": string, "label": string, "group_1": string, "group_2": string }[],
    states: string[],
    countries: string[]) {
    return cities
      .filter(city => countries.map(c => c.trim()).indexOf(city.group_2) > -1 || !countries.length)
      .filter(city => states.map(s => s.trim()).indexOf(city.group_1) > -1 || !states.length);
  }

  clearLocations() {
    this.form.controls['states'].patchValue([]);
    this.form.controls['cities'].patchValue([]);
  }

  clearForm() {
    this.form.reset();
    this.storeService.clearAll();
  }
}
