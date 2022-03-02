import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout'
import { AlertModule } from 'ngx-bootstrap/alert';
import { TypeaheadModule } from 'ngx-bootstrap/typeahead';

import { SharedModule } from '../shared/shared.module';
import { InstitutionsApiService } from '../services/institutions-api.service';
import { InstitutionsFormComponent } from './institutions-form/institutions-form.component';

@NgModule({
  imports: [
    BrowserModule,
    FlexLayoutModule,
    HttpClientModule,
    ReactiveFormsModule,
    AlertModule.forRoot(),
    TypeaheadModule.forRoot(),
    SharedModule,
  ],
  providers: [
    InstitutionsApiService,
    FormBuilder,
  ],
  declarations: [InstitutionsFormComponent],
  bootstrap: [InstitutionsFormComponent]
})
export class InstitutionsModule { }
