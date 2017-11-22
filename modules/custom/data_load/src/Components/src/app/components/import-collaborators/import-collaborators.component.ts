import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FileValidators } from '../../validators/file-validator/file-validator';
import { ImportService, ParseResult } from '../../services/import.service';
import { ExportService } from '../../services/export.service';

@Component({
  selector: 'icrp-import-collaborators',
  templateUrl: './import-collaborators.component.html',
  styleUrls: ['./import-collaborators.component.css'],
  providers: [ImportService, ExportService]
})
export class ImportCollaboratorsComponent {

  form: FormGroup;

  loading: boolean = false;
  error: boolean = false;
  message: string = '';
  records: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private importService: ImportService,
    private exportService: ExportService
  ) {
    this.form = formBuilder.group({
      file: ['', [
        FileValidators.required,
        FileValidators.pattern(/.csv$/)
      ]]
    });
  }

  async submit() {
    if (!this.form.valid)
      return;

    this.loading = true;
    this.error = false;
    this.message = '';

    const csv = await this.importService.parseCSV(this.form.controls.file.value[0]) as ParseResult;
    const data = csv.data;
    data.shift();
    const response$ = await this.importService.importCollaborators(data);
    response$.subscribe(
      data => {
        if (data && data.length > 0) {
          this.error = true;
          this.message = 'The following records did not pass the integrity check. The import process has been aborted. Please correct the data file and import again.';
          this.records = data;
        }

        else {
          this.error = false;
          this.message = 'Collaborators have been imported successfully.';
        }
      },

      ({error}) => {
        this.error = true;
        this.message = error;
        console.error(error);
        this.loading = false;
      },

      () => {
        this.loading = false;
      }
    );
  }

  export() {
    const filename: string = this.form.controls.file.value[0].name;
    const sheets = [
      {
        title: 'Invalid Records',
        rows: [['Error', 'Institution', 'City']]
          .concat(this.records.map(
            ({Error, Institution, City}) =>
              [Error, Institution, City]
          ))
      },
    ];

    this.exportService.getExcelExport(sheets, filename.replace(/.csv$/, '_Errors'))
      .subscribe(response => window.document.location.href =
        `${window.location.protocol}//${window.location.hostname}/${response}`);
  }

  reset() {
    this.form.reset();
    this.error = false;
    this.message = '';
    this.records = [];
  }
}
