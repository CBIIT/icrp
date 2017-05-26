import { Component, Input } from '@angular/core';
import { trigger, state, style, animate, transition, keyframes } from '@angular/animations';


@Component({
  selector: 'ui-panel',
  templateUrl: './panel.component.html',
  styleUrls: ['./panel.component.css'],
  animations: [
    trigger('visibilityChanged', [
      state('true', style({
        height: '*',
        paddingTop: 10,
        paddingBottom: 10,
        overflow: 'visible',
        opacity: 1,
      })),
      state('false', style({
        height: 0, 
        paddingTop: 0,
        paddingBottom: 0,
        borderTop: 'none',
        overflow: 'hidden',

      })),
      transition('void => false', animate('0s')),
      transition('void => true', animate('0.1s')),
      transition('true <=> false', animate('0.15s ease-in-out'))
    ]),

    trigger('rotationChanged', [
      state('true', style({
        transform: 'rotate(0deg)'
      })),
      state('false', style({
        transform: 'rotate(180deg)'
      })),
      transition(':enter', animate('0.1s')),
      transition('active <=> inactive', animate('0.15s ease-in-out'))
    ]),
  ]
})
export class PanelComponent {
  @Input() title: string = '';
  @Input() visible: boolean = false;
}
