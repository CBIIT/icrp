import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { OverlayComponent } from './overlay.component';

@NgModule({
  imports: [
    CommonModule,
    BrowserAnimationsModule
  ],
  declarations: [
    OverlayComponent
  ],
  exports: [
    OverlayComponent
  ],
  entryComponents: [
    OverlayComponent
  ]
})
export class OverlayModule { }