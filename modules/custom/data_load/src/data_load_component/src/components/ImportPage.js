import React, { Component } from 'react';
import {
    Button,
    Panel,
} from 'react-bootstrap';
import Spinner from './SpinnerComponent';

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

  state = {
    fundingYearMin: '',
    fundingYearMax: '',
    importNotes: '',
    loading: false,
    message: '',
    results: {},
    isPristine: true,
    validationErrors: {},
  };

  validate() {
    let { fundingYearMin, fundingYearMax, importNotes } = this.state;
    if (!parseInt(fundingYearMax) || !parseInt(fundingYearMin))
      return false;
  }

  setValue(key, value) {
    let validationRules = {
      fundingYearMin: {
        required: true,
        isNumeric: true,
      },

      fundingYearMax: {
        isNumeric: true,
      }
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

    let years = [];
    for (let i = +fundingYearMin; i <= +fundingYearMax; i ++) {
      years.push(i);
    }

    let fundingYears = years.join(',');

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

    let data = await response.json();
    console.log(data);
    this.setState({
      results: data,
      loading: false,
    })
  }

  render() {

    let { fundingYearMin, fundingYearMax, importNotes, loading, message, results, validationErrors, isPristine } = this.state;
    let { type, cancelUrl } = this.props;

    return (
      <div>
        <Spinner visible={loading} />

        <div className="form-group">
          Please provide the following information and click Import to import the data to staging.
        </div>


        <div className="panel panel-default category-panel form-group">
            <div className="panel-heading">
              Workbook Info
            </div>
            <div style={{marginTop: '15px'}}>

              <div className="row form-group" style={{display: 'flex', alignItems: 'center'}}>
                <div className="col-md-2 text-right">
                  <label for="fundingYear">Funding Year</label>
                </div>

                <div className="col-md-10">
                  <input
                    value={fundingYearMin}
                    type="number"
                    onChange={event => this.setValue('fundingYearMin', event.target.value)}
                    id="fundingYear"
                    className="form-control"
                    placeholder="Enter first year"
                    style={{display: 'inline-block', width: '200px'}}/>
                  {' - '}
                  <input
                    value={fundingYearMax}
                    type="number"
                    onChange={event => this.setValue('fundingYearMax', event.target.value)}
                    className="form-control"
                    placeholder="Enter last year"
                    style={{display: 'inline-block', width: '200px'}}/>

                  {
                    validationErrors.fundingYearMin && validationErrors.fundingYearMin.required &&
                    <div style={{color: 'red'}}>Please enter a value for the first funding year.</div>
                  }

                  {
                    validationErrors.fundingYearMin && validationErrors.fundingYearMin.isNumeric &&
                    <div style={{color: 'red'}}>Please ensure that the first funding year provided is a valid year.</div>
                  }

                  {
                    validationErrors.fundingYearMax && validationErrors.fundingYearMin.isNumeric &&
                    <div style={{color: 'red'}}>Please ensure that the last funding year provided is a valid year.</div>
                  }

                </div>
              </div>

              <div className="row form-group">
                <div className="col-md-2 text-right">
                  <label for="importNotes">Import Notes</label>
                </div>

                <div className="col-md-10">
                  <textarea
                    value={importNotes}
                    onChange={event => this.setState({importNotes: event.target.value})}
                    id="importNotes"
                    className="form-control"
                    placeholder="Enter import notes"
                    style={{width: '80%'}}
                  />
                </div>
              </div>
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
