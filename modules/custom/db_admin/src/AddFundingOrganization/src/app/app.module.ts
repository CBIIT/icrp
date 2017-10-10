import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';


import { FundingOrganizationFormComponent } from './funding-organization-form/funding-organization-form.component';

@NgModule({
  declarations: [
    FundingOrganizationFormComponent
  ],
  imports: [
    BrowserModule,
    FlexLayoutModule,
    ReactiveFormsModule,
  ],
  providers: [],
  bootstrap: [FundingOrganizationFormComponent]
})
export class AppModule { }
