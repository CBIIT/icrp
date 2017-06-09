import React from 'react';
import FundingOrganizationForm from './FundingOrganizationForm';

class Form extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      form: {
        partner: null,
        memberType: null,
        name: null,
        abbreviation: null,
        organizationType: null,
        annualizedFunding: null,
        country: null,
        currency: null,
      },
      fields: {

      }
    };

    this.handleChange.bind(this);
    this.handleValidation.bind(this);
  }

  handleChange(event) {
    console.log(event);
    let field = event.target.name;
    console.log(field);
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
      state={ this.state.form }
      changeCallback={ this.handleChange }
      validationCallback={ this.handleValidation } />
  }
}

export default Form;
