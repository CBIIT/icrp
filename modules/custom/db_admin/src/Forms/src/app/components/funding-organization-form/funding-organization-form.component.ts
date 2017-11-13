import { Component } from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators, AbstractControl, ValidatorFn } from '@angular/forms';
import { DataService } from '../../services/data.service';
import { Field } from '../../services/data.service.types';

@Component({
  selector: 'icrp-funding-organization-form',
  templateUrl: './funding-organization-form.component.html',
  styleUrls: ['./funding-organization-form.component.css'],
  providers: [DataService],
})
export class FundingOrganizationFormComponent {

  form: FormGroup;

  options: {
    funding_organizations: any[],
    partners: Field[],
    countries: Field[],
    currencies: Field[],
  };

  messages: {type: string, text: string}[];

  constructor(
    private dataService: DataService,
    private formBuilder: FormBuilder) {

    this.form = this.createForm();

    this.options = {
      funding_organizations: [],
      partners: [],
      countries: [],
      currencies: [],
    };

    this.messages = [];

    this.dataService.getFields()
      .subscribe(fields => this.options = fields);
  }

  createForm(): FormGroup {
    let formGroup = this.formBuilder.group({
      operationType: ['Add'],
      partner: [null, Validators.required],
      memberType: ['Associate', Validators.required],
      memberStatus: ['Current', Validators.required],
      name: [null, [Validators.required, Validators.maxLength(100)]],
      id: [null],
      abbreviation: [null, [Validators.required, Validators.maxLength(15)]],
      website: [null, [Validators.maxLength(250), Validators.pattern(/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/i)]],
      organizationType: [null, Validators.required],
      latitude: [null, [Validators.min(-90), Validators.max(90), Validators.required]],
      longitude: [null, [Validators.min(-180), Validators.max(180), Validators.required]],
      country: [null, Validators.required],
      currency: [null, Validators.required],
      note: [null, Validators.maxLength(8000)],
      annualizedFunding: false,
    });

    const controls = formGroup.controls;

    controls.operationType.valueChanges.subscribe(value => {
      this.form.reset({
        operationType: value,
        memberType: 'Associate',
        memberStatus: 'Current',
      }, {emitEvent: false});

      if (value === 'Add') {
        controls.id.clearValidators();
        controls.name.setValidators([Validators.required]);
      }

      if (value === 'Update') {
        controls.name.clearValidators();
        controls.id.setValidators([Validators.required]);
      }

      controls.name.updateValueAndValidity();
      controls.id.updateValueAndValidity();
    });

    controls.partner.valueChanges.subscribe(value => {

      if (controls.operationType.value === 'Add'
        && controls.memberType.value === 'Partner') {
        let partner = this.options.partners.find(
          partner => +partner.value === +value
        );

        if (partner && partner.country) {
          controls.name.patchValue(partner.label);
          controls.country.patchValue(partner.country);
        }
      }
    });

    controls.memberType.valueChanges.subscribe(value => {
      controls.partner.updateValueAndValidity();
    });

    controls.country.valueChanges.subscribe(value => {
      let country = this.options.countries.find(
        country => country.value === value
      );

      let currencyValue = country ? country.currency : '';
      let currency = this.options.currencies.find(
        currency => currency.value === currencyValue
      );

      controls.currency.patchValue(
        currency ? currency.value : null
      );

      controls.currency.markAsDirty();
    });

    controls.id.valueChanges.subscribe(value => {
      if (this.options.funding_organizations.length > 0 && value != null) {

        let org = this.options.funding_organizations
          .find(organization => organization.funding_organization_id == value);

        console.log(org);

        this.form.patchValue({
          partner: org.partner_id,
          memberType: org.member_type,
          memberStatus: org.member_status,
          abbreviation: org.organization_abbreviation,
          website: org.organization_website,
          organizationType: org.organization_type,
          latitude: org.latitude,
          longitude: org.longitude,
          country: org.country,
          currency: org.currency,
          note: org.note,
          annualizedFunding: org.is_annualized === 1
        }, {emitEvent: false});
      }
    })

    return formGroup;
  }

  resetForm(event) {
    event.preventDefault();
    this.form.reset({
      operationType: 'Add',
      memberType: 'Associate',
      memberStatus: 'Current',
    });
  }

  submit() {

    console.log('clicked submit')
    for (let key in this.form.controls) {
      this.form.controls[key].markAsDirty();
    }

    this.messages = [];

    if (this.form.valid) {
      let formValue = {...this.form.value};
      if (formValue.id && !formValue.name) {
        formValue.name = this.options.funding_organizations
          .find(org => org.funding_organization_id == formValue.id)
          .organization_name;
      }

      let formData = new FormData();
      let keyMap = {
        operationType: 'operation_type',
        partner: 'partner_id',
        memberType: 'member_type',
        memberStatus: 'member_status',
        name: 'organization_name',
        id: 'funding_organization_id',
        abbreviation: 'organization_abbreviation',
        organizationType: 'organization_type',
        latitude: 'latitude',
        longitude: 'longitude',
        country: 'country',
        currency: 'currency',
        note: 'note',
        annualizedFunding: 'is_annualized',
        website: 'website',
      }

      for (let key in formValue) {
        let value = formValue[key];
        let mappedKey = keyMap[key];

        if (value !== null && value !== '')
          formData.set(mappedKey, value);
      }

      let request = this.form.controls.operationType.value === 'Update'
        ? this.dataService.updateFundingOrganization(formData)
        : this.dataService.addFundingOrganization(formData);

      console.log('request', request);

      request.subscribe(response => {
        const typeMap = {
          ERROR: 'danger',
          SUCCESS: 'success',
        };

        for (let responseMessage of response) {
          let key = Object.keys(responseMessage)[0];

          this.messages.push({
            type: typeMap[key],
            text: responseMessage[key]
          })
        }

        this.dataService.getFields()
          .subscribe(fields => this.options = fields);
      });
    }

    else {
      console.log(this.form, this.form.errors);
    }
  }

}