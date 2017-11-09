import { Component, Input, ElementRef, ViewChild, forwardRef } from '@angular/core';
import { ControlValueAccessor, FormGroup, FormBuilder, NG_VALUE_ACCESSOR } from '@angular/forms';

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
export class WebsiteInputComponent {

  form: FormGroup;

  protocols = [
    {label: 'http://', value: 'http'},
    {label: 'https://', value: 'https'},
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

  constructor(private formBuilder: FormBuilder) {
    this.form = formBuilder.group({
      protocol: 'http',
      resource: null,
    });

    this.form.controls.protocol.valueChanges;
    this.form.controls.resource.valueChanges;
  }
}
