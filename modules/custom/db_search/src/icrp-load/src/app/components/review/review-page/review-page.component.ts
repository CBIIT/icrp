import { Component } from '@angular/core';
import { ReviewService } from '../../../services/review.service';
import { SharedService } from '../../../services/shared.service';


import { Observable } from 'rxjs';

@Component({
  selector: 'icrp-review-page',
  templateUrl: './review-page.component.html',
  styleUrls: ['./review-page.component.css']
})
export class ReviewPageComponent {

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

  loading: boolean = true;
  numResults = 0;
  analytics = {
    project_counts_by_country: null,
    project_counts_by_cso_research_area: null,
    project_counts_by_cancer_type: null,
    project_counts_by_type: null,
    project_funding_amounts_by_year: null,
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
      if (response && response.length) {
        this.sponsorUploadsTable = response;
        this.selectUploadID(response[0].data_upload_id);
      }

      this.loading = false;
    });
  }

  getAnalytics(id, types = [], year = null) {
    if (!types || types.length === 0)
      types = Object.keys(this.analytics);

    for (let key of types) {
      this.analytics[key] = [];

      this.reviewService.getAnalytics({
        search_id: id,
        type: key,
        year: year,
      })
      .subscribe(response => this.analytics[key] = response);
    }
  }

  getSearchResults(parameters, updateAnalytics = false) {

    this.loading = true;

    this.reviewService.getSearchResults(parameters)
      .subscribe(response => {
        this.searchResults = response.results;
        this.searchID = response.search_id;
        this.numResults = response.results_count;

        if (updateAnalytics) {
          this.getAnalytics(this.searchID);
        }

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

      this.currentSponsor = this.sponsorUploadsTable
        .filter(e => e.data_upload_id == this.uploadID)[0];

      this.getSearchResults(
        Object.assign(this.sortPaginateParameters, {
          data_upload_id: uploadID
        }),
        true);
    }
  }
}
