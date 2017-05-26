import { Component, Input, Output, EventEmitter } from '@angular/core';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-charts-panel',
  templateUrl: './charts-panel.component.html',
  styleUrls: ['./charts-panel.component.css']
})
export class ChartsPanelComponent implements Input {
  @Input() analytics: any = {};
  @Input() fields: any = {};
  @Input() loading: boolean = false;

  @Output() requestChart: EventEmitter<any> = new EventEmitter<any>();

  showMore: boolean = false;

  constructor(public sharedService: SharedService) { }
}
