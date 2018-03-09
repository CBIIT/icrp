import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout'
import { FundingOrganizationsApiService } from '../services/funding-organizations-api.service'
import { FundingOrganizationsFormComponent } from './funding-organizations-form/funding-organizations-form.component';

@NgModule({
  imports: [
    BrowserModule,
    FlexLayoutModule,
    HttpClientModule,
    ReactiveFormsModule,
  ],
  providers: [
    FundingOrganizationsApiService,
    FormBuilder
  ],
  declarations: [FundingOrganizationsFormComponent],
  bootstrap: [FundingOrganizationsFormComponent]
})
export class FundingOrganizationsModule { }
