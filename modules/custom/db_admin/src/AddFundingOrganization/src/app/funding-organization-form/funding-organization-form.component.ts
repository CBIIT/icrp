import { Component } from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators, AbstractControl, ValidatorFn } from '@angular/forms';
import { DataService } from '../services/data.service';
import { Field } from '../services/data.service.types';

@Component({
  selector: 'icrp-funding-organization-form',
  templateUrl: './funding-organization-form.component.html',
  styleUrls: ['./funding-organization-form.component.css'],
  providers: [DataService],
})
export class FundingOrganizationFormComponent {

  form: FormGroup;

  options: {
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
      partner: ['', Validators.required],
      memberType: ['associate', Validators.required],
      name: ['', [Validators.required, Validators.maxLength(100)]],
      abbreviation: ['', [Validators.required, Validators.maxLength(15)]],
      organizationType: ['', Validators.required],
      latitude: [null],
      longitude: [null],
      country: ['', Validators.required],
      currency: ['', Validators.required],
      note: ['', Validators.maxLength(8000)],
      annualizedFunding: false,
    });

    const controls = formGroup.controls;

    controls.latitude.setValidators([
      Validators.min(-90),
      Validators.max(90),
      this.requireWith(controls.longitude)
    ]);

    controls.longitude.setValidators([
      Validators.min(-180),
      Validators.max(180),
      this.requireWith(controls.latitude)
    ]);

    controls.latitude.valueChanges.subscribe(value => {
      controls.longitude.updateValueAndValidity({emitEvent: false, onlySelf: true})
      controls.longitude.markAsDirty();
    });

    controls.longitude.valueChanges.subscribe(value => {
      controls.latitude.updateValueAndValidity({emitEvent: false, onlySelf: true})
      controls.latitude.markAsDirty();
    });

    controls.partner.valueChanges.subscribe(value => {
      let partner = this.options.partners.find(
        partner => partner.value === value
      );

      if (partner && partner.country && controls.memberType.value === 'partner') {
        controls.name.patchValue(partner.label);
        controls.country.patchValue(partner.country);
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
        currency ? currency.value : ''
      );

      controls.currency.markAsDirty();
    });

    return formGroup;
  }

  requireWith(otherControl: AbstractControl): ValidatorFn {
    return (control: AbstractControl): {[key: string]: any} => {
      let invalid = (control.value && !otherControl.value)
        || (otherControl.value && !control.value);

      return invalid
        ? { requireWith: true }
        : null;
    }
  }

  resetForm() {
    this.form = this.createForm();
  }

  submit() {
    for (let key in this.form.controls) {
      this.form.controls[key].markAsDirty();
    }


    if (this.form.valid) {
      this.dataService.addFundingOrganization(this.form.value)
        .subscribe(response => {
          // reset form
          // this.form = this.createForm();


        });
    }

    else {
      this.messages.push({
        type: 'danger',
        text: 'Some fields have not passed all validation checks. Please update these fields and re-submit the form.'
      })
    };
  }

}
