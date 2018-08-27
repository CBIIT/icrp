import { Component, ElementRef } from '@angular/core';
import { SharedService } from './services/shared.service';
import { environment } from '../environments/environment';
@Component({
  selector: 'icrp-root',
  template: `
    <div [ngSwitch]="sharedService.get('componentType')">
      <icrp-review-page *ngSwitchCase="'review'"></icrp-review-page>
      <icrp-search-page *ngSwitchCase="'search'"></icrp-search-page>
    </div>
  `
})
export class AppComponent {
  constructor(
    private elementRef: ElementRef,
    public sharedService: SharedService
  ) {
    let el = elementRef.nativeElement;
    sharedService.set('isProduction', environment.production);
    sharedService.set('apiRoot', el.getAttribute('data-api-root') || '');
    sharedService.set('componentType', el.getAttribute('data-component-type'));
    sharedService.set('userRoles', (el.getAttribute('data-user-roles') || '').split(','));
  }
}
