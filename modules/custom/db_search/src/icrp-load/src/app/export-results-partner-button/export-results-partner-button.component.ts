import { AfterViewInit, Component, Inject, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Component({
  selector: 'export-results-partner-button',
  templateUrl: './export-results-partner-button.component.html',
  styleUrls: ['./export-results-partner-button.component.css']
})
export class ExportResultsPartnerButtonComponent implements OnInit {

  constructor(    @Inject(FormBuilder) private formbuilder: FormBuilder,  @Inject(Http) private http: Http) { }

  ngOnInit() { }
  
  downloadResultsPartner(modal: any){
  	modal.show();
  	//let endpoint = 'http://localhost/ExportResultsPartner';
  	let endpoint = '/ExportResultsPartner';
  	let query = this.http.get(endpoint, {})
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
