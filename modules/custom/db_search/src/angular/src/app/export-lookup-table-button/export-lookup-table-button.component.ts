import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-export-lookup-table-button',
  templateUrl: './export-lookup-table-button.component.html',
  styleUrls: ['./export-lookup-table-button.component.css']
})
export class ExportLookupTableButtonComponent implements OnInit {

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) { 
      
    }

  ngOnInit() {
  }


  downloadResult(modal: any){
  	modal.show();
  	//let endpoint = 'http://localhost/ExportLookupTable';
  	let endpoint = '/ExportLookupTable';
  	let query = this.http.get(endpoint, {})
        	.map((res: Response) => res.json())
      		.catch((error: any) => Observable.throw(error || 'Server error'))
        	.subscribe(
        	res => {
        		console.log(res);
  			alert(res);
  			//document.location.href=res;
        		modal.hide();
       		},
    		error => {
    			console.error(error);
    			modal.hide();
    			alert("Error");
    		});
  }

}
