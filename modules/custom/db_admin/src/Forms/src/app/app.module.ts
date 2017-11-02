import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { FlexLayoutModule } from '@angular/flex-layout';
import { AlertModule } from 'ngx-bootstrap';

import { FundingOrganizationFormComponent } from './components/funding-organization-form/funding-organization-form.component';
import { PartnerFormComponent } from './components/partner-form/partner-form.component';
import { AdminFormComponent } from './components/admin-form/admin-form.component';

@NgModule({
  declarations: [
    FundingOrganizationFormComponent,
    PartnerFormComponent,
    AdminFormComponent,
  ],
  imports: [
    BrowserModule,
    FlexLayoutModule,
    HttpClientModule,
    ReactiveFormsModule,
    AlertModule.forRoot(),
  ],
  providers: [],
  bootstrap: [AdminFormComponent]
})
export class AppModule { }
