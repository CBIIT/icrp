import * as React from 'react';
import { ComponentBase } from 'resub';
import * as qs from 'query-string';

import { globalStore } from '../../stores/GlobalStore';
import { loadState } from '../../stores/loadState';
import { locationFilters } from '../../stores/LocationFilters';
import { locations } from '../../stores/Locations';
import { searchCriteria } from '../../stores/SearchCriteria';

import {
  GoogleMap,
  LocationSelector,
  MapOverlay,
  SearchCriteria,
  Spinner,
  SummaryGrid,
  ExportButton,
} from '..'

import {
  BASE_URL,
  getLocations,
  getNewSearchId,
  Location,
  LocationCounts,
  LocationApiRequest,
  ViewLevel
} from '../../services/DataService';

export interface AppState {
  loading: boolean;
  loadingMessage: string;

  searchId: number;
  viewLevel: ViewLevel
  filters: LocationApiRequest;
  locations: Location[];
  searchCriteria: (string|number)[][];
  totalCounts: LocationCounts
}

export default class App extends ComponentBase<{}, AppState> {

  _buildState(): AppState {
    return {
      loading: loadState.isLoading(),
      loadingMessage: loadState.getLoadingMessage(),

      searchId: locationFilters.getSearchId(),
      viewLevel: locationFilters.getViewLevel(),
      filters: locationFilters.getApiRequest(),

      locations: locations.get(),
      searchCriteria: searchCriteria.get(),
      totalCounts: globalStore.getLocationCounts(),
    }
  }

  async componentDidMount() {
    loadState.set(true);
    loadState.setMessage('Loading Map...');
    locationFilters.setSearchId(+qs.parse(window.location.search).sid || 0)
    locationFilters.setViewLevel('regions');

    let response = await getLocations(locationFilters.getApiRequest());
    globalStore.setLocationCounts(response.counts);
    locations.set(response.locations);
    loadState.set(false);
  }

  async redirectToSearchPage(locationApiRequest: LocationApiRequest) {
    loadState.set(true);
    loadState.setMessage('Loading Search Page...');
    let searchId = getNewSearchId(locationApiRequest);
    let uri = `${BASE_URL}/db_search/?sid=${searchId}`;
    window.document.location.href = uri;
  }

  async selectLocation(locationApiRequest: LocationApiRequest) {
    loadState.set(true);
    loadState.setMessage('Loading Map...');

    let response = await getLocations(locationApiRequest);

    locations.set(response.locations);
    globalStore.setLocationCounts(response.counts);
    locationFilters.setApiRequest(locationApiRequest);
    loadState.set(false);
  }

  render() {
    let {
      loading,
      loadingMessage,
      viewLevel,
      searchId,
      locations,
      totalCounts
    } = this.state;

    let criteria = {
      table: searchCriteria.get(),
      summary: searchCriteria.getSummary(),
    }

    return (
      <div>
        <Spinner visible={loading} message={loadingMessage} />
        <SearchCriteria searchCriteria={criteria} counts={totalCounts} />
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
            locations={locations}
            viewLevel={viewLevel}
            showMapLabels={viewLevel !== 'regions'}
            showDataLabels={viewLevel === 'regions'}
            onSelect={location => this.selectLocation(location)}
          />
        </div>

        <ExportButton />
        <SummaryGrid onSelect={locationApiRequest => this.redirectToSearchPage(locationApiRequest)} />
      </div>
    );
  }

}