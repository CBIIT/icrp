import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable()
export class DataUploadService {

  BASE_HREF = `${window.location.protocol}//${window.location.hostname}`

  constructor(private http: HttpClient) { }

  toFormData(data: {[key: string]: any}) {
    let formData = new FormData();
  
    for (let key in data) {
      const value = data[key];
      value.constructor === File
        ? formData.append(key, value, value.name)
        : formData.append(key, value);
    }
  
    return formData;
  }


  loadProjects(data) {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/loadProjects`;
    return this.http.post<any | any[]>(endpoint, this.toFormData(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  getProjects(data) {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/getProjects`;
    return this.http.post<any | any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  importProjects(data) {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/importProjects`;
    return this.http.post<any | any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  getPartners() {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/getPartners`;
    return this.http.get<any | any[]>(endpoint, {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  getValidationRules() {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/getValidationRules`;
    return this.http.get<any | any[]>(endpoint, {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  integrityCheck(data) {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/integrityCheck`;
    return this.http.post<any | any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  integrityCheckDetails(data) {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/integrityCheckDetails`;
    return this.http.post<any | any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  calculateFundingAmounts() {
    const endpoint = `${this.BASE_HREF}/DataUploadTool/calculateFundingAmounts`;
    return this.http.get<any | any[]>(endpoint, {
      withCredentials: window.location.hostname === window.location.host,
    });
  }  
}