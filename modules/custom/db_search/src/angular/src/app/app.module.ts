import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppComponent } from './app.component';

import { SearchPageComponent } from './components/search/search-page/search-page.component';
import { ReviewPageComponent } from './components/review/review-page/review-page.component';
import { SearchFormComponent } from './components/search/search-form/search-form.component';

import { LocalTableModule } from './components/ui-components/local-table/local.table.module';
import { TableComponent } from './components/ui-components/table/table.component';
import { PanelComponent } from './components/ui-components/panel/panel.component'
import { UiChartComponent } from './components/ui-components/chart/ui-chart.component'

import { TreeViewModule } from './components/ui-components/treeview';
import { SelectModule } from './components/ui-components/select';
import { SpinnerModule } from './components/ui-components/spinner';

import { SharedService } from './services/shared.service';
import { SearchService } from './services/search.service';
import { ReviewService } from './services/review.service';
import { ExportService } from './services/export.service';

import { TooltipModule, PaginationModule, ModalModule, AlertModule, BsDropdownModule, ButtonsModule, PopoverModule } from 'ngx-bootstrap';

import { SummaryPanelComponent } from './components/shared/summary-panel/summary-panel.component';
import { ChartsPanelComponent } from './components/shared/charts-panel/charts-panel.component';
import { ReviewSummaryPanelComponent } from './components/review/review-summary-panel/review-summary-panel.component';
import { ReviewUploadsTableComponent } from './components/review/review-uploads-table/review-uploads-table.component';
import { ExportButtonsPanelComponent } from './components/shared/export-buttons-panel/export-buttons-panel.component';
import { ExportButtonComponent } from './components/export/export-button/export-button.component';
import { EmailResultsButtonComponent } from './components/export/email-results-button/email-results-button.component';
import { OverlayComponent } from './components/ui-components/overlay/overlay.component';
import { ResultsTablePanelComponent } from './components/shared/results-table-panel/results-table-panel.component';
import { SimpleSelectComponent } from './components/ui-components/simple-select/simple-select.component';
import { SearchSummaryPanelComponent } from './components/search/search-summary-panel/search-summary-panel.component';

import 'rxjs/add/operator/map'
import 'rxjs/add/operator/catch'
import 'rxjs/add/operator/delay'
import 'rxjs/add/operator/mergeMap';
import { DataUploadCompletenessComponent } from './components/shared/data-upload-completeness/data-upload-completeness.component';

@NgModule({
  declarations: [
    AppComponent,
    SearchPageComponent,
    ReviewPageComponent,
    SearchFormComponent,
    TableComponent,
    PanelComponent,
    UiChartComponent,
    SummaryPanelComponent,
    ChartsPanelComponent,
    ReviewSummaryPanelComponent,
    ReviewUploadsTableComponent,
    ExportButtonsPanelComponent,
    EmailResultsButtonComponent,
    ExportButtonComponent,
    OverlayComponent,
    ResultsTablePanelComponent,
    SimpleSelectComponent,
    SearchSummaryPanelComponent,
    DataUploadCompletenessComponent,
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpModule,
    LocalTableModule,
    BrowserAnimationsModule,
    TooltipModule.forRoot(),
    PaginationModule.forRoot(),
    ModalModule.forRoot(),
    AlertModule.forRoot(),
    BsDropdownModule.forRoot(),
    ButtonsModule.forRoot(),
    PopoverModule.forRoot(),

    SpinnerModule.forRoot(),
    SelectModule.forRoot(),
    TreeViewModule.forRoot(),
  ],
  providers: [
    SharedService,
    SearchService,
    ReviewService,
    ExportService,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
