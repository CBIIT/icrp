import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { InstitutionsApiService } from 'src/app/services/institutions-api.service';
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'icrp-institutions-form',
  templateUrl: './institutions-form.component.html',
  styleUrls: ['./institutions-form.component.css']
})
export class InstitutionsFormComponent {

  form: FormGroup;
  messages: { type: string, content: string }[] = [];
  fields: any = {};
  loading: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private api: InstitutionsApiService
  ) {

    this.form = this.formBuilder.group({
      operationType: 'add',
      institutionSearch: null,
      institutionId: null, // required when operationType is 'update'
      name: [null, [Validators.required, Validators.maxLength(250)]], // required when operationType is 'add'
      country: [null, Validators.required],
      city: [null, Validators.required],
      state: null,
      postal: null,
      latitude: [null, [Validators.required, Validators.min(-90), Validators.max(90)]],
      longitude: [null, [Validators.required, Validators.min(-180), Validators.max(180)]],
      grid: null
    });

    this.api.fields().subscribe(response => {
      this.fields = response;
      console.log(this.fields);
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

  updateForm(formControlName, value) {
    console.log(formControlName, value);
    this.form.get(formControlName).patchValue(value);
  }

  stateCountryFilter(country) {
    return item => item && item.country == country;
  }

  initializeFormControls() {
    const controls = this.form.controls;

    // clear form and update validators when we change the operation type (add/update)
    controls.operationType.valueChanges.subscribe(value => {
      const { institutionId, name } = controls;

      // clear validators for related fields
      institutionId.clearValidators();
      name.clearValidators();

      if (value === 'add') {
        name.setValidators([Validators.required, Validators.maxLength(250)]);
      } else if (value === 'update') {
        institutionId.setValidators(Validators.required);
      }

      this.form.reset({
        operationType: value,
      }, {emitEvent: false});

      institutionId.updateValueAndValidity();
      name.updateValueAndValidity();
    });

    // fill in the form with the correct values when we select an institution

    controls.institutionId.valueChanges.subscribe(value => {
      if (value === null) return;
      const institution = this.fields.institutions.find(e => e.id === value);
      this.form.patchValue({
        institutionId: institution.id,
        city: institution.city,
        state: institution.state,
        postal: institution.postal,
        latitude: institution.latitude,
        longitude: institution.longitude,
        grid: institution.grid
      }, {emitEvent: false});
    });
  }

  submit() {
    this.messages = [];
    console.log('sub')

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

    const action = formValue.operationType; // 'add' or 'update'
    this.api[action](formData)
      .subscribe(response => {
        window.scrollTo(0, 0);
        let content = action === 'add'
          ? `The institution has been added. `
          : `The institution has been updated. `

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
      operationType: 'add',
    });
  }

}
