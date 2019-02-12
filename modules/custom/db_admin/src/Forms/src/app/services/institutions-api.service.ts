
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';

@Injectable()
export class InstitutionsApiService {
  BASE_HREF = environment.production
    ? `/api/admin/institutions`
    : `${location.protocol}//${location.hostname}/api/admin/institutions`

  constructor(private http: HttpClient) {}

  fields() {
    return this.http.get(`${this.BASE_HREF}/fields`, {
      withCredentials: environment.production
    });
  }

  add(parameters: FormData) {
    console.log('adding');
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
