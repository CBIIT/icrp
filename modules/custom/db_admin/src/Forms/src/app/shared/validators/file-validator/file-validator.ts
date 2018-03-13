import { AbstractControl, ValidatorFn } from '@angular/forms';


const required: ValidatorFn = (control: AbstractControl): {[key: string]: any} =>
  control.value == null || control.value.length == 0
    ? {required: true}
    : null;

const pattern: (pattern: string | RegExp) => ValidatorFn = (pattern: string | RegExp): ValidatorFn =>
(control: AbstractControl): {[key: string]: any} => {

  if (control.value) {
    const regex = pattern instanceof RegExp
      ? pattern
      : new RegExp(pattern);

    for(let file of Array.from(control.value as FileList)) {
      if (!regex.test((file as File).name)) {
        return {pattern: true};
      }
    }
  }

  return null;
}

export const FileValidators = {pattern, required}
