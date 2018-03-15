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
      memberStatus: 'Current',
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

    api.fields().subscribe(response => {
        this.fields = response;
        this.fields.currentFundingOrganizations = [];
        this.initializeFormControls();
    }, errorResponse => {
      let error = errorResponse.error;
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
      const {operationType, country, name, memberType} = controls;

      // disable controls if no partner was selected
      for (let key in controls) {
        if (!['operationType', 'partnerId'].includes(key)) {
          partnerId == null
            ? controls[key].disable({emitEvent: false})
            : controls[key].enable({emitEvent: false});
        }
      }

      const partner = this.fields.partners
        .find(partner => partner.partnerid === partnerId);

      if (partner
        && operationType.value === 'Add'
        && memberType.value === 'Partner') {
        name.patchValue(partner.name);
        country.patchValue(partner.country);
      }

      if (partner && operationType.value === 'Update') {
        this.fields.currentFundingOrganizations = this.fields.fundingOrganizations
          .filter(fundingOrganization => fundingOrganization.sponsorcode === partner.sponsorcode);
        this.form.reset({
          operationType: 'Update',
          partnerId: partnerId,
          memberType: 'Associate',
          memberStatus: 'Current',
        }, {emitEvent: false});
      }
    });

    controls.memberType.valueChanges.subscribe(value => {
      controls.partnerId.updateValueAndValidity()
    })

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
          isAnnualized: record.isannualized
        }, {emitEvent: false});
      }
    })

    controls.partnerId.updateValueAndValidity();
  }

  submit() {
    this.messages = [];

    for (let key in this.form.controls)
      this.form.controls[key].markAsDirty();

    if (!this.form.valid) {
      document.querySelector('h1').scrollIntoView();
      return;
    }

    const formData = new FormData();
    for (let key in this.form.value) {
        formData.append(key, this.form.value[key]);
    }

    const action = this.form.value.operationType.toLowerCase(); // 'add' or 'update'
    this.api[action](formData)
      .subscribe(response => {
        document.querySelector('h1').scrollIntoView();
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
        document.querySelector('h1').scrollIntoView();
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
