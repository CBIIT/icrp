import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'icrp-summary-panel',
  templateUrl: './summary-panel.component.html',
  styleUrls: ['./summary-panel.component.css']
})
export class SummaryPanelComponent {
  showSummary: boolean = false;
}
