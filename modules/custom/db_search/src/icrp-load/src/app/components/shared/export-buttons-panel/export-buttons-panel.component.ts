import { Component, Input } from '@angular/core';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-export-buttons-panel',
  templateUrl: './export-buttons-panel.component.html',
  styleUrls: ['./export-buttons-panel.component.css']
})
export class ExportButtonsPanelComponent  {
  @Input() authenticated: boolean = false;

  constructor(public sharedService: SharedService) { }
}
