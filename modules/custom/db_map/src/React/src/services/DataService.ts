import { stringify } from 'query-string';
import { ExcelSheet } from './ExportService';

export interface Location {
  label: string;
  value: string;
  coordinates: google.maps.LatLngLiteral;
  data: {
    relatedProjects: number;
    primaryInvestigators: number;
    collaborators: number;
  }
}

export interface LocationFilters {
  searchId: number;
  region?: string;
  country?: string;
  city?: string;
}

export interface ApiParameters {
  searchId: number;
  type?: 'region' | 'country' | 'city';
  region?: string;
  country?: string;
}

export interface ApiResponse {
  locations: Location[];
  counts: {
    projects: number,
    primaryInvestigators: number,
    collaborators: number,
  };
}

export const BASE_URL = `${window.location.protocol}//${window.location.hostname}`;

export const jsonRequest = async (url: string, params: object) => {
  let response = await fetch(url, params);
  return await response.json();
}

export const getLocations = async (params: ApiParameters): Promise<ApiResponse> =>
  await jsonRequest(`${BASE_URL}/map/getLocations/?${stringify(params)}`, {
    credentials: 'same-origin'
  });

export const getSearchParameters = async (searchId: number): Promise<(string|number)[][]> =>
  await jsonRequest(`${BASE_URL}/map/getSearchParameters/?${stringify({searchId})}`, {
    credentials: 'same-origin'
  });

export const getExcelExport = async (data: ExcelSheet[]): Promise<string> =>
  await jsonRequest(`${BASE_URL}/map/getExcelExport/`, {
    method: 'POST',
    body: JSON.stringify(data),
    credentials: 'same-origin'
  });

export const getNewSearchId = async (filters: LocationFilters): Promise<number> =>
  await jsonRequest(`${BASE_URL}/map/getNewSearchId/?${stringify(filters)}`, {
    credentials: 'same-origin'
  });

export const getSearchParametersFromFilters = async(filters: LocationFilters): Promise<(string|number)[][]> =>
  await getSearchParameters(await getNewSearchId(filters));