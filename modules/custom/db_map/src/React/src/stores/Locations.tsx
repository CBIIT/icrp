import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';
import { Location } from '../services/DataService';

@AutoSubscribeStore
class Locations extends StoreBase {
  locations: Location[] = [];

  add(location: Location) {
    this.locations = this.locations.concat(location);
    this.trigger();
  }

  set(locations: Location[]) {
    this.locations = locations;
    this.trigger();
  }

  @autoSubscribe
  get() {
    return this.locations;
  }
}

export const locations = new Locations();