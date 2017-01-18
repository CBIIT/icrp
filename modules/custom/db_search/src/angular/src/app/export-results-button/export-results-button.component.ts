import { AfterViewInit, Component, Inject, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Component({
  selector: 'export-results-button',
  templateUrl: './export-results-button.component.html',
  styleUrls: ['./export-results-button.component.css']
})
export class ExportResultsButtonComponent implements OnInit {

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) { 
      
    }

  ngOnInit() {
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

}
