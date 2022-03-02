import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FileValueAccessorDirective } from './file-value-accessor.directive';

@NgModule({
  imports: [CommonModule],
  declarations: [FileValueAccessorDirective],
  exports: [FileValueAccessorDirective]
})
export class FileValueAccessorModule { }
