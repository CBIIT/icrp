import { Component, Input, forwardRef } from '@angular/core';
import { ControlValueAccessor, FormGroup, FormControl,  NG_VALUE_ACCESSOR } from '@angular/forms';
import * as parse from 'url-parse';

@Component({
  selector: 'website-input',
  templateUrl: './website-input.component.html',
  styleUrls: ['./website-input.component.css'],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => WebsiteInputComponent),
    multi: true,
  }]
})
export class WebsiteInputComponent implements ControlValueAccessor {

  /**
   * Contains form controls for a WebsiteInputComponent
   *
   * @type {FormGroup}
   * @memberof WebsiteInputComponent
   */
  form: FormGroup =  new FormGroup({
    protocol: new FormControl("http:"),
    resource: new FormControl("")
  });

  /**
   * Contains allowed protocol identifiers
   *
   * @memberof WebsiteInputComponent
   */
  protocols = [
    {label: 'http://', value: 'http:'},
    {label: 'https://', value: 'https:'},
  ];

  /**
   * Placeholder text for the input
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  placeholder: string = 'Enter website'

  /**
   * Global css classes to be applied to the select element
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  selectClass: string;

  /**
   * CSS styles to be applied to the select element
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  selectStyle: string;

  /**
   * Global css classes to be applied to the input element
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  inputClass: string;

  /**
   * Css styles to be applied to the input element
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  inputStyle: string;

  /**
   * ID attribute to set for the input element
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  inputId: string;

  /**
   * Name attribute to set for the input element
   *
   * @type {string}
   * @memberof WebsiteInputComponent
   */
  @Input()
  inputName: string;

  /**
   * The current value of this component
   *
   * @private
   * @type {(string | null)}
   * @memberof WebsiteInputComponent
   */
  private _value: string | null = null;

  constructor() {
    const protocolRegex = /^https?:\/\//;

    this.form.controls.resource.valueChanges.subscribe((value) => {
      if (value.length) {
        if (!protocolRegex.test(value)) value = `${this.form.value.protocol}//${value}`;
        const protocol = value.match(protocolRegex)[0].replace(/\/{2}$/g, "");
        const newValue = value.replace(protocolRegex, "");

        this.form.patchValue(
          {
            protocol: protocol,
            resource: newValue
          },
          { emitEvent: false }
        );
      } else {
        this.form.patchValue(
          { resource: "" },
          { emitEvent: false }
        );
      }
    });

    this.form.valueChanges.subscribe((value) => {
      this.value = value.resource
        ? `${value.protocol}//${value.resource}`
        : null;
    });

    this.form.controls.resource.updateValueAndValidity();
  }

  /**
   * Gets the value property
   *
   * @memberof WebsiteInputComponent
   */
  get value() {
    return this._value;
  }

  /**
   * Sets the value property
   *
   * @param {string} value The new value to assign to this component
   * @memberof WebsiteInputComponent
   */
  set value(value: string) {
    if (value) {
      const url = parse(value);
      this._value = url ? url.href : null;
    } else {
      this._value = null;
    }
    
    this.onChange(this._value);
  }

  onChange(value: string) {
    this.form.controls.protocol.updateValueAndValidity({ emitEvent: false });
    this.form.controls.resource.updateValueAndValidity({ emitEvent: false });
  }

  registerOnTouched() {}
  registerOnChange(fn) {
    this.onChange = fn;
  }

  // writes the current value to value property
  writeValue(value: string) {
    this.form.patchValue({
      resource: value || ""
    });
  }

  setDisabledState(isDisabled: boolean) {
    if (isDisabled) {
      this.form.disable();
    } else {
      this.form.enable();
    }
  }
}
