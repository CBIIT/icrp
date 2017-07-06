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
        currency: '',
        isAnnualized: false,
      },
      fields: {
        partners: [],
        countries: [],
        currencies: [],
        organizationTypes: [
          'Government',
          'Non-profit',
          'Other',
        ],
      },
      validationErrors: {

      },
      loading: true,
      messages: [],
    };

    this.getFields();
  }

  async getFields() {

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let endpoint = `${protocol}//${hostname}/api/admin/partners/fields`;
//    if (hostname === 'localhost')
//      endpoint = 'https://icrpartnership-dev.org/api/admin/partners/fields';

    let response = await fetch(endpoint, { credentials: 'same-origin' });
    let data = await response.json()

    let form = this.state.form;
    let fields = this.state.fields;
    for (let key in data) {
      fields[key] = data[key];
    }

    if (fields.partners && fields.partners.length > 0) {
      let partner = fields.partners[0];

      let country = fields.countries
        .find(e => e.label.toLowerCase() === partner.country.toLowerCase());

      form.partner = partner.partner_name;
      form.joinedDate = moment(partner.joined_date);
      form.country = country ? country.value : '';
      form.description = partner.description;
      form.email = partner.email;

      form.currency = '';
      if (fields.currencies
        .find(e => e.value === country.currency)) {
        form.currency = country.currency || '';
      }
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

      let country = this.state.fields.countries
        .find(e => e.label.toLowerCase() === partner.country.toLowerCase());

      form.partner = partner.partner_name;
      form.joinedDate = moment(partner.joined_date);
      form.country = country ? country.value : '';
      form.description = partner.description;
      form.email = partner.email;
    }

    if (field === 'country') {
      let country = this.state.fields.countries
        .find(e => e.value === value);
      
      form.currency = '';
      if (this.state.fields.currencies
        .find(e => e.value === country.currency)) {
        form.currency = country.currency || '';
      }
    }

    this.setState({
      form: form
    });
  }

  validate() {
    let form = this.state.form;
    let validationErrors = {};
    let isValid = true;

    let validationRules = {
      partner: {
        required: true
      },

      joinedDate: {
        required: true,
        format: /^\d{4}-\d{2}-\d{2}$/,
      },

      country: {
        required: true,
      },

      email: {
        required: true,
        format: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      },

      description: {
        required: true,
      },

      sponsorCode: {
        required: true,
      },

      organizationType: {
        required: form.isFundingOrganization
      },

      currency: {
        required: form.isFundingOrganization
      }
    }

    for (let field in validationRules) {
      validationErrors[field] = {};
      let value = field !== 'joinedDate'
        ? (form[field] || '').toString().trim()
        : form[field] ? moment(form[field]).format('YYYY-MM-DD') : '0';


      if (validationRules[field].required && value.constructor === String && value.length === 0) {
        validationErrors[field].required = true;
        isValid = false;
      }

      if (validationRules[field].format && !validationRules[field].format.test(value)) {
        validationErrors[field].format = true;
        isValid = false;
      }
    }

    this.setState({
      validationErrors: validationErrors
    })

    return isValid;
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
        currency: 'currency',
      };


      for (let key in form) {
        let formKey = parameterMap[key];
        let formValue = form[key];
        if (key === 'joinedDate')
          formValue = moment(formValue._d).format('YYYY-MM-DD');

        if (formValue !== '' && formValue !== null)
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
//      if (hostname === 'localhost')
//        endpoint = 'https://icrpartnership-dev.org/api/admin/partners/add';

      let response = await fetch(endpoint, {
        method: 'POST',
        body: formData,
        credentials: 'same-origin',
      });

      let messages = await response.json();

      if (messages.constructor === Array && messages.length > 0) {

        this.setState({
          messages: messages
        });

        this.getFields();
      }
    }
  }

  dismissMessage(index) {
    let messages = this.deepCopy(this.state.messages);
    messages.splice(index, 1);
    this.setState({
      messages: messages
    })
  }

  deepCopy(obj) {
    return JSON.parse(JSON.stringify(obj));
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
      validationErrors: {},
      messages: [],
    });
  }

  render() {
    let form = {
      values: this.state.form,
      fields: this.state.fields,
      validationErrors: this.state.validationErrors,
      messages: this.state.messages,
    };

    return <PartnerForm
        context={this}
        form={form}
        changeCallback={this.handleChange.bind(this)}
        submitCallback={this.submit.bind(this)}
        resetCallback={this.clear.bind(this)}
        dismissMessageCallback={this.dismissMessage.bind(this)}
      />
  }
}
