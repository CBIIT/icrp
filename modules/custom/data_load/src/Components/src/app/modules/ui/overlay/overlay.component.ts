import { Component, Input } from '@angular/core';

@Component({
  selector: 'ui-overlay',
  templateUrl: './overlay.component.html',
  styleUrls: ['./overlay.component.css'],
  standalone: false
})
export class OverlayComponent {

  @Input()
  fullscreen = false;

  @Input()
  active: boolean = true;
}
