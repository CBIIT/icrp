import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';


@Component({
  selector: 'icrp-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent {

  @Input()
  fields: any;

  @Output()
  search: EventEmitter<object>;

  form: FormGroup;

  parameters: any = {};
  defaultParameters: any = {};
  displayParameters: any = {};

  constructor(private formBuilder: FormBuilder) {
    this.search = new EventEmitter<object>();

    this.form = formBuilder.group({
      search_terms: [''],
      search_type: [''],
      years: [],

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

      if (value != null && value.length > 0)
        this.parameters[key] = value;
    }

    this.search.emit({
      parameters: this.parameters,
      displayParameters: this.displayParameters
    });
  }

  setParameters(parameters) {
    for (let key in parameters) {
      this.form.controls[key].patchValue(parameters[key]);
    }
  }

  setDefaultParameters(parameters) {
    this.defaultParameters = parameters;
    this.setParameters(this.defaultParameters);
  }

  updateDisplayParameters(key, value) {
    if (value && value.length) {
      this.displayParameters[key] = value.map(e => e.label || e.value || e);
    }
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
}
