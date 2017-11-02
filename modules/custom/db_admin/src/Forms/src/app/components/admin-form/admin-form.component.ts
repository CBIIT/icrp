import { Component, ElementRef } from '@angular/core';

@Component({
  selector: 'icrp-admin-form',
  templateUrl: './admin-form.component.html',
})
export class AdminFormComponent {

  componentType: string;

  constructor(private elementRef: ElementRef) {
    const el: HTMLElement = elementRef.nativeElement;
    this.componentType = el.getAttribute('component');
  }
}
