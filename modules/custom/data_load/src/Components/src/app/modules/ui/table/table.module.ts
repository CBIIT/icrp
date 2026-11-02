import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { TableComponent } from './table.component';


@NgModule({
  imports: [
    CommonModule,
    PaginationModule,
  ],
  declarations: [TableComponent],
  exports: [TableComponent]
})
export class TableModule { }
