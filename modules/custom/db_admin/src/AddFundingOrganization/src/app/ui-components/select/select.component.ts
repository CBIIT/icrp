import { Component, Input } from '@angular/core';

@Component({
  selector: 'ui-select',
  templateUrl: './select.component.html',
  styleUrls: ['./select.component.css']
})
export class SelectComponent {

  @Input() inputClass;

  @Input() options;

  constructor() {
    this.options = [
      'a', 'b', 'c'
    ];
  }


}
