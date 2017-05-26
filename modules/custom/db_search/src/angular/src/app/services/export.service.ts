import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';

@Injectable()
export class ExportService {

  constructor(private http: Http, private sharedService: SharedService) { }

  getRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      searchParams.set(key, parameters[key]);
    }

    return this.http.get(
      url,
      {
        search: searchParams,
        withCredentials: this.sharedService.get('is_production')
      }
    ).map(response => response.json());
  }

  emailResults(params: {"name": string, "recipient_email": string, "personal_message": string}) {
    //let endpoint = 'http://localhost/ExportResultsPartner';
    let endpoint = '/EmailResults';
    return this.getRequest(endpoint, params);
  }

  export(endpoint: string) {
    return this.getRequest(endpoint);
  }
}
