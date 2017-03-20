import {
  AfterViewInit,
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnInit,
  OnChanges,
  Output,
  Renderer,
  SimpleChanges,
  ViewChild,
  ViewEncapsulation
} from '@angular/core';

import { Column } from './column';
import { Observable } from 'rxjs';

import { enableResizableColumns } from './enableResizableColumns';

@Component({
  selector: 'ui-table',
  templateUrl: './ui-table.component.html',
  styleUrls: ['./ui-table.component.css'],
  encapsulation: ViewEncapsulation.None
})
export class UiTableComponent implements OnChanges {

  @Input() data: any[];
  @Input() columns: Column[];

  @Input() loading: boolean;
  @Input() numResults: number;
  @Input() pageSizes: number[];

  @Output() sort: EventEmitter<{ "sort_column": string, "sort_type": "asc" | "desc" }>;
  @Output() paginate: EventEmitter<{ "page_size":number, "page_number":number }>;

  @ViewChild('table') table;

  pagingModel: number;
  pageOffset: number;
  pageSize: number;

  constructor() {
    this.columns = [];
    this.data = [];
    
    this.loading = true;
    this.pageOffset = 0;

    Observable.fromEvent(window, 'resize')
      .debounceTime(100)
      .subscribe((event) => {
        if (this.table && this.table.nativeElement) {
          window.setTimeout(e => {
            enableResizableColumns(this.table.nativeElement);
          }, 0);
        }
      })

    this.sort = new EventEmitter<{ "sort_column": string, "sort_type": "asc" | "desc" }>();
    this.paginate = new EventEmitter<{ "page_size":number, "page_number":number }>();
  }

  updateCurrentPage(event: any) {
    this.pageOffset = event.page;
    this.updatePagination();
  }

  updatePageSize(event) {
    this.pageSize = +event;
    this.pagingModel = 1;
    this.updatePagination()
  }

  updatePagination() {
    let offset = this.pageOffset || 1;
    let size = this.pageSize;

    this.loading = true;
    this.paginate.emit({
      page_size: size,
      page_number: offset
    })
  }

  sortTableColumn(column: Column) {
    let sortAscending = !column.sortAscending;
    this.removeColumnSorting();
    column.sortAscending = sortAscending;
    
    this.loading = true;
    this.sort.emit({
      sort_column: column.value,
      sort_type: sortAscending ? 'asc' : 'desc'
    })
  }

  removeColumnSorting() {
    this.columns.forEach(column => delete column.sortAscending);
  }

  

  ngOnChanges(changes: SimpleChanges) {

    if (changes['pageSizes']) {
      this.pageSize = this.pageSizes[0];
    }

    if (changes['data']) {
      this.loading = false;
    }
    
    if (changes['data'] && this.table && this.table.nativeElement) {
      window.setTimeout(e => {
        enableResizableColumns(this.table.nativeElement);
      }, 0);
    }
  }
}