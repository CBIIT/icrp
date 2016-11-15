import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
import { SearchFormComponent } from './search-form/search-form.component';
import { SearchComponent } from './search/search.component';
import { SearchResultsComponent } from './search-results/search-results.component';
import { SearchVisualizationComponent } from './search-visualization/search-visualization.component';

import { SelectModule } from 'ng2-select/ng2-select';
import { TooltipModule } from 'ng2-bootstrap/components/tooltip';
import { CollapseModule } from 'ng2-bootstrap/components/collapse';
import { AccordionModule } from 'ng2-bootstrap/components/accordion';

import { DataTableModule, PaginatorModule, SharedModule, ChartModule, CarouselModule } from 'primeng/primeng';

@NgModule({
  declarations: [
    AppComponent,
    SearchFormComponent,
    SearchComponent,
    SearchResultsComponent,
    SearchVisualizationComponent,
    
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    SelectModule,
    TooltipModule,
    CollapseModule,
    AccordionModule,
    SharedModule,
    DataTableModule,
    PaginatorModule,
    ChartModule,
    CarouselModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
