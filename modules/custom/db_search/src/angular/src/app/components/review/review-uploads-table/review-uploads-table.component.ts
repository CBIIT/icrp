import { Component, Input, Output, EventEmitter } from '@angular/core';
import { ReviewService } from '../../../services/review.service';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-review-uploads-table',
  templateUrl: './review-uploads-table.component.html',
  styleUrls: ['./review-uploads-table.component.css'],
})
export class ReviewUploadsTableComponent {
  @Input() uploads: any[] = [];
  @Output() select: EventEmitter<any> = new EventEmitter<any>();
  @Output() syncProd: EventEmitter<any> = new EventEmitter<any>();
  @Output() deleteImport: EventEmitter<any> = new EventEmitter<any>();

  constructor(
    private reviewService: ReviewService,
    public sharedService: SharedService
  ) {}
}
