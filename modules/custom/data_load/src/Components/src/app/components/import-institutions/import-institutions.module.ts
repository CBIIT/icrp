import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { ImportInstitutionsComponent } from './import-institutions.component';
import { FileValueAccessorModule } from '../../directives/file-value-accessor/file-value-accessor.module';

import { AlertModule } from 'ngx-bootstrap';
import { ModalModule } from 'ngx-bootstrap';
import { OverlayModule } from '../ui/overlay';
import { SpinnerModule } from '../ui/spinner';
import { IconModule } from '../ui/icon';
import { TableModule } from '../ui/table';

@NgModule({
  declarations: [
    ImportInstitutionsComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    ReactiveFormsModule,

    AlertModule.forRoot(),
    ModalModule.forRoot(),
    SpinnerModule.forRoot(),
    OverlayModule,
    IconModule,
    TableModule,
    FileValueAccessorModule,
  ],
  providers: [],
  bootstrap: [ImportInstitutionsComponent]
})
export class ImportInstitutionsModule { }


