import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { FlexLayoutModule } from '@angular/flex-layout';
import { AlertModule } from 'ngx-bootstrap';

import { FundingOrganizationFormComponent } from './funding-organization-form/funding-organization-form.component';
import { SelectComponent } from './ui-components/select/select.component';

@NgModule({
  declarations: [
    FundingOrganizationFormComponent,
    SelectComponent
  ],
  imports: [
    BrowserModule,
    FlexLayoutModule,
    HttpClientModule,
    ReactiveFormsModule,
    AlertModule.forRoot(),
  ],
  providers: [],
  bootstrap: [FundingOrganizationFormComponent]
})
export class AppModule { }
