import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { FlexLayoutModule } from '@angular/flex-layout';

import { DataUploadToolComponent } from './data-upload-tool.component';
import { FileValueAccessorModule } from '../../directives/file-value-accessor/file-value-accessor.module';

import { SharedDataService } from '../../services/shared-data.service';
import { DataUploadService } from '../../services/data-upload.service';
import { ExportService } from '../../services/export.service';

import { AccordionModule } from 'ngx-bootstrap';
import { AlertModule } from 'ngx-bootstrap';
import { BsDatepickerModule } from 'ngx-bootstrap';
import { TabsModule } from 'ngx-bootstrap';
import { ModalModule } from 'ngx-bootstrap';


import { OverlayModule } from '../ui/overlay';
import { SpinnerModule } from '../ui/spinner';
import { IconModule } from '../ui/icon';
import { TableModule } from '../ui/table';
import { RemoteDataTableModule } from '../ui/remote-data-table/remote-data-table.module';
import { UploadPageComponent } from './components/upload-page/upload-page.component';
import { ImportPageComponent } from './components/import-page/import-page.component';
import { IntegrityCheckPageComponent } from './components/integrity-check-page/integrity-check-page.component';
import { UploadFormComponent } from './components/upload-form/upload-form.component';

@NgModule({
  declarations: [
    DataUploadToolComponent,
    UploadPageComponent,
    ImportPageComponent,
    IntegrityCheckPageComponent,
    UploadFormComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    ReactiveFormsModule,
    FlexLayoutModule,
    FileValueAccessorModule,

    AccordionModule.forRoot(),
    AlertModule.forRoot(),
    BsDatepickerModule.forRoot(),
    ModalModule.forRoot(),
    TabsModule.forRoot(),
    
    SpinnerModule.forRoot(),
    OverlayModule,
    IconModule,
    TableModule,
    RemoteDataTableModule,
  ],
  providers: [
    DataUploadService,
    ExportService,
    SharedDataService,
  ],
  bootstrap: [DataUploadToolComponent]
})
export class DataUploadToolModule { }
