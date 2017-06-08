import { Component, Input } from '@angular/core';

@Component({
  selector: 'icrp-search-summary-panel',
  templateUrl: './search-summary-panel.component.html',
  styleUrls: ['./search-summary-panel.component.css']
})
export class SearchSummaryPanelComponent {
  @Input() displayParameters: any = [];
  @Input() projectCount: number;
  @Input() relatedProjectCount: number;
  @Input() loading: boolean = true;

  map = {
      'TermSearchType:': 'Term Search Type:',
      'ProjectType:': 'Project Type:',
      'AwardCode:': 'Award Code:',
      'piLastName:': 'PI Last Name:',
      'piFirstName:': 'PI First Name:',
      'piORCiD:': 'PI ORCiD:',
      'FundingOrgType:': 'Funding Organization Type:',
      'FundingOrg:': 'Funding Organization:',
      'CancerType:': 'Cancer Type:',
  }

  keys = Object.keys(this.map);

  getSummary(): string {
    if (this.loading) {
      return 'Loading...';
    }

    if (!this.displayParameters || this.displayParameters.length === 0) {
      return 'All projects are shown below. Use the form on the left to refine search results';
    }

    let keys = this.displayParameters
      .map(row => this.getDisplayName(row[0]))
      .filter(item => item.length)
      .map(item => item[item.length - 1] == ':' ? item.substring(0, item.length - 1) : item);

    return '<b>Search Criteria: </b>' + keys.join(' + ');
  }

  getDisplayName(key): string {
    return this.map[key] || key;
  }

}
