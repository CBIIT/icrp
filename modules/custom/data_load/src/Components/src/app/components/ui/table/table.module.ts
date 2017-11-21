import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PaginationModule } from 'ngx-bootstrap';
import { TableComponent } from './table.component';


@NgModule({
  imports: [
    CommonModule,
    PaginationModule.forRoot(),
  ],
  declarations: [TableComponent],
  exports: [TableComponent],
  entryComponents: [TableComponent]
})
export class TableModule { }
