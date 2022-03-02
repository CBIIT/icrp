import { Component, OnInit } from '@angular/core';
import { SearchService } from '../../../services/search.service';
import { SharedService } from '../../../services/shared.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'icrp-data-upload-completeness',
  templateUrl: './data-upload-completeness.component.html',
  styleUrls: ['./data-upload-completeness.component.css']
})
export class DataUploadCompletenessComponent implements OnInit {

  authenticated = true;
  data$: Observable<any[]>;

  constructor(
    private searchService: SearchService,
    private sharedService: SharedService
  ){ }

  ngOnInit() {
    this.authenticated = this.sharedService.get('authenticated');
    this.data$ = this.searchService.getDataUploadCompletenessSummary();
  }
}
