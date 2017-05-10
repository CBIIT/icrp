import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'icrp-search-criteria-display',
  templateUrl: './search-criteria-display.component.html',
  styleUrls: ['./search-criteria-display.component.css']
})
export class SearchCriteriaDisplayComponent {

  @Input()
  criteria: any = {};

  @Input()
  additionalCriteria: any = {};
  
  showCriteria: boolean = false;

  criteriaMap = {
    total_projects: 'Total Projects',
    total_related_projects: 'Total Related Projects',

    search_terms: 'Search Terms',
    search_type: 'Search Type',
    years: 'Years',

    institution: 'Institution',
    pi_first_name: 'Primary Investigator\'s First Name',
    pi_last_name: 'Primary Investigator\'s First Name',
    pi_orcid: 'Primary Investigator\'s ORCiD',
    award_code: 'Project Award Code',

    countries: 'Countries',
    states: 'States',
    cities: 'Cities',

    funding_organizations: 'Funding Organizations',
    funding_organization_types: 'Funding Organization Types',
    cancer_types: 'Cancer Types',
    is_childhood_cancer: 'Is Childhood Cancer',
    project_types: 'Project Types',
    cso_research_areas: 'CSO Research Areas',
  };

  getCriteria() {
    let criteria = [];

    for (let key in this.criteria) {
      criteria.push({
        label: this.criteriaMap[key], 
        value: this.criteria[key]
      });
    }

    return criteria;    
  }

  getCriteriaCategories() {
    return Object.keys(this.criteria)
      .map(c => this.criteriaMap[c])
      .join(' + ');
  }

  getAdditionalCriteria() {
    let criteria = [];

    for (let key in this.additionalCriteria) {
      criteria.push(`${this.criteriaMap[key]}: ${this.additionalCriteria[key]}`);
    }

    return criteria.join(' / ');
  }


}
