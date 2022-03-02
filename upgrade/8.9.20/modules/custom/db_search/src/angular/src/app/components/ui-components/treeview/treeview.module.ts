import { NgModule, ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TreeViewComponent } from './treeview.component';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [
    TreeViewComponent
  ],
  exports: [
    TreeViewComponent
  ],
  entryComponents: [
    TreeViewComponent
  ]
})
export class TreeViewModule {
  public static forRoot(): ModuleWithProviders {
    return {
      ngModule: TreeViewModule,
      providers: [

      ]
    }
  }
}
