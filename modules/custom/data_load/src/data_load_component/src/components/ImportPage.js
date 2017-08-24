import React, { Component } from 'react';
import {
    Button,
} from 'react-bootstrap';
import Spinner from './SpinnerComponent';


export default class ImportPage extends Component {

  state = {
    fundingYearMin: '',
    fundingYearMax: '',
    importNotes: '',
    loading: false,
    message: '',
    results: [],
  };

  validate() {
    let { fundingYearMin, fundingYearMax, importNotes } = this.state;
    if (!parseInt(fundingYearMax) || !parseInt(fundingYearMin))
      return false;
  }

  async importProjects() {
    let { partnerCode, receivedDate, type } = this.props;
    let { fundingYearMin, fundingYearMax, importNotes } = this.state;

    let fundingYears = [];
    for (let i = fundingYearMin; i <= fundingYearMax; i ++) {
      fundingYears.push(i);
    }

    const parameters = {
      partnerCode,
      fundingYears,
      importNotes,
      receivedDate,
      type,
    };
  }

  render() {

    return (
      <div>
        <div>
          Please provide the following information and click Import to import the data to staging.
        </div>




      </div>
    );
  }
}
