import { StoreBase, AutoSubscribeStore, autoSubscribe } from 'resub';

@AutoSubscribeStore
class LoadState extends StoreBase {

  loading: boolean;
  loadingMessage: string;

  set(loading: boolean) {
    this.loading = loading;
    this.trigger();
  }

  setMessage(loadingMessage: string) {
    this.loadingMessage = loadingMessage;
    this.trigger();
  }

  @autoSubscribe
  isLoading() {
    return this.loading;
  }

  @autoSubscribe
  getLoadingMessage() {
    return this.loadingMessage;
  }
}

export const loadState = new LoadState(100);