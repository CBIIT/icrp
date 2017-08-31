import React, { Component } from 'react';
import {
    Alert,
    Button,
    Panel,
} from 'react-bootstrap';
import Spinner from './SpinnerComponent';

const Asterisk = () => <span className="red-text">*</span>

const ResultsTable = ({rows}) =>
  <div className="table-responsive" style={{maxWidth: '500px'}}>
    {
      rows.map(row =>
        <tr>
          {
            row.map(value => {
              <td title={value}>{value}</td>
            })
          }
        </tr>
      )
    }
  </div>


export default class ImportPage extends Component {

  DEFAULT_YEAR = (new Date()).getFullYear() -1;

  state = {
    fundingYearMin: this.DEFAULT_YEAR,
    fundingYearMax: this.DEFAULT_YEAR,
    importNotes: '',
    loading: false,
    message: '',
    results: {},
    isPristine: true,
    validationErrors: {},
    error: false,
  };

  validate() {
    let { fundingYearMin, fundingYearMax, importNotes } = this.state;
    if (!parseInt(fundingYearMax) || !parseInt(fundingYearMin))
      return false;
  }

  setValue(key, value) {

    let { fundingYearMin, fundingYearMax, importNotes } = this.state;
    
    let validationRules = {
      fundingYearMin: {
        required: true,
        isNumeric: true,
        isLessThanMaxYear: true,
      },

      fundingYearMax: {
        isNumeric: true,
      },

      importNotes: {
        required: true,
      },

      
    }[key] || {};

    let validationErrors = this.state.validationErrors;
    validationErrors[key] = {};

    for(let rule in validationRules) {
      if (rule === 'required' && !value) {
        validationErrors[key].required = true;
      }

      if (rule === 'isNumeric'
        && value
        && isNaN(parseInt(value))
        && (+value < 1 || +value > 9999)
      ) {
        validationErrors[key].isNumeric = true;
      }

      if (rule === 'isLessThanMaxYear') {
        if (+fundingYearMin > +fundingYearMax) {
          validationErrors[key].isLessThanMaxYear = true;
        }
      }
    }

    if (Object.keys(validationErrors[key]).length === 0) {
      delete validationErrors[key];
    }

    console.log(validationErrors);


    this.setState({
      [key]: value,
      validationErrors: validationErrors,
      isPristine: false,
    })


  }

  async importProjects() {

    this.setState({loading: true})
    let { partnerCode, receivedDate, type } = this.props;
    let { fundingYearMin, fundingYearMax, importNotes } = this.state;

    let fundingYears = `${fundingYearMin} - ${fundingYearMax}`;

    const parameters = {
      partnerCode,
      fundingYears,
      importNotes,
      receivedDate,
      type,
    };

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = 'DataUploadTool/importProjects';
    if (hostname === 'localhost') {
        protocol = 'http:';
        //hostname = 'icrp-dataload';
    }
    let response = await fetch(`${protocol}//${hostname}/${pathname}`, {
      method: 'POST',
      credentials: 'same-origin',
      body: JSON.stringify(parameters),
    });

    if (response.ok) {
      let data = await response.json();
      console.log(data);
      this.setState({
        results: data,
        loading: false,
        error: false,
        message: 'The uploaded projects were imported successfuly.',
      })
    }

    else {
      let data = await response.text();
      console.log(data);
      this.setState({
        results: data,
        loading: false,
        error: false,
        message: 'The uploaded projects were not imported successfuly: ' + data,
      })
    }
  }

  render() {

    let { fundingYearMin, fundingYearMax, importNotes, loading, message, results, validationErrors, isPristine, error } = this.state;
    let { type, cancelUrl } = this.props;

    return (
      <div>
        <Spinner visible={loading} />

        {this.state.message &&
          <Alert
              bsStyle={error ? "danger" : "success"}
              onDismiss={ev => this.setState({message: '', error: false})}>
              { this.state.message }
          </Alert>}


        <div className="form-group">
          Please provide the following information and click Import to import the data to staging.
        </div>

        <div className="panel panel-default category-panel form-group">
            <div className="panel-heading">Data Upload Information</div>

            <div style={{marginTop: '15px'}}>

              <div className="form-group" style={{display: 'flex', flexFlow: 'wrap'}}>
                <div style={{width: '120px', maxWidth: '120px', minWidth: '120px'}} className="text-right">
                  <label for="fundingYear" style={{marginTop: '5px', marginRight: '5px'}}>Funding Year <Asterisk /> </label>
                </div>
                <div style={{display: 'flex', flexFlow: 'wrap', alignItems: 'center'}}>
                  <input
                      value={fundingYearMin}
                      type="number"
                      onChange={event => this.setValue('fundingYearMin', event.target.value)}
                      id="fundingYear"
                      className="form-control"
                      placeholder="Enter first year"
                      style={{display: 'inline-block', width: '200px'}}
                  />

                  <span style={{marginLeft: '5px', marginRight: '5px'}}>-</span>

                  <input
                    value={fundingYearMax}
                    type="number"
                    onChange={event => this.setValue('fundingYearMax', event.target.value)}
                    className="form-control"
                    placeholder="Enter last year"
                    style={{display: 'inline-block', width: '200px'}}
                  />

                  {
                    validationErrors.fundingYearMin && validationErrors.fundingYearMin.required &&
                    <div style={{color: 'red', marginLeft: '5px'}}>Please enter a value for the first funding year.</div>
                  }

                  {
                    validationErrors.fundingYearMin && validationErrors.fundingYearMin.isNumeric &&
                    <div style={{color: 'red', marginLeft: '5px'}}>Please ensure that the first funding year provided is a valid year.</div>
                  }

                  {
                    validationErrors.fundingYearMax && validationErrors.fundingYearMin.isNumeric &&
                    <div style={{color: 'red', marginLeft: '5px'}}>Please ensure that the last funding year provided is a valid year.</div>
                  }

                  {
                    validationErrors.fundingYearMin && validationErrors.fundingYearMin.isLessThanMaxYear &&
                    <div style={{color: 'red', marginLeft: '5px'}}>Please ensure that the first funding year is less than the last funding year.</div>
                  }


                </div>
              </div>


              <div className="form-group" style={{display: 'flex', flexFlow: 'wrap'}}>
                <div style={{width: '120px', maxWidth: '120px', minWidth: '120px'}} className="text-right">
                  <label for="importNotes" style={{marginRight: '5px'}}>Import Notes <Asterisk /> </label>
                </div>
                <div style={{width: '80%'}}>
                  <textarea
                    value={importNotes}
                    onChange={event => this.setValue('importNotes', event.target.value)}
                    id="importNotes"
                    className="form-control"
                    maxlength="1000"
                    placeholder="Enter import notes"
                    style={{width: '80%'}}
                  />
                  {
                    validationErrors.importNotes && validationErrors.importNotes.required &&
                    <div style={{color: 'red'}}>Please ensure this field is not empty.</div>
                  }
                </div>
              </div>
              <br />
          </div>
        </div>

        {
          Object.keys(results).length > 0 &&
          <div>
            <div className="form-group">
              The following records have been successfully imported to staging. Please use the <a href="/data-upload-review">Data Review Tool</a> to review the imported data.
            </div>

            <div class="table-responsive">
              <table style={{border: 'none', width: '300px' }}>
                <tr>
                  <td>Project Count</td>
                  <td>{results.ProjectCount.toLocaleString()}</td>
                </tr>
                <tr>
                  <td>Project Funding Count</td>
                  <td>{results.ProjectFundingCount.toLocaleString()}</td>
                </tr>
                <tr>
                  <td>Project Funding Investigator Count</td>
                  <td>{results.ProjectFundingInvestigatorCount.toLocaleString()}</td>
                </tr>
                <tr>
                  <td>Project CSO Count</td>
                  <td>{results.ProjectCSOCount.toLocaleString()}</td>
                </tr>
                <tr>
                  <td>Project Cancer Type Count</td>
                  <td>{results.ProjectCancerTypeCount.toLocaleString()}</td>
                </tr>
                <tr>
                  <td>Project Type Count</td>
                  <td>{results.Project_ProjectTypeCount.toLocaleString()}</td>
                </tr>
                <tr>
                  <td>Project Abstract Count</td>
                  <td>{results.ProjectAbstractCount.toLocaleString()}</td>
                </tr>
              </table>
            </div>
          </div>
        }



        <div style={{display: 'flex', justifyContent: 'space-between', marginTop: '15px'}}>
          <div />
          <div>
            <Button className="horizontal-margin" onClick={event => this.props.onNavigation(2)}>Back</Button>
            <Button className="horizontal-margin"
              onClick={event => this.importProjects()}
              disabled={isPristine || Object.keys(this.state.validationErrors).length > 0 || Object.keys(results).length > 0}>
              Import
            </Button>
          </div>
          <Button href={cancelUrl}>Cancel</Button>
        </div>

      </div>
    );
  }
}
