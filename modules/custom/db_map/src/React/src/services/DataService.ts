import { stringify } from 'query-string';

export interface Location {
  label: string;
  value: string | number;
  coordinates: google.maps.LatLngLiteral;
  data: {
    relatedProjects: number;
    primaryInvestigators: number;
    collaborators: number;
  }
}

export interface ExcelSheet {
  title: string;
  rows: (number|string)[][];
}

export interface RegionInterface {
  locations: Location[];
  counts: {
    projects: number,
    primaryInvestigators: number,
    collaborators: number,
  };
}

export const BASE_URL = `${window.location.protocol}//${window.location.hostname}`;

export const request = async (url: string, params: object) => {
  let response = await fetch(url, params);
  return await response.json();
}

export const getRegions = async (searchId: number): Promise<RegionInterface> =>
  await request(`${BASE_URL}/map/getRegions/?${stringify({searchId})}`, {
    credentials: 'same-origin'
  });


export const getSearchParameters = async (searchId: number): Promise<(string|number)[][]> =>
  await request(`${BASE_URL}/map/getSearchParameters/?${stringify({searchId})}`, {
    credentials: 'same-origin'
  });

export const getExcelExport = async(data: ExcelSheet[]): Promise<string> =>
  await request(`${BASE_URL}/map/getExcelExport/`, {
    method: 'POST',
    body: JSON.stringify(data),
    credentials: 'same-origin'
  });
