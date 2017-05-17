import { Http } from '@angular/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';


@Injectable()
export class SharedService {

  data: any = {
    root: '',
    componentType: '',
    authenticated: false,
    is_production: false,
  };

  constructor(private http: Http) {
    this.updateAuthenticationStatus();
    this.set('is_production', environment.production);
  }

  get(property: string): any {
    return this.data[property];
  }

  set(property: string, value: any): void {
    this.data[property] = value;
  }

  updateAuthenticationStatus(): void {
    let auth = this.http.get('/api/authenticate', {withCredentials: true});
    auth.subscribe();

    Observable.of(true)
      .subscribe(response => this.set('authenticated', response));
  }
}
