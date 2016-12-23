import {
  Component,
  OnChanges,
  AfterViewInit,
  Input,
  ElementRef,
  ViewChild,
  SimpleChanges
} from '@angular/core';

import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';


import { UiChartParameters } from './ui-chart.parameters';
import { PieChart } from './ui-chart.pie';
import * as d3 from 'd3';


@Component({
  selector: 'ui-chart',
  templateUrl: './ui-chart.component.html',
  styleUrls: ['./ui-chart.component.css']
})
export class UiChartComponent implements OnChanges, AfterViewInit {

  @Input() searchParam: Object;
  @Input() group: string;

  @Input() param: UiChartParameters;
  @Input() title: string;
  @ViewChild('svg') svg: ElementRef;
  loading = true;

  constructor(private http: Http) {
  }

  drawChart(param: UiChartParameters) {
    if (param.options.type === 'pie') {
      new PieChart().draw(this.svg.nativeElement, param.data);
    }
  }

  ngAfterViewInit() {
//    this.queryAnalytics();
  }

  /** Redraw chart on changes */  
  ngOnChanges(changes: SimpleChanges) {

    this.queryAnalytics();


    console.log('updated chart', changes);
    console.log('chart parameters', this.param);

//    this.drawChart(this.param);
  }


  queryAnalytics() {
    console.log('CREATING CHART WITH', this.searchParam, this.group)

    this.queryServerAnalytics(this.searchParam, this.group).subscribe(
      response => {

        console.log('CHART DATA', response);
        new PieChart().draw(this.svg.nativeElement, response);
      },
      error => {
        console.error(error);
        this.loading = false;
      }
    )
  }
  

  queryServerAnalytics(parameters: Object, group: string): Observable<any[]> {
    let endpoint = `http://localhost/drupal/db_search_api/public_analytics/${group}`;
    let params = new URLSearchParams();

    for (let key of Object.keys(parameters)) {
      params.set(key, parameters[key]);
    }

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
    
  }


}
