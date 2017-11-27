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

    let parseResults: ParseResult = {
      data: [],
      errors: [],
      meta: {
        delimiter: '',
        linebreak: '',
        aborted: false,
        fields: [],
        truncated: false,
      }
    };

    return new Promise((resolve, reject) => {
      parse(file, {
        header: header,
        skipEmptyLines: true,
        step: results => {
          let data = results.data[0];

          // parse as array
          if (Array.isArray(data)) {
            data = data.map(e => e === 'NULL' ? null : e);
          }

          // parse as object
          else {
            console.log('parse as object', data);
            for (let key in data) {
              console.log(key, data[key]);
              if (data[key] === 'NULL') {
                console.log('null found', data);
                data[key] = null;
              }
            }
          }

          parseResults.meta = results.meta;
          parseResults.data.push(data);
          parseResults.errors = {
            ...parseResults.errors,
            ...results.errors
          };
        },
        complete: () => resolve(parseResults),
        error: () => reject,
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
