import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { parse } from 'papaparse';

type ParseResult = PapaParse.ParseResult;
type ParseError = PapaParse.ParseError;

@Injectable()
export class ImportService {

  BASE_HREF = `${window.location.protocol}//${window.location.hostname}`

  constructor(private http: HttpClient) { }

  parseCSV(file: File): Promise<any[] | ParseError> {
    return new Promise((resolve, reject) => {
      parse(file, {
        header: false,
        skipEmptyLines: true,
        complete: result =>  resolve(result.data.slice(1)),
        error: error => resolve(error)
      })
    });
  }

  async importCollaborators(files: FileList) {
    const data = await this.parseCSV(files[0]);
    const endpoint = `${this.BASE_HREF}/api/collaborators/import`;
    return this.http.post<any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }

  async importInstitutions(files: FileList) {
    const data = await this.parseCSV(files[0]);
    const endpoint = `${this.BASE_HREF}/api/institutions/import`;
    return this.http.post<any[]>(endpoint, JSON.stringify(data), {
      withCredentials: window.location.hostname === window.location.host,
    });
  }
}
