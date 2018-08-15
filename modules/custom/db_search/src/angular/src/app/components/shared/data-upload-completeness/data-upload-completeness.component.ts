import { Component, OnInit } from '@angular/core';
import { SearchService } from '../../../services/search.service';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-data-upload-completeness',
  templateUrl: './data-upload-completeness.component.html',
  styleUrls: ['./data-upload-completeness.component.css']
})
export class DataUploadCompletenessComponent implements OnInit {

  authenticated = false;
  data = [];

  constructor(
    private searchService: SearchService,
    private sharedService: SharedService
  ){ }

  ngOnInit() {
    this.authenticated = this.sharedService.get('authenticated');
    this.searchService.getDataUploadCompletenessSummary()
      .subscribe(response => {
        this.data = response
          .map(e => {
            for (let key in e)
              e[key] = +e[key]

            // e.Status = Math.random() < 0.5 ? 1 : 2;
            return e;
          })
          .sort((a, b) => b.Year - a.Year)
      });
  }

}
