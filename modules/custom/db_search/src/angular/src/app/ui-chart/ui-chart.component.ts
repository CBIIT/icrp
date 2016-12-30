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
    
    let res = this.queryServerAnalytics(this.searchParam, this.group);
    new PieChart().draw(this.svg.nativeElement, res);


  }
  
  queryServerAnalytics(parameters: Object, group: string) {
    let res = [];

    if (group === 'country') {
      res = [{"value":50287,"label":"US"},{"value":13650,"label":"CA"},{"value":9630,"label":"GB"},{"value":685,"label":"NL"},{"value":661,"label":"AU"},{"value":551,"label":"FR"},{"value":98,"label":"JP"}]
    }


    if (group === 'cso_code') {
      res = [{"value":33268,"label":"Biology"},{"value":23421,"label":"Treatment"},{"value":14436,"label":"Early Detection, Diagnosis, and Prognosis"},{"value":14035,"label":"Causes of Cancer/Etiology"},{"value":11273,"label":"Cancer Control, Survivorship and Outcomes Research"},{"value":6342,"label":"Prevention"},{"value":327,"label":"Uncoded"},{"value":2,"label":"Scientific Model Systems"}]
    }


    if (group === 'cancer_type_id') {
      res = [{"value":20846,"label":"Breast Cancer"},{"value":18521,"label":"Not Site-Specific Cancer"},{"value":8713,"label":"Gastrointestinal Tract"},{"value":8478,"label":"Prostate Cancer"},{"value":8080,"label":"Genital System, Male"},{"value":7408,"label":"Blood Cancer"},{"value":5434,"label":"Colon and Rectal Cancer"},{"value":5330,"label":"Lung Cancer"},{"value":5241,"label":"Leukemia / Leukaemia"},{"value":4831,"label":"Respiratory System"}]
    }
    

    return res;
  }
  

/*  
  queryAnalyticsOld() {
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

  


  oldqueryServerAnalytics(parameters: Object, group: string): Observable<any[]> {
    let endpoint = `http://localhost/drupal/db_search_api/public_analytics/${group}`;
    let params = new URLSearchParams();

    for (let key of Object.keys(parameters)) {
      params.set(key, parameters[key]);
    }

    return this.http.get(endpoint, {search: params})
      .map((res: Response) => res.json())
      .catch((error: any) => Observable.throw(error.json().error || 'Server error'))
    
  }

*/
}
