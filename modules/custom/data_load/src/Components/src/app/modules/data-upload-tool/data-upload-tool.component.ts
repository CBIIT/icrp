import { Component, ViewChild } from '@angular/core';
import { TabsetComponent } from 'ngx-bootstrap';
import { SharedDataService } from '../../services/shared-data.service';
import { DataUploadService } from '../../services/data-upload.service';

@Component({
  selector: 'icrp-data-upload-tool',
  templateUrl: './data-upload-tool.component.html',
  styleUrls: ['./data-upload-tool.component.css']
})
export class DataUploadToolComponent {

  @ViewChild('tabs') tabset: TabsetComponent;

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
    });
  }


  selectTab(tab_id: number) {
    this.tabset.tabs[tab_id].active = true;
  }

  cancel() {
    window.location.href = this.dataUploadService.BASE_HREF
  }





}
