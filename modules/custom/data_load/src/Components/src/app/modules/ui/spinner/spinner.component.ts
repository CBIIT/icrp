import { Component, Input, AfterViewInit, OnChanges } from '@angular/core';
import { SpinnerConfig } from './spinner.config';

@Component({
  selector: 'ui-spinner',
  templateUrl: './spinner.component.html',
  styleUrls: ['./spinner.component.css']
})
export class SpinnerComponent implements OnChanges, AfterViewInit {

  /** Controls the visibility of this spinner */
  @Input() active: boolean;

  /** If true, this spinner can be dismissed by clicking on it */
  @Input() dismissible: boolean;

  /** Controls the size of the spinner (in pixels) */
  @Input() size: number;

  /** Refers to the svg arc's path attribute */
  arc: string;

  /** Set default property values */
  public constructor(config: SpinnerConfig) {
    Object.assign(this, config);
  }

  updateArc() {
    window.setTimeout(() => {
      let edgeWidth = 10;
      let radius = this.size/2 - this.size/edgeWidth;
      this.arc = `M ${this.size/2} ${this.size/edgeWidth} a ${radius} ${radius} 0 0 1 ${radius} ${radius}`;
    }, 0);
  }

  ngOnChanges() {
    this.updateArc();
  }

  ngAfterViewInit() {
    this.updateArc();
  }
}
