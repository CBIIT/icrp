import { Component, Input } from '@angular/core';
import { ExportService } from '../../../services/export.service';

@Component({
  selector: 'icrp-export-button',
  templateUrl: './export-button.component.html',
  styleUrls: ['./export-button.component.css']
})
export class ExportButtonComponent {

  @Input() label: string;
  @Input() endpoint: string;

  loading: boolean = false;

  constructor(private exportService: ExportService) { }

  export() {

    this.loading = true;
    this.exportService.export(this.endpoint)
      .subscribe(
        response => document.location.href = response,
        error => console.error(error),
        () => this.loading = false
      );
  }

}
