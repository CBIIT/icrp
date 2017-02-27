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
  selector: 'ui-select',
  templateUrl: './ui-select.component.html',
  styleUrls: ['./ui-select.component.css'],
  host: {
    '(document:mousedown)': 'mouseDown($event)',
    '(document:click)': 'focusInput($event)',
    '(document:mouseup)': 'documentMouseUp($event)',
  },
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => UiSelectComponent),
    multi: true
  }]  
})

export class UiSelectComponent {

  /** The array of possible items for this input */
  @Input() items: { "value": number | string, "label": "string"}[];

  /** Placeholder text */
  @Input() placeholder: string;

  /** Control evaluation of this component */
  @Input() disable: boolean;

  /** Updates whenever an item has been selected or deselected  */
  @Output() onSelect: EventEmitter<(string | number)[]>;

  /** Reference to the input element */
  @ViewChild('input') input: ElementRef;

  /** Selected items */
  selectedItems: { "value": number | string, "label": "string"}[];

  /** Indexes of items matching the search results. 
   * 
   * Index refers to the index of the item.  
   * Location refers to the location of the matched text. 
   */  
  matchingItems: { "value": number | string, "label": "string"} [];

  /** Index of highlighted item in search dropdown */
  highlightedItemIndex: number;

  /** Initial index of highlighted item in search dropdown */
  initialHiglightedRangeIndex: number;

  /** Current index of highlighted item in search dropdown */
  currentHiglightedRangeIndex: number;

  /** Boolean controlling whether search dropdown should appear or not */
  showSearchDropdown: boolean;

  /** Boolean storing mouse state */
  mousePressed: boolean;

  constructor(private _ref: ElementRef) {
    this.disable = false;
    this.showSearchDropdown = false;
    this.items = [];
    this.placeholder = '';
    this.onSelect = new EventEmitter<(string | number)[]>();

    this.selectedItems = [];
    this.matchingItems = [];
    this.highlightedItemIndex = -1;
    this.initialHiglightedRangeIndex = -1;
    this.currentHiglightedRangeIndex = -1;
  }

  /** Sets the value of this control */
  writeValue(values: string[]) {
    this.selectedItems = [];
    if (values && values.length) {
      for (let value of values) {
        this.selectedItems.push(
          this.items.find(item => item.value == value)
        );
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
    let values = this.selectedItems.map(item => item.value);
    this.propagateChange(values);
    this.onSelect.emit(values);
  }

  removeSelectedItem(index: number) {
    this.selectedItems.splice(index, 1);
    this.emitValue();
  }

  addSelectedItem(item: { "value": number | string, "label": "string"}) {
    this.selectedItems.push(item);
    this.input.nativeElement.value = '';
    this.emitValue();
  }

  handleKeydownEvent(event: KeyboardEvent) {

    if (event.key === 'Enter' && this.matchingItems.length > 0) {
      event.preventDefault();

      this.addSelectedItem(this.matchingItems[this.highlightedItemIndex]);
      this.updateSearchResults();
    }

    if (event.key === 'Backspace' 
    && this.input.nativeElement.value.length === 0 
    && this.selectedItems.length > 0) {
      this.selectedItems.pop();
      this.updateSearchResults();
      this.emitValue();
    }
  }

  handleKeyupEvent(event: KeyboardEvent) {
    let input = this.input.nativeElement;

    if (event.key === 'ArrowUp') {
      this.highlightedItemIndex --;

      if (this.highlightedItemIndex < 0)
        this.highlightedItemIndex = this.matchingItems.length - 1;
    }

    else if (event.key === 'ArrowDown') {
      this.highlightedItemIndex ++;

      if (this.highlightedItemIndex >= this.matchingItems.length)
        this.highlightedItemIndex = 0;
    }

    else {
      this.updateSearchResults();
    }
  }

  /** Updates matching indexes */
  updateSearchResults(): void {
    let label = this.input.nativeElement.value;

    this.matchingItems = this.items
      .filter(item => !this.selectedItems.find(selectedItem => item.label == selectedItem.label))
      .filter(item => item.label.toLowerCase().indexOf(label.toLowerCase()) > -1)

    this.highlightedItemIndex = this.matchingItems.length ? 0 : -1;
    this.showSearchDropdown = this.matchingItems.length > 0;
  }

  highlightItem(index: { "value": number | string, "label": "string"}, item): string {

    let label: string = index.label;
    let inputValue = this.input.nativeElement.value;
    let inputLength: number = this.input.nativeElement.value.length;
    let displayString = label;
    
    if (inputValue && inputLength) {
      let location = label.toLowerCase().indexOf(inputValue.toLowerCase());

      if (location >= 0) {
        let first = label.substr(0, location);
        let mid = label.substr(location, inputLength);
        let end = label.substr(location + inputLength);

        displayString = first + '<b>' + mid + '</b>' + end;
      }
    }
    
    return displayString;
  }

  focusInput(event: any) {
    this.showSearchDropdown = this._ref.nativeElement.contains(event.target);

    if (this.showSearchDropdown) {
      this.input.nativeElement.focus();
      this.updateSearchResults();
      this.showSearchDropdown = true;
    }
  }

  highlightIndex(index, item) {

    this.currentHiglightedRangeIndex = index;
    this.highlightedItemIndex = index;

    if (isNaN(this.initialHiglightedRangeIndex) || !this.mousePressed)
      this.initialHiglightedRangeIndex = this.currentHiglightedRangeIndex;
  }

  mouseDown(event, index, item) {
    this.mousePressed = true;
    this.initialHiglightedRangeIndex = +this.currentHiglightedRangeIndex;
  }


  documentMouseUp(index, item: any) {
    this.mousePressed = false;
  }

  mouseUp(index, item: any) {
    this.mousePressed = false;
    this.addRangeToSelectedItems();
  }

  addRangeToSelectedItems() {

    for (let i = this.initialHiglightedRangeIndex; i <= this.currentHiglightedRangeIndex; i ++) {
      let item = this.matchingItems[i];

      if (item && !this.selectedItems.find(i => i.label === item.label && i.value === item.value)) {
        console.log('will add item: ', item)
        this.selectedItems.push(this.matchingItems[i]);
      }    
    }

    this.initialHiglightedRangeIndex = -1;
    this.currentHiglightedRangeIndex = -1;

    this.emitValue();
  }
}
