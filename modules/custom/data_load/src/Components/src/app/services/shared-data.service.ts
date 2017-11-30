import { Injectable, EventEmitter } from '@angular/core';
import { Observable } from 'rxjs/Observable';

@Injectable()
export class SharedDataService {

  private data: any = {};

  public events: EventEmitter<any> = new EventEmitter();

  get(key: string) {
    return this.data[key];
  }
  
  set(key: string, value: any) {
    this.data[key] = value;
    this.events.emit(this.data);
  }

  merge(obj: any) {
    this.data = {
      ...this.data,
      ...obj
    };
    this.events.emit(this.data);
  }

  clear() {
    this.data = {};
    this.events.emit(this.data);
  }

}
