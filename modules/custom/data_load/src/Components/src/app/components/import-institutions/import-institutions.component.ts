import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FileValidators } from '../../validators/file-validator/file-validator';
import { ImportService, ParseResult, ParseError } from '../../services/import.service';
import { tr } from 'ngx-bootstrap/bs-moment/i18n/tr';

@Component({
  selector: 'icrp-import-institutions',
  templateUrl: './import-institutions.component.html',
  styleUrls: ['./import-institutions.component.css'],
  providers: [ImportService],
})
export class ImportInstitutionsComponent  {

  form: FormGroup;

  loading: boolean = false;
  error: boolean = false;
  success: boolean = false;

  message: string = '';
  records: any[] = [];
  headers: string[] = [];

  invalidRecords: any[] = [];
  invalidRecordHeaders: string[] = [];


  constructor(
    private formBuilder: FormBuilder,
    private importService: ImportService,
  ) {
    this.form = formBuilder.group({
      file: ['', [
        FileValidators.required,
        FileValidators.pattern(/.csv$/)
      ]]
    });
  }

  async load() {
    if (!this.form.valid)
      return;

    const csv = await this.importService
      .parseCSV(this.form.controls.file.value[0], true) as ParseResult;

    this.headers = csv.meta.fields;
    this.records = csv.data;
  }

  async import() {
    if (!this.form.valid)
      return;

    this.loading = true;
    this.error = false;
    this.success = false;
    this.message = '';

    const data = this.records.map(row => this.headers.map(header => row[header]));
    const response$ = await this.importService.importInstitutions(data);
    response$.subscribe(
      data => {
        this.loading = false;
        this.success = true;
        this.invalidRecords = data;
        this.invalidRecordHeaders = Object.keys(this.invalidRecords[0]);
      },

      ({error}) => {
        this.loading = false;
        this.error = true;
        this.message = error;
        console.error(error);
      },
    );
  }

  reset() {
    this.form.reset();
    this.error = false;
    this.success = false;
    this.message = '';
    this.records = [];
    this.headers = [];
  }

  cancel() {
    window.location.href = `${window.location.protocol}//${window.location.hostname}`;
  }

}
