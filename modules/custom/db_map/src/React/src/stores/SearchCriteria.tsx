import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';

@AutoSubscribeStore
class SearchCriteria extends StoreBase {

  searchCritera: (string|number)[][] ] [];

  set(searchCritera: (string|number)[][]) {
    this.searchCritera = searchCritera;
    this.trigger();
  }

  @autoSubscribe
  get() {
    return this.searchCritera;
  }

  @autoSubscribe
  getSummary() {
    return this.searchCritera.length > 0
      ? this.searchCritera
          .map(e => e[0].toString().replace(':', '').trim())
          .filter(e => e.length > 0)
          .join(' + ')
      : 'All';
  }
}

export const searchCriteria = new SearchCriteria();