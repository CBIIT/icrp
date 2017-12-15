import { parse, stringify } from 'query-string';

export type ViewLevel = 'regions' | 'countries' | 'cities' | 'institutions';

/**
 * Defines LocationCounts,
 * which contain the associated data
 * for a particular location.
 */
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
  state?: string;
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
  await jsonRequest(`${BASE_URL}/map/getLocations?${stringify(params)}`, {
    credentials: 'same-origin'
  });

export const getSearchParameters = async (searchId: number): Promise<any[][]> =>
  await jsonRequest(`${BASE_URL}/map/getSearchParameters?${stringify({searchId})}`, {
    credentials: 'same-origin'
  });

export const getNewSearchId = async (filters: LocationFilters): Promise<number> =>
  await jsonRequest(`${BASE_URL}/map/getNewSearchId?${stringify(filters)}`, {
    credentials: 'same-origin'
  });

export const getSearchParametersFromFilters = async(filters: LocationFilters): Promise<any[][]> =>
  await getSearchParameters(await getNewSearchId(filters));

export const parseViewLevel = (viewLevel: ViewLevel): string => ({
  regions: 'Region',
  countries: 'Country',
  cities: 'City',
  institutions: 'Institution',
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

  let filters = {
    ...locationFilters,
    type: getNextViewLevel(locationFilters.type),
    [key]: location.value,
  };

  delete filters.state;

  if (key === 'city') {
    let labels = location.label.split(',');
    if (labels.length > 1) {
      let state = (labels.pop() as String).trim();
      if (state && /^[A-Za-z0-9]{2,15}$/.test(state))
        filters.state = state;
    }
  }

  // console.log('called getNextLocationFilters', location, locationFilters, filters);

  return filters;
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


export const getCountryFromAbbreviation = (abbreviation: string) => ({"AD":"Andorra","AE":"United Arab Emirates","AF":"Afghanistan","AG":"Antigua and Barbuda","AI":"Anguilla","AL":"Albania","AM":"Armenia","AO":"Angola","AQ":"Antarctica","AR":"Argentina","AS":"American Samoa","AT":"Austria","AU":"Australia","AW":"Aruba","AX":"Åland Island","AZ":"Azerbaijan","BA":"Bosnia and Herzegovina","BB":"Barbados","BD":"Bangladesh","BE":"Belgium","BF":"Burkina Faso","BG":"Bulgaria","BH":"Bahrain","BI":"Burundi","BJ":"Benin","BL":"Saint Barthélemy","BM":"Bermuda","BN":"Brunei Darussalam","BO":"Bolivia, Plurinational State Of","BQ":"Bonaire, Sint Eustatius and Saba","BR":"Brazil","BS":"Bahamas","BT":"Bhutan","BV":"Bouvet Island","BW":"Botswana","BY":"Belarus","BZ":"Belize","CA":"Canada","CC":"Cocos (Keeling) Islands","CD":"Congo, The Democratic Republic Of The","CF":"Central African Republic","CG":"Congo","CH":"Switzerland","CI":"Cote d'Ivoire","CK":"Cook Islands","CL":"Chile","CM":"Cameroon","CN":"China","CO":"Colombia","CR":"Costa Rica","CU":"Cuba","CV":"Cape Verde","CW":"Curacao","CX":"Christmas Island","CY":"Cyprus","CZ":"Czech Republic","DE":"Germany","DJ":"Djibouti","DK":"Denmark","DM":"Dominica","DO":"Dominican Republic","DZ":"Algeria","EC":"Ecuador","EE":"Estonia","EG":"Egypt","EH":"Western Sahara","ER":"Eritrea","ES":"Spain","ET":"Ethiopia","FI":"Finland","FJ":"Fiji","FK":"Falkland Islands (Malvinas)","FM":"Micronesia, Federated States Of","FO":"Faroe Islands","FR":"France","GA":"Gabon","GD":"Grenada","GE":"Georgia","GF":"French Guiana","GG":"Guernsey","GH":"Ghana","GI":"Gibraltar","GL":"Greenland","GM":"Gambia","GN":"Guinea","GP":"Guadeloupe","GQ":"Equatorial Guinea","GR":"Greece","GS":"South Georgia And The South Sandwich Islands","GT":"Guatemala","GU":"Guam","GW":"Guinea-Bissau","GY":"Guyana","HK":"Hong Kong","HM":"Heard Island and McDonald Islands","HN":"Honduras","HR":"Croatia","HT":"Haiti","HU":"Hungary","ID":"Indonesia","IE":"Ireland","IL":"Israel","IM":"Isle Of Man","IN":"India","IO":"British Indian Ocean Territory","IQ":"Iraq","IR":"Iran, Islamic Republic Of","IS":"Iceland","IT":"Italy","JE":"Jersey","JM":"Jamaica","JO":"Jordan","JP":"Japan","KE":"Kenya","KG":"Kyrgyzstan","KH":"Cambodia","KI":"Kiribati","KM":"Comoros","KN":"Saint Kitts And Nevis","KP":"Korea, Democratic People's Republic of","KR":"Korea, Republic of","KW":"Kuwait","KY":"Cayman Islands","KZ":"Kazakhstan","LA":"Lao People's Democratic Republic","LB":"Lebanon","LC":"Saint Lucia","LI":"Liechtenstein","LK":"Sri Lanka","LR":"Liberia","LS":"Lesotho","LT":"Lithuania","LU":"Luxembourg","LV":"Latvia","LY":"Libyan Arab Jamahiriya","MA":"Morocco","MC":"Monaco","MD":"Moldova, Republic Of","ME":"Montenegro","MF":"Saint Martin (French Part)","MG":"Madagascar","MH":"Marshall Islands","MK":"Macedonia, The Former Yugoslav Republic Of","ML":"Mali","MM":"Myanmar","MN":"Mongolia","MO":"Macao","MP":"Northern Mariana Islands","MQ":"Martinique","MR":"Mauritania","MS":"Montserrat","MT":"Malta","MU":"Mauritius","MV":"Maldives","MW":"Malawi","MX":"Mexico","MY":"Malaysia","MZ":"Mozambique","NA":"Namibia","NC":"New Caledonia","NE":"Niger","NF":"Norfolk Island","NG":"Nigeria","NI":"Nicaragua","NL":"Netherlands","NO":"Norway","NP":"Nepal","NR":"Nauru","NU":"Niue","NZ":"New Zealand","OM":"Oman","PA":"Panama","PE":"Peru","PF":"French Polynesia","PG":"Papua New Guinea","PH":"Philippines","PK":"Pakistan","PL":"Poland","PM":"Saint Pierre And Miquelon","PN":"Pitcairn","PR":"Puerto Rico","PS":"Palestinian Territory, Occupied","PT":"Portugal","PW":"Palau","PY":"Paraguay","QA":"Qatar","RE":"Réunion","RO":"Romania","RS":"Serbia","RU":"Russian Federation","RW":"Rwanda","SA":"Saudi Arabia","SB":"Solomon Islands","SC":"Seychelles","SD":"Sudan","SE":"Sweden","SG":"Singapore","SH":"Saint Helena, Ascension And Tristan Da Cunha","SI":"Slovenia","SJ":"Svalbard and Jan Mayen","SK":"Slovakia","SL":"Sierra Leone","SM":"San Marino","SN":"Senegal","SO":"Somalia","SR":"Suriname","SS":"South Sudan","ST":"Sao Tome and Principe","SV":"El Salvador","SX":"Sint Maarten (Dutch Part)","SY":"Syrian Arab Republic","SZ":"Swaziland","TC":"Turks and Caicos Islands","TD":"Chad","TF":"French Southern Territories","TG":"Togo","TH":"Thailand","TJ":"Tajikistan","TK":"Tokelau","TL":"Timor-Leste","TM":"Turkmenistan","TN":"Tunisia","TO":"Tonga","TR":"Turkey","TT":"Trinidad and Tobago","TV":"Tuvalu","TW":"Taiwan, Province Of China","TZ":"Tanzania, United Republic Of","UA":"Ukraine","UG":"Uganda","UK":"United Kingdom","UM":"United States Minor Outlying Islands","US":"United States","UY":"Uruguay","UZ":"Uzbekistan","VA":"Holy See (Vatican City State)","VC":"Saint Vincent And The Grenadines","VE":"Venezuela, Bolivarian Republic Of","VG":"Virgin Islands, British","VI":"Virgin Islands, U.S.","VN":"Viet Nam","VU":"Vanuatu","WF":"Wallis and Futuna","WS":"Samoa","YE":"Yemen","YT":"Mayotte","ZA":"South Africa","ZM":"Zambia","ZW":"Zimbabwe"})[abbreviation || 'Country'];
