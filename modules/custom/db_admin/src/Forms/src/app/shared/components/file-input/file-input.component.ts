import { Component, Input, ElementRef, ViewChild, forwardRef } from '@angular/core';
import { ControlValueAccessor, FormGroup, FormBuilder, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'file-input',
  templateUrl: './file-input.component.html',
  styleUrls: ['./file-input.component.css'],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => FileInputComponent),
    multi: true,
  }]
})
export class FileInputComponent {

  /**
   * Contains form controls for a FileInputComponent
   *
   * @type {FormGroup}
   * @memberof FileInputComponent
   */
  form: FormGroup;

  /**
   * Placeholder text for the input
   *
   * @type {string}
   * @memberof FileInputComponent
   */
  @Input()
  placeholder: string = 'Select a file'

  /**
   * Text for "Browse" button
   *
   * @type {string}
   * @memberof FileInputComponent
   */
  @Input()
  buttonText: string = 'Browse...'


  /**
   * Global css classes to be applied to the select button
   *
   * @type {string}
   * @memberof FileInputComponent
   */
  @Input()
  buttonClass: string;


  /**
   * Global css classes to be applied to the read-only text input
   *
   * @type {string}
   * @memberof FileInputComponent
   */
  @Input()
  inputClass: string;

  /**
   * ID attribute to set for the file input element
   *
   * @type {string}
   * @memberof FileInputComponent
   */
  @Input()
  inputId: string;


  /**
   * If true, allows multiple file selections
   *
   * @type {boolean}
   * @memberof FileInputComponent
   */
  @Input()
  multiple: boolean = false;


  private fileName: string;

  private fileList: FileList = null;


  constructor(private formBuilder: FormBuilder) {
    this.form = formBuilder.group({
      fileName: null
    });
  }


  /**
   * Gets the value property
   *
   * @memberof WebsiteInputComponent
   */
  get value() {
    return this.fileList;
  }

  /**
   * Sets the value property
   *
   * @param {string} value The new value to assign to this component
   * @memberof WebsiteInputComponent
   */
  set value(value: FileList) {

  }


  onChange(value: string) {
    this.form.controls.fileName.updateValueAndValidity({emitEvent: false});
  }

  registerOnTouched() {}
  registerOnChange(fn) {
    this.onChange = fn;
  }

  // writes the current value to the value property
  writeValue(fileName: string) {
    this.form.patchValue({fileName});
  }
}
