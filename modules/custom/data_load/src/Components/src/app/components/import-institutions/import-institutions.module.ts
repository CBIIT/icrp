import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { ImportInstitutionsComponent } from './import-institutions.component';
import { FileValueAccessorDirective } from '../../directives/file-value-accessor/file-value-accessor.directive';

@NgModule({
  declarations: [
    ImportInstitutionsComponent,
    FileValueAccessorDirective,
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [ImportInstitutionsComponent]
})
export class ImportInstitutionsModule { }
