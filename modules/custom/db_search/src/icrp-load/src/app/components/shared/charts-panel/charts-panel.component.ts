import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'icrp-charts-panel',
  templateUrl: './charts-panel.component.html',
  styleUrls: ['./charts-panel.component.css']
})
export class ChartsPanelComponent implements Input {
  @Input() analytics: any = {};
  @Input() fields: any = {};

  @Output() requestChart: EventEmitter<any> = new EventEmitter<any>();

  showMore: boolean = false;
}
