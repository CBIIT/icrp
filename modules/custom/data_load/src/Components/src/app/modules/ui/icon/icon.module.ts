import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IconComponent } from './icon.component';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [
    IconComponent,
  ],
  exports: [
    IconComponent,
  ],
  entryComponents: [
    IconComponent,
  ]
})
export class IconModule { }
