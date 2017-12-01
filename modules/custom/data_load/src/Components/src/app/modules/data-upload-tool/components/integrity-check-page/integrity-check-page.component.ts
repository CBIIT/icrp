import { Component, TemplateRef, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, FormControl } from '@angular/forms';
import { BsModalService } from 'ngx-bootstrap/modal';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';
import { DataUploadService } from '../../../../services/data-upload.service';
import { SharedDataService } from '../../../../services/shared-data.service';
import { ExportService } from '../../../../services/export.service';
import { share } from 'rxjs/operators/share';

@Component({
  selector: 'data-integrity-check-page',
  templateUrl: './integrity-check-page.component.html',
  styleUrls: ['./integrity-check-page.component.css'],
  providers: [BsModalService]
})
export class IntegrityCheckPageComponent {

  form: FormGroup;

  validationRules: any[] = [];

  _validationRules: any[] = [];

  showRules: boolean = true;

  showSummary: boolean = false;

  showResults: boolean = false;

  summary = [];

  results = [];

  description = '';

  details = [];

  detailHeaders = [];

  integrityCheckValid: boolean = false;

  uploadType: string;


  // @ViewChild('template')
  // templateRef: TemplateRef<any>;

  // modalRef: BsModalRef;

  constructor(
    private formBuilder: FormBuilder,
    private dataUpload: DataUploadService,
    private sharedData: SharedDataService,
    private modalService: BsModalService,
    private exportService: ExportService
  ) {
    this.form = this.formBuilder.group({});
    this.sharedData.events.subscribe(data => {
      this.uploadType = data.uploadType || 'New';
      this.updateValidationRules();
    });

    this.dataUpload.getValidationRules()
      .subscribe(response => this._validationRules = response)
  }

  updateValidationRules() {
    let rules = this._validationRules
      .filter(rule => rule.isActive === 1)
      .filter(rule => ['BOTH', this.uploadType.toUpperCase()].includes(rule.type.toUpperCase()))

    this.validationRules = rules;
    this.form = this.formBuilder.group(
      rules.reduce((prev, curr) => ({
        ...prev,
        [curr.id]: {value: true, disabled: curr.isRequired === 1},
      }), {})
    );
  }

  reset() {
    this.summary = [];
    this.results = [];
    this.showSummary = false;
    this.showResults = false;
  }

  submit() {

    this.summary = [];
    this.results = [];

    this.showSummary = false;
    this.showResults = false;
    this.sharedData.merge({loading: true});

    this.dataUpload.integrityCheck({
      partnerCode: this.sharedData.get('sponsorCode'),
      type: this.sharedData.get('uploadType')
    }).subscribe(response => {

      this.summary = response
        .filter(row => row.Type === 'Summary');

      const invalidKeys = Object.keys(this.form.value)
        .filter(key => !this.form.value[key]);

      this.results = response
        .filter(row => row.Type === 'Rule')
        .filter(row => !invalidKeys.map(k => +k).includes(row.ID));

      this.integrityCheckValid = this.results
        .filter(row => row.Type === 'Rule')
        .filter(row => row.Count > 0)
        .length === 0;

      this.showSummary = true;
      this.showResults = true;
      this.sharedData.merge({
        integrityCheckValid: this.integrityCheckValid,
        loading: false,
      })
    })
  }

  getIntegrityCheckDetails(ruleId: number, description: string, modal: any) {
    this.sharedData.merge({loading: true});

    this.details = [];
    this.detailHeaders = [];

    this.dataUpload.integrityCheckDetails({
      partnerCode: this.sharedData.get('sponsorCode'),
      ruleId: ruleId
    }).subscribe(response => {
      this.sharedData.merge({loading: false});
      this.details = response;
      this.description = description;

      if (this.details && this.details.length > 0)
        this.detailHeaders = Object.keys(this.details[0]);
        modal.show();
    })
  }


  async export() {
    const sponsorCode = this.sharedData.get('sponsorCode');
    const rules = this.results
      .filter(row => row.Count > 0)

    const flattenRows = rows => {
      if (rows.length === 0) {
        return [''];
      }

      const keys = Object.keys(rows[0]);
      return [
        keys,
        ...rows.map(row =>
          keys.map(key => row[key]))
      ];
    }

    const sheets = await Promise.all(rules.map(async rule => await ({
      title: rule.Description,
      rows: [[rule.Description]].concat(flattenRows(
        await this.dataUpload.integrityCheckDetails({
          partnerCode: sponsorCode,
          ruleId: rule.ID
        }).toPromise())
      )
    })));

    this.exportService.exportAsExcel(sheets);
  }


}
