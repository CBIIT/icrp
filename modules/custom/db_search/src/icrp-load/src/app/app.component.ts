import { Component, ElementRef } from '@angular/core';
import { SharedService } from './services/shared.service';

@Component({
  selector: 'icrp-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(private elementRef: ElementRef, public sharedService: SharedService) {
    let el = elementRef.nativeElement;
    sharedService.set('apiRoot', el.getAttribute('data-api-root') || '');
    sharedService.set('componentType', el.getAttribute('data-component-type'));
  }
}
