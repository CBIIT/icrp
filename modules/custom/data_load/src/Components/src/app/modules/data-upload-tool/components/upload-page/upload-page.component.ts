import { Component } from '@angular/core';
import { DataUploadService } from '../../../../services/data-upload.service';
import { SharedDataService } from '../../../../services/shared-data.service';
import { Observable } from 'rxjs/Observable';
import { } from 'rxjs/operators';

@Component({
  selector: 'data-upload-page',
  templateUrl: './upload-page.component.html',
  styleUrls: ['./upload-page.component.css']
})
export class UploadPageComponent {
  constructor(
    private dataUpload: DataUploadService,
    private sharedData: SharedDataService
  ) {}

  alerts: {type: string, message: string}[] = [];
  loading: boolean = false;
  nextEnabled: boolean = false;
  count: number = 0;
  projects: any[] = [];
  headers: any[] = [];

  onSubmit(event) {
    console.log(event);
    this.sharedData.merge({
      loading: true,
      workbookValid: false,
      uploadType: event.uploadType,
      sponsorCode: event.sponsorCode,
      submissionDate: [
        event.submissionDate.getFullYear(),
        event.submissionDate.getMonth() + 1,
        event.submissionDate.getDate(),
      ].join('-'),
    });

    this.alerts = [];
    this.nextEnabled = false;
    
    this.dataUpload.loadProjects({
      file: event.file[0],
      locale: event.csvDateFormat,
    }).subscribe(
      response => {
        this.loading = false;
        this.projects = response.projects;
        this.headers = Object.keys(this.projects[0]);
        this.count = response.count;
        this.nextEnabled = true;

        this.sharedData.merge({
          workbookValid: true,
          loading: false,
        })
      },

      // handle errors
      ({error}) => {
        this.alerts.push({
          type: 'danger',
          message: error,
        });

        this.sharedData.merge({
          loading: false
        });
      }
    )
  }

  getProjects(event) {
    this.sharedData.set('loading', true);
    this.dataUpload.getProjects(event)
      .subscribe(response => {
        this.sharedData.set('loading', false);
        this.projects = response;
      });
  }

  onReset() {
    this.alerts = [];
    this.projects = [];
    this.count = 0;
    this.sharedData.clear();
  }
}
