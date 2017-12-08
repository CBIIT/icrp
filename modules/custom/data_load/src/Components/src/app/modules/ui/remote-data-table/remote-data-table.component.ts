import { Component, OnChanges, ElementRef, ViewChild, Input, Output, SimpleChanges, EventEmitter, AfterViewChecked } from '@angular/core';
import { enableResizableColumns } from './ResizableColumns';
import { AfterViewInit } from '@angular/core/src/metadata/lifecycle_hooks';

interface RequestParameters {
  page: number;
  pageSize: number;
  sortColumn: string;
  sortDirection: string;
}

interface Header {
  value: string;
  label: string;
  sortDirection?: string; // "asc" | "desc" | "none"
}


@Component({
  selector: 'ui-remote-data-table',
  templateUrl: './remote-data-table.component.html',
  styleUrls: ['./remote-data-table.component.css']
})
export class RemoteDataTableComponent implements OnChanges, AfterViewInit {

  @Input() count: number = 0;

  @Input() headers: string[] = [];

  @Input() data: any[] = [];

  @Output() request: EventEmitter<RequestParameters> = new EventEmitter();

  @ViewChild('table') tableRef: ElementRef;

  _headers: Header[] = [];

  page = 1;

  pageSize = 25;

  sortColumn = '';

  sortDirection = 'ASC';

  math = Math;


  sort(columnName: string) {
    const header = this._headers.find(h => h.value === columnName)
    const previousDirection = header.sortDirection;

    this._headers.forEach(header => header.sortDirection = 'none');
    header.sortDirection = {
      none: 'asc',
      asc: 'desc',
      desc: 'asc',
    }[previousDirection];

    this.sortColumn = header.value;
    this.sortDirection = header.sortDirection;
    this.emit();
  }

  emit() {
    this.request.emit({
      page: this.page,
      pageSize: this.pageSize,
      sortColumn: this.sortColumn,
      sortDirection: this.sortDirection
    });
  }

  max(a, b) {
    return Math.max(a, b);
  }

  min(a, b) {
    return Math.min(a, b);
  }


  ngAfterViewInit() {
    let table: HTMLTableElement = this.tableRef.nativeElement;
    enableResizableColumns(table, {
      preserveWidth: false
    })
  }

  ngOnChanges(changes: SimpleChanges) {

    if (changes.headers && changes.headers.currentValue) {
      this._headers = changes.headers.currentValue.map(val => ({
          value: val,
          label: val,
          sortDirection: 'none'
        }));
      }

    if (changes.data && changes.data.currentValue) {
    }

    if (changes.count) {
      this.page = 1;
    }
  }

}
