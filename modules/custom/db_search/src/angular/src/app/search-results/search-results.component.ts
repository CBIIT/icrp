import { AfterViewInit, Component, Inject, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import {
  Validators,
  FormBuilder,
  FormGroup
} from '@angular/forms';

import { UiChartParameters } from '../ui-chart/ui-chart.parameters';
import { Observable } from 'rxjs/Rx';


import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';


@Component({
  selector: 'app-search-results',
  templateUrl: './search-results.component.html',
  styleUrls: ['./search-results.component.css']
})
export class SearchResultsComponent implements OnChanges, AfterViewInit  {

  @Input() loading;  
  @Input() loadingAnalytics: boolean;  

  @Input() results;
  @Input() analytics;
  @Input() searchParameters;
  @Input() authenticated;
  @Input() fundingYearOptions = [];

  @Output() sort: EventEmitter<{ "column": string, "type": "asc" | "desc" }>;
  @Output() paginate: EventEmitter<{ "size": number, "offset": number }>;
  @Output() updateFundingYear: EventEmitter<{ "year": number }>;
  

  fundingYear = new Date().getFullYear();
  emailForm: FormGroup;

  showCriteriaLocked = true;  
  searchCriteriaSummary;
  searchTerms;
  searchFilters;
  showCriteria: boolean;
  searchCriteriaGroups: {"category": string, "criteria": string[], "type": string}[];

  showExtendedCharts = false;

  projectData;
  projectColumns;

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) {

    this.authenticated = false;
    
    this.loadingAnalytics = true;
    this.showCriteria = false;
    this.searchCriteriaGroups = [];
    
    this.sort = new EventEmitter<{ "column": string, "type": "asc" | "desc" }>();
    this.paginate = new EventEmitter<{ "size": number, "offset": number }>();
    this.updateFundingYear = new EventEmitter<{ "year": number }>();

    this.analytics = {
      count: 0,
      country: [],
      cso_code: [],
      cancer_type_id: [],
      project_type: []
    }

    this.projectColumns = [
      {
        label: 'Project Title',
        value: 'project_title',
        link: 'url',
        tooltip: 'Title of Award'
      },
      {
        label: 'PI',
        value: `pi_name`,
        tooltip: 'Principal Investigator'
      },
      {
        label: 'Institution',
        value: 'institution',
        tooltip: 'PI Institution'
      },
      {
        label: 'Ctry.',
        value: 'country',
        tooltip: 'PI Institution Country'
      },
      {
        label: 'Funding Org.',
        value: 'funding_organization',
        tooltip: 'Funding Organization of Award (abbreviated name shown)',
      },
      {
        label: 'Award Code',
        value: 'award_code',
        tooltip: 'Unique Identifier for Award (supplied by Partner)',        
      }
    ]

    this.projectData = [];


  }

  ngAfterViewInit() {

  }

  convertCase(underscoreString: string) {
    return underscoreString.split('_')
      .map(str => str[0].toUpperCase() + str.substring(1))
      .join(' ');
  }

  ngOnChanges(changes: SimpleChanges) {
    
    console.log(changes);

    if (changes['searchParameters']) {

      if (Object.keys(this.searchParameters).length == 0) {
        this.searchCriteriaSummary = "All projects are shown below. Use the form on the left to refine search results";
        this.showCriteriaLocked = true; 
      }

      else {
        this.showCriteriaLocked = false; 
        let searchCriteria = [];
        this.searchCriteriaGroups = [];
        for (let key of Object.keys(this.searchParameters)) {

          if (key != 'search_type')
            searchCriteria.push(this.convertCase(key));

          let param = this.searchParameters[key];

          let criteriaGroup = {
            category: this.convertCase(key),
            criteria: [],
            type: "single"
          }

          if (param instanceof Array) {
            criteriaGroup.criteria = param;
            criteriaGroup.type = "array";
          }

          else {
            criteriaGroup.criteria = [param];
          }  

          this.searchCriteriaGroups.push(criteriaGroup);
        }

        this.searchCriteriaSummary = searchCriteria.join(' + ');
        
      }

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
          url: `/project/${result.project_id}`
        }
      })
    }

  }
  
  clearValue(control: any, clear: boolean) {
    if (clear) {
      control.value = '';
    }
  }
  
  fireModalEvent(modal: any) {
    modal.hide();
  }

  setFundingYear(year) {
    this.updateFundingYear.emit(year);
    this.fundingYear = year;
  }

  ngOnInit() {

  }
}
