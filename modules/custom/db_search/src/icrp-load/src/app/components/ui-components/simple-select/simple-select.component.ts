
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
  selector: 'ui-simple-select',
  templateUrl: './simple-select.component.html',
  styleUrls: ['./simple-select.component.css'],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => SimpleSelectComponent),
    multi: true
  }],
  host: {
    '(document:click)': 'focusInput($event)',
  },
  
})

export class SimpleSelectComponent {

  /** Placeholder text */
  @Input() placeholder: string;

  /** Sets the default item delimiter */
  @Input() itemDelimiter: string = ',';

  /** Default email regex */
  @Input() validationRegex: RegExp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

  /** Updates whenever an item has been selected or deselected  */
  @Output() select: EventEmitter<any[]>;

  /** Reference to the input element */
  @ViewChild('input') input: ElementRef;

  public valid: boolean = false;

  /** Selected items */
  selectedItems: string[];

  constructor(private _ref: ElementRef) {
    this.placeholder = '';
    this.select = new EventEmitter<any[]>();

    this.selectedItems = [];
  }

  /** Sets the value of this control */
  writeValue(values: string[]) {
    this.selectedItems = JSON.parse(JSON.stringify(values));
    this.emitValue();
  }

  /** Register change handlers */
  propagateChange(_: any) { };
  registerOnTouched() { }
  registerOnChange(fn) {
    this.propagateChange = fn;
  }

  emitValue() {
    this.propagateChange(this.selectedItems);
    this.select.emit(this.selectedItems);
  }

  removeSelectedItem(index: number) {
    this.selectedItems.splice(index, 1);
    this.emitValue();
  }

  handleKeydownEvent(event: KeyboardEvent) {

    let input = this.input.nativeElement;

    if (event.key === this.itemDelimiter) {
      event.preventDefault();
      this.addValueToSelection();
    }

    if (event.key === 'Backspace' && !input.value.length) {
      this.valid = true;
      this.selectedItems.pop();
    }

    this.emitValue();
  }

  addValueToSelection() {
    let input = this.input.nativeElement;
    let value = input.value;

    if (this.validationRegex.test(value)) {
      this.valid = true;
      this.selectedItems.push(value);
      input.value = '';
    } else {
      this.valid = false;
      console.log('valid', this.valid);
    }

  }

  focusInput(event: any) {
    if (this._ref.nativeElement.contains(event.target)) {
      this.input.nativeElement.focus();
    }
    else {
      this.addValueToSelection();
      this.emitValue();
    }
  }
}
