import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FileValidators } from '../../validators/file-validator/file-validator';
import { ImportService, ParseResult, ParseError } from '../../services/import.service';
import { ExportService } from '../../services/export.service';

@Component({
  selector: 'icrp-import-collaborators',
  templateUrl: './import-collaborators.component.html',
  styleUrls: ['./import-collaborators.component.css'],
})
export class ImportCollaboratorsComponent {

  form: FormGroup;

  loading: boolean = false;
  alerts: {type: string, content: string}[] = [];

  records: any[] = [];
  headers: string[] = [];

  hasInvalidRecords: boolean = false;
  importDisabled: boolean = true;

  EXPECTED_COLUMNS: number = 10;

  constructor(
    private formBuilder: FormBuilder,
    private importService: ImportService,
    private exportService: ExportService,
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

    this.alerts = [];
    this.loading = true;
    const csv = await this.importService
      .parseCSV(this.form.controls.file.value[0], true) as ParseResult;
    this.loading = false;

    if (csv.meta.fields.length === this.EXPECTED_COLUMNS) {
      this.headers = csv.meta.fields;
      this.records = csv.data;
      this.importDisabled = false;
    }

    else {
      window.scroll(0, 0);
      this.alerts.push({
        type: 'danger',
        content: 'The input file does not contain the expected number of columns.'
      });
    }

  }

  async import() {
    if (!this.form.valid)
      return;

    this.loading = true;
    this.importDisabled = true;
    this.hasInvalidRecords = false;
    this.alerts = [];

    const records = this.records.map(row => this.headers.map(header => row[header]));
    const response$ = await this.importService.importCollaborators(records);
    response$.subscribe(
      data => {
        window.scroll(0, 0);
        this.loading = false;

        if (Array.isArray(data) && data.length > 0) {
          this.hasInvalidRecords = true;
          this.records = data;
          this.headers = Object.keys(data[0]);
          this.alerts.push({
            type: 'warning',
            content: 'The following records failed the data check. Import aborted. Please correct the data file and rerun the import.'
          });
        } else {
          window.scroll(0, 0);
          this.alerts.push({
            type: 'success',
            content: `${records.length.toLocaleString()} collaborators have been successfully imported.`
          });
        }
      },

      ({error}) => {
        this.loading = false;
        this.alerts.push({
          type: 'danger',
          content: error,
        });
      },
    );
  }

  export() {
    const filename: string = this.form.controls.file.value[0].name
      .replace(/.csv$/, '_Errors.xlsx');

    const sheets = [{
      title: 'Invalid Records',
      rows: [this.headers]
        .concat(this.records
          .map(record => this.headers
            .map(header => record[header])))
    }];

    this.exportService.exportAsExcel(sheets, filename);
  }

  reset() {
    this.form.reset();
    this.alerts = [];
    this.records = [];
    this.headers = [];
    this.importDisabled = true;
    this.hasInvalidRecords = false;
  }

  cancel() {
    window.location.href = `${window.location.protocol}//${window.location.hostname}`;
  }
}
