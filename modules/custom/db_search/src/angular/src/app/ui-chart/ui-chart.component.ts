import {
  Component,
  OnChanges,
  AfterViewInit,
  Input,
  ElementRef,
  ViewChild,
  SimpleChanges
} from '@angular/core';

import { PieChart } from './ui-chart.pie';
import * as d3 from 'd3';

@Component({
  selector: 'ui-chart',
  templateUrl: './ui-chart.component.html',
  styleUrls: ['./ui-chart.component.css']
})
export class UiChartComponent implements OnChanges, AfterViewInit {

  @Input() type: string;
  @Input() data: any;
  @Input() label: string;

  @ViewChild('svg') svg: ElementRef;
  @ViewChild('tooltip') tooltip: ElementRef;

  constructor() {}

  drawChart() {
    if (this.type === 'pie') {
      new PieChart().draw(
        this.svg.nativeElement, 
        this.tooltip.nativeElement,
        this.data);
    }
  }

  /** Redraw chart on changes */  
  ngOnChanges(changes: SimpleChanges) {
    this.drawChart()
  }

  ngAfterViewInit() {}

}
