import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout'
import { AlertModule, BsDatepickerModule  } from 'ngx-bootstrap';

import { SharedModule } from '../shared/shared.module';
import { PartnersApiService } from '../services/partners-api.service'
import { NonPartnersApiService } from '../services/non-partners-api.service'
import { PartnersFormComponent } from './partners-form/partners-form.component';

@NgModule({
  imports: [
    BrowserModule,
    FlexLayoutModule,
    HttpClientModule,
    ReactiveFormsModule,
    AlertModule.forRoot(),
    BsDatepickerModule.forRoot(),
    SharedModule,
  ],
  providers: [
    FormBuilder,
    NonPartnersApiService,
    PartnersApiService,
  ],
  declarations: [PartnersFormComponent],
  bootstrap: [PartnersFormComponent]
})
export class PartnersModule { }
