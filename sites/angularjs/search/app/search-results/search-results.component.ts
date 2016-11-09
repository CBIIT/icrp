import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-search-results',
  templateUrl: './search-results.component.html',
  styleUrls: ['./search-results.component.css']
})
export class SearchResultsComponent implements OnInit {

  @Input() results = {
      headers: null,
      data: null
  }
  

  table = {
    numRows: 25
  }

  summaryMessage: string  
  message = 'The default search is shown (all awards, all years). Use the search boxes on the left or the dashboard below to refine your search.'
  showMessage = true;

  constructor() {
    this.generateSummary()

  }

  paginate(event) {
    console.log('paginating')
    console.log(event);
  }

  generateSummary() {
    this.summaryMessage = 'Summary message placeholder'
  }

  ngOnInit() {
  }

}
