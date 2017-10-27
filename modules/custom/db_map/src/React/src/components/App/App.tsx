import * as React from 'react';
import { ComponentBase } from 'resub';
import { store } from '../../services/Store';

import {
  GoogleMap,
  ViewLevelSelector,
  MapOverlay,
  SearchCriteria,
  LoadingSpinner,
  SummaryGrid,
  ExportButton,
} from '..'

import {
  BASE_URL,
  SEARCH_ID,

  getLocations,
  getNewSearchId,
  getSearchParameters,
  getSearchParametersFromFilters,

  Location,
  LocationCounts,
  LocationFilters,
  ViewLevel,
} from '../../services/DataService';

export interface AppState {
  viewLevel: ViewLevel;
  locationFilters: LocationFilters;
  locations: Location[];
  searchCriteria: any[][];
  locationCounts: LocationCounts
}

export default class App extends ComponentBase<{}, AppState> {

  initialLoad = true;

  _buildState(): AppState {
    return {
      viewLevel: store.getViewLevel(),
      locationFilters: store.getLocationFilters(),

      locations: store.getLocations(),
      searchCriteria: store.getSearchCriteria(),
      locationCounts: store.getLocationCounts(),
    }
  }

  async componentDidMount() {
    const { locationFilters } = this.state;
    store.setLoading(true);
    store.setLoadingMessage('Loading Map...');
    this.selectLocation(locationFilters);
  }

  async redirectToSearchPage(locationFilters: LocationFilters) {
    store.setLoading(true);
    store.setLoadingMessage('Loading Search Page...');

    if (SEARCH_ID == 0 && !locationFilters.country && !locationFilters.region) {
      let searchId = 0;
      let uri = `${BASE_URL}/db_search/?sid=${searchId}`;
      window.document.location.href = uri;
    }

    else {
      let searchId = await getNewSearchId(locationFilters);
      let uri = `${BASE_URL}/db_search/?sid=${searchId}`;
      window.document.location.href = uri;
    }
  }

  async selectLocation(locationFilters: LocationFilters) {
    store.setLoading(true);
    store.setSearchCriteria([['Loading...']]);
    store.setLoadingMessage('Loading Map...');
    let response = await getLocations(locationFilters);
    store.setLocationFilters(locationFilters);
    store.setLocationCounts(response.counts);
    store.setLocations(response.locations);
    store.setLoading(false);
    this.updateSearchCriteria();
  }

  async updateSearchCriteria() {
    const { locationFilters } = this.state;
    store.setSearchCriteria([['Loading...']]);

    console.log('inital view', this.initialLoad);

    if (this.initialLoad) {
      let response = await getSearchParameters(SEARCH_ID);
      store.setSearchCriteria(response);
      this.initialLoad = false;
    }

    else {
      let response = await getSearchParametersFromFilters(locationFilters);
      store.setSearchCriteria(response);
    }
  }

  render() {
    let {
      viewLevel,
      locations,
      locationCounts,
      searchCriteria,
      locationFilters,
    } = this.state;

    return (
      <div>
        <LoadingSpinner />
        <SearchCriteria searchCriteria={searchCriteria} counts={locationCounts} />
        <div className="text-right margin-top">
          <a
            className="cursor-pointer"
            onClick={event => this.redirectToSearchPage(locationFilters)}>
            View ICRP Data
          </a>
        </div>
        <div className="position-relative">
          <MapOverlay>
            <ViewLevelSelector onSelect={locationFilters => this.selectLocation(locationFilters)} />
          </MapOverlay>
          <GoogleMap
            locations={locations}
            viewLevel={viewLevel}
            locationFilters={locationFilters}
            showMapLabels={viewLevel !== 'regions'}
            showDataLabels={viewLevel === 'regions'}
            onSelect={locationFilters => this.selectLocation(locationFilters)}
          />
        </div>

        <SummaryGrid onSelect={locationFilters => this.redirectToSearchPage(locationFilters)}>
          <ExportButton />
        </SummaryGrid>

      </div>
    );
  }

}