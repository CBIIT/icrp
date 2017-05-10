import { Component, OnChanges, Input, Output, EventEmitter, SimpleChanges, ElementRef, ViewChild } from '@angular/core';
import { enableResizableColumns } from './enableResizableColumns';

interface Header {
  label: string;
  key: string;
  sort?: 'asc' | 'desc' | null | undefined;
  tooltip?: string
}

@Component({
  selector: 'ui-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})
export class TableComponent implements OnChanges {

  @Input()
  headers: Header[];

  @Input()
  data: object;

  @Input()
  numResults: number;

  @Input()
  pageSizes = [50, 100, 150, 200, 250, 300];

  @Input()
  loading: boolean = true;

  @Output()
  sort: EventEmitter<any> = new EventEmitter<any>();

  @Output()
  paginate: EventEmitter<any> = new EventEmitter<any>();

  @ViewChild('table') table;

  pageSize = this.pageSizes[0];
  pageNumber = 0;
  pagingModel: any;

  constructor() { }

  toggleSort(header: Header) {
    console.log(header);

    let toggledSort: 'asc' | 'desc' = header.sort === 'asc'
      ? 'desc'
      : 'asc';

    for (let h of this.headers)
      h.sort = null;

    header.sort = toggledSort;

    this.sort.emit({
      sort_column: header.key,
      sort_direction: header.sort
    })
  }

  emitPagination() {
    this.paginate.emit({
      page_size: this.pageSize,
      page_number: this.pageNumber
    });
  }

  setPageSize(size) {
    this.pageSize = size;
    this.pageNumber = 1;
    this.emitPagination();
  }

  setCurrentPage(event) {
    this.pageNumber = event.page;
    this.emitPagination();
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['data'] && this.data && this.table && this.table.nativeElement) {
      window.setTimeout(e => {
        enableResizableColumns(this.table.nativeElement);
      }, 0);
    }
  }
}
