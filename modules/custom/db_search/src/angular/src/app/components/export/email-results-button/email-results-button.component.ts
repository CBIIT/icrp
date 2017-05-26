import { Component, ViewChild } from '@angular/core';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { ModalDirective  } from 'ngx-bootstrap/modal';
import { ExportService } from '../../../services/export.service';

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
    private exportService: ExportService,
    private formbuilder: FormBuilder
  ) {

    this.emailForm = formbuilder.group({
      name: ['',  Validators.required],   
      recipient_emails: [[], Validators.required],
      personal_message: [''],
    });
  }

  sendEmail() {
    this.state = {
      initial: false,
      pending: true,
      success: false,
      valid: false
    };

    let params = {
      name:  this.emailForm.controls['name'].value,
      recipient_email: this.emailForm.controls['recipient_emails'].value,
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
