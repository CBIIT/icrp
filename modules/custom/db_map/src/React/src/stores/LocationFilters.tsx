import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';
import { LocationApiRequest, ViewLevel } from '../services/DataService';

@AutoSubscribeStore
class LocationFilters extends StoreBase {

  locationApiRequest: LocationApiRequest = {searchId: 0}

  setSearchId(searchId: number) {
    this.locationApiRequest = {
      searchId: searchId,
      ...this.locationApiRequest
    }
    this.trigger();
  }

  setViewLevel(viewLevel: ViewLevel) {
    this.locationApiRequest = {
      type: viewLevel,
      ...this.locationApiRequest
    }
    this.trigger();
  }

  setRegion(region: string) {
    this.locationApiRequest = {
      region: region,
      ...this.locationApiRequest
    }
    this.trigger();
  }

  setApiRequest(locationApiRequest: LocationApiRequest) {
    this.locationApiRequest = locationApiRequest;
    this.trigger();
  }

  @autoSubscribe
  getSearchId() {
    return this.locationApiRequest.searchId;
  }

  @autoSubscribe
  getViewLevel() {
    return this.locationApiRequest.type;
  }

  @autoSubscribe
  getRegion() {
    return this.locationApiRequest.region;
  }

  @autoSubscribe
  getApiRequest() {
    return this.locationApiRequest;
  }
}

export const locationFilters = new LocationFilters();