import { Component, OnInit, Inject, EventEmitter, Output } from '@angular/core';
import { Validators, FormBuilder, FormGroup } from "@angular/forms";
import { SearchFields } from './search-fields';

@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css'],
})
export class SearchFormComponent implements OnInit {

  @Output() onSearch: EventEmitter<Object>;
  form: FormGroup;

  searchFields: SearchFields;  
  fields: {
    "years": string[],
    "countries": { "id": string, "text": string }[],
    "states": { "id": string, "text": string }[],
    "cities": { "id": string, "text": string }[],
    "currencies": { "id": string, "text": string }[],
    "cancerSites": { "id": string, "text": string }[],
    "projectTypes": { "id": string, "text": string }[],
    "fundingOrgs": { "id": string, "text": string }[],
    "csoAreas": { "id": string, "text": string }[],
  };
  locationFilters: {
    "countries": string[],
    "states": string[]
  }

  constructor( @Inject(FormBuilder) fb: FormBuilder) {
    this.onSearch = new EventEmitter();
    this.searchFields = new SearchFields();
    this.locationFilters = {
      countries: [],
      states: []
    }    

    this.form = fb.group({
      search_keywords: [''],
      search_filter: [''],
      years: [''],
      institution: [''],
      piFirstName: [''],
      piLastName: [''],
      orcid: [''],
      awardCode: [''],
      countries: [''],
      states: [''],
      cities: [''],
      currency: [''],
      fundingOrgs: [''],
      cancerTypes: [''],
      projectTypes: [''],
      csoAreas: [''],

      searchterms: fb.group({
        keywords: '',
        filter: ''
      })
    })

    this.applyFilters();
  }

  submit() {
    console.log(this.form);
    this.onSearch.emit({
      keywords: this.form.controls['search_keywords'].value,
      institution: this.form.controls['institution'].value,
      year: this.form.controls['years'].value,
      pi_last_name: this.form.controls['piLastName'].value,
      pi_first_name: this.form.controls['piFirstName'].value,
      pi_orcid: this.form.controls['orcid'].value,
      award_code: this.form.controls['awardCode'].value,
      country: this.form.controls['countries'].value,
      state: this.form.controls['states'].value,
      city: this.form.controls['cities'].value,
      page_size: 25
    })
  }

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

    console.log(this.fields)
  }


  ngOnInit() {
    this.onSearch.emit({
      page_size: 25
    })
  }

}
