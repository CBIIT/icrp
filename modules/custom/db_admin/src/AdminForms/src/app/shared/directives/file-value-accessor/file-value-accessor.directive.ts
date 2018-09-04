import { Directive, HostListener, ElementRef } from '@angular/core';
import { NG_VALUE_ACCESSOR, ControlValueAccessor } from '@angular/forms';

@Directive({
  selector: 'input[type=file]',
  host: {
    '(change)': 'onChange($event.target.files)',
    '(blur)': 'onTouched()',
  },
  providers: [
    {provide: NG_VALUE_ACCESSOR, useExisting: FileValueAccessorDirective, multi: true}
  ]
})
export class FileValueAccessorDirective implements ControlValueAccessor {

  constructor(private elementRef: ElementRef) {}
  registerOnChange(fn: any) {this.onChange = fn;}
  registerOnTouched(fn: any) {this.onTouched = fn;}
  onChange(_: FileList) {}
  onTouched() {};
  writeValue(value: any) {
    if (value === null || value === '') {
      this.elementRef.nativeElement.value = '';
    }
  }

  get value() {
    return this.elementRef.nativeElement.value;
  }

  set value(value) {
    this.writeValue(null);
  }
}
