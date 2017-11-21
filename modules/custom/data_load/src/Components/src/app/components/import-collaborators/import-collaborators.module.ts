import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { ImportCollaboratorsComponent } from './import-collaborators.component';
import { FileValueAccessorModule } from '../../directives/file-value-accessor/file-value-accessor.module';

import { OverlayModule } from '../ui/overlay';
import { SpinnerModule } from '../ui/spinner';
import { IconModule } from '../ui/icon';
import { TableModule } from '../ui/table';

@NgModule({
  declarations: [
    ImportCollaboratorsComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    ReactiveFormsModule,
    SpinnerModule.forRoot(),
    OverlayModule,
    IconModule,
    TableModule,
    FileValueAccessorModule,
  ],
  providers: [],
  bootstrap: [ImportCollaboratorsComponent]
})
export class ImportCollaboratorsModule { }
