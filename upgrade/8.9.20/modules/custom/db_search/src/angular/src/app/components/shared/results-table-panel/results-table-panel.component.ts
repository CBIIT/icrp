import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'icrp-results-table-panel',
  templateUrl: './results-table-panel.component.html',
  styleUrls: ['./results-table-panel.component.css']
})
export class ResultsTablePanelComponent {

  @Input()
  results: any[] = [];

  @Input()
  numResults: number = 0;

  @Input()
  loading: boolean = true;

  @Output('sortPaginate')
  sortPaginateEmitter: EventEmitter<any> = new EventEmitter<any>();

  sortPaginateParameters = {
    page_size: 50,
    page_number: 1,
    sort_column: 'project_title',
    sort_direction: 'asc',
  }

  headers = [
    {
      label: 'Project Title',
      key: 'project_title',
      link: 'project_url',
      tooltip: 'Title of Award',
      sort: 'asc',
      width: 200,
    },

    {
      label: 'PI',
      key: 'pi_name',
      tooltip: 'Principal Investigator',
      width: 100,
    },

    {
      label: 'Institution',
      key: 'institution',
      tooltip: 'PI Institution',
      width: 200,
    },

    {
      label: 'Ctry.',
      key: 'country',
      tooltip: 'PI Institution Country',
      width: 100,
    },

    {
      label: 'Funding Org.',
      key: 'funding_organization',
      tooltip: 'Funding Organization of Award (abbreviated name shown)',
      width: 100,
    },

    {
      label: 'Award Code',
      key: 'award_code',
      tooltip: 'Unique Identifier for Award (supplied by Partner)',
      width: 100,
    },
  ];

  sortPaginate(parameters) {
    this.sortPaginateParameters = Object.assign(
      this.sortPaginateParameters,
      parameters);

    this.sortPaginateEmitter.emit(this.sortPaginateParameters);
  }
}
