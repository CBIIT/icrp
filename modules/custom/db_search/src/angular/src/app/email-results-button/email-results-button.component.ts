import { AfterViewInit, Component, Inject, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Component({
  selector: 'email-results-button',
  templateUrl: './email-results-button.component.html',
  styleUrls: ['./email-results-button.component.css']
})
export class EmailResultsButtonComponent implements OnInit {

  emailForm: FormGroup;

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) {
    
    this.emailForm = formbuilder.group({
      name: ['',  Validators.required],   
      recipient_email: ['', [Validators.required, Validators.pattern(/^([\w+-.%]+@[\w-.]+\.[A-Za-z]{2,4},*[\W]*)+$/)]],
      personal_message: [''],
    });
    
  }
  ngOnInit() {
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


  
  
  fireModalEvent(modal: any) {
    modal.hide();
  }

}
