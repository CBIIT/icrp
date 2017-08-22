import React, {Component} from 'react';
import { Button } from 'react-bootstrap';
import DataGrid from './DataGrid';
import FileInput from './FileInput';
import { parse } from '../services/ParseCSV';

export default class App extends Component {

  CANCEL_URL = window.location.protocol + '//' + window.location.host;
  state = this.initialState();

  initialState() {
    return {
      headers: [],
      institutions: [],
      failedInstitutions: [],
      showTable: false,
      showModal: false,
    }
  }

  reset(elements) {
    this.setState(this.initialState());
    for (let key in elements) {
      elements[key].value = '';
    }
  }

  showTable(event) {
    let {headers, institutions} = event;
    let showTable = true;
    this.setState({headers, institutions, showTable});
  }

  async addInstitutions() {

    let { headers, institutions } = this.state;
    let data = institutions.map(institution =>
      headers.map(header => institution[header])
    );

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = 'DataUploadTool/addInstitutions';
    let response = await fetch(`${protocol}//${hostname}/${pathname}`, {
      method: 'POST',
      credentials: 'same-origin',
      body: JSON.stringify(data),
    });

    this.setState({
      failedInstitutions: await response.json()
    });
  }

  render() {
    let {
      headers,
      institutions,
      failedInstitutions,
      showTable,
      showModal,
    } = this.state;

    return (
      <div>
        <div className="bordered clearfix m-b-10">
          <FileInput
             onLoad={event => this.showTable(event)}
             onReset={elements => this.reset(elements)}
          />

          <DataGrid
            className="m-5"
            visible={showTable}
            rows={institutions}
            columns={headers}
          />
        </div>

        <div className="text-center">
          <Button
            className="m-5"
            onClick={event => this.addInstitutions()}>
            Add Institutions
          </Button>

          <Button
            className="m-5"
            href={this.CANCEL_URL}>
            Cancel
          </Button>
        </div>
        {
          failedInstitutions.length &&
          <DataGrid
            className="m-5"
            visible={showTable}
            rows={failedInstitutions}
            columns={headers}
          />
        }
      </div>
    );
  }
}