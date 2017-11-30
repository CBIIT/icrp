import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';

interface Header {
  value: string;
  label: string;
  sortDirection?: string; // "asc" | "desc" | "none"
}


@Component({
  selector: 'ui-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})
export class TableComponent implements OnChanges {

  @Input()
  pageSizes = [25, 50, 100, 150, 200, 250, 300];

  @Input()
  headers: (string | Header)[] = [];

  @Input()
  data: any[] = [];

  _data: any[] = [];

  _headers: Header[] = [];

  pageSize = this.pageSizes[0];

  pageNumber = 1;

  sort(columnName: string) {
    this._data = [...this.data];

    const header = this._headers.find(h => h.value === columnName)
    const previousDirection = header.sortDirection;

    this._headers.forEach(header => header.sortDirection = 'none');
    header.sortDirection = {
      asc: 'desc',
      desc: 'none',
      none: 'asc'
    }[previousDirection];

    if (header.sortDirection !== 'none') {
      this._data.sort((a: any, b: any) => {
        let v1 = a[columnName];
        let v2 = b[columnName];

        switch(header.sortDirection) {
          case 'asc':
            return isNaN(v1) && isNaN(v2)
              ? v1.toString().localeCompare(v2.toString())
              : +v1 - +v2;

          case 'desc':
            return isNaN(v2) && isNaN(v1)
              ? v2.toString().localeCompare(v1.toString())
              : +v2 - +v1;
        }
      });
    }
  }

  ngOnChanges(changes: SimpleChanges) {

    console.log(changes);

    if (changes.headers && changes.headers.currentValue) {
      this._headers = changes.headers.currentValue.map(val =>
        typeof val === 'string'
          ? {value: val, label: val, sortDirection: 'none'}
          : val
      );
    }

    if (changes.data && changes.data.currentValue) {
      this._data = [...changes.data.currentValue];
    }
  }
}
