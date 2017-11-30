import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PaginationModule } from 'ngx-bootstrap';

import { RemoteDataTableComponent } from './remote-data-table.component';

@NgModule({
  imports: [
    CommonModule,
    PaginationModule.forRoot(),
  ],
  declarations: [RemoteDataTableComponent],
  exports: [RemoteDataTableComponent],
})
export class RemoteDataTableModule { }
