import { Component, Input } from '@angular/core';
import { ExportService } from '../../../services/export.service';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-export-button',
  templateUrl: './export-button.component.html',
  styleUrls: ['./export-button.component.css']
})
export class ExportButtonComponent {

  @Input() label: string;
  @Input() endpoint: string;

  loading: boolean = false;

  constructor(
    private exportService: ExportService,
    private sharedService: SharedService
  ) { }

  export() {
    let parameters = {
      search_id: this.sharedService.get('searchID'),
      data_upload_id: this.sharedService.get('dataUploadID'),
      year: this.sharedService.get('conversionYear'),
    }

    this.loading = true;
    this.exportService.export(this.endpoint, parameters)
      .subscribe(
        response => document.location.href = response,
        error => console.error(error),
        () => this.loading = false
      );
  }

}
