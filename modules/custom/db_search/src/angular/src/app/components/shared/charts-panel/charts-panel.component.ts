import { Component, Input, Output, EventEmitter, OnChanges } from '@angular/core';
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

  constructor(
    public sharedService: SharedService,
    private formBuilder: FormBuilder
  ) {
    this.form = formBuilder.group({
      display_type: ['project_counts'],
      conversion_year: new FormControl({value: null, disabled: true}),
    });

    this.form.controls['display_type'].valueChanges
      .subscribe(value => {
        let control = this.form.controls['conversion_year'];
        value === 'project_counts'
          ? control.disable()
          : control.enable();
      })

  }

  updateFundingCharts() {
    let charts = [
      'project_funding_amounts_by_country',
      'project_funding_amounts_by_cso_research_area',
      'project_funding_amounts_by_cancer_type',
      'project_funding_amounts_by_type',
      'project_funding_amounts_by_year',
    ];

    for (let chart of charts) {
      this.requestChart.emit({
        type: chart,
        year: this.form.controls['conversion_year'].value
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
