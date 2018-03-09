import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';
import 'rxjs/add/operator/map';

@Injectable()
export class FundingOrganizationsApiService {

  BASE_HREF = environment.production
    ? `/api/admin/funding-organization`
    : `${location.protocol}//${location.hostname}/api/admin/funding-organizations`

  constructor(private http: HttpClient) {}

  fields() {
    return this.http.get(`${this.BASE_HREF}/fields`, {
      withCredentials: environment.production
    }).map((record: any) => ({
      ...record,
      fundingOrganizations: record.fundingOrganizations.map(entry => ({
        ...entry,
        memberstatus: entry.memberstatus.trim(),
        isannualized: entry.isannualized === 1,
        latitude: +entry.latitude || null,
        longitude: +entry.longitude || null,
        note: entry.note || null
      })),
      partners: record.partners.map(entry => ({
        ...entry,
        longitude: +entry.longitude || null,
        latitude: +entry.latitude || null,
        note: entry.note || null
      }))
    }));
  }

  add(parameters: any) {
    return this.http.get(`${this.BASE_HREF}/add`, {
      withCredentials: environment.production
    })
  }

  update(parameters: any) {
    return this.http.get(`${this.BASE_HREF}/update`, {
      withCredentials: environment.production
    })
  }
}
