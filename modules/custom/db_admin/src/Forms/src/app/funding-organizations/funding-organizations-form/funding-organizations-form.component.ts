import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { FundingOrganizationsApiService } from '../../services/funding-organizations-api.service'
import { HttpErrorResponse } from '@angular/common/http';
import { controlNameBinding } from '@angular/forms/src/directives/reactive_directives/form_control_name';

@Component({
  selector: 'icrp-funding-organizations-form',
  templateUrl: './funding-organizations-form.component.html',
  styleUrls: ['./funding-organizations-form.component.css']
})
export class FundingOrganizationsFormComponent {

  form: FormGroup;
  messages: {type: string, content: string}[] = [];
  fields: any = {};
  loading: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private api: FundingOrganizationsApiService
  ) {
    this.form = this.formBuilder.group({
      operationType: 'Add',
      partnerId: [null, Validators.required],
      memberType: 'Associate',
      isPartner: false,
      memberStatus: 'Current',
      isDataCompletenessExcluded: [false],
      name: [null, [Validators.required, Validators.maxLength(100)]],
      fundingOrganizationId: [null],
      type: [null, Validators.required],
      abbreviation: [null, [Validators.required, Validators.maxLength(15)]],
      website: [null, [Validators.maxLength(250), Validators.pattern(/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/i)]],
      country: [null, Validators.required],
      currency: [null, Validators.required],
      latitude: [null, [Validators.required, Validators.min(-90), Validators.max(90)]],
      longitude: [null, [Validators.required, Validators.min(-180), Validators.max(180)]],
      isAnnualized: false,
      note: [null, Validators.maxLength(1000)]
    });

    for (let key in this.form.controls) {
      this.form.controls[key].disable({emitEvent: false});
    }

    api.fields().subscribe(response => {
        this.fields = response;
        this.initializeFormControls();
    }, (errorResponse: HttpErrorResponse) => {
      let error = errorResponse.error;
      console.log(errorResponse);
      let message = error.constructor === String
          ? error
          : 'An unknown error occured while loading this page.';
      this.messages.push({
        type: 'danger',
        content: message
      });
    });
  }

  initializeFormControls() {
    const controls = this.form.controls;

    controls.operationType.valueChanges.subscribe(operationType => {
      const {name, fundingOrganizationId, partnerId} = controls;

      this.form.reset({
        operationType: operationType,
        memberType: 'Associate',
        memberStatus: 'Current',
        // partnerId: partnerId.value,
      }, {emitEvent: false});

      name.clearValidators();
      fundingOrganizationId.clearValidators();

      if (operationType === 'Add') {
        name.setValidators([
          Validators.required,
          Validators.maxLength(100)
        ]);
      }

      else if (operationType === 'Update') {
        fundingOrganizationId.setValidators([
          Validators.required
        ]);
      }

      name.updateValueAndValidity({emitEvent: false});
      fundingOrganizationId.updateValueAndValidity({emitEvent: false});
      partnerId.updateValueAndValidity();

    });

    controls.partnerId.valueChanges.subscribe(partnerId => {
      const {operationType, isPartner, country, name, abbreviation, memberType} = controls;

      // disable controls if no partner was selected
      for (let key in controls) {
        partnerId !== null || ['operationType', 'partnerId'].includes(key)
          ? controls[key].enable({emitEvent: false})
          : controls[key].disable({emitEvent: false})
      }

      this.form.reset({
        operationType: operationType.value,
        partnerId: partnerId,
        memberStatus: 'Current',
        isPartner: false,
        memberType: 'Associate',
        isAnnualized: false,
        isDataCompletenessExcluded: false,
      }, {emitEvent: false});
    });

    controls.isPartner.valueChanges.subscribe(isPartner => {
      const {
        abbreviation,
        country,
        name,
        fundingOrganizationId,
        partnerId,
        memberType,
        operationType
      } = controls;

      memberType.setValue(isPartner ? 'Partner' : 'Associate');
      const partner = this.fields.partners
        .find(partner => partner.partnerid === partnerId.value);

      if (isPartner && operationType.value === 'Add') {
        if (partner) {
          name.patchValue(partner.name);
          abbreviation.patchValue(partner.sponsorcode);
          country.patchValue(partner.country);
        }
      }

      if (isPartner
        && operationType.value === 'Update'
        && fundingOrganizationId.value !== null) {
        name.patchValue(partner.name);
        abbreviation.patchValue(partner.sponsorcode);
      }

      if (!isPartner
        && operationType.value === 'Update'
        && fundingOrganizationId.value !== null) {
          const record = this.fields.fundingOrganizations
            .find(fundingOrganization => fundingOrganization.fundingorgid === fundingOrganizationId.value);

          name.patchValue(record.name);
      }
    });

    controls.country.valueChanges.subscribe(value => {
      const country = this.fields.countries
        .find(country => country.abbreviation === value);

      if (country && this.fields.currencies
        .map(currency => currency.code)
        .includes(country.currency)) {
        controls.currency.setValue(country.currency);
      } else {
        controls.currency.setValue(null);
      }

      controls.currency.markAsDirty();
    });

    controls.fundingOrganizationId.valueChanges.subscribe(fundingOrganizationId => {
      if (fundingOrganizationId != null) {

        const record = this.fields.fundingOrganizations
          .find(fundingOrganization => fundingOrganization.fundingorgid === fundingOrganizationId);

        this.form.patchValue({
          memberType: record.membertype,
          isPartner: /Partner/i.test(record.membertype),
          memberStatus: record.memberstatus,
          name: record.name,
          abbreviation: record.abbreviation,
          website: record.website,
          type: record.type,
          latitude: record.latitude,
          longitude: record.longitude,
          country: record.country,
          currency: record.currency,
          note: record.note,
          isAnnualized: record.isannualized,
          isDataCompletenessExcluded: record.isdatacompletenessexcluded,
        }, {emitEvent: false});
      } else {
        this.form.reset({
          operationType: controls.operationType.value,
          partnerId: controls.partnerId.value,
          memberStatus: 'Current',
          isAnnualized: false,
          isPartner: false,
          isDataCompletenessExcluded: false,
        }, {emitEvent: false});
      }

      controls.memberStatus.updateValueAndValidity();
    })


    controls.memberStatus.valueChanges.subscribe(memberStatus => {

      if (memberStatus === 'Former') {
        this.form.controls.isDataCompletenessExcluded.disable();
        this.form.patchValue({
          isDataCompletenessExcluded: true
        });
      } else {
        this.form.controls.isDataCompletenessExcluded.enable();
        if (this.form.value.operationType === 'Add')
          this.form.patchValue({
            isDataCompletenessExcluded: false
          })
      }
    })

    controls.partnerId.updateValueAndValidity();
  }

  submit() {
    this.messages = [];

    for (let key in this.form.controls)
      this.form.controls[key].markAsDirty();

    if (!this.form.valid) {
      window.scrollTo(0, 0);
      return;
    }

    const formData = new FormData();
    const formValue = this.form.getRawValue();
    for (let key in formValue) {
        formData.append(key, formValue[key]);
    }

    const action = this.form.value.operationType.toLowerCase(); // 'add' or 'update'
    this.api[action](formData)
      .subscribe(response => {
        window.scrollTo(0, 0);
        let content = action === 'add'
          ? `The funding organization has been added. `
          : `The funding organization has been updated. `
        content += `Visit <a href="/partners">ICRP Partners and Funding Organizations</a> to view a list of current ICRP funding organizations. `;

        this.messages.push({
          type: 'success',
          content: content,
        });
        this.api.fields().subscribe(response => {
          this.fields = response;
          this.form.controls.partnerId.updateValueAndValidity();
        });

      }, errorResponse => {
        window.scrollTo(0, 0);
        this.messages.push({
          type: 'danger',
          content: `${errorResponse.error}`,
        });
      });
  }

  reset() {
    this.form.reset({
      operationType: 'Add',
      memberType: 'Associate',
      memberStatus: 'Current',
    });
  }
}
