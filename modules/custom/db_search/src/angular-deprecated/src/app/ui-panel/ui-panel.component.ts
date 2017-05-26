import {
  Component,
  Input,
  OnInit,
  OnChanges,
  trigger,
  state,
  animate,
  transition,
  style
} from '@angular/core';

@Component({
  selector: 'ui-panel',
  templateUrl: './ui-panel.component.html',
  styleUrls: ['./ui-panel.component.css'],
  animations: [
    trigger('visibilityChanged', [
      state('true', style({ height: '*', paddingTop: 10, paddingBottom: 10, marginTop: 0, overflow: 'visible' })),
      state('false', style({ height: 0, paddingTop: 0, paddingBottom: 0, marginTop: -2, overflow: 'hidden' })),
      transition('void => *', animate('0s')),
      transition('* => *', animate('0.15s ease-in-out'))
    ]),

    trigger('rotationChanged', [
      state('true', style({ transform: 'rotate(0deg)' })),
      state('false', style({ transform: 'rotate(180deg)' })),
      transition('* => *', animate('0.15s ease-in-out'))
    ]),

  ]
})
export class UiPanelComponent implements OnInit {

  @Input() title: string;
  @Input() visible: boolean;
  
  constructor() {
    this.title = '';
    this.visible = false;
  }

  ngOnInit() {
  }

}
