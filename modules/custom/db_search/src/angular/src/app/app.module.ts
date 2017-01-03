import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';

import { SearchComponent } from './search/search.component';
import { SearchFormComponent } from './search-form/search-form.component';
import { SearchResultsComponent } from './search-results/search-results.component';
import { UiSelectComponent } from './ui-select/ui-select.component';
import { UiPanelComponent } from './ui-panel/ui-panel.component';
import { UiTreeviewComponent } from './ui-treeview/ui-treeview.component';
import { UiTableComponent } from './ui-table/ui-table.component';
import { UiChartComponent } from './ui-chart/ui-chart.component';

import { TooltipModule } from 'ng2-bootstrap';

@NgModule({
  declarations: [
    AppComponent,
    SearchComponent,
    SearchFormComponent,
    SearchResultsComponent,
    UiSelectComponent,
    UiPanelComponent,
    UiTreeviewComponent,
    UiTableComponent,
    UiChartComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpModule,
    TooltipModule.forRoot()
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
