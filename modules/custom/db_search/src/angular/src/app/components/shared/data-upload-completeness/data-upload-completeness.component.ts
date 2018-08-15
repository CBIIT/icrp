import { Component, OnInit } from '@angular/core';
import { SearchService } from '../../../services/search.service';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-data-upload-completeness',
  templateUrl: './data-upload-completeness.component.html',
  styleUrls: ['./data-upload-completeness.component.css']
})
export class DataUploadCompletenessComponent implements OnInit {

  authenticated = true;
  data = [];

  constructor(
    private searchService: SearchService,
    private sharedService: SharedService
  ){ }

  ngOnInit() {
    if (window['drupalSettings']) {
      this.authenticated = window['drupalSettings']['user']['roles'].includes('authenticated');
    }

    this.searchService.getDataUploadCompletenessSummary()
      .subscribe(response => {
        this.data = response
          .map(e => {
            for (let key in e)
              e[key] = +e[key]
            return e;
          })
          
      });
  }

}
