import { stringify } from 'query-string';

export interface Location {
  label: string;
  value: string;
  coordinates: {
    latitude: number;
    longitude: number;
  }
  data: {
    relatedProjects: number;
    primaryInvestigators: number;
    collaborators: number;
  }
}

export const BASE_URL = `${window.location.protocol}//${window.location.hostname}`;

export const getRequest = async (url: string, params: object) => {
  let response = await fetch(url, params);
  return await response.json();
}

export const getRegions = async (searchId: number):
  Promise<{
    locations: Location[],
    counts: {
      projects: number,
      primaryInvestigators: number,
      collaborators: number,
    }
  }> =>
  await getRequest(`${BASE_URL}/map/getRegions/?${stringify({searchId})}`, {
    credentials: 'same-origin'
  });