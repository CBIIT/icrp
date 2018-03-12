import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';
import 'rxjs/add/operator/map';

@Injectable()
export class FundingOrganizationsApiService {

  BASE_HREF = environment.production
    ? `/api/admin/funding-organizations`
    : `${location.protocol}//${location.hostname}/api/admin/funding-organizations`

  constructor(private http: HttpClient) {}

  fields() {
    return this.http.get(`${this.BASE_HREF}/fields`, {
      withCredentials: environment.production
    }).map((record: any) => ({
      ...record,
      fundingOrganizations: record.fundingOrganizations
        .map(entry => ({
          ...entry,
          memberstatus: entry.memberstatus.trim(),
          isannualized: entry.isannualized === 1,
          latitude: +entry.latitude || null,
          longitude: +entry.longitude || null,
          note: entry.note || null
        }))
        .sort((a, b) => a.name.localeCompare(b.name)),
      partners: record.partners
        .map(entry => ({
          ...entry,
          longitude: +entry.longitude || null,
          latitude: +entry.latitude || null,
          note: entry.note || null
        }))
        .sort((a, b) => a.name.localeCompare(b.name))
    }));
  }

  add(parameters: FormData) {
    return this.http.post(
      `${this.BASE_HREF}/add`,
      parameters,
      { withCredentials: environment.production }
    );
  }

  update(parameters: FormData) {
    return this.http.post(
      `${this.BASE_HREF}/update`,
      parameters,
      { withCredentials: environment.production }
    );
  }

}
