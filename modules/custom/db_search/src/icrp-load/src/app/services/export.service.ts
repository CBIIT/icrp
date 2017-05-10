import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';

@Injectable()
export class ExportService {

  constructor(private http: Http) { }

  createGetRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      searchParams.set(key, parameters[key]);
    }

    return this.http.get(url, {search: searchParams})
      .map(response => response.text());
  }

  emailResults(params: {"name": string, "recipient_email": string, "personal_message": string}) {
    //let endpoint = 'http://localhost/ExportResultsPartner';
    let endpoint = '/EmailResults';
    return this.createGetRequest(endpoint, params);
  }

  export(endpoint: string) {
    return this.createGetRequest(endpoint);
  }
}
