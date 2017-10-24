import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {
  ApiFields,
  ApiStatusMessage,
} from './data.service.types';

@Injectable()
export class DataService {

  BASE_HREF = `${window.location.protocol}//${window.location.hostname}`

  constructor(private http: HttpClient) { }

  getFields() {
    const endpoint = `${this.BASE_HREF}/api/admin/funding_organizations/fields`;
    return this.http.get<ApiFields>(endpoint, {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  addFundingOrganization(data: FormData) {
    const endpoint = `${this.BASE_HREF}/api/admin/funding_organizations/add`;
    return this.http.post<ApiStatusMessage[]>(endpoint, data, {
      withCredentials: window.location.hostname === window.location.host,
    });
  }
}
