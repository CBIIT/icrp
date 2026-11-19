import { Component, Input, Output, EventEmitter, OnChanges, SimpleChanges } from '@angular/core';
import { SearchService } from '../../../services/search.service';

/**
 * ICRP Manager bulk status changes from the Project List: inactivate (NCIATWP-11800)
 * and re-activate (NCIATWP-11795).
 * Texts follow the story's acceptance criteria.
 */
export const STATUS_ACTIONS = {
  inactivate: {
    active: false,
    columnLabel: 'Inactivate?',
    buttonLabel: 'Inactivate',
    subProjectWarning: 'Inactivating these projects will also inactivate their sub-projects. Are you sure you want to proceed?\n\nSelected projects with sub-projects: ',
    confirmation: 'Please confirm you would like to inactivate all selected projects and their sub-projects if any.',
    done: 'The following Projects (and their sub-projects if applicable) were flagged as Inactive and therefore removed from public display on the ICRP site: ',
  },
  reactivate: {
    active: true,
    columnLabel: 'Re-activate?',
    buttonLabel: 'Re-activate',
    subProjectWarning: 'All sub-projects of the selected base projects will also be re-activated. Navigate to the Project Summary page to make necessary adjustments in their statuses.\n\nSelected projects with sub-projects: ',
    confirmation: 'Please confirm you would like to re-activate all selected projects and their sub-projects if any.',
    done: 'The following Projects (and their sub-projects if applicable) were flagged as Active and therefore are now available to the public to view on the ICRP site: ',
  },
};

@Component({
  selector: 'icrp-results-table-panel',
  templateUrl: './results-table-panel.component.html',
  styleUrls: ['./results-table-panel.component.css']
})
export class ResultsTablePanelComponent implements OnChanges {

  // 'inactivate' (NCIATWP-11800) or 'reactivate' (NCIATWP-11795) shows the selection column and button
  // (ICRP Managers only; the server checks the role)
  @Input()
  statusAction: string = null;

  // Selections are cleared when a new search is shown
  @Input()
  searchId: any = null;

  @Output('statusChanged')
  statusChangedEmitter: EventEmitter<any> = new EventEmitter<any>();

  selected: { [projectId: string]: string } = {};  // project ID -> award code

  // Most projects changed in one action (keeps the preview request short; the server accepts 1000)
  readonly maxSelected = 500;
  statusBusy: boolean = false;
  statusError: string = null;

  constructor(private searchService: SearchService) { }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['statusAction'] || changes['searchId']) {
      this.clearSelection();
    }
  }

  get action() {
    return this.statusAction ? STATUS_ACTIONS[this.statusAction] : null;
  }

  get selectedIds(): number[] {
    return Object.keys(this.selected).map(id => +id);
  }

  onRowSelect(event: { row: any, checked: boolean }) {
    if (event.checked) {
      this.selected[event.row.project_id] = event.row.award_code;
    } else {
      delete this.selected[event.row.project_id];
    }
  }

  clearSelection() {
    this.selected = {};
    this.statusError = null;
  }

  // Award codes for a dialog, shortened when many projects are selected
  listAwardCodes(codes: string[]): string {
    const shown = 25;
    return codes.length > shown
      ? codes.slice(0, shown).join(', ') + ` and ${codes.length - shown} more`
      : codes.join(', ');
  }

  // Warn about sub-projects, ask for confirmation, change the status, then report the projects changed
  changeStatus() {
    const action = this.action;
    const ids = this.selectedIds;
    if (!action || !ids.length || this.statusBusy) {
      return;
    }
    if (ids.length > this.maxSelected) {
      this.statusError = `Select at most ${this.maxSelected} projects at a time.`;
      return;
    }
    this.statusBusy = true;
    this.statusError = null;
    this.searchService.getProjectStatusPreview(ids)
      .then(previewed => {
        // Skip projects already in the target state (e.g. changed by another Manager since the list loaded)
        const projects = previewed.filter(p => p.is_active !== action.active);
        if (!projects.length) {
          this.statusError = 'The selected projects already have this status.';
          return null;
        }
        const withSubProjects = projects.filter(p => p.sub_projects > 1).map(p => p.award_code);
        if (withSubProjects.length && !window.confirm(action.subProjectWarning + this.listAwardCodes(withSubProjects))) {
          return null;
        }
        if (!window.confirm(action.confirmation + '\n\n' + this.listAwardCodes(projects.map(p => p.award_code)))) {
          return null;
        }
        return this.searchService.setProjectStatus(projects.map(p => p.project_id), action.active)
          .then(() => projects.map(p => p.award_code));
      })
      .then(awardCodes => {
        this.statusBusy = false;
        if (awardCodes) {
          this.clearSelection();
          this.statusChangedEmitter.emit({ message: action.done + awardCodes.join(', ') });
        }
      })
      .catch(error => {
        this.statusBusy = false;
        this.statusError = 'The status could not be changed. Please try again.';
        console.error(error);
      });
  }

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
      label: 'Country',
      key: 'country_name',
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
      label: 'Funding Org. Name',
      key: 'funding_org_name',
      tooltip: 'Funding Organization of Award',
       width: 200,
    },
    {
      label: 'Award Code',
      key: 'award_code',
      tooltip: 'Unique Identifier for Award (supplied by Partner)',
      width: 100,
    },
  ];

  // NCIATWP-11892: ICRP Managers also see each row's ProjectFundingID (the server sends it only to Managers)
  @Input()
  showFundingId: boolean = false;

  fundingIdHeader = {
    label: 'Funding ID',
    key: 'project_funding_id',
    tooltip: 'ICRP ProjectFundingID of the sub-project shown in this row (ICRP Managers only)',
    width: 100,
    sortable: false,
  };

  headersWithFundingId: any[] = (this.headers as any[]).concat([this.fundingIdHeader]);

  get tableHeaders(): any[] {
    return this.showFundingId ? this.headersWithFundingId : this.headers;
  }

  sortPaginate(parameters) {
    this.sortPaginateParameters = Object.assign(
      this.sortPaginateParameters,
      parameters);

    this.sortPaginateEmitter.emit(this.sortPaginateParameters);
  }
}
