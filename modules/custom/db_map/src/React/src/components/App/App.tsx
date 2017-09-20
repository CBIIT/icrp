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
            <span className="margin-right">
              Export
            </span>
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