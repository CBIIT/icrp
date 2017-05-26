import { AfterViewInit, Component, Inject, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Component({
  selector: 'export-results-graphs-partner-button',
  templateUrl: './export-results-graphs-partner-button.component.html',
  styleUrls: ['./export-results-graphs-partner-button.component.css']
})
export class ExportResultsGraphsPartnerButtonComponent implements OnInit {

	@Input() inputYear;

  constructor(    
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) {
	}

  ngOnInit() {
  }
  
  downloadResultsWithGraphsPartner(modal: any){

	let params = new URLSearchParams();
	params.set('year', this.inputYear || 2017);

  	modal.show();
	//let endpoint = 'http://localhost/ExportResultsWithGraphsPartner';
  	let endpoint = '/ExportResultsWithGraphsPartner';
  	let query = this.http.get(endpoint, {search: params})
        	.map((res: Response) => res.json())
      		.catch((error: any) => Observable.throw(error || 'Server error'))
        	.subscribe(
        	res => {
        		console.log(res);
  			document.location.href=res;
        		modal.hide();
       		},
    		error => {
    			console.error(error);
    			modal.hide();
    			alert("Error");
    		});  
  
  }

}
