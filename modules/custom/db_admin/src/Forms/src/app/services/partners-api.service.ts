import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';
import 'rxjs/add/operator/map';

@Injectable()
export class PartnersApiService {

  BASE_HREF = environment.production
    ? `/api/admin/partners`
    : `${location.protocol}//${location.hostname}/api/admin/partners`

  constructor(private http: HttpClient) {}

  fields() {
    return this.http.get(`${this.BASE_HREF}/fields`, {
      withCredentials: environment.production
    }).map((fields: any) => ({
      ...fields,
      partners: fields.partners.map(record => {
        let date = record.joindate.split('-').map(Number);
        return {
          ...record,
          latitude: +record.latitude,
          longitude: +record.longitude,
          isdsasigned: record.isdsasigned === 1,
          joindate: new Date(date[0], date[1] - 1, date[2])
        }
      }),
      partnerApplications: fields.partnerApplications.map(record => ({
        ...record,
        country: fields.countries.map(c => c.name).includes(record.country)
          ? fields.countries.find(c => c.name == record.country).abbreviation
          : fields.countries.map(c => c.abbreviation).includes(record.country)
          ? record.country
          : null,
      })),
      nonPartners: fields.nonPartners.map(record => ({
        ...record,
        canceronly: record.canceronly === 1,
        donotcontact: record.donotcontact === 1,
        researchfunder: record.researchfunder === 1,
      }))
    }));
  }

  add(parameters: FormData) {
    return this.http.post(`${this.BASE_HREF}/add`,
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
