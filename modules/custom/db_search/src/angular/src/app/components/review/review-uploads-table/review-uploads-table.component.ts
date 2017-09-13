import { Component, Input, Output, EventEmitter } from '@angular/core';
import { ReviewService } from '../../../services/review.service';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-review-uploads-table',
  templateUrl: './review-uploads-table.component.html',
  styleUrls: ['./review-uploads-table.component.css'],
})
export class ReviewUploadsTableComponent {

  loading: boolean = false;
  success: boolean = false;
  showAlert: boolean = false;

  @Input() uploads: any[] = [];
  @Output() select: EventEmitter<any> = new EventEmitter<any>();

  constructor(
    private reviewService: ReviewService,
    public sharedService: SharedService
  ) {}

  syncProd(id: number) {
    this.loading = true;
    this.showAlert = false;
    this.success = true;
    
    this.reviewService.syncProd({data_upload_id: id})
      .subscribe(response => {
        console.log(response);
        this.success = response;
        this.showAlert = true;
        this.loading = false;
      });
  }
}
