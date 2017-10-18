import { Component, Input, ElementRef, ViewChild, forwardRef, OnChanges } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { Option } from './select.types';

@Component({
  selector: 'ui-select',
  templateUrl: './select.component.html',
  styleUrls: ['./select.component.css'],
  host: {
//    '(document:click)': 'handleDocumentClick($event)'
  },
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => SelectComponent),
    multi: true
  }]
})
export class SelectComponent implements OnChanges {

  @ViewChild('input') inputRef: ElementRef;

  @Input() inputClass: string = '';

  @Input() placeholder: string = '';

  @Input() dropdownContainerClass: string = '';

  @Input() dropdownItemClass: string = '';

  @Input() options: Option[] = [];

  filteredOptions: Option[] = [];

  selectedIndex: number = -1;

  open: boolean = false;

  constructor(private elementRef: ElementRef) {}

  writeValue(value: string) {
    let input = this.inputRef.nativeElement;
    input.value = '';

    let foundOption = this.options
      .find(option => option.value === value)

    if (foundOption) {
      input.value = foundOption.label;
    }
  }

  propagateChange(_: any) {};
  registerOnTouched() {};
  registerOnChange(fn) {
    this.propagateChange = fn;
  }

  boldMatch(input: string, original: string) {
    let markup = Array.from(original);
    let index = original.toLocaleLowerCase().indexOf(input.toLocaleLowerCase());
    markup.splice(index + input.length, 0, '</b>')
    markup.splice(index, 0, '<b>');
    return markup.join('');
  }

  handleKeyDown(event: KeyboardEvent) {
    let input = this.inputRef.nativeElement;

    if (event.key === 'ArrowUp') {
      this.selectedIndex -= 1;

      if (this.selectedIndex < 0)
        this.selectedIndex = this.filteredOptions.length - 1;
    }

    if (event.key === 'ArrowDown') {
      this.selectedIndex += 1;

     if (this.selectedIndex >= this.filteredOptions.length)
       this.selectedIndex = 0;
    }

    if (event.key === 'Tab') {
      event.preventDefault();
      let selectedOption = this.filteredOptions[this.selectedIndex];
      input.value = selectedOption.label;
    }

    if (event.key === 'Enter') {
      event.preventDefault();
      let selectedOption = this.filteredOptions[this.selectedIndex];
      input.value = selectedOption.label;
      this.propagateChange(selectedOption.value);
      this.open = false;
    }
  }

  handleKeyUp(event: KeyboardEvent) {
    let input = this.inputRef.nativeElement;
    let label = input.value;

    this.filteredOptions = this.options
      .filter(option => new RegExp(label, 'gi').test(option.label));

    let selectedOption = this.filteredOptions[this.selectedIndex];
  }

  handleFocus(event: FocusEvent) {
    console.log(event);
    let input = this.inputRef.nativeElement;
    this.open = true;
  }

  handleBlur(event) {
    let input = this.inputRef.nativeElement;
    this.open = false;
  }

  handleDocumentClick(event: MouseEvent) {
    let input = this.inputRef.nativeElement;
    this.open = event.target === input;

    if (this.open) {
      input.focus();
      input.value = '';
      this.selectedIndex = 0;
    }

    else {
      let label = input.value;
    }
  }

  handleDocumentFocus(event: FocusEvent) {
    let input = this.inputRef.nativeElement;
    this.open = event.target === input;

    if (this.open) {
      input.focus();
      input.value = '';
      this.selectedIndex = 0;
    }

    else {
      let label = input.value;
    }
  }

  handleOptionClick(selectedOption, index) {
    this.inputRef.nativeElement.value = selectedOption.label;
    this.propagateChange(selectedOption.value);
  }

  ngOnChanges() {
    this.filteredOptions = this.options;
    this.selectedIndex = 0;
  }



}
