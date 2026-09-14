import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';

import { ImportInstitutionsComponent } from './import-institutions.component';
import { FileValueAccessorModule } from '../../directives/file-value-accessor/file-value-accessor.module';
import { ImportService } from '../../services/import.service';
import { ExportService } from '../../services/export.service';

import { AlertModule } from 'ngx-bootstrap/alert';
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
    ReactiveFormsModule,
    FileValueAccessorModule,

    AlertModule,
    SpinnerModule.forRoot(),
    OverlayModule,
    IconModule,
    TableModule,
  ],
  providers: [
    provideHttpClient(withInterceptorsFromDi()),
    ImportService,
    ExportService,
  ],
  bootstrap: [ImportInstitutionsComponent]
})
export class ImportInstitutionsModule { }
