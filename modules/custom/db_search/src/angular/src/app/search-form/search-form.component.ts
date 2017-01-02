import {
  Component,
  Inject,
  Input,
  EventEmitter,
  OnInit,
  Output
} from '@angular/core';

import {
  Validators,
  FormBuilder,
  FormGroup
} from '@angular/forms';

import { SearchFields } from './search-form.fields';



@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent implements OnInit {

  @Output()
  search: EventEmitter<{
    search_terms?: string,
    years?: string,
    
    institution?: string,
    pi_first_name?: string,
    pi_orcid?: string,
    award_code?: string,

    countries?: string,
    states?: string,
    cities?: string,

    funding_organizations?: string,
    cancer_types?: string,
    project_types?: string,
    cso_codes?: string
  }>;

  form: FormGroup;

  searchFields: SearchFields;

  fields: {
    "years":                  { "value": number, "label": string }[],
    "countries":              { "value": string, "label": string }[],
    "states":                 { "value": string, "label": string }[],
    "cities":                 { "value": string, "label": string }[],
    "currencies":             { "value": number, "label": string }[],
    "cancer_types":           { "value": number, "label": string }[],
    "project_types":          { "value": string, "label": string }[],
    "funding_organizations":  { "value": number, "label": string }[],
    "cso_research_areas":     { "value": string, "label": string }[],
  };

  constructor(
    @Inject(FormBuilder)
    fb: FormBuilder) {
    
    this.search = new EventEmitter();

    this.form = fb.group({
      search_terms: [''],
      search_type: ['all'],
      years: [''],
      institution: [''],
      pi_first_name: [''],
      pi_last_name: [''],
      pi_orcid: [''],
      award_code: [''],
      countries: [''],
      states: [''],
      cities: [''],
      funding_organizations: [''],
      cancer_types: [''],
      project_types: [''],
      cso_codes: [''],
    })

    // initialize locations
    this.searchFields = new SearchFields();
    this.initializeFields();
  }

  submit() {

    let parameters = {

      search_terms: this.form.controls['search_terms'].value,
      search_type: this.form.controls['search_type'].value,
      years: this.form.controls['years'].value,

      institution: this.form.controls['institution'].value,
      pi_first_name: this.form.controls['pi_first_name'].value,
      pi_last_name: this.form.controls['pi_last_name'].value,
      pi_orcid: this.form.controls['pi_orcid'].value,
      award_code: this.form.controls['award_code'].value,

      countries: this.form.controls['countries'].value,
      states: this.form.controls['states'].value,
      cities: this.form.controls['cities'].value,

      funding_organizations: this.form.controls['funding_organizations'].value,
      cancer_types: this.form.controls['cancer_types'].value,
      project_types: this.form.controls['project_types'].value,
      cso_codes: this.form.controls['cso_codes'].value,
    };

    // remove unused parameters
    delete parameters['years'];

    for (let key in parameters) {
      if (!parameters[key] || parameters[key].length === 0) {
        delete parameters[key];
      }
    }

    if (!parameters['search_terms'] || !parameters['search_type']) {
      delete parameters['search_terms'];
      delete parameters['search_type'];
    }

    this.search.emit(parameters)
  }

  initializeFields() {
    this.fields = {
      years: this.searchFields.getYears(),
      countries: this.searchFields.getCountries(),
      states: this.searchFields.getStates([]),
      cities: this.searchFields.getCities([], []),
      currencies: this.searchFields.getCurrencies(),
      cancer_types: this.searchFields.getCancerTypes(),
      project_types: this.searchFields.getProjectTypes(),
      funding_organizations: this.searchFields.getFundingOrganizations(),
      cso_research_areas: this.searchFields.getCsoResearchAreas()
    }
  }

  updateLocationSearch() {
    console.log('UPDATING SEARCH LOCATION', this.form.controls['countries'].value);
  }  


/*
  updateFilters(type: string, event: any) {
    console.log(type, event);
    this.locationFilters[type] = event;
    console.log(this.locationFilters);

    this.applyFilters()
  }

  applyFilters() {
    this.fields = {
      years: this.searchFields.getYears(),
      countries: this.searchFields.getCountries(),
      states: this.searchFields.getStates(this.locationFilters.countries),
      cities: this.searchFields.getCities(this.locationFilters.countries, this.locationFilters.states),
      currencies: this.searchFields.getCurrencies(),
      cancerSites: this.searchFields.getAllCancerSites(),
      projectTypes: this.searchFields.getAllProjectTypes(),
      fundingOrgs: this.searchFields.getFundingOrganizations(this.locationFilters.countries, null, null),
      csoAreas: this.searchFields.getCsoAreas(null)
    }
  }*/


  



  ngOnInit() {
  }

}
