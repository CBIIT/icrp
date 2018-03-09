import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { FundingOrganizationsApiService } from '../../services/funding-organizations-api.service'
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'icrp-funding-organizations-form',
  templateUrl: './funding-organizations-form.component.html',
  styleUrls: ['./funding-organizations-form.component.css']
})
export class FundingOrganizationsFormComponent {

  form: FormGroup;
  messages: {type: string, message: string}[] = [];
  fields: any = {};
  loading: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private api: FundingOrganizationsApiService
  ) {
    api.fields().subscribe(response => {
        this.fields = response;
        this.initializeForm();
    }, errorResponse => {
      console.error(errorResponse.error);
    });
  }

  initializeForm() {
    this.form = this.formBuilder.group({
      operationType: 'add',
      partnerId: [null, Validators.required],
      memberType: 'Associate',
      memberStatus: 'Current',
      name: [null, [Validators.required, Validators.maxLength(100)]],
      fundingOrganizationId: [null],
      type: [null],
      abbreviation: [null, [Validators.required, Validators.maxLength(15)]],
      websiteProtocol: ['http://'],
      country: [null, Validators.required],
      currency: [null, Validators.required],
      latitude: [null, [Validators.required, Validators.min(-90), Validators.max(90)]],
      longitude: [null, [Validators.required, Validators.min(-180), Validators.max(180)]],
      isAnnualized: [false],
      note: [null, Validators.maxLength(1000)]
    });

    const controls = this.form.controls;

    controls.operationType.valueChanges.subscribe(operationType => {
      const {name, fundingOrganizationId} = controls;

      name.setValue(null);
      name.clearValidators();

      fundingOrganizationId.setValue(null);
      fundingOrganizationId.clearValidators();

      if (operationType === 'add') {
        name.setValidators([
          Validators.required,
          Validators.maxLength(100)
        ]);
      }

      else if (operationType === 'update') {
        fundingOrganizationId.setValidators([
          Validators.required
        ]);
      }

      name.updateValueAndValidity({emitEvent: false});
      fundingOrganizationId.updateValueAndValidity({emitEvent: false});
    });

    controls.partnerId.valueChanges.subscribe(partnerId => {
      const {operationType, country} = controls;

      const partner = this.fields.partners
        .find(partner => partner.partnerid = partnerId);

      if (partner && operationType.value === 'add') {

      }
    });

    controls.country.valueChanges.subscribe(value => {
      const country = this.fields.countries
        .find(country => country.abbreviation === value);

      controls.currency.setValue(country ? country.currency : null);
    });
  }

  add() {
    this.messages = [];
    if (!this.form.valid)
      return;

    const formData = new FormData();
    for (let key in this.form.value)
      formData.append(key, this.form.value[key]);

      this.api.add(formData)
        .subscribe(response => {
          this.messages.push({
            type: 'success',
            message: `The funding organization has been added to the database.`,
          });
        }, errorResponse => {
          this.messages.push({
            type: 'danger',
            message: `Error: ${errorResponse.error}`,
          });
        });
  }

  update() {
    this.messages = [];
    if (!this.form.valid)
      return;

    const formData = new FormData();
    for (let key in this.form.value)
      formData.append(key, this.form.value[key]);

    this.api.update(formData)
      .subscribe(response => {
        this.messages.push({
          type: 'success',
          message: `The funding organization has been updated.`,
        });
      }, errorResponse => {
        this.messages.push({
          type: 'danger',
          message: `Error: ${errorResponse.error}`,
        });
      });
  }
}
