import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { ImportInstitutionsComponent } from './import-institutions.component';
import { FileValueAccessorModule } from '../../directives/file-value-accessor/file-value-accessor.module';

@NgModule({
  declarations: [
    ImportInstitutionsComponent,
  ],
  imports: [
    BrowserModule,
    FileValueAccessorModule
  ],
  providers: [],
  bootstrap: [ImportInstitutionsComponent]
})
export class ImportInstitutionsModule { }
