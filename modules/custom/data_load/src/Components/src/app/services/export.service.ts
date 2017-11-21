import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable()
export class ExportService {

  BASE_HREF = `${window.location.protocol}//${window.location.hostname}`

  constructor(private http: HttpClient) { }

  getExcelExport(data: any[], prefix: string = 'Data_Export') {
    const endpoint = `${this.BASE_HREF}/api/getExcelExport/${prefix}/`;
    return this.http.post<string>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }
}