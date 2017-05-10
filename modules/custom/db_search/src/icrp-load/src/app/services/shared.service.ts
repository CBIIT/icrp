import { Http } from '@angular/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable()
export class SharedService {

  data: any = {
    root: '',
    componentType: '',
    authenticated: false,
  };

  constructor(private http: Http) {
    this.updateAuthenticationStatus();
  }

  get(property: string): any {
    return this.data[property];
  }

  set(property: string, value: any): void {
    this.data[property] = value;
  }

  updateAuthenticationStatus(): void {
    let auth = this.http.get('/api/authenticate', {withCredentials: true});

    Observable.of(true)
      .subscribe(response => this.set('authenticated', response));
  }
}
