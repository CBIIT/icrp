class Store {

  data = {};
  subscribers = [];

  subscribe(callback) {
    this.subscribers.push(callback);
    return callback;
  }

  unsubscribe(callback) {
    const index = this.subscribers
      .findIndex(s => s === callback);

    if (index !== -1)
      this.subscribers.splice(index, 1);
  }

  trigger() {
    this.subscribers
      .forEach(callback => callback(this.data));
  }

  set(data) {
    this.data = {...this.data, ...data};
    this.trigger();
  }

  reset() {
    this.data = {};
    this.trigger();
  }
}

export const store = new Store();