import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';
import { CommonModule } from '@angular/common';
import { FileValueAccessorModule } from './directives/file-value-accessor/file-value-accessor.module';
import { WebsiteInputComponent } from './components/website-input/website-input.component';

@NgModule({
  imports: [
    CommonModule,
    FlexLayoutModule,
    ReactiveFormsModule,
    FileValueAccessorModule,
  ],
  exports: [
    WebsiteInputComponent,
    FileValueAccessorModule
  ],
  declarations: [
    WebsiteInputComponent,
  ],
})
export class SharedModule { }
