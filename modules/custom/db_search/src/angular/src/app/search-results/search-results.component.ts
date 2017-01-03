import { AfterViewInit, Component, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';

import { UiChartParameters } from '../ui-chart/ui-chart.parameters';


@Component({
  selector: 'app-search-results',
  templateUrl: './search-results.component.html',
  styleUrls: ['./search-results.component.css']
})
export class SearchResultsComponent implements OnChanges, AfterViewInit  {

  @Input() loading;  
  @Input() results;
  @Input() analytics;

  @Output() sort: EventEmitter<{ "column": string, "type": "asc" | "desc" }>;
  @Output() paginate: EventEmitter<{ "size": number, "offset": number }>;
  
  analyticsData;

  searchTerms;
  searchFilters;

  projectData;
  projectColumns;

  constructor() {
    this.sort = new EventEmitter<{ "column": string, "type": "asc" | "desc" }>();
    this.paginate = new EventEmitter<{ "size": number, "offset": number }>();
    
    this.analytics = {
      country: [],
      cso_code: [],
      cancer_type_id: [],
      project_type: []
    }

    this.projectColumns = [
      {
        label: 'Project Title',
        value: 'project_title',
        link: 'url'
      },
      {
        label: 'Name',
        value: `pi_name`,
      },
      {
        label: 'Institution',
        value: 'institution'
      },
      {
        label: 'City',
        value: 'city'
      },
      {
        label: 'State',
        value: 'state'
      },
      {
        label: 'Country',
        value: 'country'
      },
      {
        label: 'Funding Organization',
        value: 'funding_organization'
      },
      {
        label: 'Award Code',
        value: 'award_code'
      }
    ]

    this.projectData = []
  }

  ngAfterViewInit() {

  }

  ngOnChanges(changes: SimpleChanges) {

    
    if (changes['analytics']) {

    }

    if (this.results) {
      this.projectData = this.results.map(result => {
        return {
          project_title: result.project_title,
          pi_name: result.pi_name,
          institution: result.institution,
          city: result.city,
          state: result.state,
          country: result.country,
          funding_organization: result.funding_organization,
          award_code: result.award_code,
          url: `https://icrpartnership-demo.org/ViewProject/${result.project_id}`
        }
      })
    }

  }

  ngOnInit() {
  }
}
