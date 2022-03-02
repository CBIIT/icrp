import { Component, ViewChild } from '@angular/core';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { ModalDirective  } from 'ngx-bootstrap/modal';
import { ExportService } from '../../../services/export.service';
import { SharedService } from '../../../services/shared.service';

@Component({
  selector: 'icrp-email-results-button',
  templateUrl: './email-results-button.component.html',
  styleUrls: ['./email-results-button.component.css']
})
export class EmailResultsButtonComponent {

  @ViewChild('emailResultsModal') emailResultsModal: ModalDirective;

  emailForm: FormGroup;

  state = {
    initial: true,
    success: false,
    pending: false,
    valid: false
  }

  constructor(
    private sharedService: SharedService,
    private exportService: ExportService,
    private formbuilder: FormBuilder
  ) {

    this.emailForm = formbuilder.group({
      sender_name: ['',  Validators.required],
      recipient_addresses: [[], Validators.required],
      personal_message: [''],
    });

//    this.emailForm.valueChanges
//      .subscribe(data => console.log(data));
  }

  sendEmail() {
    this.state = {
      initial: false,
      pending: true,
      success: false,
      valid: false
    };

    let params = {
      search_id: +this.sharedService.get('searchID'),
      sender_name:  this.emailForm.controls['sender_name'].value,
      recipient_addresses: this.emailForm.controls['recipient_addresses'].value,
      personal_message: this.emailForm.controls['personal_message'].value,
    }

    this.exportService.emailResults(params)
      .subscribe(response => this.state = {
        initial: false,
        pending: false,
        success: true,
        valid: false
      })

  }

  closeModal() {
    this.emailResultsModal.hide();

    this.state = {
      initial: true,
      success: false,
      pending: false,
      valid: false,
    }

    this.emailForm.patchValue({
      name: '',
      recipient_emails: [],
      personal_message: '',
    })
  }
}
