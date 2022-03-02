import { Component, Input } from '@angular/core';
import { SharedService } from '../../../services/shared.service';
import { ExportService } from '../../../services/export.service';

@Component({
  selector: 'icrp-export-buttons-panel',
  templateUrl: './export-buttons-panel.component.html',
  styleUrls: ['./export-buttons-panel.component.css']
})
export class ExportButtonsPanelComponent  {
  @Input() authenticated: boolean = false;

  loading: boolean = false;

  constructor(
    public sharedService: SharedService,
    private exportService: ExportService
  ) { }

  getRoutes() {
    let componentType = this.sharedService.get('componentType');

    let baseRoute = {
      search: '/api/database/export',
      review: '/api/database/review/export',
    }[componentType];

    return {
      exportResults: this.sharedService.get('authenticated')
        ? `${baseRoute}/partners/search_results`
        : `${baseRoute}/search_results`,
      exportResultsSingle: `${baseRoute}/partners/search_results/single`,
      exportAbstracts: `${baseRoute}/partners/search_results/abstracts`,
      exportAbstractsSingle: `${baseRoute}/partners/search_results/abstracts/single`,
      exportCsoCancerTypes: `${baseRoute}/partners/search_results/cso_cancer_types`,
      exportGraphs: this.sharedService.get('authenticated')
        ? `${baseRoute}/partners/search_results/graphs`
        : `${baseRoute}/search_results/graphs`,
    }
  }


  export(endpoint) {
    let parameters = {
      search_id: this.sharedService.get('searchID'),
      data_upload_id: this.sharedService.get('dataUploadID'),
      year: this.sharedService.get('conversionYear'),
    }

    this.loading = true;
    this.exportService.export(endpoint, parameters)
      .subscribe(
        response => document.location.href = response,
        error => console.error(error),
        () => this.loading = false
      );
  }
}
