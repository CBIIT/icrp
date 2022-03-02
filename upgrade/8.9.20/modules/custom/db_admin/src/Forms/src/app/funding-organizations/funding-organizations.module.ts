import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout'
import { AlertModule } from 'ngx-bootstrap';

import { SharedModule } from '../shared/shared.module';
import { FundingOrganizationsApiService } from '../services/funding-organizations-api.service'
import { FundingOrganizationsFormComponent } from './funding-organizations-form/funding-organizations-form.component';

@NgModule({
  imports: [
    BrowserModule,
    FlexLayoutModule,
    HttpClientModule,
    ReactiveFormsModule,
    AlertModule.forRoot(),
    SharedModule,
  ],
  providers: [
    FundingOrganizationsApiService,
    FormBuilder
  ],
  declarations: [FundingOrganizationsFormComponent],
  bootstrap: [FundingOrganizationsFormComponent]
})
export class FundingOrganizationsModule { }
