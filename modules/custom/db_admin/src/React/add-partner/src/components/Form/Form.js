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

  getDefaultForm() {
    return {
      values: this.getDefaultValues(),
      fields: this.getDefaultFields(),
      validationErrors: {},
      messages: [],
    }
  }

  getDefaultValues() {
    return {
      partner: '',
      joinedDate: null,
      country: '',
      email: '',
      description: '',
      sponsorCode: '',
      urlProtocol: 'https://',
      website: '',
      mapCoordinates: '',
      logoFile: '',
      note: '',
      agreeToTerms: false,

      isFundingOrganization: false,
      organizationType: '',
      currency: '',
      isAnnualized: false,
    };
  }

  getDefaultFields() {
    return {
      partners: [],
      countries: [],
      currencies: [],
      organizationTypes: [],
      urlProtocols: [],
    };
  }

  async updateFields() {
    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let endpoint = `${protocol}//${hostname}/api/admin/partners/fields`;

    let response = await fetch(endpoint, { credentials: 'same-origin' });
    let data = await response.json();
    let form = this.state.form;
    form.fields = data;

    this.setState({
      form: form,
      loading: false,
    }, e => {
      if (data.partners.length > 0) {
        this.handleChange(
          'partner',
          data.partners[0].partner_name
        );
      }
    })
  }

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

      let partner = fields.partners
        .find(e => e.partner_name === value);

      let country = fields.countries
        .find(e => e.label.toLowerCase() === partner.country.toLowerCase());

      values.partner = partner.partner_name;
      values.joinedDate = moment(partner.joined_date);
      values.country = country ? country.value : '';
      values.description = partner.description;
      values.email = partner.email;
      values.currency = findCurrency(country, fields);
    }

    if (field === 'country') {
      let country = fields.countries
        .find(e => e.value === value);

      values.currency = findCurrency(country, fields);
    }

    form.values = values;
    return form;
  }

  handleChange(field, value) {
    let form = this.state.form;
    this.setState({
      form: this.updateForm(form, field, value)
    });
  }

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
        format: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
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
    }

    let form = this.state.form;
    form.validationErrors = validationErrors;
    this.setState(
      { form: form }
    );

    return isValid;
  }

  async submit() {
    let isValid = this.validate();

    if (isValid) {
      let values = this.state.form.values;
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
        mapCoordinates: 'map_coordinates',
        logoFile: 'logo_file',
        note: 'note',
        agreeToTerms: 'agree_to_terms',

        isFundingOrganization: 'is_funding_organization',
        organizationType: 'organization_type',
        isAnnualized: 'is_annualized',
        currency: 'currency',
      };

      let formData = new FormData();
      for (let key in values) {
        let formKey = parameterMap[key];
        let formValue = values[key];
        if (key === 'joinedDate')
          formValue = moment(formValue._d).format('YYYY-MM-DD');

        if (formValue !== '' && formValue !== null)
          formData.set(formKey, formValue);
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

  dismissMessage(index) {
    let form = this.state.form;
    let messages = this.deepCopy(this.state.form.messages);
    messages.splice(index, 1);
    form.messages = messages;
    this.setState(
      { form: form }
    );
  }

  deepCopy(obj) {
    return JSON.parse(JSON.stringify(obj));
  }

  clear() {
    let form = this.state.form;
    form.values = this.getDefaultValues();
    this.setState(
      { form: form }
    );
  }

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
