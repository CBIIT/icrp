import { Component, Input } from '@angular/core';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-export-buttons-panel',
  templateUrl: './export-buttons-panel.component.html',
  styleUrls: ['./export-buttons-panel.component.css']
})
export class ExportButtonsPanelComponent  {
  @Input() authenticated: boolean = false;

  routes: any = {}
  /**
   * 
   * 

  <icrp-export-button
    *ngIf="authenticated"
    label="Export Single"
    endpoint="/load/ExportResultsSignlePartner">
  </icrp-export-button>

  <icrp-export-button
    *ngIf="authenticated"
    label="Export Abstracts"
    endpoint="/load/ExportResultsWithAbstractPartner">
  </icrp-export-button>

  <icrp-export-button
    *ngIf="authenticated"
    label="Export Abstracts Single"
    endpoint="/load/ExportAbstractSignlePartner">
  </icrp-export-button>

  <span class="pull-right">
    <icrp-export-button
      label="Export Graphs"
      endpoint="/load/ExportResultsWithGraphsPartner">
    </icrp-export-button>
   * 
   * @param sharedService 
   */

  constructor(public sharedService: SharedService) {
    let componentType = this.sharedService.get('componentType');

    let baseRoute = {
      review: '/load',
      search: ''
    }[componentType];

    this.routes = {
      exportResults: this.authenticated
        ? `${baseRoute}/ExportResultsPartner`
        : `${baseRoute}/ExportResults`,
      exportResultsSingle: `${baseRoute}/ExportResultsSignlePartner`,
      exportAbstracts: `${baseRoute}/ExportResultsWithAbstractPartner`,
      exportAbstractsSingle: `${baseRoute}/ExportAbstractSignlePartner`,
      exportGraphs: this.authenticated
        ? `${baseRoute}/ExportResultsWithGraphsPartner`
        : `${baseRoute}/exportResultsWithGraphsPartnerPublic`
    }
  }
}
