import { Component, TemplateRef, ElementRef, ViewChild } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { PartnersApiService } from '../../services/partners-api.service'
import { HttpErrorResponse } from '@angular/common/http';
import { NonPartnersApiService } from '../../services/non-partners-api.service';
import { BsModalService } from 'ngx-bootstrap/modal';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';

@Component({
  selector: 'icrp-partners-form',
  templateUrl: './partners-form.component.html',
  styleUrls: [
    './partners-form.component.css',
  ]
})
export class PartnersFormComponent {

  form: FormGroup;
  messages: {type: string, content: string}[] = [];
  fields: any = {};
  loading: boolean = false;
  today = new Date();
  modalRef: BsModalRef;

  @ViewChild('template')
  template: TemplateRef<any>;

  confirmed: boolean = false;


  constructor(
    private formBuilder: FormBuilder,
    private partnersApi: PartnersApiService,
    private nonPartnersApi: NonPartnersApiService,
    private modalService: BsModalService
  ) {

/*
CREATE  PROCEDURE [dbo].[AddPartner]
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@JoinedDate [datetime],
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@Status [varchar](25) = 'Current'

CREATE  PROCEDURE [dbo].[AddNonPartner]
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@EstimatedInv [varchar](200),
	@DoNotContact bit,
	@CancerOnly bit,
	@ResearchFunder bit,
	@ContactPerson [varchar](200),
	@Position [varchar](100)

CREATE  PROCEDURE [dbo].[UpdatePartner]
	@PartnerID INT,
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@JoinedDate [datetime],
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@Status [varchar](25) = 'Current'

CREATE  PROCEDURE [dbo].[UpdateNonPartner]
	@NonPartnerID int,
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@EstimatedInv [varchar](200),
	@DoNotContact bit,
	@CancerOnly bit,
	@ResearchFunder bit,
	@ContactPerson [varchar](200),
	@Position [varchar](100)
*/


    this.form = this.formBuilder.group({
      operationType: 'Add',
      isNonPartner: [false],
      partnerId: [null],
      partnerApplicationId: [null],
      nonPartnerId: [null],
      status: 'Current',

      country: [null, Validators.required],
      email: [null, [Validators.required, Validators.email]],

      description: [null, [Validators.required]],
      sponsorCode: [null, [Validators.required, Validators.maxLength(50)]],
      website: [null, [Validators.maxLength(250), Validators.pattern(/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/i)]],

      latitude: [null, [Validators.required, Validators.min(-90), Validators.max(90)]],
      longitude: [null, [Validators.required, Validators.min(-180), Validators.max(180)]],

      logoFile: [null],
      logoFileInput: [null],

      note: [null, Validators.maxLength(8000)],

      joinedDate: [null, Validators.required],

      isDsaSigned: [false],

      name: [null, [Validators.required, Validators.maxLength(100)]],
      abbreviation: [null, [Validators.required, Validators.maxLength(15)]],

      estimatedInvestment: [null, Validators.required],

      cancerOnly: [false],
      researchFunder: [false],

      contactPerson: [null],
      position: [null],
      doNotContact: [false],

      isFundingOrganization: [false],
      type: [null],
      currency: [null],
      isAnnualized: false,
    });

    partnersApi.fields().subscribe(response => {
      this.fields = response;
      this.initializeFormControls();
    }, errorResponse => {
      console.log(errorResponse);
      this.messages.push({
        type: 'danger',
        content: errorResponse.error
      });
    });
  }

  initializeFormControls() {
    const controls = this.form.controls;

    controls.operationType.valueChanges.subscribe(operationType => {
      const { partnerId, partnerApplicationId, nonPartnerId, name, isNonPartner } = controls;

      partnerId.clearValidators();
      partnerApplicationId.clearValidators();
      nonPartnerId.clearValidators();
      name.clearValidators();

      if (isNonPartner) {
        if (operationType === 'Add') {
          name.setValidators(Validators.required);
        }

        else if (operationType === 'Update') {
          nonPartnerId.setValidators(Validators.required);
        }
      }

      else {
        if (operationType === 'Add') {
          partnerApplicationId.setValidators(Validators.required);
        }

        else if (operationType === 'Update') {
          partnerId.setValidators(Validators.required);
        }
      }

      this.form.reset({
        operationType: operationType,
        isNonPartner: isNonPartner.value,
        isFundingOrganization: false,
        isDsaSigned: false,
        cancerOnly: false,
        researchFunder: false,
        doNotContact: false,
      }, {emitEvent: false});
    });

    controls.isNonPartner.valueChanges.subscribe(isNonPartner => {
      const {
        operationType,
        partnerId,
        partnerApplicationId,
        longitude,
        latitude,
        joinedDate,
        isFundingOrganization,
        email,
       } = controls;

      let enabledControls = [
        'operationType',
        'isNonPartner',
        'name',
        'country',
        'email',
        'description',
        'sponsorCode',
        'website',
        'latitude',
        'longitude',
        'logoFile',
        'logoFileInput',
        'note'
      ];

      if (isNonPartner) {
        enabledControls.push(
          'nonPartnerId',
          'estimatedInvestment',
          'cancerOnly',
          'researchFunder',
          'contactPerson',
          'position',
          'doNotContact',
        );

        // operationType.updateValueAndValidity();

        joinedDate.clearValidators();
        isFundingOrganization.updateValueAndValidity(),
        latitude.setValidators([Validators.min(-90), Validators.max(90)]);
        longitude.setValidators([Validators.min(-180), Validators.max(180)]);
        email.clearValidators();
        email.updateValueAndValidity();
      }

      else {
        enabledControls.push(
          'partnerId',
          'partnerApplicationId',
          'status',
          'joinedDate',
          'isDsaSigned',
          'isFundingOrganization',
          'type',
          'currency',
          'isAnnualized'
        );

        latitude.setValidators([Validators.required, Validators.min(-90), Validators.max(90)]);
        longitude.setValidators([Validators.required, Validators.min(-180), Validators.max(180)]);
        email.setValidators([Validators.required, Validators.email]);
        email.updateValueAndValidity();
      }

      this.form.reset({
        isNonPartner: isNonPartner,
        operationType: operationType.value,
        status: 'Current',
        isFundingOrganization: false,
        isDsaSigned: false,
        cancerOnly: false,
        researchFunder: false,
        doNotContact: false,
      }, {emitEvent: false});

      for (let key in controls) {
        enabledControls.includes(key)
          ? controls[key].enable({emitEvent: false})
          : controls[key].disable({emitEvent: false});
      }
    });

    controls.logoFileInput.valueChanges.subscribe((logoFileInput: FileList) => {
      const { logoFile } = controls;
      logoFile.setValue(null);
      if (logoFileInput && logoFileInput.length > 0) {
        const file = logoFileInput[0];
        logoFile.setValue(file.name);
      }
    });

    controls.partnerApplicationId.valueChanges.subscribe(partnerApplicationId => {
      this.form.reset({
        partnerApplicationId: partnerApplicationId,
        operationType: controls.operationType.value,
        status: 'Current',
        isFundingOrganization: false,
        isDsaSigned: false,
        cancerOnly: false,
        researchFunder: false,
        doNotContact: false,
      }, {emitEvent: false});

      if (partnerApplicationId !== null) {
        const record = this.fields.partnerApplications
          .find(partnerApplication => partnerApplication.partnerapplicationid === partnerApplicationId);

        this.form.patchValue({
          country: record.country,
          description: record.description,
          email: record.email,
          name: record.name
        })
      }
    })

    controls.partnerId.valueChanges.subscribe(partnerId => {
      this.form.reset({
        partnerId: partnerId,
        operationType: controls.operationType.value,
        status: 'Current',
        isFundingOrganization: false,
        isDsaSigned: false,
        cancerOnly: false,
        researchFunder: false,
        doNotContact: false,
      }, {emitEvent: false});

      if (partnerId !== null) {
        const record = this.fields.partners
          .find(partner => partner.partnerid === partnerId);

        this.form.patchValue({
          partnerid: record.partnerid,
          name: record.name,
          sponsorCode: record.sponsorcode,
          status: record.status,
          description: record.description,
          country: record.country,
          website: record.website,
          joinedDate: record.joindate,
          email: record.email,
          latitude: record.latitude,
          longitude: record.longitude,
          logoFile: record.logofile,
          note: record.note,
          isDsaSigned: record.isdsasigned || false,
        });
      }
    });

    controls.nonPartnerId.valueChanges.subscribe(nonPartnerId => {
      this.form.reset({
        nonPartnerId: nonPartnerId,
        isNonPartner: controls.isNonPartner.value,
        operationType: controls.operationType.value,
        isFundingOrganization: false,
        isDsaSigned: false,
        cancerOnly: false,
        researchFunder: false,
        doNotContact: false,
      }, {emitEvent: false});

      if (nonPartnerId !== null) {
        const record = this.fields.nonPartners
          .find(nonPartner => nonPartner.nonpartnerid === nonPartnerId);

        this.form.patchValue({
          name: record.name,
          description: record.description,
          sponsorCode: record.abbreviation,
          email: record.email,
          country: record.country,
          longitude: record.longitude,
          latitude: record.latitude,
          website: record.website,
          logofile: record.logofile,
          note: record.note,
          estimatedInvestment: record.estimatedinvest,
          contactPerson: record.contactperson,
          position: record.position,
          doNotContact: record.donotcontact  || false,
          cancerOnly: record.canceronly  || false,
          researchFunder: record.researchfunder  || false,
        });
      }
    })


    controls.country.valueChanges.subscribe(country => {
      controls.country.valueChanges.subscribe(value => {
        if (!controls.currency.enabled)
          return;

        const country = this.fields.countries
          .find(country => country.abbreviation === value);

        if (country && this.fields.currencies
          .map(currency => currency.code)
          .includes(country.currency)) {
          controls.currency.setValue(country.currency);
        } else {
          controls.currency.setValue(null);
        }

        controls.currency.markAsDirty();
      });
    })

    controls.isFundingOrganization.valueChanges.subscribe(isFundingOrganization => {
      const { type, currency } = controls;
      type.clearValidators();
      currency.clearValidators();

      if (isFundingOrganization) {
        type.setValidators(Validators.required);
        currency.setValidators(Validators.required);
      }

      type.updateValueAndValidity();
      currency.updateValueAndValidity();
    })

    controls.isFundingOrganization.updateValueAndValidity();
    controls.isNonPartner.updateValueAndValidity();

  }


  submit() {
    this.messages = [];
    const formValue = this.form.value;

    for (let key in this.form.controls) {
      this.form.controls[key].markAsDirty();
    }

    if (!this.form.valid) {
      document.querySelector('h1').scrollIntoView();
      return;
    }

    if (!this.confirmed
      && formValue.operationType === 'Update'
      && !formValue.isNonPartner
      && formValue.status === 'Former'
      && this.fields.partners.find(e => e.partnerid === formValue.partnerId).status === 'Current') {
      this.openModal(this.template);
        return;
    }

    this.confirmed = false;
    const formData = new FormData();
    for (let key in formValue) {
      let value = formValue[key];
      if (value && value.constructor === FileList) {
        formData.append(key, value[0], value[0].name);
      } else if (value && value.constructor === Date) {
        let date = [
          value.getFullYear(),
          (value.getMonth() + 1).toString().padStart(2, '0'),
          value.getDate().toString().padStart(2, '0')
        ].join('-');
        formData.append(key, date);
      } else {
        formData.append(key, value);
      }
    }

    const action = this.form.value.operationType.toLowerCase(); // 'add' or 'update'
    const api = this.form.value.isNonPartner
      ? 'nonPartnersApi'
      : 'partnersApi';

    this[api][action](formData)
      .subscribe(response => {
        document.querySelector('h1').scrollIntoView();
        let content;

        if (action === 'add' && api === 'partnersApi' && formValue.isFundingOrganization)
          content = `The partner has been added as a funding organization. `;

        else if (action === 'add' && api === 'partnersApi')
          content = `The partner has been added. `;

        else if (action === 'update' && api === 'partnersApi')
          content = `The partner has been updated. `;

        else if (action === 'add' && api === 'nonPartnersApi')
          content = `The prospective partner has been added. `;

        else if (action === 'update' && api === 'nonPartnersApi')
          content = `The prospective partner has been updated. `;

        content += `Visit <a href="/partners">Current Partners and Funding Organizations</a> to view a list of current ICRP partners. `

        this.messages.push({
          type: 'success',
          content: content,
        });

        this.partnersApi.fields().subscribe(response => {
          this.fields = response;
          this.form.controls.partnerId.updateValueAndValidity();
          this.form.controls.nonPartnerId.updateValueAndValidity();
          this.form.controls.isNonPartner.updateValueAndValidity();
        });

      }, errorResponse => {
        document.querySelector('h1').scrollIntoView();
        this.messages.push({
          type: 'danger',
          content: `${errorResponse.error}`,
        });
      });
  }

  reset() {
    this.form.reset({
      operationType: 'Add',
      memberType: 'Associate',
      status: 'Current',
    });
  }

  openModal(template: TemplateRef<any>) {
    this.modalRef = this.modalService.show(template);
  }

  confirm(): void {
    this.confirmed = true;
    this.modalRef.hide();
    this.submit();
  }
}
