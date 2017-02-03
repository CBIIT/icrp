import { Injectable } from '@angular/core'
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Injectable()
export class SearchFields {

  devEndpoint = '';

  constructor(private http: Http) {}
  
  getFields(): Observable<Response> {
    let endpoint = `${this.devEndpoint}/db/public/fields`;
    return this.http.get(endpoint)
      .map((response: Response) => response.json())
      .catch((error: Response | any) => Observable.throw(error.json().error || 'Server Error'));
  }
}