import React from 'react';
import FundingOrganizationForm from './FundingOrganizationForm';

class Form extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      form: {
        partner: '',
        memberType: '',
        name: '',
        abbreviation: '',
        organizationType: '',
        annualizedFunding: '',
        country: '',
        currency: '',
        note: '',
      },
      fields: {
        organizationTypes: [
          'Government',
          'Non-profit',
          'Other',
        ],
        partners: [],
        countries: [],
        currencies: [],
      },
      controls: {

      }
    };

    this.getFields();
  }

  async getFields() {

    let endpoint = 'http://localhost/api/admin/funding_organizations/fields';
    let response = await fetch(endpoint);
    let data = await response.json()

    let fields = this.state.fields;
    for (let key in data) {
      fields[key] = data[key];
    }

    this.setState({
      fields: fields
    });
  }

  handleChange(field, value) {
    console.log(field, value);

    let formState = this.state.form;
    formState[field] = value;

    if (['partner', 'memberType'].indexOf(field) > -1
      && formState.partner
      && formState.memberType === 'Partner') {

      console.log(formState);

      let partner = this.state.fields.partners.find(e => e.value === formState.partner)
      console.log('auto-filling fields')
      console.log(partner);
      formState.country = partner.country;
      formState.currency = partner.currency;
    }


    this.setState({
      form: formState
    });
  }



  handleValidation(event) {
    console.log(event);
  }

  async getFormFields() {
    let response = await fetch(`${this.props.endpoint}/api/admin/add_funding_organization/fields`);
    let fields = await response.json();

    this.setState({
      fields: fields
    });
  }


  render() {
    return <FundingOrganizationForm
      form={ this.state.form }
      fields={ this.state.fields }
      controls={ this.state.controls }
      changeCallback={ this.handleChange.bind(this) }
      validationCallback={ this.handleValidation } />
  }
}

export default Form;
