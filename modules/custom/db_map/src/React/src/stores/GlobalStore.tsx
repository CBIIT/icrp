import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';
import { LocationCounts } from '../services/DataService';

@AutoSubscribeStore
class GlobalStore extends StoreBase {

  locationCounts: LocationCounts = {
    projects: 0,
    primaryInvestigators: 0,
    collaborators: 0,
  }

  setLocationCounts(locationCounts: LocationCounts) {
    this.locationCounts = locationCounts;
    this.trigger();
  }

  @autoSubscribe
  getLocationCounts() {
    return this.locationCounts;
  }
}

export const globalStore = new GlobalStore();