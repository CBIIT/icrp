import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators, AbstractControl, ValidatorFn } from '@angular/forms';

@Component({
  selector: 'icrp-funding-organization-form',
  templateUrl: './funding-organization-form.component.html',
  styleUrls: ['./funding-organization-form.component.css']
})
export class FundingOrganizationFormComponent implements OnInit {

  form: FormGroup;

  constructor(private formBuilder: FormBuilder) {
    this.form = this.createForm();

    this.form.controls['latitude'].valueChanges
      .subscribe(value => console.log(value))
  }

  createForm(): FormGroup {
    let formGroup = this.formBuilder.group({
      partner: ['', Validators.required],
      memberType: ['associate', Validators.required],
      name: ['', Validators.required],
      abbreviation: ['', Validators.required],
      organizationType: ['', Validators.required],
      latitude: [null,],
      longitude: [null],
      country: ['', Validators.required],
      currency: ['', Validators.required],
      note: ['', Validators.maxLength(1000)],
      annualizedFunding: false,
    });

    let latitude = formGroup.controls.latitude;
    let longitude = formGroup.controls.longitude;

    latitude.setValidators([
      Validators.min(-90),
      Validators.max(90),
      this.requireWith(longitude)
    ])

    longitude.setValidators([
      Validators.min(-90),
      Validators.max(90),
      this.requireWith(latitude)
    ]);

    latitude.valueChanges.subscribe(value =>
      longitude.updateValueAndValidity({emitEvent: false})
    );

    longitude.valueChanges.subscribe(value =>
      latitude.updateValueAndValidity({emitEvent: false})
    );

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

  ngOnInit() {
  }

}
