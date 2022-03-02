import { Injectable } from '@angular/core';

@Injectable()
export class SharedService {

  data: any = {
    root: '',
    componentType: '',
    authenticated: false,
    isProduction: false,
    searchID: null,
    dataUploadID: null,
    userRoles: [],
  };

  get(property: string): any {
    return this.data[property];
  }

  set(property: string, value: any): void {
    this.data[property] = value;
  }
}
