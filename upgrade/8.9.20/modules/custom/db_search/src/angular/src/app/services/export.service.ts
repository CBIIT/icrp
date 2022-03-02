import { Http, URLSearchParams } from '@angular/http';
import { Injectable } from '@angular/core';
import { SharedService } from './shared.service';

@Injectable()
export class ExportService {

  constructor(private http: Http, private sharedService: SharedService) { }

  getRequest(url: string, parameters: any = {}) {
    let searchParams = new URLSearchParams();
    for (let key in parameters) {
      let value = parameters[key];

      if (value) {
        searchParams.set(key, value);
      }
    }

    return this.http.get(
      url,
      {
        search: searchParams,
        withCredentials: this.sharedService.get('isProduction')
      }
    ).map(response => response.text());
  }

  emailResults(params: {"search_id": number, "sender_name": string, "recipient_addresses": string, "personal_message": string}) {
    let endpoint = '/api/database/email-results';
    return this.getRequest(endpoint, params);
  }

  export(endpoint: string, parameters: any) {
    return this.getRequest(endpoint, parameters);
  }
}
