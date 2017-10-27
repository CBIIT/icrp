import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';
import { SEARCH_ID, Location, LocationCounts, LocationFilters, ViewLevel } from '../services/DataService';

@AutoSubscribeStore
class Store extends StoreBase {

  loading: boolean = false;

  loadingMessage: string = 'Loading...';

  loadingSearchCriteria: boolean = false;

  locations: Location[];

  locationCounts: LocationCounts = {
    projects: 0,
    primaryInvestigators: 0,
    collaborators: 0,
  }

  locationFilters: LocationFilters = {
    searchId: SEARCH_ID,
    type: 'regions',
  }

  searchCriteria: any[][] = [['Loading...']];

  tablePage: number = 1;

  tablePageSize: number = 25;

  setTablePage(tablePage: number) {
    this.tablePage = tablePage;
    this.trigger();
  }

  setLoading(loading: boolean) {
    this.loading = loading;
    this.trigger();
  }

  setLoadingSearchCriteria(loadingSearchCriteria: boolean) {
    this.loadingSearchCriteria = loadingSearchCriteria;
    this.trigger();
  }

  setLoadingMessage(loadingMessage: string) {
    this.loadingMessage = loadingMessage;
    this.trigger();
  }

  setLocationCounts(locationCounts: LocationCounts) {
    this.locationCounts = locationCounts;
    this.trigger();
  }

  setLocations(locations: Location[]) {
    this.locations = locations;
    this.trigger();
  }

  setLocationFilters(locationFilters: LocationFilters) {
    this.locationFilters = locationFilters;
    this.trigger();
  }

  setSearchId(searchId: number) {
    this.locationFilters = {
      searchId: searchId,
      ...this.locationFilters
    }
    this.trigger();
  }

  setViewLevel(viewLevel: ViewLevel) {
    this.locationFilters = {
      type: viewLevel,
      ...this.locationFilters
    }
    this.trigger();
  }

  setRegion(region: string | undefined) {
    this.locationFilters = {
      region: region,
      ...this.locationFilters
    }
    this.trigger();
  }

  setCountry(country: string | undefined) {
    this.locationFilters = {
      country: country,
      ...this.locationFilters
    }
    this.trigger();
  }

  setSearchCriteria(searchCriteria: any[][]) {
    this.searchCriteria = searchCriteria;
    this.trigger();
  }

  @autoSubscribe
  getLocations() {
    return this.locations;
  }

  @autoSubscribe
  getLocationCounts() {
    return this.locationCounts;
  }

  @autoSubscribe
  getSearchCriteria() {
    return this.searchCriteria;
  }

  @autoSubscribe
  getLoadingMessage() {
    return this.loadingMessage;
  }

  @autoSubscribe
  isLoading() {
    return this.loading;
  }

  @autoSubscribe
  isLoadingSearchCriteria() {
    return this.loadingSearchCriteria;
  }

  @autoSubscribe
  getSearchId() {
    return this.locationFilters.searchId;
  }

  @autoSubscribe
  getRegion() {
    return this.locationFilters.region;
  }

  @autoSubscribe
  getCountry() {
    return this.locationFilters.country;
  }

  @autoSubscribe
  getLocationFilters() {
    return this.locationFilters;
  }

  @autoSubscribe
  getViewLevel() {
    return this.locationFilters.type;
  }

  @autoSubscribe
  getTablePage() {
    return this.tablePage;
  }

  @autoSubscribe
  getTablePageSize() {
    return this.tablePageSize;
  }
}

export const store = new Store();