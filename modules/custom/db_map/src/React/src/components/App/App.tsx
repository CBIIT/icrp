import * as React from 'react';
import * as qs from 'query-string';
import {
  GoogleMap,
  LocationSelector,
  MapOverlay,
  SearchCriteria,
  Spinner,
  SummaryGrid,
} from '..'
import * as DataService from '../../services/DataService';

import { excelExport } from '../../services/ExportService';
import { BASE_URL, getLocations, getNewSearchId, Location, MapLevelInterface, LocationApiInterface } from '../../services/DataService';


export interface ProjectCounts {
  projects: number;
  primaryInvestigators: number;
  collaborators: number;
}

export interface AppState {
  loading: boolean;
  loadingMessage: string;

  searchId: number;

  mapZoom: number;
  mapCenter: google.maps.LatLngLiteral;

  currentLevel: string; // regions, countries, cities

  filters: {
    region?: number;
    country?: string;
    city?: string;
  };

  locations: {
    regions: Location[],
    countries: Location[],
    cities: Location[]
  };

  searchCriteria: {
    summary: string,
    table: any[],
  };

  totalCounts: {
    regions: ProjectCounts,
    countries: ProjectCounts,
    cities: ProjectCounts,
  }
}

export default class App extends React.Component<{}, AppState> {

  state = {
    loading: true,
    loadingMessage: 'Loading Map...',

    searchId: 0,

    mapZoom: 2,
    mapCenter: {
      lat: 30,
      lng: 0,
    },

    currentLevel: 'regions',

    filters: {
      region: null,
      country: null,
      city: null
    },

    locations: {
      regions: [],
      countries: [],
      cities: [],
    },

    searchCriteria: {
      summary: 'All',
      table: [],
    },

    totalCounts: {
      regions: {
        projects: 0,
        primaryInvestigators: 0,
        collaborators: 0,
      },

      countries: {
        projects: 0,
        primaryInvestigators: 0,
        collaborators: 0,
      },

      cities: {
        projects: 0,
        primaryInvestigators: 0,
        collaborators: 0,
      },
    },
  }

  async componentDidMount() {
    await this.fetchData({
      searchId: qs.parse(window.location.search).sid || 0,
      type: 'region',
    });
  }

  async fetchData(parameters: LocationApiInterface) {
    let { searchId } = parameters;
    let { totalCounts, locations, currentLevel } = this.state;

    let data = await getLocations(parameters);
    let searchParameters = await DataService.getSearchParameters(searchId);

    totalCounts[currentLevel] = data.counts;
    locations[currentLevel] = data.locations;

    let searchCriteria = {
      summary: searchParameters.length > 0
        ? searchParameters
            .map(e => e[0].toString().replace(':', '').trim())
            .filter(e => e.length > 0)
            .join(' + ')
        : 'All',
      table: searchParameters,
    }

    this.setState({
      searchId: searchId,
      locations: locations,
      totalCounts: totalCounts,
      searchCriteria: searchCriteria,
      loading: false,
    });
  }

  async redirectToSearchPage(searchId: number, region?: number, country?: string, city?: string) {
    this.setState({
      loading: true,
      loadingMessage: 'Loading Search Page...'
    });

    let response = await getNewSearchId(searchId, region, country, city);
    let uri = `${BASE_URL}/db_search/?sid=${response.newSearchId}`;
    window.document.location.href = uri;
  }

  async export() {
    let { searchCriteria, locations, currentLevel } = this.state;

    let type = {
      regions: 'Region',
      countries: 'Country',
      cities: 'City',
    }[currentLevel];

    excelExport({
      searchCriteria: searchCriteria,
      locations: locations[currentLevel],
      type: type,
    })
  }

  async selectLocation(location: Location) {

    this.setState({
      loading: true,
      loadingMessage: 'Fetching data...',
    });

    let { searchId, currentLevel } = this.state;
    let { value } = location;

    // assuming we always drill down, we can use an object map
    // to determine the next type of map view
    let newLevel = {
      regions: 'countries',
      countries: 'cities',
    }[currentLevel];

    let type = {
      regions: 'region',
      countries: 'country',
      cities: 'city',
    }[newLevel];

    await this.setState({
      currentLevel: newLevel,
    });

    await this.fetchData({
      searchId: searchId,
      type: type,
      region: value.toString(),
    });


    console.log(location)
  }

  render() {
    let {
      loading,
      loadingMessage,

      searchId,

      mapCenter,
      mapZoom,

      currentLevel,
      filters,

      locations,
      searchCriteria,
      totalCounts,
    } = this.state;


    let currentLocations = locations[currentLevel];
    let counts = totalCounts[currentLevel];

    let type = {
      regions: 'Region',
      countries: 'Country',
      cities: 'City',
    }[currentLevel];

    return (
      <div>
        <Spinner visible={loading} message={loadingMessage} />
        <SearchCriteria searchCriteria={searchCriteria} counts={counts} />
        <div className="text-right margin-top">
          <a
            className="cursor-pointer"
            onClick={event => this.redirectToSearchPage(searchId)}>
            View ICRP Data
          </a>
        </div>
        <div className="position-relative">
          <MapOverlay>
            <LocationSelector />
          </MapOverlay>
          <GoogleMap
            autofit={true}
            coordinates={mapCenter}
            locations={currentLocations}
            zoom={mapZoom}
            showMapLabels={currentLevel !== 'regions'}
            showDataLabels={currentLevel === 'regions'}
            onSelect={location => this.selectLocation(location)}
          />
        </div>

        {
          currentLocations.length > 0 &&
          <button
            className="btn btn-default btn-sm margin-top margin-bottom"
            onClick={event => this.export()}
          >
            <div className="display-flex align-items-center">
              <svg width="12px" height="12px" viewBox="0 0 16 16">
                <g stroke="none" strokeWidth="1" fillRule="evenodd" fill="#000000">
                  <path d="M4,6 L7,6 L7,0 L9,0 L9,6 L12,6 L8,10 L4,6 L4,6 Z M15,2 L11,2 L11,3 L15,3 L15,11 L1,11 L1,3 L5,3 L5,2 L1,2 C0.45,2 0,2.45 0,3 L0,12 C0,12.55 0.45,13 1,13 L6.34,13 C6.09,13.61 5.48,14.39 4,15 L12,15 C10.52,14.39 9.91,13.61 9.66,13 L15,13 C15.55,13 16,12.55 16,12 L16,3 C16,2.45 15.55,2 15,2 L15,2 Z" id="Shape"></path>
                </g>
              </svg>
              <span className="margin-left">
                Export
              </span>
            </div>
          </button>
        }

        <SummaryGrid
          locations={currentLocations}
          filters={filters}
          type={currentLevel}
          searchId={searchId}
          onSelect={
            ({searchId, region, country, city}: MapLevelInterface) =>
              this.redirectToSearchPage(searchId, region, country, city)
          } />
      </div>
    );
  }

}