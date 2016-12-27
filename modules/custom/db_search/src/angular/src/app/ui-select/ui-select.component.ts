import {
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnChanges,
  Output,
  SimpleChanges,
  ViewChild
} from '@angular/core';

@Component({
  selector: 'ui-select',
  templateUrl: './ui-select.component.html',
  styleUrls: ['./ui-select.component.css'],
  host: {
    '(document:click)': 'focusInput($event)'
  }
})
export class UiSelectComponent implements OnChanges {

  /** The array of possible items for this input */
  @Input() items: { "value": string | number, "label": string | number }[] | string[];

  /** Placeholder text */
  @Input() placeholder: string;
  
  /** Updates whenever an item has been selected or deselected  */
  @Output() onSelect: EventEmitter<string[]>;

  /** Reference to the input element */
  @ViewChild('input') input: ElementRef;

  /** Actual values for all items */
  values: string[];
  
  /** Labels for all items */
  labels: string[];

  /** Indexes of selected items */  
  selectedItems: number[];

  /** Indexes of matched items - index refers to the index of the item, location refers to the location of the matched item */  
  matchingItems: { "index": number, "location": number }[];

  selectedIndex: number;

  isActive: boolean;

  constructor(private _ref: ElementRef) {
    this.isActive = false;
    this.items = [];
    this.placeholder = '';
    this.onSelect = new EventEmitter<string[]>();
    this.values = [];
    this.labels = [];
    this.selectedItems = [];
    this.matchingItems = [];
    this.selectedIndex = -1;
  }

  removeSelectedItem(index: number) {
    this.selectedItems.splice(index, 1);
  }

  addSelectedItem(index: number) {
    this.selectedItems.push(index);
    this.input.nativeElement.value = '';
  }

  update(event: KeyboardEvent) {
    let input = this.input.nativeElement;

    if (event.key === 'Enter' && this.matchingItems.length >= 0) {
      this.selectedItems.push(this.matchingItems[this.selectedIndex].index)
      input.value = '';
      this.updateSearchResults();
    }

    else if (event.key === 'Backspace' && input.value.length === 0 && this.selectedItems.length > 0) {
      this.selectedItems.pop();
      this.updateSearchResults();
    }

    else if (event.key === 'ArrowUp') {
      this.selectedIndex --;

      if (this.selectedIndex < 0)
        this.selectedIndex = this.matchingItems.length - 1;
    }

    else if (event.key === 'ArrowDown') {
      this.selectedIndex ++;

      if (this.selectedIndex >= this.matchingItems.length)
        this.selectedIndex = 0;
    }
      
    else {
      this.updateSearchResults();
    }


  }


  /** Updates matching indexes */
  updateSearchResults(): void {
    let label = this.input.nativeElement.value;

    this.matchingItems = this.labels.reduce((accumulator, current, index) => {

      let loc = label.length && current.toLowerCase().indexOf(label.toLowerCase());
      
      if ((loc >= 0 && this.selectedItems.indexOf(index) == -1))
        accumulator.push({
          index: index,
          location: loc
        });
      return accumulator;
    }, []);

    this.selectedIndex = this.matchingItems.length ? 0 : -1;
  }

  highlightItem(item: { "index": number, "location": number }, index: number): string {

    let label: string = this.labels[item.index];
    let length: number = this.input.nativeElement.value.length;

    let displayString = label;
    
    if (item.location >= 0) {
      let first = label.substr(0, item.location);
      let mid = label.substr(item.location, length);
      let end = label.substr(item.location + length);

      displayString = first + '<b>' + mid + '</b>' + end;
    }

    return displayString;
  }

  focusInput(event: any) {
    this.isActive = this._ref.nativeElement.contains(event.target);

    if (this.isActive) {
      this.input.nativeElement.focus();
      this.updateSearchResults();
      this.isActive = true;
    }
  }

  selectIndex(index) {
    console.log('new index', index);
    this.selectedIndex = index;
  }

  

  ngOnChanges(changes: SimpleChanges) {
    if (changes['items'])
      this.initializeItems(this.items);
  }


  /**
   * Initializes separate arrays for values and labels to improve performance
   */
  initializeItems(items: any[]) {
    
    this.values = [];
    this.labels = [];

    items.forEach(item => {
      if (typeof item === 'string') {
        this.values.push(item);
        this.labels.push(item);
      } else if (typeof item === 'object' && item.value && item.label) {
        this.values.push(item.value);
        this.labels.push(item.label);
      }
    })
  }

  
}
