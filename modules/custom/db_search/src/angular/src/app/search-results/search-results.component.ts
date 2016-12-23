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
  @Input() analytics : {
    country: { "label": string, "value": number }[],
    cso_code: { "label": string, "value": number }[],
    cancer_type_id: { "label": number, "value": number }[],
    project_type: { "label": string, "value": number }[]
  };

  @Input() param: Object;

  chartData: Object = {};

  @Output() sort: EventEmitter<{ "column": string, "type": "asc" | "desc" }>;
  @Output() paginate: EventEmitter<{ "size": number, "offset": number }>;
  
  projectData;
  projectColumns;
  numProjects: number;

  chartParams: UiChartParameters [];

  constructor() {
    this.sort = new EventEmitter<{ "column": string, "type": "asc" | "desc" }>();
    this.paginate = new EventEmitter<{ "size": number, "offset": number }>();
    
    this.analytics = {
      country: [],
      cso_code: [],
      cancer_type_id: [],
      project_type: []
    }

    for (let key in this.analytics) {
      this.chartData[key] = this.getChart(this.analytics[key])
    }

    console.log(this.chartData);
    

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

    console.log('changes made', changes);

    if (changes['analytics']) {

      let change = changes['analytics'].currentValue;

      let cancer_type_id = changes['analytics'].currentValue['cancer_type_id'].map(e => e);

      console.log('cancer type', cancer_type_id);

      console.log('updating graphs with', change);
      for (let key in change) {

        console.log('applying ', this.getChart(change[key]), 'to', key, 'actual', change[key]);
        this.chartData[key] = this.getChart(change[key])
      }

      console.log('New ChartData', this.chartData);
    }

    if (this.results && this.results.projects && this.results.count) {
      console.log('Updating results', this.results)

      let projects = this.results.projects;
      this.numProjects = this.results.count;

      this.projectData = projects.map(result => {
        return {
          project_title: result.project_title,
          pi_name: result.pi_name,
          institution: result.institution,
          city: result.city,
          state: result.state,
          country: result.country,
          funding_organization: result.funding_organization,
          award_code: result.award_code,
          url: `https://icrpartnership-test.org/ViewProject/${result.project_id}`
        }
      })
    }

  }

  ngOnInit() {
  }

  getChart(data) {
    return {
      data: data,
      options: {
        type: 'pie'
      }
    }
  }
}
