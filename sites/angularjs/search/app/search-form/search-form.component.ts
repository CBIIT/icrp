import { Component, OnInit, Output, EventEmitter, AfterViewInit } from '@angular/core';
import { SearchFields } from './search-fields';


@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent implements OnInit, AfterViewInit {

  @Output() onSearch: EventEmitter<Object>;
  
 searchFields: SearchFields = new SearchFields();
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

 filters: {
   "countries": string[],
   "states": string[]
 }

 constructor() {
    this.onSearch = new EventEmitter();
    this.filters = {
      countries: [],
      states: []
    }
    this.applyFilters();
  }

  search(term) {
    this.onSearch.emit({
      keywords: term,
      year: 2015,
      pageSize: 50
    })
  }

  ngAfterViewInit() {
   this.onSearch.emit({
      keywords: 'cancer',
      year: 2015,
      pageSize: 50
    })
  }

  ngOnInit() {
    
  }
  

  updateFilters(type: string, event: any) {
    console.log(type, event);
    this.filters[type] = event.map(el => el.id)
    console.log(this.filters)

    this.applyFilters()
  }

  applyFilters() {


    this.fields = {
      years: this.searchFields.getYears(),
      countries: this.searchFields.getCountries(),
      states: this.searchFields.getStates(this.filters.countries),
      cities: this.searchFields.getCities(this.filters.countries, this.filters.states),
      currencies: this.searchFields.getCurrencies(),
      cancerSites: this.searchFields.getAllCancerSites(),
      projectTypes: this.searchFields.getAllProjectTypes(),
      fundingOrgs: this.searchFields.getFundingOrganizations(this.filters.countries, null, null),
      csoAreas: this.searchFields.getCsoAreas(null)
    }

    console.log(this.fields)
  }

}
