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
import { BASE_URL, getRegions, getExcelExport, getNewSearchId, Location, ExcelSheet, MapLevelInterface } from '../../services/DataService';

export interface AppState {
  loading: boolean;
  loadingMessage: string;
  zoom: number;
  coordinates: google.maps.LatLngLiteral;
  locations: Location[];
  searchId: number;

  searchCriteria: {
    summary: string,
    parsed: object,
    table: any[],
  };

  totalCounts: {
    projects: number,
    primaryInvestigators: number,
    collaborators: number,
  }
}

export default class App extends React.Component<{}, AppState> {

  state = {
    loading: true,
    loadingMessage: 'Loading Map...',
    zoom: 2,
    coordinates: {
      lat: 30,
      lng: 0,
    },
    locations: [],
    searchId: 0,
    searchCriteria: {
      summary: 'All',
      parsed: {},
      table: [],
    },
    totalCounts: {
      projects: 0,
      primaryInvestigators: 0,
      collaborators: 0,
    }
  }

  async componentDidMount() {
    let searchId = qs.parse(window.location.search).sid || 0;
    let data = await getRegions(searchId);
    let searchParameters = await DataService.getSearchParameters(searchId);

    let searchCriteria = {
      summary: searchParameters.length > 0
        ? searchParameters
            .map(e => e[0].toString().replace(':', '').trim())
            .filter(e => e.length > 0)
            .join(' + ')
        : 'All',
      table: searchParameters,
      parsed: {},
    }

    this.setState({
      searchId: searchId,
      locations: data.locations,
      totalCounts: data.counts,
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
    let uri = `${BASE_URL}/db_search/?sid=${response['newSearchId']}`;
    window.document.location.href = uri;
    this.setState({
      loading: false
    });
  }


  async export() {

    let {searchCriteria} = this.state;
    let locations: Location[] = this.state.locations;

    let searchCriteriaRows = [['Search Criteria: ', searchCriteria.summary],]
      .concat(searchCriteria.table);

    let exportData: (string | number)[][] = [['Region', 'Total Projects', 'Total PIs', 'Total Collaborators']];
    exportData = exportData.concat(locations.map(row => [
      row.label,
      row.data.relatedProjects,
      row.data.primaryInvestigators,
      row.data.collaborators,
    ]))

    let sheets: ExcelSheet[] = [
      {
        title: 'Search Criteria',
        rows: searchCriteriaRows
      },
      {
        title: 'Data',
        rows: exportData
      }
    ];

    let uri = `${BASE_URL}/${await getExcelExport(sheets)}`;
    window.document.location.href = uri;
  }

  render() {
    let {
      loading,
      loadingMessage,
      locations,
      coordinates,
      zoom,
      searchId,
      searchCriteria,
      totalCounts,
    } = this.state;

    return (
      <div>
        <Spinner visible={loading} message={loadingMessage} />
        <SearchCriteria searchCriteria={searchCriteria} counts={totalCounts} />
        <div className="text-right margin-top">
          <a className="cursor-pointer" onClick={event => this.redirectToSearchPage(searchId)}>View ICRP Data</a>
        </div>
        <div className="position-relative">
          <MapOverlay>
            <LocationSelector />
          </MapOverlay>
          <GoogleMap
            coordinates={coordinates}
            locations={locations}
            zoom={zoom}
          />
        </div>

        {
          locations.length > 0 &&
          <button
            className="btn btn-default btn-sm margin-top margin-bottom"
            onClick={event => this.export()}
          >
            <div className="display-flex align-items-center">
              <svg width="12px" height="12px" viewBox="0 0 16 16" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <g id="desktop-download" stroke="none" stroke-width="1" fill-rule="evenodd" fill="#000000">
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
          locations={locations}
          type="Region"
          searchId={searchId}
          onSelect={
            ({searchId, region, country, city}: MapLevelInterface) =>
              this.redirectToSearchPage(searchId, region, country, city)
          } />
      </div>
    );
  }

}