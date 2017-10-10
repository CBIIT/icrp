import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';

@Component({
  selector: 'icrp-funding-organization-form',
  templateUrl: './funding-organization-form.component.html',
  styleUrls: ['./funding-organization-form.component.css']
})
export class FundingOrganizationFormComponent implements OnInit {

  form: FormGroup;

  constructor(private formBuilder: FormBuilder) {
    this.form = this.createForm();
  }

  createForm(): FormGroup {
    return this.formBuilder.group({
      partner: ['', Validators.required],
      memberType: ['associate', Validators.required],
      name: '',
      abbreviation: '',
      organizationType: '',
      latitude: null,
      longitude: null,
      country: '',
      currency: '',
      note: '',
      annualizedFunding: false,
    });
  }

  ngOnInit() {
  }

}
