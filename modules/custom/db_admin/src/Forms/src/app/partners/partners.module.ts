import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { PartnersFormComponent } from './partners-form/partners-form.component';

@NgModule({
  imports: [
    BrowserModule,
    HttpClientModule
  ],
  declarations: [PartnersFormComponent],
  bootstrap: [PartnersFormComponent]
})
export class PartnersModule { }
