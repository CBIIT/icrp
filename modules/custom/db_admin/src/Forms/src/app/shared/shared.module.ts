import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';
import { CommonModule } from '@angular/common';
import { WebsiteInputComponent } from './website-input/website-input.component';
import { FileInputComponent } from './file-input/file-input.component';

@NgModule({
  imports: [
    CommonModule,
    FlexLayoutModule,
    ReactiveFormsModule,
  ],
  exports: [
    FileInputComponent,
    WebsiteInputComponent,
  ],
  declarations: [
    FileInputComponent,
    WebsiteInputComponent,
  ],
})
export class SharedModule { }
