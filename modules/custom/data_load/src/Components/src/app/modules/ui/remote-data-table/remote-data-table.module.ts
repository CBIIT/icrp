import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PaginationModule } from 'ngx-bootstrap/pagination';

import { RemoteDataTableComponent } from './remote-data-table.component';

@NgModule({
  imports: [
    CommonModule,
    PaginationModule,
  ],
  declarations: [RemoteDataTableComponent],
  exports: [RemoteDataTableComponent],
})
export class RemoteDataTableModule { }
