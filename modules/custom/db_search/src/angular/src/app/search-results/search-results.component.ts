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

  @Output() sort: EventEmitter<{ "column": string, "type": "asc" | "desc" }>;
  @Output() paginate: EventEmitter<{ "size": number, "offset": number }>;
  
  emailForm: FormGroup;

  showCriteriaLocked = true;  
  searchCriteriaSummary;
  searchTerms;
  searchFilters;
  showCriteria: boolean;
  searchCriteriaGroups: {"category": string, "criteria": string[], "type": string}[];

  projectData;
  projectColumns;

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) {
    
    
    this.loadingAnalytics = true;
    this.showCriteria = false;
    this.searchCriteriaGroups = [];
    
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

    this.projectData = [];
    
    this.emailForm = formbuilder.group({
      name: ['',  Validators.required],   
      recipient_email: ['', [Validators.required, Validators.pattern(/^([\w+-.%]+@[\w-.]+\.[A-Za-z]{2,4},*[\W]*)+$/)]],
      personal_message: [''],
    });
    
  }

  ngAfterViewInit() {

  }

  convertCase(underscoreString: string) {
    return underscoreString.split('_')
      .map(str => str[0].toUpperCase() + str.substring(1))
      .join(' ');
  }

  ngOnChanges(changes: SimpleChanges) {
    
    if (Object.keys(this.searchParameters).length == 0) {
      this.searchCriteriaSummary = "All projects are shown below. Use the form on the left to refine search results";
      this.showCriteriaLocked = true; 
    }

    else {
      this.showCriteriaLocked = false; 
      let searchCriteria = [];
      for (let key of Object.keys(this.searchParameters)) {
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

      this.searchCriteriaSummary = "Search Criteria: " + searchCriteria.join(' + ');
      
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
  
  clearValue(control: any, clear: boolean) {
    if (clear) {
      control.value = '';
    }
  }
  
  sendEmail(modal: any, modal2: any) {
    
    
    let params = {
      name:  this.emailForm.controls['name'].value,
      recipient_email: this.emailForm.controls['recipient_email'].value,
      personal_message: this.emailForm.controls['personal_message'].value,
    }

    let endpoint = '/EmailResults';
    console.log(params);
    
    let parameters = new URLSearchParams();
    for(let key in params){
	parameters.set(key, params[key]);	    
    }

    
    let query = this.http.get(endpoint, {search: parameters})
        	.map((res: Response) => res.json())
      		.catch((error: any) => Observable.throw(error.json().error || 'Server error'))
        	.subscribe(
        	res => {
        		modal.hide();
        		modal2.show();
    		},
    		error => {
    			modal.hide();
    			modal2.show();
    			alert("Error");
    		});
 
  }


  
  downloadResult(modal: any){
  	modal.show();
  	let endpoint = '/ExportResults';
  	let query = this.http.get(endpoint, {})
        	.map((res: Response) => res.json())
      		.catch((error: any) => Observable.throw(error || 'Server error'))
        	.subscribe(
        	res => {
        		console.log(res);
  			window.open(res);
        		modal.hide();
       		},
    		error => {
    			console.error(error);
    			modal.hide();
    			alert("Error");
    		});
  }
  
  fireModalEvent(modal: any) {
    modal.hide();
  }

  ngOnInit() {
  }
}
