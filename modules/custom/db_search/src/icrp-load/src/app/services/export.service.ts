import { Http } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';

@Injectable()
export class ExportService {

  constructor(private http: Http, private sharedService: SharedService) { }

  createGetRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      searchParams.set(key, parameters[key]);
    }

    return this.http.get(url, {search: searchParams})
      .map(response => response.json());
  }


  emailResults(params: {"name": string, "recipient_email": string, "personal_message": string}) {
    //let endpoint = 'http://localhost/ExportResultsPartner';
    let endpoint = '/EmailResults';
    return this.createGetRequest(endpoint, params);
  }

  export(endpoint: string) {
    return this.createGetRequest(endpoint);
  }  

  exportResults() {
    // let endpoint = 'http://localhost/ExportResultsPartner';
  	// let endpoint = 'http://localhost/ExportResults';

    let endpoint = this.sharedService.get('authenticated')
      ? '/ExportResultsPartner'
      : '/ExportResults';
    
    return this.createGetRequest(endpoint);
  }

  exportResultsSingle() {
    //let endpoint = 'http://localhost/ExportResultsSignlePartner';
    let endpoint = '/ExportResultsSignlePartner';
    return this.createGetRequest(endpoint);
  }

  exportAbstracts() {
  	//let endpoint = 'http://localhost/ExportResultsWithAbstractPartner';
  	let endpoint = '/ExportResultsWithAbstractPartner';
    return this.createGetRequest(endpoint);
  }

  exportAbstractsSingle() {
  	//let endpoint = 'http://localhost/ExportAbstractSignlePartner';
  	let endpoint = '/ExportAbstractSignlePartner';
    return this.createGetRequest(endpoint);
  }

  exportGraphs() {
	//let endpoint = 'http://localhost/ExportResultsWithGraphsPartner';
  	let endpoint = '/ExportResultsWithGraphsPartner';
    return this.createGetRequest(endpoint);
  }
}
