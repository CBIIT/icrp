import { Component, ViewChild } from '@angular/core';
import { ReviewService } from '../../../services/review.service';
import { SharedService } from '../../../services/shared.service';
import {
  trigger,
  state,
  style,
  animate,
  transition
} from '@angular/animations';

import { Observable, of, timer } from 'rxjs';
import { delay } from 'rxjs/operators';

@Component({
  selector: 'icrp-review-page',
  templateUrl: './review-page.component.html',
  styleUrls: ['./review-page.component.css'],

  animations: [
    trigger('loadingState', [
      state('false', style({
        opacity: 0,
        display: 'none',
      })),
      state('true', style({
        opacity: '0.4',
        display: 'flex',
      })),

      transition(':enter', animate('10ms ease-in')),
      transition('true => false', animate('1000ms ease-out')),
      transition('false => true', animate('1000ms ease-in')),
    ])
  ]
})
export class ReviewPageComponent {

  @ViewChild('chartspanel') chartsPanel;

  searchID: number | string;
  uploadID: number | string;

  sponsorUploadsTable: any[];
  currentSponsor: any;

  sortPaginateParameters = {
    page_size: 50,
    page_number: 1,
    sort_column: 'project_title',
    sort_direction: 'asc',
  }

  state = {
    projectCount: 0,
    relatedProjectCount: 0,
    lastBudgetYear: 0
  }

  loading: boolean = true;
  numResults = 0;
  analytics = {
    project_counts_by_country: null,
    project_counts_by_cso_research_area: null,
    project_counts_by_cancer_type: null,
    project_counts_by_type: null,
    project_counts_by_year: null,
    project_counts_by_institution: null,
    project_counts_by_childhood_cancer: null,
    project_counts_by_funding_organization: null,

    project_funding_amounts_by_country: null,
    project_funding_amounts_by_cso_research_area: null,
    project_funding_amounts_by_cancer_type: null,
    project_funding_amounts_by_type: null,
    project_funding_amounts_by_year: null,
    project_funding_amounts_by_institution: null,
    project_funding_amounts_by_childhood_cancer: null,
    project_funding_amounts_by_funding_organization: null,
  };

  fields: any = {};



  searchResults: any[];
  headers = [
    {
      label: 'Project Title',
      key: 'project_title',
      link: 'project_url',
      tooltip: 'Title of Award',
      sort: 'asc',
    },

    {
      label: 'PI',
      key: 'pi_name',
      tooltip: 'Principal Investigator',
    },

    {
      label: 'Institution',
      key: 'institution',
      tooltip: 'PI Institution',
    },

    {
      label: 'Ctry.',
      key: 'country',
      tooltip: 'PI Institution Country',
    },

    {
      label: 'Funding Org.',
      key: 'funding_organization',
      tooltip: 'Funding Organization of Award (abbreviated name shown)',
    },

    {
      label: 'Award Code',
      key: 'award_code',
      tooltip: 'Unique Identifier for Award (supplied by Partner)',
    },
  ];




  success: boolean = false;
  showAlert: boolean = false;

  loadingMessage = 'Update in Progress...';


  constructor(
    private reviewService: ReviewService,
    private sharedService: SharedService) {

    // retrieve any fields used on this page
    reviewService.getFields().subscribe(response => {
      this.fields = response;
    })

    // retrieve initial data upload results
    this.getSponsorUploads();
  }

  getSponsorUploads() {

    this.loading = true;

    // once sponsor uploads have been fetched,
    // set the current upload id and retrieve analytics and search results
    this.reviewService.getSponsorUploads().subscribe(response => {

      if (response) {
        this.sponsorUploadsTable = response;

        if (response[0])
          this.selectUploadID(response[0].data_upload_id);
      }

      this.loading = false;
    });
  }


  getSearchSummary(updateConversionYear: boolean = true) {
    return this.reviewService.getSearchSummary({ search_id: this.searchID })
      .map(response => {
        this.state.projectCount = +response.project_count;
        this.state.relatedProjectCount = +response.related_project_count;
        return this.state;
      })
  }

  getAnalytics(id, types = [], year = null) {
    if (!types || types.length === 0) {
      types = [
        'project_counts_by_country',
        'project_counts_by_cso_research_area',
        'project_counts_by_cancer_type',
        'project_counts_by_type',
      ];
    }

    for (let key of types) {

      let loadingTrue$ = timer(250)
        .subscribe(e => this.analytics[key] = []);

      this.reviewService.getAnalytics({
        search_id: id,
        type: key,
        year: year,
      })
      .subscribe(response => {
        loadingTrue$.unsubscribe();
        this.analytics[key] = response
      });
    }
  }

  getSearchResults(parameters, updateAnalytics = false) {

    let loadingTrue$ = timer(100)
      .subscribe(e => this.loading = true);

    this.reviewService.getSearchResults(parameters)
      .subscribe(response => {
        this.searchResults = response.results;
        this.searchID = response.search_id;
        this.numResults = response.results_count;
        this.sharedService.set('searchID', this.searchID);

        if (updateAnalytics) {
          this.chartsPanel.updateCharts(this.searchID);
        }

        this.getSearchSummary().subscribe();

        loadingTrue$.unsubscribe();
        this.loading = false;
      });
  }

  sortPaginate(parameters) {
    this.sortPaginateParameters = Object.assign(
      this.sortPaginateParameters,
      parameters);

    this.getSearchResults(
      Object.assign(this.sortPaginateParameters, {
        data_upload_id: this.uploadID
      })
    );
  }

  selectUploadID(uploadID) {
    if (uploadID !== this.uploadID) {
      this.uploadID = uploadID;
      this.resetAnalytics();

      this.sharedService.set('dataUploadID',  this.uploadID);

      this.currentSponsor = this.sponsorUploadsTable
        .filter(e => e.data_upload_id == this.uploadID)[0];

      this.getSearchResults(
        Object.assign(this.sortPaginateParameters, {
          data_upload_id: uploadID,
          page_number: 1,
        }),
        true);
    }
  }


  syncProd(uploadID: number) {
    this.loading = true;
    this.showAlert = false;
    this.success = true;

    this.reviewService.syncProd({data_upload_id: uploadID})
      .subscribe(response => {
        console.log(response);

        this.success = response;
        this.showAlert = true;
        this.loading = false;

        // retrieve initial data upload results
        this.getSponsorUploads();
      });
  }


  resetAnalytics() {
    this.analytics = {
      project_counts_by_country: null,
      project_counts_by_cso_research_area: null,
      project_counts_by_cancer_type: null,
      project_counts_by_type: null,
      project_counts_by_year: null,
      project_counts_by_institution: null,
      project_counts_by_childhood_cancer: null,
      project_counts_by_funding_organization: null,

      project_funding_amounts_by_country: null,
      project_funding_amounts_by_cso_research_area: null,
      project_funding_amounts_by_cancer_type: null,
      project_funding_amounts_by_type: null,
      project_funding_amounts_by_year: null,
      project_funding_amounts_by_institution: null,
      project_funding_amounts_by_childhood_cancer: null,
      project_funding_amounts_by_funding_organization: null,
    };
  }
}
