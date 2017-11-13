import { Component, Input, ElementRef, ViewChild, forwardRef } from '@angular/core';
import { ControlValueAccessor, FormGroup, FormBuilder, NG_VALUE_ACCESSOR } from '@angular/forms';
import { Observable } from 'rxjs';
import { defaultIfEmpty, map } from 'rxjs/operators'
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

  form: FormGroup;

  protocols = [
    {label: 'http://', value: 'http:'},
    {label: 'https://', value: 'https:'},
  ];

  @Input()
  placeholder: string = 'Enter website'

  @Input()
  selectClass: string;

  @Input()
  selectStyle: string;

  @Input()
  inputClass: string;

  @Input()
  inputStyle: string;

  @Input()
  inputId: string;

  @Input()
  inputName: string;

  @Input('value')
  _value: string;


  constructor(private formBuilder: FormBuilder) {
    this.form = formBuilder.group({
      protocol: 'http:',
      resource: '',
    });

    let { protocol, resource } = this.form.controls;

    let protocol$ = protocol.valueChanges;
    let resource$ = resource.valueChanges.pipe(
      map((value: string) => {

      let resourceValue = value || '';
      if (/^https?:\/\//.test(value)) {
        let url = parse(value);
        resourceValue = `${url.host}${url.pathname}`;
        this.form.patchValue({
          protocol: url.protocol,
          resource: resourceValue
        });
      }

      return resourceValue
    }));

    Observable.combineLatest(
      protocol$,
      resource$,
      this.parseInput
    ).subscribe(value => this.value = value)

    protocol.updateValueAndValidity();
    resource.updateValueAndValidity();
  }

  parseInput(protocol, resource) {
    return `${protocol}//${resource}`
  }

  get value() {
    return this._value;
  }

  set value(value) {
    let url = parse(value);
    let path = `${url.host}${url.pathname}`;

    this._value = path
      ? `${url.protocol}//${path}`
      : null;

    this.form.patchValue({
      protocol: url.protocol,
      resource: `${url.host}${url.pathname}`
    }, {emitEvent: false});
    this.onChange(this._value);
  }

  onChange(value: string) {}
  registerOnTouched() {}
  registerOnChange(fn) {
    this.onChange = fn;
  }

  writeValue(value: string) {
    this.form.reset({
      protocol: 'http:',
      resource: value
    });
  }
}
