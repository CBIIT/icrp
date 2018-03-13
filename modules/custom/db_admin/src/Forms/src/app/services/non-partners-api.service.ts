import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';

@Injectable()
export class NonPartnersApiService {

  BASE_HREF = environment.production
    ? `/api/admin/partners`
    : `${location.protocol}//${location.hostname}/api/admin/non-partners`

  constructor(private http: HttpClient) {}

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
