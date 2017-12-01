import { Component, Output, EventEmitter } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { DateValidators } from '../../../../validators/date-validator/date-validator';
import { FileValidators } from '../../../../validators/file-validator/file-validator';
import { DataUploadService } from '../../../../services/data-upload.service';

import { defineLocale } from 'ngx-bootstrap/bs-moment';
import { enGb } from 'ngx-bootstrap/locale';
defineLocale('en-GB', enGb);

@Component({
  selector: 'data-upload-form',
  templateUrl: './upload-form.component.html',
  styleUrls: ['./upload-form.component.css']
})
export class UploadFormComponent {

  @Output() onSubmit: EventEmitter<any> = new EventEmitter();

  @Output() onReset: EventEmitter<any> = new EventEmitter();

  form: FormGroup;

  currentDate: Date = new Date();

  csvDateFormats = [
    {value: 'en', label: 'United States (mm/dd/yyyy)'},
    {value: 'en-GB', label: 'United Kingdom (dd/mm/yyyy)'},
  ];

  sponsorCodes = [];

  loadDisabled: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private dataUpload: DataUploadService) {
    this.form = this.formBuilder.group({
      uploadType: ['NEW'],
      submissionDate: [null, [
        Validators.required,
        DateValidators.max(new Date())
      ]],
      csvDateFormat: ['en'],
      sponsorCode: [null, Validators.required],
      file: [null, [
        FileValidators.required,
        FileValidators.pattern(/csv$/),
      ]],
    });

    dataUpload.getPartners()
      .subscribe(response => this.sponsorCodes = response);
  }

  submit() {
    this.form.disable();
    this.loadDisabled = true;
    this.onSubmit.emit(this.form.value);
  }

  reset() {
    this.form.enable();

    this.form.controls.submissionDate.patchValue(null);

    this.form.reset({
      uploadType: 'NEW',
      csvDateFormat: 'en'
    });

    this.onReset.emit(null);
    this.loadDisabled = false;
  }

}
