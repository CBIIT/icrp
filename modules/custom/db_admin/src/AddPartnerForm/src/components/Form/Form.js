import React from 'react';
import PartnerForm from '../PartnerForm';
import Spinner from '../Spinner';
import moment from 'moment';

export default class Form extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      form: this.getDefaultForm(),
    };

    this.updateFields();
  }

  // creates a new, empty form
  getDefaultForm() {
    return {
      values: this.getDefaultValues(),
      fields: this.getDefaultFields(),
      validationErrors: {},
      messages: [],
    }
  }

  // returns the default values for this form
  getDefaultValues() {
    return {
      partner: '',
      joinedDate: null,
      country: '',
      email: '',
      description: '',
      operation_type: 'new',
      sponsorCode: '',
      urlProtocol: 'http://',
      website: '',
      mapCoordinates: '',
      latitude: '',
      longitude: '',
      logoFile: '',
      note: '',
      agreeToTerms: false,

      isFundingOrganization: false,
      organizationType: '',
      currency: '',
      isAnnualized: false,
    };
  }

  // returns the default fields for this form
  getDefaultFields() {
    return {
      partners: [],
      countries: [],
      currencies: [],
      organizationTypes: [],
      urlProtocols: [],
    };
  }

  // updates this form's fields (partners, organization types, countries, currencies, etc)
  async updateFields() {
    let form = this.state.form;
    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let endpoint = `${protocol}//${hostname}/api/admin/partners/fields/${form.values.operation_type}`;

    let response = await fetch(endpoint, { credentials: 'same-origin' });
    let data = await response.json();
    form.fields = data;

    this.setState({
      form: form,
      loading: false,
    }, e => {
      // select the first partner application by default
      if (data.partners.length > 0) {
        this.handleChange(
          'partner',
          data.partners[0].partner_name
        );
      }
    })
  }

  // updates the form's state
  updateForm(form, field, value) {

    let values = form.values;
    let fields = form.fields;

    values[field] = value;

    const findCurrency = (country, fields) => {
      if (country) {
        let currency = fields.currencies.find(e => e.value === country.currency);
        return currency ? currency.value : '';
      }

      return '';
    }

    if (field === 'partner') {
      values = this.getDefaultValues();
      values.operation_type = form.values.operation_type;

      let partner = fields.partners
        .find(e => e.partner_name === value);

      let country = fields.countries
        .find(e => e.value.toLowerCase() === partner.country.toLowerCase());

      values.partner = partner.partner_name;
      values.joinedDate = moment(partner.joined_date);
      values.country = country ? country.value : '';
      values.description = partner.description;
      values.email = partner.email;
      values.sponsorCode = partner.sponsor_code;
      values.urlProtocol = partner.website.substr(0,partner.website.indexOf('//')+2);
      values.website = partner.website.substr(values.urlProtocol.length);
      values.latitude = partner.latitude===null?'':partner.latitude;
      values.longitude = partner.longitude===null?'':partner.longitude;
      values.defaultLogoFile = partner.logo_file;
      values.note = partner.note;
      values.agreeToTerms = parseInt(partner.agree_to_terms);
      values.currency = findCurrency(country, fields);
    }

    if (field === 'country') {
      let country = fields.countries
        .find(e => e.value === value);

      values.currency = findCurrency(country, fields);
    }

    form.values = values;

    if (field === 'operation_type') {
      this.updateFields();
    }

    return form;
  }

  // change callback to update the form's values
  handleChange(field, value) {
    let form = this.state.form;
    this.setState({
      form: this.updateForm(form, field, value)
    });
  }

  // validates the form object
  validate() {
    let values = this.state.form.values;
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
        format: /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      },

      description: {
        required: true,
      },

      sponsorCode: {
        required: true,
      },

      organizationType: {
        required: values.isFundingOrganization
      },

      currency: {
        required: values.isFundingOrganization
      },

      latitude: {
        numeric: true,
        min: -90,
        max: 90,
        required: true
      },

      longitude: {
        numeric: true,
        min: -180,
        max: 180,
        required: true
      }
    }

    for (let field in validationRules) {
      validationErrors[field] = {};
      let value = field !== 'joinedDate'
        ? (values[field] || '').toString().trim()
        : values[field] ? moment(values[field]).format('YYYY-MM-DD') : '0';

      if (validationRules[field].required && value.constructor === String && value.length === 0) {
        validationErrors[field].required = true;
        isValid = false;
      }

      if (value && validationRules[field].format && !validationRules[field].format.test(value)) {
        validationErrors[field].format = true;
        isValid = false;
      }

      if (validationRules[field].numeric && isNaN(value)) {
        validationErrors[field].numeric = true;
        isValid = false;
      }

      if (validationRules[field].min !== undefined && +value < validationRules[field].min) {
        validationErrors[field].min = true;
        isValid = false;
      }

      if (validationRules[field].max !== undefined && +value > validationRules[field].max) {
        validationErrors[field].max = true;
        isValid = false;
      }
    }

    let form = this.state.form;
    form.validationErrors = validationErrors;
    this.setState(
      { form: form }
    );

    return isValid;
  }

  // submit this form to the endpoint
  async submit() {
    let isValid = this.validate();

    if (isValid) {
      let values = {...this.state.form.values};
      let fields = this.state.form.fields;

      // add prefix to url
      if (values.website)
        values.website = values.urlProtocol + values.website;

      let parameterMap = {
        partner: 'partner_name',
        joinedDate: 'joined_date',
        country: 'country',
        email: 'email',
        description: 'description',
        sponsorCode: 'sponsor_code',
        website: 'website',
        logoFile: 'logo_file',
        note: 'note',
        agreeToTerms: 'agree_to_terms',

        isFundingOrganization: 'is_funding_organization',
        organizationType: 'organization_type',
        isAnnualized: 'is_annualized',
        currency: 'currency',
        latitude: 'latitude',
        longitude: 'longitude',

        operation_type: 'operation_type'
      };
      let formData = new FormData();
      for (let key in parameterMap) {
        let formKey = parameterMap[key];
        let formValue = values[key];
        if (key === 'joinedDate')
          formValue = moment(formValue._d).format('YYYY-MM-DD');

        if (formValue !== '' && formValue !== null) {
          console.log(formKey, formValue);
          formData.set(formKey, formValue);
        }
      }

      let partner = fields.partners
        .find(e => e.partner_name === values.partner);
      formData.set('partner_application_id', partner.partner_application_id);

      let protocol = window.location.protocol;
      let hostname = window.location.hostname;
      let endpoint = `${protocol}//${hostname}/api/admin/partners/add`;

      let response = await fetch(endpoint, {
        method: 'POST',
        body: formData,
        credentials: 'same-origin',
      });

      let messages = await response.json();
      let form = this.state.form;

      if (messages.constructor === Array && messages.length > 0) {
        form.values = this.getDefaultValues();
        form.messages = messages;

        this.setState(
          { form: form },
          () => this.updateFields()
        );
      }
    }
  }


  // updates the state of this form, dismissing the message by index
  dismissMessage(index) {
    let form = this.state.form;
    let messages = this.deepCopy(this.state.form.messages);
    messages.splice(index, 1);
    form.messages = messages;
    this.setState({form});
  }

  // returns a deep copy of an object
  deepCopy(obj) {
    return JSON.parse(JSON.stringify(obj));
  }

  // clears this form (resets all fields to their default values)
  clear() {
    let form = this.state.form;
    form.values = this.getDefaultValues();
    this.setState({form});
  }

  // renders the current state
  render() {
    return <div>
      <Spinner message="Loading..." visible={this.state.loading} />
      <PartnerForm
        context={this}
        form={this.state.form}
        changeCallback={this.handleChange.bind(this)}
        submitCallback={this.submit.bind(this)}
        resetCallback={this.clear.bind(this)}
        dismissMessageCallback={this.dismissMessage.bind(this)}
      />
    </div>
  }
}
