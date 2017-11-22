import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { parse } from 'papaparse';

export type ParseResult = PapaParse.ParseResult;
export type ParseError = PapaParse.ParseError;

@Injectable()
export class ImportService {

  BASE_HREF = `${window.location.protocol}//${window.location.hostname}`

  constructor(private http: HttpClient) { }

  parseCSV(file: File, header: boolean = false): Promise<ParseResult | ParseError> {
    return new Promise((resolve, reject) => {
      parse(file, {
        header: header,
        skipEmptyLines: true,
        complete: resolve,
        error: reject,
      })
    });
  }

  async importCollaborators(data: any) {
    const endpoint = `${this.BASE_HREF}/api/collaborators/import`;
    return this.http.post<any | any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  async importInstitutions(data: any) {
    const endpoint = `${this.BASE_HREF}/api/institutions/import`;
    return this.http.post<any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }
}
