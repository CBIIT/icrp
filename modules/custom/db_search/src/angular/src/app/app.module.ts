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
import { PaginationModule } from 'ng2-bootstrap';
import { ModalModule } from 'ng2-bootstrap';
import { EmailResultsButtonComponent } from './email-results-button/email-results-button.component';
import { ExportResultsButtonComponent } from './export-results-button/export-results-button.component';
import { ExportResultsPartnerButtonComponent } from './export-results-partner-button/export-results-partner-button.component';
import { ExportResultsAbstractsPartnerButtonComponent } from './export-results-abstracts-partner-button/export-results-abstracts-partner-button.component';
import { ExportResultsGraphsPartnerButtonComponent } from './export-results-graphs-partner-button/export-results-graphs-partner-button.component';
import { EmailResultsPartnerButtonComponent } from './email-results-partner-button/email-results-partner-button.component';
import { ExportResultsAbstractsSinglePartnerButton } from './export-results-abstracts-single-partner-button/export-results-abstracts-single-partner-button';
import { ExportResultsSinglePartnerButton } from './export-results-single-partner-button/export-results-single-partner-button';
import { ExportLookupTableButtonComponent } from './export-lookup-table-button/export-lookup-table-button.component';

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
    UiChartComponent,
    EmailResultsButtonComponent,
    ExportResultsButtonComponent,
    ExportResultsPartnerButtonComponent,
    ExportResultsAbstractsPartnerButtonComponent,
    ExportResultsGraphsPartnerButtonComponent,
    EmailResultsPartnerButtonComponent,
    ExportResultsAbstractsSinglePartnerButton,
    ExportResultsSinglePartnerButton,
    ExportLookupTableButtonComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpModule,
    TooltipModule.forRoot(),
    PaginationModule.forRoot(),
    ModalModule.forRoot(),
  ],
  providers: [
    {
      provide: 'api_root',
      useValue: 'https://icrpartnership-demo.org'
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
