import {
  Component,
  ElementRef,
  EventEmitter,
  forwardRef,
  Input,
  Output,
  ViewChild
} from '@angular/core';

import { 
  ControlValueAccessor, 
  NG_VALUE_ACCESSOR 
} from '@angular/forms';

@Component({
  selector: 'custom-select',
  templateUrl: './custom-select.component.html',
  styleUrls: ['./custom-select.component.css'],
  host: {
    '(document:click)': 'focusInput($event)',
  },
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => CustomSelectComponent),
    multi: true
  }]
})

export class CustomSelectComponent {

  /** Placeholder text */
  @Input() placeholder: string;

  /** Control evaluation of this component */
  @Input() disable: boolean;

  /** Updates whenever an item has been added or deleted  */
  @Output() onSelect: EventEmitter<string[]>;

  /** Reference to the input element */
  @ViewChild('input') input: ElementRef;

  /** State of current element validation */
  valid: boolean = false;

  /** Entered items */
  items: string[];

  /** Boolean storing mouse state */
  mousePressed: boolean;

  constructor(private _ref: ElementRef) {
    this.disable = false;
    this.items = [];
    this.placeholder = '';
    this.onSelect = new EventEmitter<(string | number)[]>();
  }

  /** Sets the value of this control */
  writeValue(values: string[]) {
    this.items = [];
    if (values && values.length) {
      for (let value of values) {
        this.items.push(value);
      }
    }
  }

  /** Register change handlers */
  propagateChange(_: any) { };
  registerOnTouched() { }
  registerOnChange(fn) {
    this.propagateChange = fn;
  }

  emitValue() {
    this.propagateChange(this.items);
    this.onSelect.emit(this.items);
  }

  validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  removeItem(index: number) {
    this.items.splice(index, 1);
    this.emitValue();
  }

  addItem(item) {
    this.valid = this.validateEmail(item);

    if (this.valid) {
      this.items.push(item);
      this.input.nativeElement.value = '';
      this.emitValue();
    }
  }

  handleKeydownEvent(event: KeyboardEvent) {

    let value = this.input.nativeElement.value;

    if (event.key === ',' && value.length > 0) {
      event.preventDefault();
      this.addItem(value);
    }

    if (event.key === 'Backspace' 
    && value.length === 0 
    && this.items.length > 0) {
      this.items.pop();
      this.emitValue();
    }
  }


  focusInput(event: any) {
    if (this._ref.nativeElement.contains(event.target)) {
      this.input.nativeElement.focus();
    } else {
      this.addItem(this.input.nativeElement.value);
    }
  }
}
