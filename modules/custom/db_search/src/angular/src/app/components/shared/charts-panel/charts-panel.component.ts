import { Component, Input, Output, EventEmitter, OnChanges, AfterViewInit } from '@angular/core';
import { Validators, FormBuilder, FormGroup, FormControl } from '@angular/forms';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-charts-panel',
  templateUrl: './charts-panel.component.html',
  styleUrls: ['./charts-panel.component.css']
})
export class ChartsPanelComponent implements OnChanges {
  @Input() analytics: any = {};
  @Input() fields: any = {};
  @Input() loading: boolean = false;

  @Output() requestChart: EventEmitter<any> = new EventEmitter<any>();

  showMore: boolean = false;
  form: FormGroup;

  currentCharts = [];
  carouselMax = 7;
  carouselSize = 4;
  carouselIndex = 0;

  constructor(
    public sharedService: SharedService,
    private formBuilder: FormBuilder
  ) {
    this.form = formBuilder.group({
      display_type: ['project_counts'],
      conversion_year: new FormControl({value: null, disabled: true}),
    });

    const { display_type, conversion_year } = this.form.controls;

    display_type.valueChanges
      .delay(0)
      .subscribe(value => {
        value === 'project_counts'
          ? conversion_year.disable()
          : conversion_year.enable();

        this.updateCharts();
      });
  }

  updateCarousel(offset: number) {
    let newIndex = this.carouselIndex + offset;
    if (newIndex >= 0 && newIndex <= this.carouselMax - this.carouselSize) {
      this.carouselIndex = newIndex;
      console.log(this.analytics);
      this.updateCharts();
    }
  }

  /**
   * Whenever the user modifies a control in the charts panel,
   * determine which charts should be requested and emit
   * events to request those charts
   *
   * @memberof ChartsPanelComponent
   */
  updateCharts() {

    const { display_type, conversion_year } = this.form.controls;

    let charts = display_type.value === 'project_counts'
      ? [
        'project_counts_by_country',
        'project_counts_by_cso_research_area',
        'project_counts_by_cancer_type',
        'project_counts_by_type',
        'project_counts_by_institution',
        'project_counts_by_childhood_cancer',
        'project_counts_by_funding_organization',
      ] : [
        'project_funding_amounts_by_country',
        'project_funding_amounts_by_cso_research_area',
        'project_funding_amounts_by_cancer_type',
        'project_funding_amounts_by_type',
        'project_funding_amounts_by_institution',
        'project_funding_amounts_by_childhood_cancer',
        'project_funding_amounts_by_funding_organization',
      ];

    charts = charts.slice(this.carouselIndex, this.carouselIndex + this.carouselSize);
    this.currentCharts = charts;

    if (this.showMore && display_type.value === 'project_counts') {
      charts.push('project_counts_by_year');
    }

    if (this.showMore && display_type.value === 'award_amounts') {
      charts.push('project_funding_amounts_by_year');
    }

    // console.log(this.analytics, charts);

    for (let chart of charts) {
      if (this.analytics[chart] === null) {
        this.requestChart.emit({
          type: chart,
          year: conversion_year.value
        });
      }
    }
  }

  isHidden(chartName) {
    return !this.currentCharts.includes(chartName);
  }

  updateFundingCharts() {

    const { display_type, conversion_year } = this.form.controls;

    let charts = [
      'project_funding_amounts_by_country',
      'project_funding_amounts_by_cso_research_area',
      'project_funding_amounts_by_cancer_type',
      'project_funding_amounts_by_type',
      'project_funding_amounts_by_institution',
      'project_funding_amounts_by_childhood_cancer',
      'project_funding_amounts_by_funding_organization',
    ];

    for (let chart of charts) {
      this.analytics[chart] = null;
    }

    charts = charts.slice(this.carouselIndex, this.carouselIndex + this.carouselSize);
    this.currentCharts = charts;

    if (this.showMore && display_type.value === 'award_amounts') {
      charts.push('project_funding_amounts_by_year');
    }

    this.analytics['project_funding_amounts_by_year'] = null;

    for (let chart of charts) {
      this.analytics[chart] = null;
      this.requestChart.emit({
        type: chart,
        year: conversion_year.value
      });
    }
  }

  ngOnChanges() {
    if (this.fields && this.fields.conversion_years) {
      this.form.patchValue({
        conversion_year: this.fields.conversion_years[0].value
      })
    }
  }
}
