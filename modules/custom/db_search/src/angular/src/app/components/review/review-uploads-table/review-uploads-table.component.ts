import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'icrp-review-uploads-table',
  templateUrl: './review-uploads-table.component.html',
  styleUrls: ['./review-uploads-table.component.css']
})
export class ReviewUploadsTableComponent {
  @Input() uploads: any[] = [];
  @Output() select: EventEmitter<any> = new EventEmitter<any>();
}
