import { Component, ViewChild } from '@angular/core';
import { TabsetComponent } from 'ngx-bootstrap';
import { SharedDataService } from '../../services/shared-data.service';
import { DataUploadService } from '../../services/data-upload.service';
import { ImportPageComponent } from './components/import-page/import-page.component';
import { IntegrityCheckPageComponent } from './components/integrity-check-page/integrity-check-page.component';
import { UploadPageComponent } from './components/upload-page/upload-page.component';

@Component({
  selector: 'icrp-data-upload-tool',
  templateUrl: './data-upload-tool.component.html',
  styleUrls: ['./data-upload-tool.component.css']
})
export class DataUploadToolComponent {

  @ViewChild('tabs') tabset: TabsetComponent;

  @ViewChild('importPage') importPage: ImportPageComponent;

  @ViewChild('integrityCheckPage') integrityCheckPage: IntegrityCheckPageComponent;

  @ViewChild('uploadPage') uploadPage: UploadPageComponent;

  loading: boolean = false;
  workbookValid: boolean = false;
  integrityCheckValid: boolean = false;

  constructor(
    private dataUploadService: DataUploadService,
    private sharedDataService: SharedDataService) {
    this.sharedDataService.events.subscribe(data => {
      this.loading = data.loading || false;
      this.workbookValid = data.workbookValid || false;
      this.integrityCheckValid = data.integrityCheckValid || false;


      this.tabset.tabs[1].disabled = !data.workbookValid;
      this.tabset.tabs[2].disabled = !data.integrityCheckValid;


    });
  }

  selectTab(tab_id: number) {
    this.tabset.tabs[tab_id].active = true;
  }

  reset() {
    this.integrityCheckPage.reset();
    this.importPage.reset();
  }

  cancel() {
    window.location.href = this.dataUploadService.BASE_HREF
  }
}
