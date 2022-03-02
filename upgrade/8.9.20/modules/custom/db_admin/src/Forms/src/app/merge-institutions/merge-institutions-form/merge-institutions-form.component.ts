import { Component } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { InstitutionsApiService } from 'src/app/services/institutions-api.service';
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'icrp-merge-institutions-form',
  templateUrl: './merge-institutions-form.component.html',
  styleUrls: ['./merge-institutions-form.component.css']
})
export class MergeInstitutionsFormComponent {

  form: FormGroup;
  messages: { type: string, content: string }[] = [];
  fields: any = {};
  loading: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private api: InstitutionsApiService
  ) {

    this.form = this.formBuilder.group({
      deletedInstitutionSearch: null,
      keptInstitutionSearch: null,
      deletedInstitutionId: [null, Validators.required],
      keptInstitutionId: [null, Validators.required],
    });

    this.api.fields().subscribe(response => {
      this.fields = response;
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
    this.form.get(formControlName).patchValue(value);
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

    this.api.merge(formData)
      .subscribe(response => {
        window.scrollTo(0, 0);
        this.form.reset();
        console.log(response);
        let content = `These two institutions were merged successfully. ${response} PIs/collaborators were moved to the new institution.`;
        this.messages.push({
          type: 'success',
          content: content,
        });
        this.api.fields().subscribe(response => {
          this.fields = response;
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
    this.form.reset();
  }

}
