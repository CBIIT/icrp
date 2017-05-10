import { NgModule, ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SelectComponent } from './select.component';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [
    SelectComponent
  ],
  exports: [
    SelectComponent
  ],
  entryComponents: [
    SelectComponent
  ]
})
export class SelectModule {
  public static forRoot(): ModuleWithProviders {
    return {
      ngModule: SelectModule,
      providers: [
        
      ]
    };
  }
}
