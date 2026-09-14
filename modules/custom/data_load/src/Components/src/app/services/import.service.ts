import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { parse, ParseError, ParseResult } from 'papaparse';

export type { ParseError, ParseResult }

@Injectable()
export class ImportService {

  BASE_HREF = `${window.location.protocol}//${window.location.hostname}`

  constructor(private http: HttpClient) { }

  parseCSV(file: File, header: boolean = false): Promise<ParseResult<any> | ParseError> {

    let parseResults: ParseResult<any> = {
      data: [],
      errors: [],
      meta: {
        delimiter: '',
        linebreak: '',
        aborted: false,
        fields: [],
        truncated: false,
        cursor: 0,
      }
    };

    return new Promise((resolve, reject) => {
      parse(file, {
        header: header,
        skipEmptyLines: true,
        step: results => {
          let data: (object|Array<any>) = results.data as (object|Array<any>);

          // parse as array
          if (Array.isArray(data)) {
            data = data.map(e => e === 'NULL' ? null : e);
          }

          // parse as object
          else {
            for (let key in data) {
              if (data[key] === 'NULL') {
                data[key] = null;
              }
            }
          }

          parseResults.meta = results.meta;
          parseResults.data.push(data);
          parseResults.errors = {
            ...parseResults.errors,
            ...results.errors
          } as any;
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
