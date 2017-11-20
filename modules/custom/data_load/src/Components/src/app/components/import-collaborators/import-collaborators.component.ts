import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FileValidators } from '../../validators/file-validator/file-validator';
import { ImportService } from '../../services/import.service';

@Component({
  selector: 'icrp-import-collaborators',
  templateUrl: './import-collaborators.component.html',
  styleUrls: ['./import-collaborators.component.css'],
  providers: [ImportService]
})
export class ImportCollaboratorsComponent {

  form: FormGroup;

  error: boolean = false;
  message: string = '';

  constructor(
    private formBuilder: FormBuilder,
    private importService: ImportService
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

    let response$ = await this.importService.importCollaborators(this.form.value.file);
    response$.subscribe(
      data => {
        console.log(data);
      },

      ({error}) => {
        this.error = true;
        this.message = error;
        console.error(error);
      }
    );
  }

  reset() {
    this.form.reset({
      file: ''
    });
  }
}
