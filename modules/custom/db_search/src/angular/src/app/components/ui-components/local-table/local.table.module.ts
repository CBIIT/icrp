import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PaginationModule } from 'ngx-bootstrap';
import { LocalTableComponent } from './local.table.component';


@NgModule({
  imports: [
    CommonModule,
    PaginationModule.forRoot(),
  ],
  declarations: [LocalTableComponent],
  exports: [LocalTableComponent],
  entryComponents: [LocalTableComponent]
})
export class LocalTableModule { }
