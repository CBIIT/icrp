import { AbstractControl, ValidatorFn } from '@angular/forms';

const max: (date: Date) => ValidatorFn = (date: Date): ValidatorFn =>
(control: AbstractControl): {[key: string]: any} => {

  return control.value && control.value as Date > date
    ? { max: true }
    : null
}

export const DateValidators = {max}
