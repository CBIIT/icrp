import { stringify } from 'query-string';
import { ExcelSheet } from './ExportService';

/**
 * Defines a Location, which represents the projects
 * for a specified region, country, or city.
 *
 * label - the display label for this location
 *
 * value - the value used internally to perform queries
 *
 * coordinates - the latitude/longitude for this location
 *
 * data - any additional information about this location
 *
 * @export
 * @interface Location
 */
export interface Location {
  label: string;
  value: string;
  coordinates: google.maps.LatLngLiteral;
  data: {
    projects: number;
    primaryInvestigators: number;
    collaborators: number;
  }
}

/**
 * Defines the type of filters used to
 *
 * @export
 * @interface LocationFilters
 */
export interface LocationFilters {
  searchId: number;
  region?: string;
  country?: string;
  city?: string;
}

/**
 * Defines the parameters used to fetch information
 * on a set of Locations.
 *
 * By specifying a type, we may request various
 * types of locations.
 *
 * For example, to request regions given a particular
 * search id, we would specify the type as 'region'
 *
 * To request country locations, we would specify
 * the type as 'country', and in addition provide
 * a region (based on the region id, which is the
 * Location's 'value' property)
 *
 * To request city locations, we would specify
 * the type as 'city', and provide the region id,
 * as well as the country id.
 *
 * @export
 * @interface LocationApiRequest
 */
export interface LocationApiRequest {
  searchId: number;
  type: 'region' | 'country' | 'city';
  region?: string;
  country?: string;
}

/**
 * Represents the response from getLocations
 * This response contains the locations of the
 * specified type (region, country, or city)
 * as well as the total numbers of related
 * projects, primary investigators, and
 * collaborators
 *
 * @export
 * @interface LocationApiResponse
 */
export interface LocationApiResponse {
  locations: Location[];
  counts: {
    projects: number,
    primaryInvestigators: number,
    collaborators: number,
  };
}

/**
 * The base url used to make all api requests
 */
export const BASE_URL = `${window.location.protocol}//${window.location.hostname}`;

export const jsonRequest = async (url: string, params: object) => {
  let response = await fetch(url, params);
  return await response.json();
}

export const getLocations = async (params: LocationApiRequest): Promise<LocationApiResponse> =>
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