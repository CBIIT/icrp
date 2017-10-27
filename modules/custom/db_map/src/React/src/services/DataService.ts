import { parse, stringify } from 'query-string';

export type ViewLevel = 'regions' | 'countries' | 'cities' | 'institutions';

export interface LocationCounts {
  projects: number;
  primaryInvestigators: number;
  collaborators: number;
}

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
  counts: LocationCounts
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
export interface LocationFilters {
  searchId: number;
  type: ViewLevel;
  region?: string;
  country?: string;
  city?: string;
  institution?: string;
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
 * @interface LocationResponse
 */
export interface LocationResponse {
  locations: Location[];
  counts: LocationCounts;
}

/**
 * The base url used to make all api requests
 */
export const BASE_URL = `${window.location.protocol}//${window.location.hostname}`;

export const SEARCH_ID = +parse(window.location.search).sid || 0;

export const jsonRequest = async (url: string, params: object) => {
  let response = await fetch(url, params);
  return await response.json();
}

export const getLocations = async (params: LocationFilters): Promise<LocationResponse> =>
  await jsonRequest(`${BASE_URL}/map/getLocations/?${stringify(params)}`, {
    credentials: 'same-origin'
  });

export const getSearchParameters = async (searchId: number): Promise<any[][]> =>
  await jsonRequest(`${BASE_URL}/map/getSearchParameters/?${stringify({searchId})}`, {
    credentials: 'same-origin'
  });

export const getNewSearchId = async (filters: LocationFilters): Promise<number> =>
  await jsonRequest(`${BASE_URL}/map/getNewSearchId/?${stringify(filters)}`, {
    credentials: 'same-origin'
  });

export const getSearchParametersFromFilters = async(filters: LocationFilters): Promise<any[][]> =>
  await getSearchParameters(await getNewSearchId(filters));

export const parseViewLevel = (viewLevel: ViewLevel): string => ({
  regions: 'Region',
  countries: 'Country',
  cities: 'City',
  institutions: 'Institutions',
}[viewLevel])

export const summarizeCriteria = (criteria: any[][]): string =>
  criteria.length > 0
  ? criteria
    .map(row => row[0].toString().replace(':', '').trim())
    .filter(str => str.length > 0)
    .join(' + ')
  : 'All';

export const getNextViewLevel = (viewLevel: ViewLevel): ViewLevel => ({
  regions: 'countries',
  countries: 'cities',
  cities: 'institutions',
}[viewLevel])

export const getNextLocationFilters = (location: Location, locationFilters: LocationFilters): LocationFilters => {
  let key = {
    regions: 'region',
    countries: 'country',
    cities: 'city',
    institutions: 'institution',
  }[locationFilters.type];

  return {
    ...locationFilters,
    type: getNextViewLevel(locationFilters.type),
    [key]: location.value,
  };
}

export const getRegionFromId = (regionId: string | undefined) => ({
  '1': 'North America',
  '2': 'Latin America & Caribbean',
  '3': 'Europe & Central Asia',
  '4': 'South Asia',
  '5': 'East Asia & Pacific',
  '6': 'Middle East & North Africa',
  '7': 'Sub-Saharan Africa',
  '8': 'Australia & New Zealand',
  '0': 'Region',
})[regionId || '0'];


