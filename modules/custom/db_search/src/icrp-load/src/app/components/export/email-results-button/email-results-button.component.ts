import { Component, OnInit } from '@angular/core';
import { ExportService } from '../../../services/export.service';

@Component({
  selector: 'icrp-email-results-button',
  templateUrl: './email-results-button.component.html',
  styleUrls: ['./email-results-button.component.css']
})
export class EmailResultsButtonComponent {
  constructor(private exportService: ExportService) { }
}
