import { Component, Input } from '@angular/core';

@Component({
  selector: 'icrp-review-summary-panel',
  templateUrl: './review-summary-panel.component.html',
  styleUrls: ['./review-summary-panel.component.css']
})
export class ReviewSummaryPanelComponent {
  @Input() analytics: any = {};
  @Input() currentSponsor: any = {};
  @Input() numResults: number;
  @Input() loading: boolean = true;

  mapKeys = {
    project_count: 'Project Count',
    project_funding_count: 'Project Funding Count',
    project_funding_investigator_count: 'Project Funding Investigator Count',
    project_cso_count: 'Project CSO Count',
    project_cancer_type_count: 'Project Cancer Type Count',
    project_type_count: 'Project Type Count',
    project_abstract_count: 'Project Abstract Count',
//  project_search_count: 'Project Search Count'
  }

  keys = Object.keys(this.mapKeys);

}
