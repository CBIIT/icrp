import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { ImportCollaboratorsComponent } from './components/import-collaborators/import-collaborators.component';
import { ImportInstitutionsComponent } from './components/import-institutions/import-institutions.component';


@NgModule({
  declarations: [
    AppComponent,
    ImportCollaboratorsComponent,
    ImportInstitutionsComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
