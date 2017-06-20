import React from 'react';
import PartnerForm from '../PartnerForm/';
import moment from 'moment';

export default class Form extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      form: {
        partner: '',
        joinedDate: null,
        country: '',
        email: '',
        description: '',
        sponsorCode: '',
        website: '',
        mapCoordinates: '',
        logoFile: '',
        note: '',
        agreeToTerms: false,

        isFundingOrganization: false,
        organizationType: '',
        isAnnualized: false,
      },
      fields: {
        partners: [],
        countries: [],
        organizationTypes: [
          'Government',
          'Non-profit',
          'Other',
        ],
      },
      validation: {

      },
      loading: true,
      message: {

      }
    };

    this.getFields();
  }

  async getFields() {

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let endpoint = `${protocol}//${hostname}/api/admin/partners/fields`;
    if (hostname === 'localhost')
      endpoint = 'https://icrpartnership-dev.org/api/admin/partners/fields';

    let response = await fetch(endpoint, { credentials: 'same-origin' });
    let data = await response.json()

    let form = this.state.form;
    let fields = this.state.fields;
    for (let key in data) {
      fields[key] = data[key];
    }

    if (fields.partners && fields.partners.length > 0) {
      let partner = fields.partners[0];

      form.partner = partner.partner_name;
      form.joinedDate = moment(partner.joined_date);
      form.country = partner.country;
      form.description = partner.description;
      form.email = partner.email;
    }

    this.setState({
      form: form,
      fields: fields,
      loading: false,
    });
  }

  handleChange(field, value) {
    let form = this.state.form;
    form[field] = value;

    if (field === 'partner') {
      let partner = this.state.fields.partners
        .find(e => e.partner_name === form.partner);

      form.partner = partner.partner_name;
      form.joinedDate = moment(partner.joined_date);
      form.country = partner.country;
      form.description = partner.description;
      form.email = partner.email;
    }

    this.setState({
      form: form
    });
  }

  validate() {
    let form = this.state.form;
    let validationState = {};
    let valid = true;
    let requiredFields = [
      'partner',
      'joinedDate',
      'country',
      'email',
      'description',
      'sponsorCode',
      'agreeToTerms',
    ];

    if (form.isFundingOrganization) {
      requiredFields.push('organizationType');
    }

    for (let field of requiredFields) {
      if (!form[field]) {
        validationState[field] = false;
        valid = false;
      }
    }

    this.setState({
      validation: validationState
    })

    return valid;
  }

  async submit() {
    let isValid = this.validate();

    if (isValid) {
      let form = this.state.form;
      let formData = new FormData();

      let parameterMap = {
        partner: 'partner_name',
        joinedDate: 'joined_date',
        country: 'country',
        email: 'email',
        description: 'description',
        sponsorCode: 'sponsor_code',
        website: 'website',
        mapCoordinates: 'map_coordinates',
        logoFile: 'logo_file',
        note: 'note',
        agreeToTerms: 'agree_to_terms',

        isFundingOrganization: 'is_funding_organization',
        organizationType: 'organization_type',
        isAnnualized: 'is_annualized',
      };


      for (let key in form) {
        let formKey = parameterMap[key];
        let formValue = form[key];
        if (key === 'joinedDate')
          formValue = formValue._i;
        formData.set(formKey, formValue);
      }

      let partner = this.state.fields.partners
        .find(e => e.partner_name === form.partner);
      formData.set('partner_application_id', partner.partner_application_id);

      let country = this.state.fields.countries
        .find(e => e.value === form.country);
      formData.set('currency', country.currency);

      let protocol = window.location.protocol;
      let hostname = window.location.hostname;
      let endpoint = `${protocol}//${hostname}/api/admin/partners/add`;
      if (hostname === 'localhost')
        endpoint = 'https://icrpartnership-dev.org/api/admin/partners/add';

      let response = await fetch(endpoint, {
        method: 'POST',
        body: formData,
        credentials: 'same-origin',
      });

      let messages = await response.json();

      if (messages.constructor === Array && messages.length > 0) {

        this.setState({
          message: messages.pop()
        });

        this.getFields();
      }
    }
  }

  dismissMessage() {
    this.setState({
      message: {}
    })
  }

  clear() {
    this.setState({
      form: {
        partner: '',
        joinedDate: null,
        country: '',
        email: '',
        description: '',
        sponsorCode: '',
        website: '',
        mapCoordinates: '',
        logoFile: null,
        note: '',
        agreeToTerms: false,

        isFundingOrganization: false,
        organizationType: '',
        isAnnualized: false,
      },
      validation: {},

    })
  }


  render() {
    return <PartnerForm
      context={this}

      form={ this.state.form }
      fields={ this.state.fields }
      validation={ this.state.validation }
      changeCallback={ this.handleChange.bind(this) }
      submitCallback={ this.submit.bind(this) }
      cancelCallback={ this.clear.bind(this) }
      loading={ this.state.loading }
      message={ this.state.message }
      dismissMessage={ this.dismissMessage.bind(this) }
    />
  }
}
