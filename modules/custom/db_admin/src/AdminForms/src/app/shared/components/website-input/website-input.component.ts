import { Component, Input, ElementRef, ViewChild, forwardRef } from '@angular/core';
import { ControlValueAccessor, FormGroup, FormBuilder, NG_VALUE_ACCESSOR } from '@angular/forms';
import { Observable, combineLatest } from 'rxjs';
import { map } from 'rxjs/operators'
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
  form: FormGroup;

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

  /**
   * Creates an instance of WebsiteInputComponent.
   * @param {FormBuilder} formBuilder Angular FormBuilder service
   * @memberof WebsiteInputComponent
   */
  constructor(private formBuilder: FormBuilder) {

    this.form = formBuilder.group({
      protocol: 'http:',
      resource: '',
    });

    const { protocol, resource } = this.form.controls;

    // initialize observables for input value changes
    const protocol$ = protocol.valueChanges;

    // if a website's url was pasted into the input,
    // remove the protocol from the supplied url,
    // set the protocol selector to the appropriate value,
    // and set the input's value to the truncated url
    const resource$ = resource.valueChanges.pipe(
      map((value: string = '') => {
        if (/^https?:\/\//.test(value)) {

          let url = null;
          let resource = value;

          // eliminate any duplicate leading protocol strings
          do {
            url = parse(resource);
            resource = `${url.host}${url.pathname}`;
          } while (/^https?:$/.test(url.host))

          // update the form controls to reflect the new value
          // when valueChanges emits a new value, that value
          // will be used instead of the current value
          this.form.setValue({
            protocol: url.protocol,
            resource: resource
          });

          return resource;
        } else {
          return value;
        }
      }),
    );

    // update the current value whenever an input changes
    combineLatest(
      protocol$,
      resource$,
      (protocol, resource) =>
        protocol && resource
          ? `${protocol}//${resource}`
          : null
    ).subscribe(value => this.value = value)

    protocol.updateValueAndValidity();
    resource.updateValueAndValidity();
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
      let url = parse(value);
      let protocol = url.protocol || 'http:';
      let resource = `${url.host}${url.pathname}${url.query}`;

      this._value = resource
        ? url.href : null;

      this.form.patchValue(
        {protocol, resource},
        {emitEvent: false}
      );
    } else {
      this._value = null;
    }

    this.onChange(this._value);
  }

  onChange(value: string) {
    this.form.controls.protocol.updateValueAndValidity({emitEvent: false});
    this.form.controls.resource.updateValueAndValidity({emitEvent: false});
  }

  registerOnTouched() {}
  registerOnChange(fn) {
    this.onChange = fn;
  }

  // writes the current value to value property
  writeValue(value: string) {
    this.form.patchValue({
      protocol: 'http:',
      resource: value || ''
    });
  }

  setDisabledState(isDisabled: boolean) {
    isDisabled
      ? this.form.disable()
      : this.form.enable();
  }
}
