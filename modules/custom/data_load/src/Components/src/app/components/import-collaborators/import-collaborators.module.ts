import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { ImportCollaboratorsComponent } from './import-collaborators.component';
import { FileValueAccessorDirective } from '../../directives/file-value-accessor/file-value-accessor.directive';

@NgModule({
  declarations: [
    ImportCollaboratorsComponent,
    FileValueAccessorDirective,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    ReactiveFormsModule,
  ],
  providers: [],
  bootstrap: [ImportCollaboratorsComponent]
})
export class ImportCollaboratorsModule { }
