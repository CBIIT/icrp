import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';
import { Location } from '../services/DataService';

@AutoSubscribeStore
class Locations extends StoreBase {

}

export const locations = new Locations();