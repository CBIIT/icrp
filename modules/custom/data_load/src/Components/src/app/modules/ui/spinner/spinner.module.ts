import { NgModule, ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SpinnerComponent } from './spinner.component';
import { SpinnerConfig } from './spinner.config';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [
    SpinnerComponent
  ],
  exports: [
    SpinnerComponent
  ],
  entryComponents: [
    SpinnerComponent
  ]
})
export class SpinnerModule {
  public static forRoot(): ModuleWithProviders {
    return {
      ngModule: SpinnerModule,
      providers: [
        SpinnerConfig
      ]
    };
  }
}
