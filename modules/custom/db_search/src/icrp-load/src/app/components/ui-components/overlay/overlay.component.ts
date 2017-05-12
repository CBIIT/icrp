import { Component, OnInit, Input } from '@angular/core';
import {
  trigger,
  state,
  style,
  animate,
  transition
} from '@angular/animations'

@Component({
  selector: 'ui-overlay',
  templateUrl: './overlay.component.html',
  styleUrls: ['./overlay.component.css'],
  animations:[
    trigger('isActive', [
      state('false', style({
        opacity: '0',
        display: 'none',
      })),

      state('true', style({
        opacity: '1',
        display: 'block',
      })),

      transition(':enter', animate('50ms ease-in')),
      transition(':leave', animate('50ms ease-out')),
      transition('true => false', animate('50ms ease-out')),
      transition('false => true', animate('50ms ease-in')),


    ])
  ]
})
export class OverlayComponent implements OnInit {

  @Input() fullscreen = false;

  @Input() active: boolean = true;

  constructor() { }

  ngOnInit() {
  }

}
